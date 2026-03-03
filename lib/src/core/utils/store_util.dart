import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/models/user_info.dart';

class StoreUtil {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static dynamic read(String key) {
    if (_prefs == null) return null;
    final value = _prefs!.get(key);
    if (value is String) {
      // Try to decode JSON strings back to Map/List for backward compatibility.
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
    final legacy = read(Constant.KEY_TOKEN);
    if (legacy != null && legacy.toString().isNotEmpty) {
      return legacy.toString();
    }
    return null;
  }

  static Future<void> writeTokens({required String access, String? refresh}) async {
    await write(Constant.KEY_ACCESS_TOKEN, access);
    await write(Constant.KEY_TOKEN, access); // legacy compatibility
    if (refresh != null) {
      await write(Constant.KEY_REFRESH_TOKEN, refresh);
    }
  }

  static Future<void> clearTokens() async {
    await remove(Constant.KEY_ACCESS_TOKEN);
    await remove(Constant.KEY_REFRESH_TOKEN);
    await remove(Constant.KEY_TOKEN);
  }

  static bool isLoggedIn() {
    final access = readAccessToken();
    return access != null && access.isNotEmpty;
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
