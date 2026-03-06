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
    String? status,
    String? priority,
    String? approvalStatus,
    int? customerId,
    int? productId,
    int? processId,
  }) {
    return _apiService.fetchWorkOrders(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      priority: priority,
      approvalStatus: approvalStatus,
      customerId: customerId,
      productId: productId,
      processId: processId,
    );
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

  @override
  Future<void> deleteWorkOrder(int id) {
    return _apiService.deleteWorkOrder(id);
  }

  @override
  Future<WorkOrderDetailDto> updateStatus(int id, String status) {
    return _apiService.updateStatus(id, status);
  }

  @override
  Future<WorkOrderDetailDto> approve({
    required int id,
    required String approvalStatus,
    String? approvalComment,
    String? rejectionReason,
  }) {
    return _apiService.approve(
      id: id,
      approvalStatus: approvalStatus,
      approvalComment: approvalComment,
      rejectionReason: rejectionReason,
    );
  }

  @override
  Future<WorkOrderDetailDto> resubmitForApproval(int id) {
    return _apiService.resubmitForApproval(id);
  }

  @override
  Future<WorkOrderDetailDto> requestReapproval(int id, String reason) {
    return _apiService.requestReapproval(id, reason);
  }
}
