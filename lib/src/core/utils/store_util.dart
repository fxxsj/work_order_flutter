import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/models/user_info.dart';
import 'package:work_order_app/src/core/utils/jwt_util.dart';

class StoreUtil {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static dynamic read(String key) {
    if (_prefs == null) return null;
    final value = _prefs!.get(key);
    if (value is String) {
      // SharedPreferences stores structured values as JSON strings.
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map || decoded is List) return decoded;
      } catch (_) {
        // Not JSON, return as-is.
      }
    }
    return value;
  }

  static Future<void> write(String key, dynamic value) async {
    if (_prefs == null) return;
    if (value == null) {
      await _prefs!.remove(key);
    } else if (value is String) {
      await _prefs!.setString(key, value);
    } else if (value is int) {
      await _prefs!.setInt(key, value);
    } else if (value is double) {
      await _prefs!.setDouble(key, value);
    } else if (value is bool) {
      await _prefs!.setBool(key, value);
    } else if (value is Map || value is List) {
      await _prefs!.setString(key, jsonEncode(value));
    }
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  static bool hasData(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  static Future<void> cleanAll() async {
    await _prefs?.clear();
  }

  static String? readAccessToken() {
    final access = read(Constant.KEY_ACCESS_TOKEN);
    if (access != null && access.toString().isNotEmpty) {
      return access.toString();
    }
    return null;
  }

  static Future<void> writeTokens({
    required String access,
    String? refresh,
  }) async {
    await write(Constant.KEY_ACCESS_TOKEN, access);
    if (refresh != null) {
      await write(Constant.KEY_REFRESH_TOKEN, refresh);
    }
  }

  static Future<void> clearTokens() async {
    await remove(Constant.KEY_ACCESS_TOKEN);
    await remove(Constant.KEY_REFRESH_TOKEN);
  }

  static bool isLoggedIn() {
    final access = readAccessToken();
    if (access != null && access.isNotEmpty && !JwtUtil.isExpired(access)) {
      return true;
    }
    final refresh = read(Constant.KEY_REFRESH_TOKEN);
    if (refresh != null && refresh.toString().isNotEmpty) {
      return !JwtUtil.isExpired(refresh.toString());
    }
    return false;
  }

  static UserInfo getCurrentUserInfo() {
    final data = read(Constant.KEY_CURRENT_USER_INFO);
    if (data == null) return UserInfo();
    if (data is Map) {
      return UserInfo.fromMap(Map<String?, dynamic>.from(data));
    }
    return UserInfo();
  }
}
