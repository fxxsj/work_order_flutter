import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';

class WorkOrderViewModel extends PaginatedViewModel<WorkOrder> {
  WorkOrderViewModel(this._repository);

  final WorkOrderRepository _repository;

  List<WorkOrder> get workOrders => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadWorkOrders({bool resetPage = false}) => loadItems(resetPage: resetPage);

  Future<WorkOrderDetail> fetchDetail(int id) async {
    final detail = await _repository.getWorkOrderDetail(id);
    return detail.toEntity();
  }

  Future<WorkOrderDetail> createWorkOrder(Map<String, dynamic> payload) async {
    final detail = await _repository.createWorkOrder(payload);
    return detail.toEntity();
  }

  Future<WorkOrderDetail> updateWorkOrder(int id, Map<String, dynamic> payload) async {
    final detail = await _repository.updateWorkOrder(id, payload);
    return detail.toEntity();
  }

  @override
  Future<PageData<WorkOrder>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getWorkOrders(
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
