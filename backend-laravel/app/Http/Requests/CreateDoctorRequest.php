<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class CreateDoctorRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'first_name' => ['required', 'string', 'max:100'],
            'last_name'  => ['required', 'string', 'max:100'],
            'email'      => ['required', 'email', 'unique:users,email'],
            'phone'      => ['required', 'unique:users,phone'],
            'password'   => ['required', 'confirmed', 'min:8'],
            'specialty_id' => ['required', 'integer', 'exists:specialties,id'],
            'bio' => ['nullable', 'string', 'max:5000'],
            'price' => ['nullable', 'numeric', 'min:0', 'max:99999999.99'],
            'days_of_week' => ['required', 'array', 'min:1'],
            'days_of_week.*' => [
                'required',
                'string',
                'distinct',
                'in:saturday,sunday,monday,tuesday,wednesday,thursday,friday',
            ],
            'start_time' => ['required', 'date_format:H:i'],
            'end_time' => ['required', 'date_format:H:i', 'after:start_time'],
            'duration_minutes' => ['nullable', 'integer', 'min:5', 'max:240'],
            'is_active' => ['boolean'],
        ];
    }
}
