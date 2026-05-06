import '../models/customer.dart';
import '../models/customer_list_response.dart';
import '../services/customer_api.dart';
import 'customer_repository.dart';

/// Customer Repository 实现
class CustomerRepositoryImpl implements CustomerRepository {
  @override
  Future<CustomerListResponse> fetchCustomers({
    required int page,
    required int pageSize,
    String? search,
    bool? isActive,
  }) async {
    return await CustomerApi.fetchCustomers(
      page: page,
      pageSize: pageSize,
      search: search,
      isActive: isActive,
    );
  }

  @override
  Future<Customer> createCustomer(Customer customer) async {
    return await CustomerApi.createCustomer(customer);
  }

  @override
  Future<Customer> updateCustomer(Customer customer) async {
    return await CustomerApi.updateCustomer(customer);
  }

  @override
  Future<void> deleteCustomer(String id) async {
    await CustomerApi.deleteCustomer(id);
  }

  @override
  Future<Customer> toggleActive(String id, bool isActive) async {
    return await CustomerApi.toggleActive(id, isActive);
  }
}
