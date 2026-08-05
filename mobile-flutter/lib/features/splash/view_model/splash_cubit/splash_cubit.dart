import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/network/api_client.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/features/auth/data/repository/auth_repository.dart';
import 'package:project1/features/auth/data/services/auth_service.dart';

import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository _repository = AuthRepository(
  AuthService(
    ApiClient(),
  ),
);
  
  SplashCubit() : super(SplashInitial()) {}

  Future<void> startSplash() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
    await checkLogin();
  }

  Future<void> checkLogin() async {

  final token = await SecureStorage.getToken();

  if (token == null) {
    emit(SplashUnauthenticated());
    return;
  }

  try {

    final user = await _repository.me();
    emit(SplashAuthenticated(user));

  } catch (e, stackTrace) {
  debugPrint("ERROR: $e");
  debugPrintStack(stackTrace: stackTrace);

  await SecureStorage.clear();

  emit(SplashUnauthenticated());
}

}
}