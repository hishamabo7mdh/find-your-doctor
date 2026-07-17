<?php

namespace Database\Seeders;

use App\Models\Specialty;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class SpecialtySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $specialties = [
            'قلب',
            'صدرية',
            'دم',
            'أطفال',
            'جلدية',
            'عظمية',
            'نسائية',
            'أذن وأنف وحنجرة',
            'عيون',
            'أسنان',
        ];
        foreach ($specialties as $specialty) {
            Specialty::create([
                'name' => $specialty,
            ]);
        }
    }
}
