import 'package:project1/features/auth/data/models/user_model.dart';

sealed class AuthState {
  const AuthState();
}

/// الحالة الابتدائية
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// أثناء التحميل
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// نجاح تسجيل الدخول أو التسجيل
class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);
}

/// المستخدم غير مسجل
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// أي خطأ
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}
