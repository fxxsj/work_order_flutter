import 'package:get/get.dart';
import '../controllers/customer_controller.dart';
import '../repositories/customer_repository.dart';
import '../repositories/customer_repository_impl.dart';

/// Customers Feature Dependencies Binding
class CustomersBinding extends Bindings {
  @override
  void dependencies() {
    // 注册 Repository
    Get.lazyPut<CustomerRepository>(() => CustomerRepositoryImpl());
    
    // 注册 Controller（自动注入 Repository）
    Get.lazyPut<CustomerController>(() => CustomerController());
  }
}
