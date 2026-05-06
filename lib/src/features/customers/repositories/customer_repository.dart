import '../models/customer.dart';
import '../models/customer_list_response.dart';

/// Customer Repository 抽象接口
abstract class CustomerRepository {
  /// 获取客户列表
  Future<CustomerListResponse> fetchCustomers({
    required int page,
    required int pageSize,
    String? search,
    bool? isActive,
  });

  /// 创建客户
  Future<Customer> createCustomer(Customer customer);

  /// 更新客户
  Future<Customer> updateCustomer(Customer customer);

  /// 删除客户
  Future<void> deleteCustomer(String id);

  /// 切换激活状态
  Future<Customer> toggleActive(String id, bool isActive);
}
