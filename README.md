1. Start the Laravel server:

   php artisan serve --host=0.0.0.0 --port=8000

2. Before running Flutter, connect your device and make sure it is detected.

3. Update the BaseURL in:
   
   Core/constants.dart

   Replace it with your computer's IP address (do not use localhost).