class DoctorModel {
  const DoctorModel({
    required this.id,
    required this.name,
    this.specialty,
    this.price,
    this.bio,
  });

  final int id;
  final String name;
  final String? specialty;
  final num? price;
  final String? bio;

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      specialty: json['specialty'] as String?,
      price: json['price'] as num?,
      bio: json['bio'] as String?,
    );
  }
}

class AppointmentSlot {
  const AppointmentSlot({required this.startsAt, required this.endsAt});

  final DateTime startsAt;
  final DateTime endsAt;

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) {
    return AppointmentSlot(
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
    );
  }
}

class AppointmentModel {
  const AppointmentModel({
    required this.id,
    required this.startsAt,
    required this.status,
    required this.doctorName,
    this.specialty,
    this.endsAt,
  });

  final int id;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String status;
  final String doctorName;
  final String? specialty;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final doctor = Map<String, dynamic>.from(
      json['doctor'] as Map? ?? const {},
    );

    return AppointmentModel(
      id: json['id'] as int,
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: json['ends_at'] == null
          ? null
          : DateTime.parse(json['ends_at'] as String),
      status: json['status'] as String? ?? '',
      doctorName: doctor['name'] as String? ?? '',
      specialty: doctor['specialty'] as String?,
    );
  }
}
