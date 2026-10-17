import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/home/patientHome/data/models/doctor_model.dart';

void main() {
  test('doctor details and appointment slots decode API responses', () {
    final doctor = DoctorModel.fromJson({
      'id': 7,
      'name': 'د. أحمد',
      'specialty': 'طب الأسرة',
      'price': 25.5,
      'bio': 'خبرة في طب الأسرة',
    });
    final slot = AppointmentSlot.fromJson({
      'starts_at': '2026-10-17T14:00:00+03:00',
      'ends_at': '2026-10-17T14:30:00+03:00',
    });

    expect(doctor.id, 7);
    expect(doctor.specialty, 'طب الأسرة');
    expect(doctor.price, 25.5);
    expect(slot.endsAt.difference(slot.startsAt), const Duration(minutes: 30));
  });
}
