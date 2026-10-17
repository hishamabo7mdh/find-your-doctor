# Find Your Doctor

## Laravel API

1. Configure the database and mail connection in `backend-laravel/.env`.
2. Run `php artisan migrate --seed` from `backend-laravel`.
3. Start the API with `php artisan serve --host=0.0.0.0 --port=8000`.
4. Run `php artisan queue:work` to process appointment email notifications when
   the queue connection is asynchronous.

## Flutter app

1. Set `ApiConstants.baseUrl` in `mobile-flutter/lib/core/constants/api_constants.dart`.
   Use `http://10.0.2.2:8000/api` for the Android emulator, or the computer's LAN
   IP address for a physical device.
2. Run `flutter pub get` and `flutter run` from `mobile-flutter`.

The patient flow includes doctor search, available appointment times, booking,
and appointment cancellation. Laravel protects appointments and patient data
with Sanctum authentication and role/ownership checks.
