<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Appointment;
use App\Models\AuditLog;
use App\Models\Doctor;
use App\Models\Specialty;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AdminController extends Controller
{
    public function reports()
    {
        return response()->json([
            'data' => [
                'users' => User::query()->selectRaw('role, count(*) as total')->groupBy('role')->pluck('total', 'role'),
                'doctors' => Doctor::query()->selectRaw('is_active, count(*) as total')->groupBy('is_active')->pluck('total', 'is_active'),
                'appointments' => Appointment::query()->selectRaw('status, count(*) as total')->groupBy('status')->pluck('total', 'status'),
                'upcoming_appointments' => Appointment::query()
                    ->where('status', 'booked')
                    ->where('appointment_at', '>', now())
                    ->count(),
            ],
        ]);
    }

    public function appointments(Request $request)
    {
        $validated = $request->validate([
            'status' => ['nullable', 'in:booked,cancelled,completed,no_show'],
            'doctor_id' => ['nullable', 'integer', 'exists:doctors,id'],
            'from' => ['nullable', 'date'],
            'to' => ['nullable', 'date', 'after_or_equal:from'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
        ]);

        $appointments = Appointment::query()
            ->with(['doctor.user', 'doctor.specialty', 'patient.user'])
            ->when($validated['status'] ?? null, fn ($query, $status) => $query->where('status', $status))
            ->when($validated['doctor_id'] ?? null, fn ($query, $id) => $query->where('doctor_id', $id))
            ->when($validated['from'] ?? null, fn ($query, $date) => $query->whereDate('appointment_at', '>=', $date))
            ->when($validated['to'] ?? null, fn ($query, $date) => $query->whereDate('appointment_at', '<=', $date))
            ->orderByDesc('appointment_at')
            ->paginate($validated['per_page'] ?? 20);

        return response()->json($appointments);
    }

    public function doctors(Request $request)
    {
        $validated = $request->validate([
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
            'is_active' => ['nullable', 'boolean'],
        ]);

        $doctors = Doctor::query()
            ->with(['user', 'specialty', 'schedules'])
            ->when(
                array_key_exists('is_active', $validated),
                fn ($query) => $query->where('is_active', $validated['is_active']),
            )
            ->orderBy('id')
            ->paginate($validated['per_page'] ?? 20);

        return response()->json($doctors);
    }

    public function updateDoctor(Request $request, Doctor $doctor)
    {
        $validated = $request->validate([
            'specialty_id' => ['sometimes', 'nullable', 'integer', 'exists:specialties,id'],
            'bio' => ['sometimes', 'nullable', 'string', 'max:5000'],
            'price' => ['sometimes', 'nullable', 'numeric', 'min:0', 'max:99999999.99'],
            'is_active' => ['sometimes', 'boolean'],
        ]);

        DB::transaction(function () use ($request, $doctor, $validated) {
            $doctor = Doctor::query()->whereKey($doctor->id)->lockForUpdate()->firstOrFail();
            $doctor->fill($validated)->save();

            if (array_key_exists('is_active', $validated)) {
                $doctor->user()->update(['is_active' => $validated['is_active']]);
            }

            AuditLog::create([
                'actor_user_id' => $request->user()->id,
                'action' => 'doctor.updated',
                'entity_type' => Doctor::class,
                'entity_id' => $doctor->id,
                'metadata' => ['fields' => array_keys($validated)],
            ]);
        });

        return response()->json([
            'data' => $doctor->fresh()->load(['user', 'specialty']),
        ]);
    }

    public function storeSpecialty(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255', 'unique:specialties,name'],
            'description' => ['nullable', 'string', 'max:5000'],
        ]);

        $specialty = Specialty::create($validated + ['is_active' => true]);
        $this->log($request, 'specialty.created', Specialty::class, $specialty->id);

        return response()->json(['data' => $specialty], 201);
    }

    public function updateSpecialty(Request $request, Specialty $specialty)
    {
        $validated = $request->validate([
            'name' => ['sometimes', 'required', 'string', 'max:255', 'unique:specialties,name,'.$specialty->id],
            'description' => ['sometimes', 'nullable', 'string', 'max:5000'],
            'is_active' => ['sometimes', 'boolean'],
        ]);

        $specialty->update($validated);
        $this->log($request, 'specialty.updated', Specialty::class, $specialty->id, array_keys($validated));

        return response()->json(['data' => $specialty->fresh()]);
    }

    public function users(Request $request)
    {
        $validated = $request->validate([
            'role' => ['nullable', 'in:admin,doctor,patient'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
        ]);

        return response()->json(
            User::query()
                ->select(['id', 'first_name', 'last_name', 'email', 'phone', 'role', 'is_active', 'created_at'])
                ->when($validated['role'] ?? null, fn ($query, $role) => $query->where('role', $role))
                ->orderBy('id')
                ->paginate($validated['per_page'] ?? 20),
        );
    }

    public function updateUser(Request $request, User $user)
    {
        $validated = $request->validate([
            'first_name' => ['sometimes', 'required', 'string', 'max:100'],
            'last_name' => ['sometimes', 'required', 'string', 'max:100'],
            'phone' => ['sometimes', 'required', 'string', 'max:30', 'unique:users,phone,'.$user->id],
            'is_active' => ['sometimes', 'boolean'],
        ]);

        $user->update($validated);
        $this->log($request, 'user.updated', User::class, $user->id, array_keys($validated));

        return response()->json([
            'data' => $user->fresh()->only([
                'id',
                'first_name',
                'last_name',
                'email',
                'phone',
                'role',
                'is_active',
            ]),
        ]);
    }

    private function log(
        Request $request,
        string $action,
        string $entityType,
        int $entityId,
        array $fields = [],
    ): void {
        AuditLog::create([
            'actor_user_id' => $request->user()->id,
            'action' => $action,
            'entity_type' => $entityType,
            'entity_id' => $entityId,
            'metadata' => $fields ? ['fields' => $fields] : null,
        ]);
    }
}
