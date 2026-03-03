import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/utils/store_util.dart';

class AppStorage {
  Future<void> init() async {
    await StoreUtil.init();
  }

  dynamic read(String key) => StoreUtil.read(key);

  Future<void> write(String key, dynamic value) => StoreUtil.write(key, value);

  Future<void> remove(String key) => StoreUtil.remove(key);

  bool isLoggedIn() => StoreUtil.isLoggedIn();

  String? readAccessToken() => StoreUtil.readAccessToken();

  String? readRefreshToken() {
    final value = StoreUtil.read(Constant.KEY_REFRESH_TOKEN);
    return value is String ? value : null;
  }

  Future<void> writeTokens({required String access, String? refresh}) {
    return StoreUtil.writeTokens(access: access, refresh: refresh);
  }

  Future<void> clearTokens() => StoreUtil.clearTokens();
}
