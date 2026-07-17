import 'package:project1/features/auth/data/models/login_request.dart';
import 'package:project1/features/auth/data/models/login_response.dart';

import '../../../../core/storage/secure_storage.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository(this.service);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await service.login(request);

    await SecureStorage.saveToken(response.token);

    return response;
  }
}