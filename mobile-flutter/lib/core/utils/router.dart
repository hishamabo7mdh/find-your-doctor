
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/features/auth/presentation/view/signIn/Sign_in_view.dart';
import 'package:project1/features/auth/presentation/view/signIn/sign_in_body.dart';
import 'package:project1/features/auth/presentation/view/signup/sign_up_body.dart';
import 'package:project1/features/auth/presentation/view/signup/sign_up_view.dart';
import 'package:project1/features/home/admin_home/presentation/views/adminHome.dart';
import 'package:project1/features/home/doctorHome.dart';
import 'package:project1/features/home/patientHome/presentation/view/patientHome.dart';
import 'package:project1/features/splash/view/splash_view.dart';

final GoRouter routerList =
    GoRouter(routes: [
      GoRoute(path: AppRouter.splash,builder: (context , state)=>SplashView()),
      GoRoute(path: AppRouter.signIn,builder: (context , state)=>SignInView()),
      GoRoute(path: AppRouter.signUp,builder: (context , state)=>SignUpView()),
      GoRoute(path: AppRouter.patientHome,builder: (context , state)=>PatientHome()),
      GoRoute(path: AppRouter.doctorHome,builder: (context , state)=>DoctorHome()),
      GoRoute(path: AppRouter.adminHome,builder: (context , state)=>AdminHome()),
    ]);