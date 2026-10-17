<?php

namespace Tests\Feature;

use App\Models\Appointment;
use App\Models\Doctor;
use App\Models\Patient;
use App\Models\Schedule;
use App\Models\Specialty;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Mail;
use App\Mail\AppointmentStatusMail;
use Tests\TestCase;

class AppointmentFlowTest extends TestCase
{
    use RefreshDatabase;

    public function test_public_registration_creates_a_patient_and_returns_a_token(): void
    {
        $this->postJson('/api/auth/register', [
            'first_name' => 'مها',
            'last_name' => 'علي',
            'email' => 'maha@example.test',
            'phone' => '0998765432',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ])
            ->assertCreated()
            ->assertJsonPath('user.role', 'patient')
            ->assertJsonStructure(['user', 'token']);

        $this->assertDatabaseCount('patients', 1);
    }

    public function test_authenticated_user_can_update_allowed_profile_fields(): void
    {
        $user = User::factory()->create([
            'role' => 'patient',
            'phone' => '0900000001',
        ]);

        $this->actingAs($user)
            ->putJson('/api/auth/me', [
                'first_name' => 'ليلى',
                'last_name' => 'أحمد',
                'phone' => '0900000002',
            ])
            ->assertOk()
            ->assertJsonPath('data.first_name', 'ليلى')
            ->assertJsonPath('data.phone', '0900000002')
            ->assertJsonMissingPath('data.password');
    }

    public function test_patient_can_book_an_available_slot_idempotently_and_cancel_it(): void
    {
        Mail::fake();
        [$patientUser, $doctor, $startsAt] = $this->createAvailableSlot();

        $firstBooking = $this->actingAs($patientUser)
            ->withHeader('Idempotency-Key', 'patient-booking-001')
            ->postJson('/api/appointments', [
                'doctor_id' => $doctor->id,
                'starts_at' => $startsAt->toIso8601String(),
            ]);

        $firstBooking->assertCreated()
            ->assertJsonPath('data.status', 'booked')
            ->assertJsonPath('data.doctor.id', $doctor->id);

        $this->withHeader('Idempotency-Key', 'patient-booking-001')
            ->postJson('/api/appointments', [
                'doctor_id' => $doctor->id,
                'starts_at' => $startsAt->toIso8601String(),
            ])
            ->assertCreated()
            ->assertJsonPath('data.id', $firstBooking->json('data.id'));
        Mail::assertQueued(AppointmentStatusMail::class, 1);

        $this->deleteJson('/api/appointments/'.$firstBooking->json('data.id'), [
            'reason' => 'تغيير الموعد',
        ])->assertOk()->assertJsonPath('data.status', 'cancelled');

        Mail::assertQueued(AppointmentStatusMail::class, 2);
        $this->assertDatabaseCount('appointments', 1);
    }

    public function test_another_patient_cannot_book_an_occupied_slot(): void
    {
        [$patientUser, $doctor, $startsAt] = $this->createAvailableSlot();

        $this->actingAs($patientUser)->postJson('/api/appointments', [
            'doctor_id' => $doctor->id,
            'starts_at' => $startsAt->toIso8601String(),
        ])->assertCreated();

        $anotherPatient = User::factory()->create(['role' => 'patient']);
        Patient::create(['user_id' => $anotherPatient->id]);

        $this->actingAs($anotherPatient)->postJson('/api/appointments', [
            'doctor_id' => $doctor->id,
            'starts_at' => $startsAt->toIso8601String(),
        ])->assertConflict();
    }

    public function test_patient_cannot_read_another_patients_appointment(): void
    {
        [$patientUser, $doctor, $startsAt] = $this->createAvailableSlot();
        $patient = $patientUser->patient;
        $appointment = Appointment::create([
            'doctor_id' => $doctor->id,
            'patient_id' => $patient->id,
            'appointment_at' => $startsAt,
            'ends_at' => $startsAt->copy()->addMinutes(30),
            'status' => 'booked',
        ]);

        $anotherPatient = User::factory()->create(['role' => 'patient']);
        Patient::create(['user_id' => $anotherPatient->id]);

        $this->actingAs($anotherPatient)
            ->getJson('/api/appointments/'.$appointment->id)
            ->assertNotFound();
    }

