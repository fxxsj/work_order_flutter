import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_repository.dart';

class PurchaseOrderViewModel extends PaginatedViewModel<PurchaseOrder> {
  PurchaseOrderViewModel(this._repository);

  final PurchaseOrderRepository _repository;
  String _statusFilter = '';
  int _supplierId = 0;

  List<PurchaseOrder> get purchaseOrders => items;
  String get statusFilter => _statusFilter;
  int get supplierId => _supplierId;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadPurchaseOrders({bool resetPage = false}) => loadItems(resetPage: resetPage);

  Future<void> setStatusFilter(String value) async {
    _statusFilter = value;
    await loadPurchaseOrders(resetPage: true);
  }

  Future<void> setSupplierId(int value) async {
    _supplierId = value;
    await loadPurchaseOrders(resetPage: true);
  }

  @override
  Future<PageData<PurchaseOrder>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getPurchaseOrders(
      page: page,
      pageSize: pageSize,
      search: search,
      status: _statusFilter.isEmpty ? null : _statusFilter,
      supplierId: _supplierId > 0 ? _supplierId : null,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
