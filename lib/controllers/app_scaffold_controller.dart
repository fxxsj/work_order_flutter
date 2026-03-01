import 'package:get/get.dart';

class AppScaffoldController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString emptyMessage = ''.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void setError(String message) {
    errorMessage.value = message;
  }

  void setEmpty(String message) {
    emptyMessage.value = message;
  }

  void clearStatus() {
    isLoading.value = false;
    errorMessage.value = '';
    emptyMessage.value = '';
  }
}
