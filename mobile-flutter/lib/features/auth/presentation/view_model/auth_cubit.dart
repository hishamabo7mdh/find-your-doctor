import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/network/api_client.dart';
import 'package:project1/features/auth/data/models/RegisterRequest.dart';
import 'package:project1/features/auth/data/models/login_request.dart';
import 'package:project1/features/auth/data/repository/auth_repository.dart';
import 'package:project1/features/auth/data/services/auth_service.dart';
import 'package:project1/features/auth/presentation/view_model/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
      : _repository = AuthRepository(
          AuthService(ApiClient()),
        ),
        super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final response = await _repository.login(
        LoginRequest(
          email: email,
          password: password,
        ),
      );

      emit(AuthAuthenticated(response.user));
    } catch (e) {
      emit(AuthError(e.toString()));
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

      emit(AuthAuthenticated(response.user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());

    try {
      await _repository.logout();

      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}