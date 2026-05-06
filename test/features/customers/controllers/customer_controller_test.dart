import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/features/customers/controllers/customer_controller.dart';
import 'package:work_order_app/src/features/customers/models/customer.dart';
import 'package:work_order_app/src/features/customers/models/customer_list_response.dart';
import 'package:work_order_app/src/features/customers/repositories/customer_repository.dart';

class MockCustomerRepository implements CustomerRepository {
  late CustomerListResponse Function() fetchCustomersFn;
  late Customer Function(Customer) createCustomerFn;
  late Customer Function(Customer) updateCustomerFn;
  late void Function(String) deleteCustomerFn;
  late Customer Function(String, bool) toggleActiveFn;

  @override
  Future<CustomerListResponse> fetchCustomers({
    required int page,
    required int pageSize,
    String? search,
    bool? isActive,
  }) async {
    return fetchCustomersFn();
  }

  @override
  Future<Customer> createCustomer(Customer customer) async {
    return createCustomerFn(customer);
  }

  @override
  Future<Customer> updateCustomer(Customer customer) async {
    return updateCustomerFn(customer);
  }

  @override
  Future<void> deleteCustomer(String id) async {
    deleteCustomerFn(id);
  }

  @override
  Future<Customer> toggleActive(String id, bool isActive) async {
    return toggleActiveFn(id, isActive);
  }
}

void main() {
  group('CustomerController', () {
    late CustomerController controller;
    late MockCustomerRepository mockRepository;

    setUp(() {
      mockRepository = MockCustomerRepository();
      controller = CustomerController(repository: mockRepository);
    });

    tearDown(() {
      controller.dispose();
    });

    test('初始状态应该正确', () {
      expect(controller.customers.isEmpty, true);
      expect(controller.isLoading.value, false);
      expect(controller.currentPage.value, 1);
      expect(controller.onlyActive.value, true);
    });

    test('loadCustomers 应该加载客户列表', () async {
      mockRepository.fetchCustomersFn = () {
        return CustomerListResponse(
          items: [
            Customer(
              id: '1',
              name: 'Test Customer',
              code: 'C001',
              contactPerson: 'Test',
              phone: '123',
              isActive: true,
            ),
          ],
          totalCount: 1,
          hasMore: false,
        );
      };

      await controller.loadCustomers();

      expect(controller.customers.length, 1);
      expect(controller.customers[0].name, 'Test Customer');
      expect(controller.totalCount.value, 1);
      expect(controller.isLoading.value, false);
    });

    test('searchCustomers 应该更新搜索查询并重新加载', () async {
      bool called = false;
      mockRepository.fetchCustomersFn = () {
        called = true;
        return CustomerListResponse(
          items: [],
          totalCount: 0,
          hasMore: false,
        );
      };

      controller.searchCustomers('test query');

      expect(controller.searchQuery.value, 'test query');
      expect(controller.currentPage.value, 1);
      await Future.delayed(Duration.zero); // 等待异步操作
      expect(called, true);
    });

    test('toggleActiveFilter 应该切换过滤器并重新加载', () async {
      bool called = false;
      mockRepository.fetchCustomersFn = () {
        called = true;
        return CustomerListResponse(
          items: [],
          totalCount: 0,
          hasMore: false,
        );
      };

      final initialValue = controller.onlyActive.value;
      controller.toggleActiveFilter();

      expect(controller.onlyActive.value, !initialValue);
      await Future.delayed(Duration.zero); // 等待异步操作
      expect(called, true);
    });
  });
}
