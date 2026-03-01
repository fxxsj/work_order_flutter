import 'package:get/get.dart';

class AppBadgeController extends GetxController {
  final RxInt todoCount = 0.obs;
  final RxBool isLoading = false.obs;

  void setTodoCount(int value) {
    todoCount.value = value;
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
