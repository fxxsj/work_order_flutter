import 'package:get/get.dart';
import 'package:work_order_app/common/http_client.dart';
import 'package:work_order_app/controllers/notification_controller.dart';
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
    _notifyNotifications(loggedIn: true);
  }

  void handleLogout() {
    StoreUtil.clearTokens();
    HttpClient.clearTokens();
    isLoggedIn.value = false;
    _notifyNotifications(loggedIn: false);
  }

  void _notifyNotifications({required bool loggedIn}) {
    if (!Get.isRegistered<NotificationController>()) {
      return;
    }
    final controller = Get.find<NotificationController>();
    if (loggedIn) {
      controller.startPolling();
    } else {
      controller.stopPolling();
    }
  }
}
