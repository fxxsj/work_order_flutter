import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/domain/salesperson.dart';

/// 客户仓库接口，定义客户相关的数据操作。
abstract class CustomerRepository {
  /// 获取客户列表。
  Future<CustomerPage> getCustomers({
    int page = 1,
    int pageSize = 20,
    String? search,
  });

  /// 创建客户。
  Future<Customer> createCustomer(Customer customer);

  /// 更新客户。
  Future<Customer> updateCustomer(Customer customer);

  /// 删除客户。
  Future<void> deleteCustomer(int id);

  /// 获取业务员列表。
  Future<List<Salesperson>> getSalespersons();
}
