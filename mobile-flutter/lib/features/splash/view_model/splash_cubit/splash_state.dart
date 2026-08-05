import 'package:project1/features/auth/data/models/user_model.dart';

abstract class SplashState {}

final class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {

  final UserModel user;

  SplashAuthenticated(this.user);

}

class SplashUnauthenticated extends SplashState {}