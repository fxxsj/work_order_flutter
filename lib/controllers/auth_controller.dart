import 'package:get/get.dart';
import 'package:work_order_app/common/app_events.dart';
import 'package:work_order_app/common/http_client.dart';
import 'package:work_order_app/utils/store_util.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoggedIn.value = StoreUtil.isLoggedIn();
  }

  void handleLogin({required String access, String? refresh}) {
    StoreUtil.writeTokens(access: access, refresh: refresh);
    HttpClient.updateTokens(access, refresh);
    isLoggedIn.value = true;
    AppEvents.emit(const AuthChangedEvent(true));
  }

  void handleLogout() {
    StoreUtil.clearTokens();
    HttpClient.clearTokens();
    isLoggedIn.value = false;
    AppEvents.emit(const AuthChangedEvent(false));
  }
}
