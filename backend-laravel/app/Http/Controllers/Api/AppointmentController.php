<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Mail\AppointmentStatusMail;
use App\Models\Appointment;
use App\Models\AuditLog;
use App\Models\Doctor;
use App\Models\Patient;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;

class AppointmentController extends Controller
{
    public function mine(Request $request)
    {
        $patient = $this->currentPatient($request);

        $appointments = $patient->appointments()
            ->with(['doctor.user', 'doctor.specialty'])
            ->orderByDesc('appointment_at')
            ->paginate(20)
            ->through(fn (Appointment $appointment) => $this->appointmentData($appointment, false));

        return response()->json($appointments);
    }

    public function doctorAppointments(Request $request)
    {
        $validated = $request->validate([
            'date' => ['nullable', 'date'],
        ]);

        $doctor = $request->user()->doctor;
        abort_unless($doctor, 403, 'لا يوجد ملف طبيب مرتبط بهذا الحساب.');

        $date = Carbon::parse($validated['date'] ?? now()->toDateString())->toDateString();
        $appointments = $doctor->appointments()
            ->with(['patient.user'])
            ->whereDate('appointment_at', $date)
            ->orderBy('appointment_at')
            ->paginate(30)
            ->through(fn (Appointment $appointment) => $this->appointmentData($appointment, true));

        return response()->json($appointments);
    }

    public function show(Request $request, Appointment $appointment)
    {
        $this->authorizeView($request, $appointment);
        $appointment->load(['doctor.user', 'doctor.specialty', 'patient.user']);

        $includePatient = $request->user()->role !== 'patient';

        return response()->json([
            'data' => $this->appointmentData($appointment, $includePatient),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'doctor_id' => ['required', 'integer', 'exists:doctors,id'],
            'starts_at' => ['required', 'date', 'after:now'],
        ]);
        $patient = $this->currentPatient($request);

        return $this->createBookingResponse(
            $request,
            $validated['doctor_id'],
            $patient,
            $validated['starts_at'],
        );
    }

    public function storeForDoctor(Request $request)
    {
        $validated = $request->validate([
            'patient_id' => ['required', 'integer', 'exists:patients,id'],
            'starts_at' => ['required', 'date', 'after:now'],
        ]);
        $doctor = $request->user()->doctor;
        abort_unless($doctor, 403, 'لا يوجد ملف طبيب مرتبط بهذا الحساب.');
        $patient = Patient::findOrFail($validated['patient_id']);

        return $this->createBookingResponse(
            $request,
            $doctor->id,
            $patient,
            $validated['starts_at'],
        );
    }

    private function createBookingResponse(
        Request $request,
        int $doctorId,
        Patient $patient,
        string $startsAtInput,
    ) {
        $key = $request->header('Idempotency-Key');
        $created = false;

        if ($key !== null && (strlen($key) > 100 || trim($key) === '')) {
            return response()->json(['message' => 'مفتاح الطلب غير صالح.'], 422);
        }

        $appointment = DB::transaction(function () use (
            $doctorId,
            $patient,
            $request,
            $key,
            $startsAtInput,
            &$created,
        ) {
            $lockedPatient = Patient::query()->whereKey($patient->id)->lockForUpdate()->firstOrFail();

            if ($key !== null) {
                $existing = Appointment::query()
                    ->where('patient_id', $lockedPatient->id)
                    ->where('idempotency_key', $key)
                    ->first();

                if ($existing) {
                    return $existing->load(['doctor.user', 'doctor.specialty']);
                }
            }

            $doctor = Doctor::query()
                ->whereKey($doctorId)
                ->lockForUpdate()
                ->firstOrFail();
            abort_unless($doctor->is_active && $doctor->user?->is_active, 404);

            $startsAt = Carbon::parse($startsAtInput);
            $dayName = strtolower($startsAt->englishDayOfWeek);
            $schedules = $doctor->schedules()
                ->where('day_of_week', $dayName)
                ->where('is_active', true)
                ->get();

            $schedule = $schedules->first(function ($item) use ($startsAt) {
                $start = $startsAt->copy()->startOfDay()->setTimeFromTimeString($item->start_time);
                $end = $startsAt->copy()->startOfDay()->setTimeFromTimeString($item->end_time);
                $duration = (int) $item->duration_minutes;

                return $startsAt->gte($start)
                    && $startsAt->copy()->addMinutes($duration)->lte($end)
                    && $start->diffInMinutes($startsAt) % $duration === 0;
            });

            abort_unless($schedule, 422, 'الفترة المختارة خارج دوام الطبيب أو غير مطابقة لفتراته.');

            if ($doctor->leaves()
                ->whereDate('start_date', '<=', $startsAt->toDateString())
                ->whereDate('end_date', '>=', $startsAt->toDateString())
                ->exists()) {
                abort(409, 'الطبيب في إجازة خلال الفترة المختارة.');
            }

            $endsAt = $startsAt->copy()->addMinutes((int) $schedule->duration_minutes);
            $overlaps = fn ($query) => $query
                ->where('appointment_at', '<', $endsAt)
                ->where(function ($endQuery) use ($startsAt) {
                    $endQuery->where('ends_at', '>', $startsAt)
                        ->orWhere(function ($legacyQuery) use ($startsAt) {
                            $legacyQuery->whereNull('ends_at')
                                ->where('appointment_at', '>=', $startsAt);
                        });
                });

            $doctorBusy = Appointment::query()
                ->where('doctor_id', $doctor->id)
                ->where('status', '!=', 'cancelled')
                ->where($overlaps)
                ->exists();

            $patientBusy = Appointment::query()
                ->where('patient_id', $lockedPatient->id)
                ->where('status', '!=', 'cancelled')
                ->where($overlaps)
                ->exists();

            abort_unless(! $doctorBusy, 409, 'الفترة لم تعد متاحة. يرجى اختيار موعد آخر.');
            abort_unless(! $patientBusy, 409, 'لديك موعد آخر يتعارض مع هذه الفترة.');

            $appointment = Appointment::create([
                'doctor_id' => $doctor->id,
                'patient_id' => $lockedPatient->id,
                'created_by_user_id' => $request->user()->id,
                'appointment_at' => $startsAt,
                'ends_at' => $endsAt,
                'status' => 'booked',
                'idempotency_key' => $key,
            ]);
            $created = true;
            AuditLog::create([
                'actor_user_id' => $request->user()->id,
                'action' => 'appointment.booked',
                'entity_type' => Appointment::class,
                'entity_id' => $appointment->id,
            ]);

            return $appointment->load(['doctor.user', 'doctor.specialty']);
        });

        if ($created) {
            $appointment->loadMissing(['doctor.user', 'patient.user']);
            Mail::to($appointment->patient->user->email)
                ->queue(new AppointmentStatusMail($appointment, 'booked'));
        }

        return response()->json([
            'data' => $this->appointmentData($appointment, false),
        ], 201);
    }

