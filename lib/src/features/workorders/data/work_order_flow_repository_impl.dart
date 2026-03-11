import 'package:work_order_app/src/features/workorders/data/work_order_flow_api_service.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_flow_repository.dart';

class WorkOrderFlowRepositoryImpl implements WorkOrderFlowRepository {
  WorkOrderFlowRepositoryImpl(this._apiService);

  final WorkOrderFlowApiService _apiService;

  @override
  Future<Map<String, dynamic>> createFromSalesOrder(Map<String, dynamic> payload) {
    return _apiService.createFromSalesOrder(payload);
  }

  @override
  Future<Map<String, dynamic>> createFromSalesOrders(Map<String, dynamic> payload) {
    return _apiService.createFromSalesOrders(payload);
  }
}
