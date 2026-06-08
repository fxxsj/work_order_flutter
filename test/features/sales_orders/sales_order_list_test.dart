import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';
import 'package:work_order_app/src/core/utils/store_util.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_detail_dto.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/sales_order_list_page.dart';

class _MockSalesOrderRepository implements SalesOrderRepository {
  String? lastStatusFilter;
  String? lastPaymentStatusFilter;
  String? lastOrdering;

  @override
  Future<void> deleteSalesOrder(int id) async {}

  @override
  Future<SalesOrderPageDto> getSalesOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? paymentStatus,
    String? ordering,
  }) async {
    lastStatusFilter = status;
    lastPaymentStatusFilter = paymentStatus;
    lastOrdering = ordering;
    return SalesOrderPageDto(
      items: [
        SalesOrderDto(
          id: 1,
          orderNumber: 'SO00001',
          status: 'draft',
          statusDisplay: '草稿',
          customerName: 'Customer A',
        ),
        SalesOrderDto(
          id: 2,
          orderNumber: 'SO00002',
          status: 'approved',
          statusDisplay: '已审核',
          customerName: 'Customer B',
        ),
      ],
      total: 2,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params}) async {
    return {};
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
}

Widget _buildTestApp({
  required Widget child,
  required SalesOrderViewModel viewModel,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => Scaffold(body: child),
      ),
    ],
  );
  return Provider<AppStorage>.value(
    value: AppStorage(),
    child: Provider<ApiClient>.value(
      value: ApiClient(),
      child: ChangeNotifierProvider<SalesOrderViewModel>.value(
        value: viewModel,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await StoreUtil.init();
  });

  setUp(() async {
    await StoreUtil.cleanAll();
    final storage = AppStorage();
    await storage.init();
    await storage.write('currentUserInfo', {
      'is_superuser': true,
      'permissions': <String>[],
    });
  });

  group('SalesOrderListPage', () {
    late _MockSalesOrderRepository repository;
    late SalesOrderViewModel viewModel;

    setUp(() {
      repository = _MockSalesOrderRepository();
      viewModel = SalesOrderViewModel(repository);
    });

    testWidgets('渲染列表页不抛异常', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const SalesOrderListPage(),
          viewModel: viewModel,
        ),
      );
      await viewModel.loadSalesOrders(resetPage: true);
      await tester.pumpAndSettle();

      // Verify the list page scaffold is present
      expect(find.byType(ListPageScaffold), findsOneWidget);
    });

    test('setStatusFilter 更新状态筛选并触发加载', () {
      viewModel.setStatusFilter('approved');
      expect(viewModel.statusFilter, equals('approved'));
      expect(repository.lastStatusFilter, equals('approved'));

      viewModel.setStatusFilter('draft');
      expect(viewModel.statusFilter, equals('draft'));
      expect(repository.lastStatusFilter, equals('draft'));

      viewModel.setStatusFilter('');
      expect(viewModel.statusFilter, isEmpty);
    });

    test('setPaymentStatusFilter 更新付款筛选并触发加载', () {
      viewModel.setPaymentStatusFilter('unpaid');
      expect(viewModel.paymentStatusFilter, equals('unpaid'));
      expect(repository.lastPaymentStatusFilter, equals('unpaid'));

      viewModel.setPaymentStatusFilter('paid');
      expect(viewModel.paymentStatusFilter, equals('paid'));
      expect(repository.lastPaymentStatusFilter, equals('paid'));
    });

    test('setOrdering 更新排序并触发加载', () {
      viewModel.setOrdering('order_number');
      expect(viewModel.ordering, equals('order_number'));
      expect(repository.lastOrdering, equals('order_number'));

      viewModel.setOrdering('-total_amount');
      expect(viewModel.ordering, equals('-total_amount'));
      expect(repository.lastOrdering, equals('-total_amount'));
    });

    test('resetFilters 清除所有筛选', () {
      viewModel.setStatusFilter('approved');
      viewModel.setPaymentStatusFilter('unpaid');
      viewModel.setOrdering('customer__name');

      viewModel.resetFilters();

      expect(viewModel.statusFilter, isEmpty);
      expect(viewModel.paymentStatusFilter, isEmpty);
      expect(viewModel.ordering, equals('-created_at'));
    });
  });
}
