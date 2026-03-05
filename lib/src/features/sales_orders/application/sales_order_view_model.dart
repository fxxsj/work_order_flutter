import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';

class SalesOrderViewModel extends PaginatedViewModel<SalesOrder> {
  SalesOrderViewModel(this._repository);

  final SalesOrderRepository _repository;

  List<SalesOrder> get salesOrders => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadSalesOrders({bool resetPage = false}) => loadItems(resetPage: resetPage);

  Future<SalesOrderDetail> fetchDetail(int id) async {
    final detail = await _repository.getSalesOrderDetail(id);
    return detail.toEntity();
  }

  Future<SalesOrderDetail> createSalesOrder(Map<String, dynamic> payload) async {
    final detail = await _repository.createSalesOrder(payload);
    return detail.toEntity();
  }

  Future<SalesOrderDetail> updateSalesOrder(int id, Map<String, dynamic> payload) async {
    final detail = await _repository.updateSalesOrder(id, payload);
    return detail.toEntity();
  }

  @override
  Future<PageData<SalesOrder>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getSalesOrders(
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
