<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\CreateDoctorRequest;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Http\Resources\UserResource;
use App\Models\AuditLog;
use App\Models\Doctor;
use App\Models\Patient;
use App\Models\Schedule;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class AuthController extends Controller
{
    public function register(RegisterRequest $request)
    {
        DB::beginTransaction();

        try {

            $user = $this->createUser($request, 'patient');

            Patient::create([
                'user_id' => $user->id,
            ]);

            $token = $user->createToken('mobile')->plainTextToken;

            DB::commit();

            return response()->json([
                'user' => new UserResource($user),
                'token' => $token,
            ], 201);
        } catch (\Throwable $e) {

            DB::rollBack();

            throw $e;
        }
    }

    public function createDoctor(CreateDoctorRequest $request)
    {
        DB::beginTransaction();

        try {
            $user = $this->createUser($request, 'doctor');

            $doctor = Doctor::create([
                'user_id' => $user->id,
                'specialty_id' => $request->specialty_id,
                'bio' => $request->bio,
                'price' => $request->price,
                'is_active' => $request->is_active ?? true,
            ]);

            foreach ($request->days_of_week as $day) {
                Schedule::create([
                    'doctor_id' => $doctor->id,
                    'day_of_week' => $day,
                    'start_time' => $request->start_time,
                    'end_time' => $request->end_time,
                    'duration_minutes' => $request->duration_minutes ?? 30,
                    'is_active' => $request->is_active ?? true,
                ]);
            }

            AuditLog::create([
                'actor_user_id' => $request->user()->id,
                'action' => 'doctor.created',
                'entity_type' => Doctor::class,
                'entity_id' => $doctor->id,
                'metadata' => ['specialty_id' => $doctor->specialty_id],
            ]);

            DB::commit();

            return response()->json([
                'user' => new UserResource($user),
            ], 201);
        } catch (\Throwable $e) {

            DB::rollBack();

            throw $e;
        }
    }

    private function createUser(RegisterRequest|CreateDoctorRequest $request, string $role): User
    {
        return User::create([
            'first_name' => $request->first_name,
            'last_name'  => $request->last_name,
            'email'      => $request->email,
            'phone'      => $request->phone,
            'password'   => bcrypt($request->password),
            'role'       => $role,
        ]);
    }
    public function login(LoginRequest $request)
    {



        $field = filter_var($request->login, FILTER_VALIDATE_EMAIL)
            ? 'email'
            : 'phone';

        if (!Auth::attempt([
            $field => $request->login,
            'password' => $request->password,
        ])) {
            return response()->json([
                'message' => 'Invalid credentials',
            ], 401);
        }

        $user = User::find(Auth::id());

        if (!$user->is_active) {

            return response()->json([
                'message' => 'Account disabled'
            ], 403);
        }

        $token = $user->createToken('mobile')->plainTextToken;

        return response()->json([
            'user' => new UserResource($user),
            'token' => $token,
        ]);
    }
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logged out successfully'
        ]);
    }
}
