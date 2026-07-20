import 'package:flutter/material.dart';
import 'package:project1/features/auth/data/models/login_request.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/user_model.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository(AuthService(ApiClient()));

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  UserModel? currentUser;

  Future<bool> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _repository.login(
        LoginRequest(email: email, password: password),
      );

      currentUser = response.user;
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.logout();

      currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
