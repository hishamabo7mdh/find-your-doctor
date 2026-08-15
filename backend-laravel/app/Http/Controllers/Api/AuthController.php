<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\CreateDoctorRequest;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Http\Resources\UserResource;
use App\Models\Doctor;
use App\Models\Patient;
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

            Doctor::create([
                'user_id' => $user->id,
                'day_of_week' => $request->day_of_week,
                'start_time' => $request->start_time,
                'end_time' => $request->end_time,
                'is_active' => $request->is_active ?? true,
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
