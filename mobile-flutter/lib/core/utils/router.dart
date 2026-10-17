import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/features/auth/presentation/view/profile_view.dart';
import 'package:project1/features/auth/presentation/view/signIn/Sign_in_view.dart';
import 'package:project1/features/auth/presentation/view/signup/sign_up_view.dart';
import 'package:project1/features/home/admin_home/presentation/views/adminHome.dart';
import 'package:project1/features/home/admin_home/presentation/views/admin_appointments_view.dart';
import 'package:project1/features/home/admin_home/presentation/views/admin_doctors_view.dart';
import 'package:project1/features/home/admin_home/presentation/views/admin_patients_view.dart';
import 'package:project1/features/home/admin_home/presentation/views/admin_schedule_view.dart';
import 'package:project1/features/home/admin_home/presentation/views/admin_settings_view.dart';
import 'package:project1/features/home/admin_home/presentation/views/body_doctor_form.dart';
import 'package:project1/features/home/doctorHome.dart';
import 'package:project1/features/home/patientHome/presentation/view/patientHome.dart';
import 'package:project1/features/home/patientHome/presentation/view/doctor_details_view.dart';
import 'package:project1/features/home/patientHome/presentation/view/doctor_search_view.dart';
import 'package:project1/features/home/patientHome/presentation/view/my_appointments_view.dart';
import 'package:project1/features/splash/view/splash_view.dart';

final GoRouter routerList = GoRouter(
  routes: [
    GoRoute(path: AppRouter.splash, builder: (context, state) => SplashView()),
    GoRoute(path: AppRouter.signIn, builder: (context, state) => SignInView()),
    GoRoute(path: AppRouter.signUp, builder: (context, state) => SignUpView()),
    GoRoute(
      path: AppRouter.patientHome,
      builder: (context, state) => PatientHome(),
    ),
    GoRoute(
      path: AppRouter.doctorHome,
      builder: (context, state) => DoctorHome(),
    ),
    GoRoute(
      path: AppRouter.adminHome,
      builder: (context, state) => const AdminHome(),
    ),
    GoRoute(
      path: AppRouter.adminDoctors,
      builder: (context, state) => const AdminDoctorsView(),
    ),
    GoRoute(
      path: AppRouter.adminSchedule,
      builder: (context, state) => const AdminScheduleView(),
    ),
    GoRoute(
      path: AppRouter.adminAppointments,
      builder: (context, state) => const AdminAppointmentsView(),
    ),
    GoRoute(
      path: AppRouter.adminPatients,
      builder: (context, state) => const AdminPatientsView(),
    ),
    GoRoute(
      path: AppRouter.adminSettings,
      builder: (context, state) => const AdminSettingsView(),
    ),
    GoRoute(
      path: AppRouter.registerDoctor,
      builder: (context, state) => BodyDoctorForm(),
    ),
    GoRoute(
      path: AppRouter.doctorSearch,
      builder: (context, state) => const DoctorSearchView(),
    ),
    GoRoute(
      path: AppRouter.doctorDetails,
      builder: (context, state) => DoctorDetailsView(
        doctorId: int.parse(state.pathParameters['doctorId']!),
      ),
    ),
    GoRoute(
      path: AppRouter.appointments,
      builder: (context, state) => const MyAppointmentsView(),
    ),
    GoRoute(
      path: AppRouter.profile,
      builder: (context, state) => const ProfileView(),
    ),
  ],
);
