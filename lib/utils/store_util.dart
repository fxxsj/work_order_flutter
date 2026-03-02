import 'package:work_order_app/constants/constant.dart';
import 'package:work_order_app/models/user_info.dart';
import 'package:get_storage/get_storage.dart';

class StoreUtil {
  static read(String key) {
    return GetStorage().read(key);
  }

  static write(String key, value) {
    GetStorage().write(key, value);
  }

  static remove(String key) {
    GetStorage().remove(key);
  }

  static hasData(String key) {
    return GetStorage().hasData(key);
  }

  static cleanAll() {
    GetStorage().erase();
  }

  static init() {
    // Reserved for future initialization hooks.
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

  static void writeTokens({required String access, String? refresh}) {
    write(Constant.KEY_ACCESS_TOKEN, access);
    write(Constant.KEY_TOKEN, access); // legacy compatibility
    if (refresh != null) {
      write(Constant.KEY_REFRESH_TOKEN, refresh);
    }
  }

  static void clearTokens() {
    remove(Constant.KEY_ACCESS_TOKEN);
    remove(Constant.KEY_REFRESH_TOKEN);
    remove(Constant.KEY_TOKEN);
  }

  static bool isLoggedIn() {
    final access = readAccessToken();
    return access != null && access.isNotEmpty;
  }

  static UserInfo getCurrentUserInfo() {
    var data = GetStorage().read(Constant.KEY_CURRENT_USER_INFO);
    return data == null ? UserInfo() : UserInfo.fromMap(data);
  }
}
