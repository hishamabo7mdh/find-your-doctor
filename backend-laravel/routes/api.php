<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AppointmentController;
use App\Http\Controllers\Api\AdminController;
use App\Http\Controllers\Api\DoctorController;
use App\Http\Controllers\Api\DoctorScheduleController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\SearchController;
use App\Http\Resources\UserResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::get('/doctors', [DoctorController::class, 'index']);
Route::get('/doctors/{doctor}/slots', [DoctorController::class, 'slots']);
Route::get('/doctors/{doctor}/nearest-slot', [DoctorController::class, 'nearestSlot']);
Route::get('/doctors/{doctor}', [DoctorController::class, 'show']);
Route::get('/specialties', [DoctorController::class, 'specialties']);
Route::get('/search', SearchController::class);

Route::prefix('auth')->group(function () {

    Route::post('/register', [AuthController::class, 'register']);

    Route::post('/login', [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {

        Route::post('/logout', [AuthController::class, 'logout']);

        Route::get('/me', function (Request $request) {
            return new UserResource($request->user());
        });
        Route::put('/me', [ProfileController::class, 'update']);

        Route::post('/admin/doctors', [AuthController::class, 'createDoctor'])
        ->middleware('role:admin');

    });
});

Route::middleware('auth:sanctum')->group(function () {
    Route::middleware('role:patient')->group(function () {
        Route::get('/appointments/my', [AppointmentController::class, 'mine']);
        Route::post('/appointments', [AppointmentController::class, 'store']);
    });

    Route::middleware('role:doctor')->get(
        '/doctor/appointments',
        [AppointmentController::class, 'doctorAppointments'],
    );
    Route::middleware('role:doctor')->group(function () {
        Route::post('/doctor/appointments', [AppointmentController::class, 'storeForDoctor']);
        Route::put('/doctor/schedules', [DoctorScheduleController::class, 'update']);
        Route::post('/doctor/leaves', [DoctorScheduleController::class, 'createLeave']);
    });

    Route::get('/appointments/{appointment}', [AppointmentController::class, 'show']);
    Route::delete('/appointments/{appointment}', [AppointmentController::class, 'cancel']);

    Route::prefix('admin')->middleware('role:admin')->group(function () {
        Route::get('/reports', [AdminController::class, 'reports']);
        Route::get('/appointments', [AdminController::class, 'appointments']);
        Route::get('/doctors', [AdminController::class, 'doctors']);
        Route::patch('/doctors/{doctor}', [AdminController::class, 'updateDoctor']);
        Route::get('/users', [AdminController::class, 'users']);
        Route::patch('/users/{user}', [AdminController::class, 'updateUser']);
        Route::post('/specialties', [AdminController::class, 'storeSpecialty']);
        Route::put('/specialties/{specialty}', [AdminController::class, 'updateSpecialty']);
    });
});