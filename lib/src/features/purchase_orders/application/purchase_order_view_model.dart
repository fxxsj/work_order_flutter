import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_repository.dart';

class PurchaseOrderViewModel extends PaginatedViewModel<PurchaseOrder> {
  PurchaseOrderViewModel(this._repository);

  final PurchaseOrderRepository _repository;

  List<PurchaseOrder> get purchaseOrders => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadPurchaseOrders({bool resetPage = false}) => loadItems(resetPage: resetPage);

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
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
