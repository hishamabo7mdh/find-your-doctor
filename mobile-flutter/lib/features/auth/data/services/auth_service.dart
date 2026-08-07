import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project1/features/auth/data/models/RegisterRequest.dart';
import 'package:project1/features/auth/data/models/login_request.dart';
import 'package:project1/features/auth/data/models/login_response.dart';
import 'package:project1/features/auth/data/models/user_model.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<LoginResponse> login(LoginRequest request) async {
    debugPrint(request.toJson().toString());
    final Response response = await apiClient.dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    
    return LoginResponse.fromJson(response.data);
  }

  Future<UserModel> me() async {
    final response = await apiClient.dio.get(ApiConstants.me);

    return UserModel.fromJson(response.data["data"]);
  }

  Future<void> logout() async {
    await apiClient.dio.post(ApiConstants.logout);
  }

  Future<LoginResponse> register(RegisterRequest request) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e,s) {

      final message = e.response?.data?['message'] ?? "فشل إنشاء الحساب";
  print("Status Code: ${e.response?.statusCode}");
  print("Response: ${e.response?.data}");

  throw Exception(e.response?.data.toString() ?? e.message);
      // throw Exception(message);
    }
  }
}
