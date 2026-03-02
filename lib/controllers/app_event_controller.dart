import 'dart:async';

import 'package:get/get.dart';
import 'package:work_order_app/common/app_events.dart';
import 'package:work_order_app/constants/response_code_constant.dart';
import 'package:work_order_app/controllers/auth_controller.dart';
import 'package:work_order_app/router/app_router.dart';
import 'package:work_order_app/utils/toast_util.dart';

class AppEventController extends GetxController {
  StreamSubscription<AppEvent>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = AppEvents.stream.listen(_handleEvent);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _handleEvent(AppEvent event) {
    if (event is AuthExpiredEvent) {
      if (Get.isRegistered<AuthController>()) {
        Get.find<AuthController>().handleLogout();
      }
      final message = (event.message != null && event.message!.isNotEmpty)
          ? event.message!
          : ResponseCodeConstant.SESSION_EXPIRE_MESSAGE;
      ToastUtil.showError(message);
      appRouter.go('/login');
      return;
    }
    // other events can be handled here
  }
}
