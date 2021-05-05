import 'package:flutter/foundation.dart';

class MasterPassword extends ChangeNotifier {
  String _masterPassword = '';

  String get masterPassword => _masterPassword;
  set masterPassword(String password) {
    _masterPassword = password;
    notifyListeners();
  }
}
