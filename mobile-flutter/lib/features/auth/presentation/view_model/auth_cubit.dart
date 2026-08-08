import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/errors/dio_failure.dart';
import 'package:project1/core/network/api_client.dart';
import 'package:project1/core/utils/function/user_session.dart';
import 'package:project1/features/auth/data/models/RegisterRequest.dart';
import 'package:project1/features/auth/data/models/login_request.dart';
import 'package:project1/features/auth/data/repository/auth_repository.dart';
import 'package:project1/features/auth/data/services/auth_service.dart';
import 'package:project1/features/auth/presentation/view_model/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
    : _repository = AuthRepository(AuthService(ApiClient())),
      super(const AuthInitial());

  final AuthRepository _repository;

Future<void> login({
  required String login,
  required String password,
}) async {
  emit(const AuthLoading());

  try {
    final response = await _repository.login(
      LoginRequest(
        login: login,
        password: password,
      ),
    );

    UserSession.setUser(response.user);
    emit(AuthAuthenticated(response.user));
  } on DioException catch (e) {
    emit(AuthError(DioFailure.fromDioException(e).message));
  } catch (_) {
    emit(const AuthError("حدث خطأ غير متوقع"));
  }
}

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const AuthLoading());

    try {
      final response = await _repository.register(
        RegisterRequest(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      );
      UserSession.setUser(response.user);
      emit(AuthAuthenticated(response.user));
    } on DioException catch (e) {
      emit(AuthError(DioFailure.fromDioException(e).message));
    } catch (_) {
      emit(const AuthError("حدث خطأ غير متوقع"));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());

    try {
      await _repository.logout();
      UserSession.clear();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
