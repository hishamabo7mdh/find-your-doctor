class AdminDashboardStats {
  const AdminDashboardStats({
    required this.doctorsCount,
    required this.upcomingAppointments,
    required this.inactiveDoctors,
    required this.successRate,
  });

  final int doctorsCount;
  final int upcomingAppointments;
  final int inactiveDoctors;
  final int successRate;

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) {
    final users = Map<String, dynamic>.from(json['users'] as Map? ?? const {});
    final doctors = Map<String, dynamic>.from(
      json['doctors'] as Map? ?? const {},
    );
    final appointments = Map<String, dynamic>.from(
      json['appointments'] as Map? ?? const {},
    );
    final totalAppointments = appointments.values.fold<int>(
      0,
      (total, count) => total + _toInt(count),
    );
    final completedAppointments = _toInt(appointments['completed']);

    return AdminDashboardStats(
      doctorsCount: _toInt(users['doctor']),
      upcomingAppointments: _toInt(json['upcoming_appointments']),
      inactiveDoctors: _toInt(doctors['0']),
      successRate: totalAppointments == 0
          ? 0
          : (completedAppointments * 100 / totalAppointments).round(),
    );
  }

  static int _toInt(Object? value) => value is num ? value.toInt() : 0;
}
