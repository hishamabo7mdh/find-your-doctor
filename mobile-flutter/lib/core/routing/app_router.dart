abstract class AppRouter {
  static const splash = '/';
  static const signIn = '/signIn';
  static const signUp = '/signUp';
  static const patientHome = '/patientHome';
  static const doctorHome = '/doctorHome';
  static const adminHome = '/adminHome';
  static const adminDoctors = '/admin/doctors';
  static const adminSchedule = '/admin/schedule';
  static const adminAppointments = '/admin/appointments';
  static const adminPatients = '/admin/patients';
  static const adminSettings = '/admin/settings';
  static const registerDoctor = '/registerDoctor';
  static const chooseSpecialty = '/choose-specialty';
  static const doctors = '/doctors';
  static const doctorSearch = doctors;
  static const doctorDetails = '/doctors/:doctorId';
  static const appointments = '/appointments';
  static const profile = '/profile';
}
