class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });
//model-> json
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }
}