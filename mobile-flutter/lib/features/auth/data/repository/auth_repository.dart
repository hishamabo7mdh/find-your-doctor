import 'package:project1/features/auth/data/models/login_request.dart';
import 'package:project1/features/auth/data/models/login_response.dart';
import 'package:project1/features/auth/data/models/user_model.dart';

import '../../../../core/storage/secure_storage.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository(this.service);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await service.login(request);
print("Token from API: ${response.token}");

    await SecureStorage.saveToken(response.token);
      final token = await SecureStorage.getToken();
    print("Token after save: $token");
    return response;
  }
  Future<UserModel> me() async {
  return await service.me();
}
}