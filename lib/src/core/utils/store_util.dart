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
    // ignore: deprecated_member_use_from_same_package — backward compat for tokens written by older app versions
    final legacy = read(Constant.KEY_TOKEN);
    if (legacy != null && legacy.toString().isNotEmpty) {
      return legacy.toString();
    }
    return null;
  }

  static Map<String, dynamic>? _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }
      final payloadBase64 = base64Url.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(payloadBase64));
      final decoded = jsonDecode(payloadString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return null;
  }

  static bool _isTokenExpired(String token) {
    final payload = _decodeJwtPayload(token);
    if (payload == null) {
      return true;
    }
    final exp = payload['exp'];
    if (exp is! int) {
      return true;
    }
    final expTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    final now = DateTime.now().toUtc();
    return now.isAfter(expTime.add(const Duration(seconds: 30)));
  }

  static Future<void> writeTokens({required String access, String? refresh}) async {
    await write(Constant.KEY_ACCESS_TOKEN, access);
    // ignore: deprecated_member_use_from_same_package — write both keys for backward compat
    await write(Constant.KEY_TOKEN, access);
    if (refresh != null) {
      await write(Constant.KEY_REFRESH_TOKEN, refresh);
    }
  }

  static Future<void> clearTokens() async {
    await remove(Constant.KEY_ACCESS_TOKEN);
    await remove(Constant.KEY_REFRESH_TOKEN);
    // ignore: deprecated_member_use_from_same_package — clear legacy key too for clean state
    await remove(Constant.KEY_TOKEN);
  }

  static bool isLoggedIn() {
    final access = readAccessToken();
    if (access != null && access.isNotEmpty && !_isTokenExpired(access)) {
      return true;
    }
    final refresh = read(Constant.KEY_REFRESH_TOKEN);
    if (refresh != null && refresh.toString().isNotEmpty) {
      return !_isTokenExpired(refresh.toString());
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