    public function test_public_doctor_search_returns_only_active_doctors(): void
    {
        [, $doctor] = $this->createAvailableSlot();
        $query = $doctor->user->first_name;

        $this->getJson('/api/doctors?q='.$query)
            ->assertOk()
            ->assertJsonPath('data.0.id', $doctor->id);

        $doctor->update(['is_active' => false]);

        $this->getJson('/api/doctors?q='.$query)
            ->assertOk()
            ->assertJsonCount(0, 'data');
    }

    public function test_patient_cannot_access_admin_reports(): void
    {
        $patient = User::factory()->create(['role' => 'patient']);

        $this->actingAs($patient)
            ->getJson('/api/admin/reports')
            ->assertForbidden();
    }

    public function test_admin_can_create_a_doctor_with_a_specialty_and_weekly_schedule(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $specialty = Specialty::create(['name' => 'طب العيون']);

        $this->actingAs($admin)
            ->postJson('/api/auth/admin/doctors', [
                'first_name' => 'سمر',
                'last_name' => 'خالد',
                'email' => 'samar@example.test',
                'phone' => '0912345678',
                'password' => 'password123',
                'password_confirmation' => 'password123',
                'specialty_id' => $specialty->id,
                'days_of_week' => ['monday', 'wednesday'],
                'start_time' => '09:00',
                'end_time' => '17:00',
                'is_active' => true,
            ])
            ->assertCreated()
            ->assertJsonPath('user.role', 'doctor')
            ->assertJsonMissingPath('token');

        $doctor = Doctor::query()->firstOrFail();
        $this->assertSame($specialty->id, $doctor->specialty_id);
        $this->assertDatabaseCount('schedules', 2);
        $this->assertDatabaseHas('audit_logs', [
            'action' => 'doctor.created',
            'entity_id' => $doctor->id,
        ]);
    }

    public function test_doctor_cannot_change_schedule_around_confirmed_appointments(): void
    {
        [$patientUser, $doctor, $startsAt] = $this->createAvailableSlot();
        $doctorUser = $doctor->user;
        $this->actingAs($patientUser)->postJson('/api/appointments', [
            'doctor_id' => $doctor->id,
            'starts_at' => $startsAt->toIso8601String(),
        ])->assertCreated();

        $this->actingAs($doctorUser)
            ->putJson('/api/doctor/schedules', [
                'schedules' => [[
                    'day_of_week' => strtolower($startsAt->englishDayOfWeek),
                    'start_time' => '15:00',
                    'end_time' => '16:00',
                    'duration_minutes' => 30,
                ]],
            ])
            ->assertConflict();

        $this->assertDatabaseHas('schedules', [
            'doctor_id' => $doctor->id,
            'start_time' => '14:00',
        ]);
    }

    public function test_doctor_leave_hides_available_slots_for_that_date(): void
    {
        [, $doctor, $startsAt] = $this->createAvailableSlot();

        $this->actingAs($doctor->user)
            ->postJson('/api/doctor/leaves', [
                'start_date' => $startsAt->toDateString(),
                'end_date' => $startsAt->toDateString(),
                'reason' => 'إجازة',
            ])
            ->assertCreated();

        $this->getJson('/api/doctors/'.$doctor->id.'/slots?from='.$startsAt->toDateString().'&to='.$startsAt->toDateString())
            ->assertOk()
            ->assertJsonCount(0, 'data');

        $this->assertDatabaseHas('doctor_leaves', [
            'doctor_id' => $doctor->id,
            'reason' => 'إجازة',
        ]);
    }

    private function createAvailableSlot(): array
    {
        $patientUser = User::factory()->create(['role' => 'patient']);
        Patient::create(['user_id' => $patientUser->id]);

        $doctorUser = User::factory()->create(['role' => 'doctor']);
        $specialty = Specialty::create(['name' => 'طب الأسرة']);
        $doctor = Doctor::create([
            'user_id' => $doctorUser->id,
            'specialty_id' => $specialty->id,
        ]);

        $startsAt = Carbon::tomorrow()->setTime(14, 0);
        Schedule::create([
            'doctor_id' => $doctor->id,
            'day_of_week' => strtolower($startsAt->englishDayOfWeek),
            'start_time' => '14:00',
            'end_time' => '15:00',
            'duration_minutes' => 30,
            'is_active' => true,
        ]);

        return [$patientUser, $doctor, $startsAt];
    }
}
