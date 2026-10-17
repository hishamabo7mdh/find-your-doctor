class DoctorAppointmentModel {
  const DoctorAppointmentModel({
    required this.id,
    required this.patientName,
    required this.startsAt,
    required this.status,
    this.patientPhone,
  });

  final int id;
  final String patientName;
  final String? patientPhone;
  final DateTime startsAt;
  final String status;

  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    final patient = Map<String, dynamic>.from(
      json['patient'] as Map? ?? const {},
    );

    return DoctorAppointmentModel(
      id: json['id'] as int,
      patientName: patient['name'] as String? ?? '',
      patientPhone: patient['phone'] as String?,
      startsAt: DateTime.parse(json['starts_at'] as String),
      status: json['status'] as String? ?? '',
    );
  }
}
