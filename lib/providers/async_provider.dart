import 'package:flutter/foundation.dart';

class AsyncProvider extends ChangeNotifier {
  bool _loading = false;
  bool _once = false;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get once => _once;
  set once(bool value) {
    _once = value;
    notifyListeners();
  }
}
