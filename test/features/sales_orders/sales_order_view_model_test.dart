import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_detail_dto.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';

class _MockSalesOrderRepository implements SalesOrderRepository {
  int deleteCallCount = 0;
  int? deletedId;
  int loadCallCount = 0;
  bool shouldFailDelete = false;

  @override
  Future<void> deleteSalesOrder(int id) async {
    deleteCallCount++;
    deletedId = id;
    if (shouldFailDelete) {
      throw Exception('Delete failed');
    }
  }

  @override
  Future<SalesOrderPageDto> getSalesOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? paymentStatus,
    String? ordering,
  }) async {
    loadCallCount++;
    return SalesOrderPageDto(
      items: [
        SalesOrderDto(
          id: 1,
          orderNumber: 'SO00001',
          status: 'draft',
        ),
      ],
      total: 1,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params}) async {
    return {};
  }

  SalesOrderDetailDto _detailDto(int id) {
    return SalesOrderDetailDto(
      entity: SalesOrderDetail(
        id: id,
        orderNumber: 'SO00001',
        customerName: 'Test Customer',
        status: 'draft',
        totalAmount: 100.0,
        orderDate: DateTime(2026, 6, 1),
        items: const [],
        workOrderSummaries: const [],
        deliveryOrderSummaries: const [],
        invoiceSummaries: const [],
      ),
    );
  }

  @override
  Future<SalesOrderDetailDto> getSalesOrderDetail(int id) async {
    return _detailDto(id);
  }

  @override
  Future<SalesOrderDetailDto> createSalesOrder(Map<String, dynamic> payload) async {
    return _detailDto(1);
  }

  @override
  Future<SalesOrderDetailDto> updateSalesOrder(
    int id,
    Map<String, dynamic> payload,
  ) async {
    return _detailDto(id);
  }

  @override
  Future<SalesOrderDetailDto> submit(int id, [Map<String, dynamic>? payload]) async {
    return _detailDto(id);
  }

  @override
  Future<SalesOrderDetailDto> approve(int id, Map<String, dynamic> payload) async {
    return _detailDto(id);
  }

  @override
  Future<SalesOrderDetailDto> reject(int id, Map<String, dynamic> payload) async {
    return _detailDto(id);
  }

  @override
  Future<SalesOrderDetailDto> startProduction(int id) async {
    return _detailDto(id);
  }

  @override
  Future<SalesOrderDetailDto> complete(int id, [Map<String, dynamic>? payload]) async {
    return _detailDto(id);
  }

  @override
  Future<SalesOrderDetailDto> cancel(int id, Map<String, dynamic> payload) async {
    return _detailDto(id);
  }

  @override
  Future<SalesOrderDetailDto> updatePayment(
    int id,
    Map<String, dynamic> payload,
  ) async {
    return _detailDto(id);
  }

  @override
  Future<Map<String, dynamic>> createWorkOrdersFromSalesOrders(
    Map<String, dynamic> payload,
  ) async {
    return {};
  }

  @override
  Future<Map<String, dynamic>> createWorkOrderFromSalesOrder(
    Map<String, dynamic> payload,
  ) async {
    return {};
  }
}

void main() {
  group('SalesOrderViewModel', () {
    late _MockSalesOrderRepository repository;
    late SalesOrderViewModel viewModel;

    setUp(() {
      repository = _MockSalesOrderRepository();
      viewModel = SalesOrderViewModel(repository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('delete', () {
      test('calls repository.deleteSalesOrder with correct id', () async {
        await viewModel.delete(42);
        expect(repository.deleteCallCount, equals(1));
        expect(repository.deletedId, equals(42));
      });

      test('refreshes sales orders after delete', () async {
        await viewModel.delete(1);
        expect(repository.loadCallCount, greaterThanOrEqualTo(1));
        expect(viewModel.salesOrders, isNotEmpty);
      });

      test('throws when repository fails', () async {
        repository.shouldFailDelete = true;
        expect(() async => await viewModel.delete(1), throwsException);
      });
    });
  });
}
