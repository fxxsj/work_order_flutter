import 'dart:async';

import 'package:work_order_app/common/app_events.dart';
import 'package:work_order_app/constants/response_code_constant.dart';
import 'package:work_order_app/controllers/auth_controller.dart';
import 'package:work_order_app/router/app_router.dart';
import 'package:work_order_app/utils/toast_util.dart';

/// Global event handler for application-wide events.
///
/// Not a ChangeNotifier because it has no UI state to expose.
/// Managed directly in the app's root State lifecycle.
class AppEventController {
  AppEventController(this._authController);

  final AuthController _authController;
  StreamSubscription<AppEvent>? _subscription;

  void initialize() {
    _subscription = AppEvents.stream.listen(_handleEvent);
  }

  void dispose() {
    _subscription?.cancel();
  }

  void _handleEvent(AppEvent event) {
    if (event is AuthExpiredEvent) {
      _authController.handleLogout();
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
