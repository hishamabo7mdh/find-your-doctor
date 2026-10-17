<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DoctorLeave extends Model
{
    protected $fillable = [
        'doctor_id',
        'start_date',
        'end_date',
        'reason',
    ];

    protected function casts(): array
    {
        return [
            'start_date' => 'date',
            'end_date' => 'date',
        ];
    }
}
