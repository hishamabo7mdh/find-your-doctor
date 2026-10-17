<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Doctor;
use App\Models\Specialty;
use Illuminate\Http\Request;

class SearchController extends Controller
{
    public function __invoke(Request $request)
    {
        $validated = $request->validate([
            'q' => ['required', 'string', 'min:1', 'max:100'],
        ]);

        $term = $validated['q'];
        $doctors = Doctor::query()
            ->with(['user', 'specialty'])
            ->where('is_active', true)
            ->whereHas('user', fn ($query) => $query->where('is_active', true))
            ->whereHas('user', function ($query) use ($term) {
                $query->where('first_name', 'like', "%{$term}%")
                    ->orWhere('last_name', 'like', "%{$term}%");
            })
            ->limit(8)
            ->get()
            ->map(fn (Doctor $doctor) => [
                'type' => 'doctor',
                'id' => $doctor->id,
                'label' => trim($doctor->user->first_name.' '.$doctor->user->last_name),
                'specialty' => $doctor->specialty?->name,
            ]);

        $specialties = Specialty::query()
            ->where('is_active', true)
            ->where('name', 'like', "%{$term}%")
            ->orderBy('name')
            ->limit(8)
            ->get(['id', 'name'])
            ->map(fn (Specialty $specialty) => [
                'type' => 'specialty',
                'id' => $specialty->id,
                'label' => $specialty->name,
            ]);

        return response()->json([
            'data' => $doctors->concat($specialties)->values(),
        ]);
    }
}
