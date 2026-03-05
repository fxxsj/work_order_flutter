import 'package:flutter/foundation.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._storage, this._apiClient);

  final AppStorage _storage;
  final ApiClient _apiClient;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void initialize() {
    _isLoggedIn = _storage.isLoggedIn();
  }

  Future<bool> ensureValidSession() async {
    if (!_isLoggedIn) {
      return false;
    }
    final refresh = _storage.readRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      try {
        await _apiClient.get('/auth/user/');
        return true;
      } catch (_) {
        await handleLogout();
        return false;
      }
    }
    final refreshed = await _apiClient.refreshAccessToken();
    if (refreshed) {
      return true;
    }
    await handleLogout();
    return false;
  }

  Future<void> handleLogin({required String access, String? refresh}) async {
    await _storage.writeTokens(access: access, refresh: refresh);
    _apiClient.updateTokens(access, refresh);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> handleLogout() async {
    await _storage.clearTokens();
    await _storage.remove(Constant.KEY_CURRENT_USER_INFO);
    _apiClient.clearTokens();
    _isLoggedIn = false;
    notifyListeners();
  }
}