    public function cancel(Request $request, Appointment $appointment)
    {
        $validated = $request->validate([
            'reason' => ['nullable', 'string', 'max:500'],
        ]);

        $user = $request->user();
        $appointment = DB::transaction(function () use ($validated, $appointment, $user) {
            $appointment = Appointment::query()
                ->whereKey($appointment->id)
                ->lockForUpdate()
                ->firstOrFail();
            $ownsAppointment = $user->role === 'patient'
                && $user->patient?->id === $appointment->patient_id;
            $isDoctor = $user->role === 'doctor'
                && $user->doctor?->id === $appointment->doctor_id;

            abort_unless($ownsAppointment || $isDoctor || $user->role === 'admin', 403);
            abort_unless($appointment->status === 'booked', 409, 'لا يمكن إلغاء هذا الموعد.');
            abort_unless(
                Carbon::parse($appointment->appointment_at)->isFuture(),
                409,
                'لا يمكن إلغاء موعد بدأ أو انتهى.',
            );

            $appointment->update([
                'status' => 'cancelled',
                'cancellation_reason' => $validated['reason'] ?? null,
            ]);
            AuditLog::create([
                'actor_user_id' => $user->id,
                'action' => 'appointment.cancelled',
                'entity_type' => Appointment::class,
                'entity_id' => $appointment->id,
            ]);

            return $appointment;
        });

        $appointment->loadMissing(['doctor.user', 'patient.user']);
        Mail::to($appointment->patient->user->email)
            ->queue(new AppointmentStatusMail($appointment, 'cancelled'));

        return response()->json([
            'data' => $this->appointmentData($appointment->fresh()->load(['doctor.user', 'doctor.specialty']), false),
        ]);
    }

    private function currentPatient(Request $request): Patient
    {
        $patient = $request->user()->patient;
        abort_unless($request->user()->role === 'patient' && $patient, 403, 'هذه العملية متاحة للمريض فقط.');

        return $patient;
    }

    private function authorizeView(Request $request, Appointment $appointment): void
    {
        $user = $request->user();
        $authorized = $user->role === 'admin'
            || ($user->role === 'patient' && $user->patient?->id === $appointment->patient_id)
            || ($user->role === 'doctor' && $user->doctor?->id === $appointment->doctor_id);

        abort_unless($authorized, 404);
    }

    private function appointmentData(Appointment $appointment, bool $includePatient): array
    {
        $data = [
            'id' => $appointment->id,
            'starts_at' => Carbon::parse($appointment->appointment_at)->toIso8601String(),
            'ends_at' => $appointment->ends_at
                ? Carbon::parse($appointment->ends_at)->toIso8601String()
                : null,
            'status' => $appointment->status,
            'cancellation_reason' => $appointment->cancellation_reason,
            'doctor' => [
                'id' => $appointment->doctor?->id,
                'name' => trim(($appointment->doctor?->user?->first_name ?? '').' '.($appointment->doctor?->user?->last_name ?? '')),
                'specialty' => $appointment->doctor?->specialty?->name,
            ],
        ];

        if ($includePatient) {
            $data['patient'] = [
                'id' => $appointment->patient?->id,
                'name' => trim(($appointment->patient?->user?->first_name ?? '').' '.($appointment->patient?->user?->last_name ?? '')),
                'phone' => $appointment->patient?->user?->phone,
            ];
        }

        return $data;
    }
}
