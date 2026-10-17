<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Doctor;
use App\Models\Specialty;
use Carbon\Carbon;
use Carbon\CarbonPeriod;
use Illuminate\Http\Request;

class DoctorController extends Controller
{
    public function specialties()
    {
        return response()->json([
            'data' => Specialty::query()
                ->where('is_active', true)
                ->orderBy('name')
                ->get(['id', 'name', 'description']),
        ]);
    }

    public function index(Request $request)
    {
        $validated = $request->validate([
            'q' => ['nullable', 'string', 'max:100'],
            'specialty_id' => ['nullable', 'integer', 'exists:specialties,id'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:50'],
        ]);

        $doctors = Doctor::query()
            ->with(['user', 'specialty'])
            ->where('is_active', true)
            ->whereHas('user', fn ($query) => $query->where('is_active', true))
            ->when($validated['q'] ?? null, function ($query, $term) {
                $query->whereHas('user', function ($userQuery) use ($term) {
                    $userQuery->where(function ($nameQuery) use ($term) {
                        $nameQuery->where('first_name', 'like', "%{$term}%")
                            ->orWhere('last_name', 'like', "%{$term}%");
                    });
                });
            })
            ->when($validated['specialty_id'] ?? null, fn ($query, $id) => $query->where('specialty_id', $id))
            ->orderBy('id')
            ->paginate($validated['per_page'] ?? 15)
            ->through(fn (Doctor $doctor) => $this->publicDoctor($doctor));

        return response()->json($doctors);
    }

    public function show(Doctor $doctor)
    {
        abort_unless($doctor->is_active && $doctor->user?->is_active, 404);

        $doctor->load(['user', 'specialty', 'schedules' => fn ($query) => $query->where('is_active', true)]);

        return response()->json([
            'data' => $this->publicDoctor($doctor) + [
                'bio' => $doctor->bio,
                'schedules' => $doctor->schedules->map(fn ($schedule) => [
                    'day_of_week' => $schedule->day_of_week,
                    'start_time' => substr($schedule->start_time, 0, 5),
                    'end_time' => substr($schedule->end_time, 0, 5),
                    'duration_minutes' => $schedule->duration_minutes,
                ])->values(),
            ],
        ]);
    }

    public function slots(Request $request, Doctor $doctor)
    {
        abort_unless($doctor->is_active && $doctor->user?->is_active, 404);

        $validated = $request->validate([
            'from' => ['nullable', 'date'],
            'to' => ['nullable', 'date', 'after_or_equal:from'],
        ]);

        $from = Carbon::parse($validated['from'] ?? now()->toDateString())->startOfDay();
        $to = Carbon::parse($validated['to'] ?? $from->copy()->addDays(13)->toDateString())->startOfDay();

        if ($from->diffInDays($to) > 30) {
            return response()->json(['message' => 'يجب ألا يتجاوز نطاق البحث 31 يوماً.'], 422);
        }

        $schedules = $doctor->schedules()->where('is_active', true)->get();
        $slots = [];

        foreach (CarbonPeriod::create($from, $to) as $date) {
            $dayName = strtolower($date->englishDayOfWeek);
            $daySchedules = $schedules->where('day_of_week', $dayName);

            if ($doctor->leaves()
                ->whereDate('start_date', '<=', $date->toDateString())
                ->whereDate('end_date', '>=', $date->toDateString())
                ->exists()) {
                continue;
            }

            foreach ($daySchedules as $schedule) {
                $cursor = $date->copy()->setTimeFromTimeString($schedule->start_time);
                $scheduleEnd = $date->copy()->setTimeFromTimeString($schedule->end_time);
                $duration = (int) $schedule->duration_minutes;

                while ($cursor->copy()->addMinutes($duration)->lte($scheduleEnd)) {
                    $slotEnd = $cursor->copy()->addMinutes($duration);

                    if ($cursor->gt(now()) && ! $this->isBooked($doctor, $cursor, $slotEnd)) {
                        $slots[] = [
                            'starts_at' => $cursor->toIso8601String(),
                            'ends_at' => $slotEnd->toIso8601String(),
                        ];
                    }

                    $cursor->addMinutes($duration);
                }
            }
        }

        usort($slots, fn ($left, $right) => strcmp($left['starts_at'], $right['starts_at']));

        return response()->json(['data' => $slots]);
    }

    public function nearestSlot(Request $request, Doctor $doctor)
    {
        $response = $this->slots($request, $doctor);
        $payload = $response->getData(true);

        return response()->json(['data' => $payload['data'][0] ?? null]);
    }

    private function isBooked(Doctor $doctor, Carbon $startsAt, Carbon $endsAt): bool
    {
        return $doctor->appointments()
            ->where('status', '!=', 'cancelled')
            ->where('appointment_at', '<', $endsAt)
            ->where(function ($query) use ($startsAt) {
                $query->where('ends_at', '>', $startsAt)
                    ->orWhere(function ($legacyQuery) use ($startsAt) {
                        $legacyQuery->whereNull('ends_at')
                            ->where('appointment_at', '>=', $startsAt);
                    });
            })
            ->exists();
    }

    private function publicDoctor(Doctor $doctor): array
    {
        return [
            'id' => $doctor->id,
            'name' => trim(($doctor->user?->first_name ?? '').' '.($doctor->user?->last_name ?? '')),
            'specialty' => $doctor->specialty?->name,
            'specialty_id' => $doctor->specialty_id,
            'price' => $doctor->price,
        ];
    }
}
