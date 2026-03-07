import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';
import 'package:work_order_app/src/core/common/http_client.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._storage, this._apiClient);

  final AppStorage _storage;
  final ApiClient _apiClient;
  bool _isLoggedIn = false;
  Completer<bool>? _validationCompleter;
  Timer? _sessionTimer;

  bool get isLoggedIn => _isLoggedIn;

  void initialize() {
    _isLoggedIn = _storage.isLoggedIn();
    _startSessionMonitor();
  }

  Future<bool> ensureValidSession() async {
    if (_validationCompleter != null) {
      return _validationCompleter!.future;
    }
    _validationCompleter = Completer<bool>();
    bool result = false;
    try {
      if (_isLoggedIn) {
        // First try access token validation via current user endpoint.
        try {
          await _apiClient.get('/auth/user/');
          result = true;
          _validationCompleter!.complete(result);
          return result;
        } catch (_) {
          // Access token failed; try refresh if available.
        }
      }

      final refresh = _storage.readRefreshToken();
      if (refresh == null || refresh.isEmpty) {
        if (_isLoggedIn) {
          await handleLogout();
        }
        result = false;
        _validationCompleter!.complete(result);
        return result;
      }

      final refreshed = await _apiClient.refreshAccessToken();
      if (refreshed) {
        if (!_isLoggedIn) {
          _isLoggedIn = true;
          notifyListeners();
        }
        result = true;
        _validationCompleter!.complete(result);
        return result;
      }

      await handleLogout();
      result = false;
      _validationCompleter!.complete(result);
      return result;
    } finally {
      if (!(_validationCompleter?.isCompleted ?? true)) {
        _validationCompleter?.complete(result);
      }
      _validationCompleter = null;
    }
  }

  Future<void> handleLogin({required String access, String? refresh}) async {
    await _storage.writeTokens(access: access, refresh: refresh);
    _apiClient.updateTokens(access, refresh);
    _isLoggedIn = true;
    _startSessionMonitor();
    notifyListeners();
  }

  Future<void> handleLogout() async {
    // 先更新状态，确保路由可立即跳转
    if (_isLoggedIn) {
      _isLoggedIn = false;
      _stopSessionMonitor();
      notifyListeners();
    }
    // 清理网络请求与 token
    _apiClient.clearTokens();
    await _storage.clearTokens();
    await _storage.remove(Constant.KEY_CURRENT_USER_INFO);
  }

  void _startSessionMonitor() {
    _sessionTimer?.cancel();
    if (!_isLoggedIn) return;
    _sessionTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _checkSessionInBackground();
    });
  }

  void _stopSessionMonitor() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  Future<void> _checkSessionInBackground() async {
    if (!_isLoggedIn || _validationCompleter != null) return;
    if (!HttpClient.isAccessTokenExpiring(leewaySeconds: 0)) {
      return;
    }
    final refresh = _storage.readRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      await handleLogout();
      return;
    }
    final refreshed = await _apiClient.refreshAccessToken();
    if (!refreshed) {
      await handleLogout();
    }
  }

  @override
  void dispose() {
    _stopSessionMonitor();
    super.dispose();
  }
}
