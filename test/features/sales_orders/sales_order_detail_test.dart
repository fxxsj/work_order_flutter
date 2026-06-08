import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';
import 'package:work_order_app/src/core/utils/store_util.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_detail_dto.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/sales_order_detail_page.dart';

class _MockSalesOrderRepository implements SalesOrderRepository {
  SalesOrderDetail _detail = _buildDetail(
    id: 1,
    status: 'draft',
    approvalStatus: 'draft',
  );

  void setDetail(SalesOrderDetail detail) {
    _detail = detail;
  }

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
    return SalesOrderPageDto(
      items: [],
      total: 0,
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
    return SalesOrderDetailDto(entity: _detail);
  }

  @override
  Future<SalesOrderDetailDto> createSalesOrder(Map<String, dynamic> payload) async {
    return SalesOrderDetailDto(entity: _detail);
  }

  @override
  Future<SalesOrderDetailDto> updateSalesOrder(
    int id,
    Map<String, dynamic> payload,
  ) async {
    return SalesOrderDetailDto(entity: _detail);
  }

  @override
  Future<SalesOrderDetailDto> submit(int id, [Map<String, dynamic>? payload]) async {
    return SalesOrderDetailDto(entity: _detail);
  }

  @override
  Future<SalesOrderDetailDto> approve(int id, Map<String, dynamic> payload) async {
    return SalesOrderDetailDto(entity: _detail);
  }

  @override
  Future<SalesOrderDetailDto> reject(int id, Map<String, dynamic> payload) async {
    return SalesOrderDetailDto(entity: _detail);
  }

  @override
  Future<SalesOrderDetailDto> startProduction(int id) async {
    return SalesOrderDetailDto(entity: _detail);
  }

  @override
  Future<SalesOrderDetailDto> complete(int id, [Map<String, dynamic>? payload]) async {
    return SalesOrderDetailDto(entity: _detail);
  }

  @override
  Future<SalesOrderDetailDto> cancel(int id, Map<String, dynamic> payload) async {
    return SalesOrderDetailDto(entity: _detail);
  }

  @override
  Future<SalesOrderDetailDto> updatePayment(
    int id,
    Map<String, dynamic> payload,
  ) async {
    return SalesOrderDetailDto(entity: _detail);
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

  static SalesOrderDetail _buildDetail({
    required int id,
    required String status,
    required String approvalStatus,
  }) {
    return SalesOrderDetail(
      id: id,
      orderNumber: 'SO00001',
      customerName: 'Test Customer',
      status: status,
      approvalStatus: approvalStatus,
      totalAmount: 100.0,
      orderDate: DateTime(2026, 6, 1),
      items: const [],
      workOrderSummaries: const [],
      deliveryOrderSummaries: const [],
      invoiceSummaries: const [],
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

  group('SalesOrderDetailPage', () {
    late _MockSalesOrderRepository repository;
    late SalesOrderViewModel viewModel;

    setUp(() {
      repository = _MockSalesOrderRepository();
      viewModel = SalesOrderViewModel(repository);
    });

    testWidgets('草稿状态显示提交和删除操作', (tester) async {
      repository.setDetail(
        _MockSalesOrderRepository._buildDetail(
          id: 1,
          status: 'draft',
          approvalStatus: 'draft',
        ),
      );

      await tester.pumpWidget(
        _buildTestApp(
          child: const SalesOrderDetailPage(orderId: 1),
          viewModel: viewModel,
        ),
      );
      await tester.pumpAndSettle();

      // Tap the action menu to reveal actions
      await tester.tap(find.text('更多操作'));
      await tester.pumpAndSettle();

      expect(find.text('提交'), findsOneWidget);
      expect(find.text('删除'), findsOneWidget);
    });

    testWidgets('已审核状态显示完成和取消操作', (tester) async {
      repository.setDetail(
        _MockSalesOrderRepository._buildDetail(
          id: 1,
          status: 'approved',
          approvalStatus: 'approved',
        ),
      );

      await tester.pumpWidget(
        _buildTestApp(
          child: const SalesOrderDetailPage(orderId: 1),
          viewModel: viewModel,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('更多操作'));
      await tester.pumpAndSettle();

      expect(find.text('完成订单'), findsOneWidget);
      expect(find.text('取消订单'), findsOneWidget);
      expect(find.text('更新付款'), findsOneWidget);
    });

    testWidgets('已完成状态不显示完成和取消操作', (tester) async {
      repository.setDetail(
        _MockSalesOrderRepository._buildDetail(
          id: 1,
          status: 'completed',
          approvalStatus: 'approved',
        ),
      );

      await tester.pumpWidget(
        _buildTestApp(
          child: const SalesOrderDetailPage(orderId: 1),
          viewModel: viewModel,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('更多操作'));
      await tester.pumpAndSettle();

      expect(find.text('完成订单'), findsNothing);
      expect(find.text('取消订单'), findsNothing);
    });

    testWidgets('详情页显示客户信息和付款信息', (tester) async {
      repository.setDetail(
        _MockSalesOrderRepository._buildDetail(
          id: 1,
          status: 'approved',
          approvalStatus: 'approved',
        ),
      );

      await tester.pumpWidget(
        _buildTestApp(
          child: const SalesOrderDetailPage(orderId: 1),
          viewModel: viewModel,
        ),
      );
      await tester.pumpAndSettle();

      // Verify basic sections are present
      expect(find.textContaining('客户订单'), findsWidgets);
      expect(find.text('Test Customer'), findsWidgets);
    });

    test('updatePayment 调用 repository 更新付款', () async {
      repository.setDetail(
        _MockSalesOrderRepository._buildDetail(
          id: 1,
          status: 'approved',
          approvalStatus: 'approved',
        ),
      );

      final result = await viewModel.updatePayment(1, {
        'paid_amount': 50.0,
        'payment_date': '2026-06-01',
      });

      expect(result, isA<SalesOrderDetail>());
    });

    test('complete 调用 repository 完成订单', () async {
      repository.setDetail(
        _MockSalesOrderRepository._buildDetail(
          id: 1,
          status: 'approved',
          approvalStatus: 'approved',
        ),
      );

      final result = await viewModel.complete(1);

      expect(result, isA<SalesOrderDetail>());
    });

    test('cancel 调用 repository 取消订单', () async {
      repository.setDetail(
        _MockSalesOrderRepository._buildDetail(
          id: 1,
          status: 'approved',
          approvalStatus: 'approved',
        ),
      );

      final result = await viewModel.cancel(1, {'reason': 'test'});

      expect(result, isA<SalesOrderDetail>());
    });
  });
}
