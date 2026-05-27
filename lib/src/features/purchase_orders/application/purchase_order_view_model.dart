import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_repository.dart';

class PurchaseOrderViewModel extends PaginatedViewModel<PurchaseOrder> {
  PurchaseOrderViewModel(this._repository);

  final PurchaseOrderRepository _repository;
  String _statusFilter = '';
  int _supplierId = 0;
  String _ordering = '-created_at';

  List<PurchaseOrder> get purchaseOrders => items;
  String get statusFilter => _statusFilter;
  int get supplierId => _supplierId;
  String get ordering => _ordering;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadPurchaseOrders({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  void setSearchTextAndReload(String value) {
    setSearchText(value);
    loadPurchaseOrders(resetPage: true);
  }

  void setStatusFilter(String value) {
    _statusFilter = value;
    loadPurchaseOrders(resetPage: true);
  }

  void setSupplierId(int value) {
    _supplierId = value;
    loadPurchaseOrders(resetPage: true);
  }

  void setOrdering(String value) {
    _ordering = value;
    loadPurchaseOrders(resetPage: true);
  }

  void resetFilters() {
    setSearchText('');
    _statusFilter = '';
    _supplierId = 0;
    _ordering = '-created_at';
    loadPurchaseOrders(resetPage: true);
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
      ordering: _ordering,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
