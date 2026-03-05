import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_repository.dart';

class DeliveryOrderViewModel extends PaginatedViewModel<DeliveryOrder> {
  DeliveryOrderViewModel(this._repository);

  final DeliveryOrderRepository _repository;

  List<DeliveryOrder> get deliveryOrders => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadDeliveryOrders({bool resetPage = false}) => loadItems(resetPage: resetPage);

  @override
  Future<PageData<DeliveryOrder>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getDeliveryOrders(
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
