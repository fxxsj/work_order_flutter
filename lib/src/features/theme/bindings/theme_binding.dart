import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

/// Theme Feature Dependencies Binding
class ThemeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(() => ThemeController());
  }
}
