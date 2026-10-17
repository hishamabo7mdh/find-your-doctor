<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function update(Request $request)
    {
        $validated = $request->validate([
            'first_name' => ['required', 'string', 'max:100'],
            'last_name' => ['required', 'string', 'max:100'],
            'phone' => [
                'required',
                'string',
                'max:30',
                'unique:users,phone,'.$request->user()->id,
            ],
        ]);

        $user = $request->user();
        $user->update($validated);

        return response()->json([
            'data' => new UserResource($user->fresh()),
        ]);
    }
}
