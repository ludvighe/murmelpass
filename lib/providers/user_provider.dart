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

  // TEST:
  // key: UpyJZDm8DClqYTWYt2f5Kf8ht5gJeDNr
  // id: Ua1d51b15-05cf-42a9-855c-b4ae1058f003

  Future<User> login(String key) async {
    user = User.fromJson(await FlaskRestApi.readUser(key));
    return user;
  }

  void logout() {
    user = null;
    notifyListeners();
  }
}
