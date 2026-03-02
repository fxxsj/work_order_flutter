import 'package:flutter/foundation.dart';

class AppBadgeController extends ChangeNotifier {
  int _todoCount = 0;
  bool _isLoading = false;

  int get todoCount => _todoCount;
  bool get isLoading => _isLoading;

  void setTodoCount(int value) {
    _todoCount = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
