
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/features/auth/presentation/view/sign_in_view.dart';
import 'package:project1/features/auth/presentation/view/sign_up_view.dart';
import 'package:project1/features/auth/presentation/view/sign_up_viewE.dart';
import 'package:project1/features/splash/view/splash_view.dart';

final GoRouter routerList =
    GoRouter(routes: [
      GoRoute(path: AppRouter.splash,builder: (context , state)=>SplashView()),
      GoRoute(path: AppRouter.signIn,builder: (context , state)=>SignInView()),
      GoRoute(path: AppRouter.signUp,builder: (context , state)=>SignUpView()),
    ]);