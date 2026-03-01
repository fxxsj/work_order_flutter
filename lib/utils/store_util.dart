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

  static UserInfo getCurrentUserInfo() {
    var data = GetStorage().read(Constant.KEY_CURRENT_USER_INFO);
    return data == null ? UserInfo() : UserInfo.fromMap(data);
  }
}
