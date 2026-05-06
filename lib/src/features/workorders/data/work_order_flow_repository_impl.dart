import 'package:work_order_app/src/features/workorders/data/work_order_flow_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_detail_dto.dart';
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

  @override
  Future<WorkOrderDetailDto> submitApproval(int id, {String? comment}) {
    return _apiService.submitApproval(id, comment: comment);
  }

  @override
  Future<WorkOrderDetailDto> approve(int id, {String? comment}) {
    return _apiService.approve(id, comment: comment);
  }

  @override
  Future<WorkOrderDetailDto> reject(int id, {required String reason}) {
    return _apiService.reject(id, reason: reason);
  }

  @override
  Future<WorkOrderDetailDto> requestReapproval(int id, String reason) {
    return _apiService.requestReapproval(id, reason);
  }

  @override
  Future<Map<String, dynamic>> checkCompletion(int id) {
    return _apiService.checkCompletion(id);
  }
}
