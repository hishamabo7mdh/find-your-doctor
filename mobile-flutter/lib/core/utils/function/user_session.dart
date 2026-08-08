import 'package:project1/features/auth/data/models/user_model.dart';

class UserSession {
  UserSession._();

  static UserModel? currentUser;

  static void setUser(UserModel user) {
    currentUser = user;
  }

  static void clear() {
    currentUser = null;
  }
}