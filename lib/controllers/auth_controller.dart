import 'package:flutter/foundation.dart';
import 'package:work_order_app/common/app_events.dart';
import 'package:work_order_app/common/http_client.dart';
import 'package:work_order_app/utils/store_util.dart';

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void initialize() {
    _isLoggedIn = StoreUtil.isLoggedIn();
  }

  Future<void> handleLogin({required String access, String? refresh}) async {
    await StoreUtil.writeTokens(access: access, refresh: refresh);
    HttpClient.updateTokens(access, refresh);
    _isLoggedIn = true;
    notifyListeners();
    AppEvents.emit(const AuthChangedEvent(true));
  }

  Future<void> handleLogout() async {
    await StoreUtil.clearTokens();
    HttpClient.clearTokens();
    _isLoggedIn = false;
    notifyListeners();
    AppEvents.emit(const AuthChangedEvent(false));
  }
}
