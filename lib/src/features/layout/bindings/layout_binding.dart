import 'package:get/get.dart';
import '../controllers/app_scaffold_controller.dart';

/// Layout Feature Dependencies Binding
class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppScaffoldController>(() => AppScaffoldController());
  }
}
