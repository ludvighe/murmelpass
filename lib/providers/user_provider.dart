import 'package:flutter/foundation.dart';
import 'package:password_manager_r1/models/user.dart';
import 'package:password_manager_r1/services/flask_rest_api.dart';

class UserProvider extends ChangeNotifier {
  User _user;
  User get user => _user;
  set user(User value) {
    _user = value;
    notifyListeners();
  }

  Future<User> login(String key) async {
    user = User.fromJson(await FlaskRestApi.readUser(key));
    return user;
  }

  void logout() {
    user = null;
    notifyListeners();
  }

  Future<String> register(User initUser) async {
    return await FlaskRestApi.register(initUser.toJson());
  }
}
