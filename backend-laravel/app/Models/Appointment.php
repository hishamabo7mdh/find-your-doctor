<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Appointment extends Model
{
    protected $fillable = [
        'doctor_id',
        'patient_id',
        'created_by_user_id',
        'appointment_at',
        'ends_at',
        'status',
        'notes',
        'cancellation_reason',
        'idempotency_key',
    ];

    protected function casts(): array
    {
        return [
            'appointment_at' => 'datetime',
            'ends_at' => 'datetime',
        ];
    }

    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }

    public function patient()
    {
        return $this->belongsTo(Patient::class);
    }

    public function createdBy()
    {
        return $this->belongsTo(User::class, 'created_by_user_id');
    }
}
