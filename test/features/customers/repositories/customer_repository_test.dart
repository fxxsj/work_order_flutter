import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/features/customers/models/customer.dart';
import 'package:work_order_app/src/features/customers/models/customer_list_response.dart';
import 'package:work_order_app/src/features/customers/repositories/customer_repository.dart';

/// Mock Repository for testing
class MockCustomerRepository implements CustomerRepository {
  bool shouldThrow = false;
  
  @override
  Future<CustomerListResponse> fetchCustomers({
    required int page,
    required int pageSize,
    String? search,
    bool? isActive,
  }) async {
    if (shouldThrow) throw Exception('Network error');
    
    return CustomerListResponse(
      items: [
        Customer(
          id: '1',
          name: 'Test Customer',
          code: 'C001',
          contactPerson: 'John Doe',
          phone: '1234567890',
          isActive: true,
        ),
      ],
      totalCount: 1,
      hasMore: false,
    );
  }

  @override
  Future<Customer> createCustomer(Customer customer) async {
    if (shouldThrow) throw Exception('Network error');
    return customer.copyWith(id: 'new-id');
  }

  @override
  Future<Customer> updateCustomer(Customer customer) async {
    if (shouldThrow) throw Exception('Network error');
    return customer;
  }

  @override
  Future<void> deleteCustomer(String id) async {
    if (shouldThrow) throw Exception('Network error');
  }

  @override
  Future<Customer> toggleActive(String id, bool isActive) async {
    if (shouldThrow) throw Exception('Network error');
    return Customer(
      id: id,
      name: 'Test',
      code: 'C001',
      contactPerson: 'Test',
      phone: '123',
      isActive: isActive,
    );
  }
}

void main() {
  group('CustomerRepository', () {
    late MockCustomerRepository mockRepository;

    setUp(() {
      mockRepository = MockCustomerRepository();
    });

    test('fetchCustomers should return customer list', () async {
      final result = await mockRepository.fetchCustomers(
        page: 1,
        pageSize: 20,
      );

      expect(result.items.length, 1);
      expect(result.items[0].name, 'Test Customer');
      expect(result.totalCount, 1);
      expect(result.hasMore, false);
    });

    test('fetchCustomers should throw on error', () async {
      mockRepository.shouldThrow = true;

      expect(
        () => mockRepository.fetchCustomers(page: 1, pageSize: 20),
        throwsA(isA<Exception>()),
      );
    });

    test('createCustomer should return customer with ID', () async {
      final customer = Customer(
        id: '',
        name: 'New Customer',
        code: 'C002',
        contactPerson: 'Jane Doe',
        phone: '0987654321',
        isActive: true,
      );

      final result = await mockRepository.createCustomer(customer);

      expect(result.id, 'new-id');
      expect(result.name, 'New Customer');
    });

    test('deleteCustomer should complete without error', () async {
      await expectLater(
        mockRepository.deleteCustomer('1'),
        completes,
      );
    });

    test('toggleActive should return customer with toggled status', () async {
      final result = await mockRepository.toggleActive('1', false);

      expect(result.id, '1');
      expect(result.isActive, false);
    });
  });
}
