import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_detail_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';

class WorkOrderRepositoryImpl implements WorkOrderRepository {
  WorkOrderRepositoryImpl(this._apiService);

  final WorkOrderApiService _apiService;

  @override
  Future<WorkOrderPageDto> getWorkOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchWorkOrders(page: page, pageSize: pageSize, search: search);
  }

  @override
  Future<WorkOrderDetailDto> getWorkOrderDetail(int id) {
    return _apiService.fetchWorkOrder(id);
  }

  @override
  Future<WorkOrderDetailDto> createWorkOrder(Map<String, dynamic> payload) {
    return _apiService.createWorkOrder(payload);
  }

  @override
  Future<WorkOrderDetailDto> updateWorkOrder(int id, Map<String, dynamic> payload) {
    return _apiService.updateWorkOrder(id, payload);
  }
}
