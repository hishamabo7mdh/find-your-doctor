<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::updateOrCreate(
            [
                'email' => 'admin@medical.com',
            ],
            [
                'first_name' => 'Admin',
                'last_name' => 'Medical',
                'phone' => '0700000000',
                'password' => Hash::make('Admin@123456'),
                'role' => 'admin',
            ]
        );
    }
}
