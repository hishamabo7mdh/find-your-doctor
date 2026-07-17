import 'user_model.dart';

class LoginResponse {
  final UserModel user;
  final String token;

  const LoginResponse({
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserModel.fromJson(json["user"]),
      token: json["token"],
    );
  }
}