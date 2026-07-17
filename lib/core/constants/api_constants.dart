class ApiConstants {
  ApiConstants._();

  /// Emulator Android
  // static const String baseUrl = "http://10.0.2.2:8000/api";

  /// Real Device
  //static const String baseUrl = "169.254.219.105:8000";
  static const String baseUrl = "http://192.168.1.100:8000/api";

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String logout = "/auth/logout";
  static const String me = "/auth/me";
}