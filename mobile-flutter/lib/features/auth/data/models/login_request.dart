class LoginRequest {
  final String login;
  final String password;

  const LoginRequest({
    required this.login,
    required this.password,
  });
//model-> json
  Map<String, dynamic> toJson() {
    return {
      "login": login,
      "password": password,
    };
  }
}