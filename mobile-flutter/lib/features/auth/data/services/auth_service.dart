import 'package:dio/dio.dart';
import 'package:project1/features/auth/data/models/RegisterRequest.dart';
import 'package:project1/features/auth/data/models/create_doctor_request.dart';
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
    final response = await apiClient.dio.get(ApiConstants.me);

    return UserModel.fromJson(response.data["data"]);
  }

  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final response = await apiClient.dio.put(
      ApiConstants.me,
      data: {'first_name': firstName, 'last_name': lastName, 'phone': phone},
    );
    return UserModel.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
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
    } on DioException catch (e) {
      final message =
          e.response?.data?['message']?.toString() ?? 'فشل إنشاء الحساب';
      throw Exception(message);
    }
  }

  Future<UserModel> createDoctor(CreateDoctorRequest request) async {
    final response = await apiClient.dio.post(
      ApiConstants.createDoctor,
      data: request.toJson(),
    );

    return UserModel.fromJson(
      Map<String, dynamic>.from(response.data['user'] as Map),
    );
  }
}
