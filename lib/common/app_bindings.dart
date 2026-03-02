import 'package:get/get.dart';
import 'package:work_order_app/controllers/app_event_controller.dart';
import 'package:work_order_app/controllers/auth_controller.dart';
import 'package:work_order_app/controllers/theme_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(AppEventController());
  }
}
