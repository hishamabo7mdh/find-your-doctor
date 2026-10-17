<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="utf-8">
    <title>{{ $event === 'booked' ? 'تأكيد حجز الموعد' : 'إلغاء الموعد' }}</title>
</head>
<body>
    <h1>{{ $event === 'booked' ? 'تم تأكيد موعدك' : 'تم إلغاء موعدك' }}</h1>
    <p>الطبيب: {{ $appointment->doctor->user->first_name }} {{ $appointment->doctor->user->last_name }}</p>
    <p>التاريخ والوقت: {{ $appointment->appointment_at->format('Y-m-d H:i') }}</p>
    <p>الحالة: {{ $event === 'booked' ? 'مؤكد' : 'ملغى' }}</p>
</body>
</html>
