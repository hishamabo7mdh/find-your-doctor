class AdminDoctor {
  const AdminDoctor({
    required this.id,
    required this.name,
    required this.isActive,
    this.specialty,
    this.phone,
    this.price,
  });

  final int id;
  final String name;
  final bool isActive;
  final String? specialty;
  final String? phone;
  final num? price;

  factory AdminDoctor.fromJson(Map<String, dynamic> json) {
    final user = _map(json['user']);
    final specialty = _map(json['specialty']);
    return AdminDoctor(
      id: _int(json['id']),
      name: _name(user),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      specialty: specialty['name'] as String?,
      phone: user['phone'] as String?,
      price: _num(json['price']),
    );
  }
}

class AdminPatient {
  const AdminPatient({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    this.phone,
  });

  final int id;
  final String name;
  final String email;
  final bool isActive;
  final String? phone;

  factory AdminPatient.fromJson(Map<String, dynamic> json) {
    return AdminPatient(
      id: _int(json['id']),
      name: _name(json),
      email: json['email'] as String? ?? '',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      phone: json['phone'] as String?,
    );
  }
}

class AdminAppointment {
  const AdminAppointment({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.startsAt,
    required this.status,
    this.specialty,
  });

  final int id;
  final String patientName;
  final String doctorName;
  final DateTime startsAt;
  final String status;
  final String? specialty;

  factory AdminAppointment.fromJson(Map<String, dynamic> json) {
    final doctor = _map(json['doctor']);
    final patient = _map(json['patient']);
    final doctorUser = _map(doctor['user']);
    final patientUser = _map(patient['user']);
    final specialty = _map(doctor['specialty']);
    final startsAt = json['appointment_at'] ?? json['starts_at'];

    if (startsAt is! String) {
      throw const FormatException('Appointment is missing its start time.');
    }

    return AdminAppointment(
      id: _int(json['id']),
      patientName: _name(patientUser),
      doctorName: _name(doctorUser),
      startsAt: DateTime.parse(startsAt),
      status: json['status'] as String? ?? '',
      specialty: specialty['name'] as String?,
    );
  }
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};

String _name(Map<String, dynamic> user) {
  final firstName = user['first_name'] as String? ?? '';
  final lastName = user['last_name'] as String? ?? '';
  return '$firstName $lastName'.trim();
}

int _int(Object? value) => value is num ? value.toInt() : 0;

num? _num(Object? value) => switch (value) {
  num number => number,
  String text => num.tryParse(text),
  _ => null,
};
