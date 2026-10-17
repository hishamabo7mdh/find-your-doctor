class CreateDoctorRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final List<String> daysOfWeek;
  final String startTime;
  final String endTime;
  final bool isActive;
  final int? specialtyId;

  CreateDoctorRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.daysOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    this.specialtyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'days_of_week': daysOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'is_active': isActive,
      if (specialtyId != null) 'specialty_id': specialtyId,
    };
  }
}
