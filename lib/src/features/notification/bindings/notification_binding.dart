import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../controllers/app_badge_controller.dart';

/// Notification Feature Dependencies Binding
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<AppBadgeController>(() => AppBadgeController());
  }
}
