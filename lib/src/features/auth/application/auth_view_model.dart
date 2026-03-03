import 'package:flutter/foundation.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/auth/domain/auth_repository.dart';
import 'package:work_order_app/src/features/auth/domain/user.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository, this._storage, this._authController);

  final AuthRepository _repository;
  final AppStorage _storage;
  final AuthController _authController;

  Map<String, dynamic> _currentUser = {};

  Map<String, dynamic> get currentUser => _currentUser;

  String? readRememberedUsername() {
    final value = _storage.read(Constant.KEY_REMEMBER_USERNAME);
    return value?.toString();
  }

  Future<void> login({
    required String username,
    required String password,
    required bool rememberUsername,
  }) async {
    final responseMap = await _repository.login(username: username, password: password);

    String? accessToken;
    String? refreshToken;
    final directAccess = responseMap['access'] ?? responseMap['access_token'] ?? responseMap['auth_token'];
    if (directAccess != null) {
      accessToken = directAccess.toString();
      refreshToken = responseMap['refresh']?.toString();
    } else if (responseMap['data'] is Map) {
      final inner = Map<String, dynamic>.from(responseMap['data'] as Map);
      final innerAccess = inner['access'] ?? inner['access_token'] ?? inner['auth_token'];
      if (innerAccess != null) {
        accessToken = innerAccess.toString();
        refreshToken = inner['refresh']?.toString();
      }
    }

    if (accessToken == null || accessToken.isEmpty) {
      throw const ApiException(message: '请检查账号密码');
    }

    responseMap['token'] = accessToken;
    responseMap['access'] = accessToken;
    responseMap['refresh'] = refreshToken;

    await _authController.handleLogin(access: accessToken, refresh: refreshToken);
    if (rememberUsername) {
      await _storage.write(Constant.KEY_REMEMBER_USERNAME, username);
    }

    final userInfo = Map<String, dynamic>.from(responseMap);
    if (responseMap.containsKey('username')) {
      userInfo['userName'] = responseMap['username'];
    }
    if (responseMap.containsKey('full_name')) {
      userInfo['name'] = responseMap['full_name'];
    }
    await _storage.write(Constant.KEY_CURRENT_USER_INFO, userInfo);
    _currentUser = userInfo;
    notifyListeners();
  }

  Future<void> register(User user) async {
    await _repository.register(user);
  }

  Future<Map<String, dynamic>> loadCurrentUser() async {
    final cached = _storage.read(Constant.KEY_CURRENT_USER_INFO);
    if (cached is Map) {
      _currentUser = Map<String, dynamic>.from(cached);
      notifyListeners();
    }
    if (_currentUser.isEmpty) {
      final fetched = await _repository.fetchCurrentUser();
      if (fetched.isNotEmpty) {
        _currentUser = fetched;
        await _storage.write(Constant.KEY_CURRENT_USER_INFO, fetched);
        notifyListeners();
      }
    }
    return _currentUser;
  }

  Future<Map<String, dynamic>> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    final data = await _repository.updateProfile(
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    final merged = {..._currentUser, ...data};
    _currentUser = merged;
    await _storage.write(Constant.KEY_CURRENT_USER_INFO, merged);
    notifyListeners();
    return merged;
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
