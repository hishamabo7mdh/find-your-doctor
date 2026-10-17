<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('doctors', function (Blueprint $table) {
            $table->foreignId('specialty_id')->nullable()->after('user_id')->constrained()->nullOnDelete();
            $table->text('bio')->nullable();
            $table->decimal('price', 10, 2)->nullable();
            $table->boolean('is_active')->default(true);
            $table->unique('user_id');
        });

        Schema::table('schedules', function (Blueprint $table) {
            $table->foreignId('doctor_id')->constrained()->cascadeOnDelete();
            $table->string('day_of_week', 10);
            $table->time('start_time');
            $table->time('end_time');
            $table->unsignedSmallInteger('duration_minutes')->default(30);
            $table->boolean('is_active')->default(true);
            $table->index(['doctor_id', 'day_of_week', 'is_active']);
        });

        Schema::table('appointments', function (Blueprint $table) {
            $table->dateTime('ends_at')->nullable()->after('appointment_at');
            $table->foreignId('created_by_user_id')->nullable()->after('patient_id')
                ->constrained('users')->nullOnDelete();
            $table->string('cancellation_reason')->nullable();
            $table->string('idempotency_key', 100)->nullable();
            $table->unique(['patient_id', 'idempotency_key']);
            $table->index(['doctor_id', 'appointment_at', 'status']);
            $table->index(['patient_id', 'appointment_at', 'status']);
        });
    }

    public function down(): void
    {
        Schema::table('appointments', function (Blueprint $table) {
            $table->dropIndex(['doctor_id', 'appointment_at', 'status']);
            $table->dropIndex(['patient_id', 'appointment_at', 'status']);
            $table->dropUnique(['patient_id', 'idempotency_key']);
            $table->dropConstrainedForeignId('created_by_user_id');
            $table->dropColumn(['ends_at', 'cancellation_reason', 'idempotency_key']);
        });

        Schema::table('schedules', function (Blueprint $table) {
            $table->dropIndex(['doctor_id', 'day_of_week', 'is_active']);
            $table->dropConstrainedForeignId('doctor_id');
            $table->dropColumn([
                'day_of_week',
                'start_time',
                'end_time',
                'duration_minutes',
                'is_active',
            ]);
        });

        Schema::table('doctors', function (Blueprint $table) {
            $table->dropUnique(['user_id']);
            $table->dropConstrainedForeignId('specialty_id');
            $table->dropColumn(['bio', 'price', 'is_active']);
        });
    }
};
