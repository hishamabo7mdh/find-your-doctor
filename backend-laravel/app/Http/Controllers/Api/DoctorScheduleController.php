<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Appointment;
use App\Models\AuditLog;
use App\Models\Doctor;
use App\Models\Schedule;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DoctorScheduleController extends Controller
{
    public function update(Request $request)
    {
        $validated = $request->validate([
            'schedules' => ['required', 'array', 'min:1', 'max:7'],
            'schedules.*.day_of_week' => [
                'required',
                'string',
                'distinct',
                'in:monday,tuesday,wednesday,thursday,friday,saturday,sunday',
            ],
            'schedules.*.start_time' => ['required', 'date_format:H:i'],
            'schedules.*.end_time' => ['required', 'date_format:H:i', 'after:schedules.*.start_time'],
            'schedules.*.duration_minutes' => ['required', 'integer', 'min:5', 'max:240'],
        ]);

        $doctor = $request->user()->doctor;
        abort_unless($doctor, 403, 'لا يوجد ملف طبيب مرتبط بهذا الحساب.');

        DB::transaction(function () use ($request, $doctor, $validated) {
            $doctor = Doctor::query()->whereKey($doctor->id)->lockForUpdate()->firstOrFail();
            $futureAppointments = $doctor->appointments()
                ->where('status', 'booked')
                ->where('appointment_at', '>', now())
                ->get();

            foreach ($futureAppointments as $appointment) {
                $startsAt = Carbon::parse($appointment->appointment_at);
                $day = strtolower($startsAt->englishDayOfWeek);
                $schedule = collect($validated['schedules'])->first(
                    fn ($item) => $item['day_of_week'] === $day,
                );

                if (! $schedule) {
                    abort(409, 'تعديل الدوام يتعارض مع مواعيد مؤكدة. عالج المواعيد أولاً.');
                }

                $scheduleStart = $startsAt->copy()->startOfDay()
                    ->setTimeFromTimeString($schedule['start_time']);
                $scheduleEnd = $startsAt->copy()->startOfDay()
                    ->setTimeFromTimeString($schedule['end_time']);
                $duration = (int) $schedule['duration_minutes'];
                $appointmentEnd = $appointment->ends_at
                    ? Carbon::parse($appointment->ends_at)
                    : $startsAt->copy()->addMinutes($duration);

                $valid = $startsAt->gte($scheduleStart)
                    && $appointmentEnd->lte($scheduleEnd)
                    && $scheduleStart->diffInMinutes($startsAt) % $duration === 0;

                if (! $valid) {
                    abort(409, 'تعديل الدوام يتعارض مع مواعيد مؤكدة. عالج المواعيد أولاً.');
                }
            }

            $doctor->schedules()->delete();

            foreach ($validated['schedules'] as $schedule) {
                $doctor->schedules()->create([
                    ...$schedule,
                    'is_active' => true,
                ]);
            }

            AuditLog::create([
                'actor_user_id' => $request->user()->id,
                'action' => 'doctor.schedules_updated',
                'entity_type' => Doctor::class,
                'entity_id' => $doctor->id,
                'metadata' => ['schedule_count' => count($validated['schedules'])],
            ]);
        });

        return response()->json([
            'data' => $doctor->schedules()->where('is_active', true)->get([
                'id',
                'day_of_week',
                'start_time',
                'end_time',
                'duration_minutes',
            ]),
        ]);
    }

    public function createLeave(Request $request)
    {
        $validated = $request->validate([
            'start_date' => ['required', 'date', 'after_or_equal:today'],
            'end_date' => ['required', 'date', 'after_or_equal:start_date'],
            'reason' => ['nullable', 'string', 'max:500'],
        ]);

        $doctor = $request->user()->doctor;
        abort_unless($doctor, 403, 'لا يوجد ملف طبيب مرتبط بهذا الحساب.');

        $leave = DB::transaction(function () use ($doctor, $validated, $request) {
            $doctor = Doctor::query()->whereKey($doctor->id)->lockForUpdate()->firstOrFail();
            $hasAppointments = Appointment::query()
                ->where('doctor_id', $doctor->id)
                ->where('status', 'booked')
                ->whereDate('appointment_at', '>=', $validated['start_date'])
                ->whereDate('appointment_at', '<=', $validated['end_date'])
                ->exists();

            abort_unless(! $hasAppointments, 409, 'تتعارض الإجازة مع مواعيد مؤكدة. عالج المواعيد أولاً.');

            $leave = $doctor->leaves()->create($validated);
            AuditLog::create([
                'actor_user_id' => $request->user()->id,
                'action' => 'doctor.leave_created',
                'entity_type' => Doctor::class,
                'entity_id' => $doctor->id,
                'metadata' => [
                    'start_date' => $leave->start_date,
                    'end_date' => $leave->end_date,
                ],
            ]);

            return $leave;
        });

        return response()->json(['data' => $leave], 201);
    }
}
