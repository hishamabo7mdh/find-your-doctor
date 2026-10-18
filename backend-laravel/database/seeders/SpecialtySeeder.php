<?php

namespace Database\Seeders;

use App\Models\Specialty;
use Illuminate\Database\Seeder;

class SpecialtySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $specialties = [
            'قلب' => 'assets/images/cardiology.png',
            'صدرية' => 'assets/images/respiratory.svg',
            'دم' => 'assets/images/blood.svg',
            'أطفال' => 'assets/images/pediatrics.png',
            'جلدية' => 'assets/images/dermatologist.png',
            'عظمية' => 'assets/images/orthopedics.svg',
            'نسائية' => 'assets/images/gynecology.svg',
            'أذن وأنف وحنجرة' => 'assets/images/ent.svg',
            'عيون' => 'assets/images/ophthalmology.png',
            'أسنان' => 'assets/images/Dentistry.png',
            'طب نفسي' => 'assets/images/psychiatry.png',
        ];

        foreach ($specialties as $name => $imagePath) {
            Specialty::updateOrCreate(
                ['name' => $name],
                ['image_path' => $imagePath],
            );
        }
    }
}
