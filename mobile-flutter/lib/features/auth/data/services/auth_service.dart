import 'package:dio/dio.dart';
import 'package:project1/features/auth/data/models/login_request.dart';
import 'package:project1/features/auth/data/models/login_response.dart';
import 'package:project1/features/auth/data/models/user_model.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';



class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<LoginResponse> login(LoginRequest request) async {
    final Response response = await apiClient.dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );

    return LoginResponse.fromJson(response.data);
  }

  Future<UserModel> me() async {
  final response = await apiClient.dio.get(
    ApiConstants.me,
  );

  return UserModel.fromJson(response.data["data"]);
}
}