import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/home/admin_home/data/models/admin_records.dart';

void main() {
  group('AdminDoctor', () {
    test('reads the admin doctor response with related user data', () {
      final doctor = AdminDoctor.fromJson({
        'id': 7,
        'is_active': true,
        'price': '125.00',
        'user': {
          'first_name': 'Sara',
          'last_name': 'Ali',
          'phone': '0501234567',
        },
        'specialty': {'name': 'Cardiology'},
      });

      expect(doctor.id, 7);
      expect(doctor.name, 'Sara Ali');
      expect(doctor.isActive, isTrue);
      expect(doctor.phone, '0501234567');
      expect(doctor.specialty, 'Cardiology');
      expect(doctor.price, 125);
    });
  });

  group('AdminPatient', () {
    test('reads the user list response', () {
      final patient = AdminPatient.fromJson({
        'id': 11,
        'first_name': 'Omar',
        'last_name': 'Noor',
        'email': 'omar@example.com',
        'phone': '0555555555',
        'is_active': false,
      });

      expect(patient.name, 'Omar Noor');
      expect(patient.email, 'omar@example.com');
      expect(patient.isActive, isFalse);
    });
  });

  group('AdminAppointment', () {
    test('reads nested appointment relations and appointment_at', () {
      final appointment = AdminAppointment.fromJson({
        'id': 15,
        'appointment_at': '2026-10-17T09:30:00.000000Z',
        'status': 'booked',
        'patient': {
          'user': {'first_name': 'Mona', 'last_name': 'Saleh'},
        },
        'doctor': {
          'user': {'first_name': 'Hadi', 'last_name': 'Khaled'},
          'specialty': {'name': 'Pediatrics'},
        },
      });

      expect(appointment.patientName, 'Mona Saleh');
      expect(appointment.doctorName, 'Hadi Khaled');
      expect(appointment.specialty, 'Pediatrics');
      expect(appointment.status, 'booked');
      expect(appointment.startsAt.toUtc(), DateTime.utc(2026, 10, 17, 9, 30));
    });
  });
}
