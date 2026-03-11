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
    String? ordering,
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
      ordering: ordering,
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

  @override
  Future<WorkOrderDetailDto> addProcess(int id, Map<String, dynamic> payload) {
    return _apiService.addProcess(id, payload);
  }

  @override
  Future<WorkOrderDetailDto> addMaterial(int id, Map<String, dynamic> payload) {
    return _apiService.addMaterial(id, payload);
  }

  @override
  Future<Map<String, dynamic>> getStatistics({Map<String, dynamic>? params}) {
    return _apiService.getStatistics(params: params);
  }

  @override
  Future<dynamic> export({Map<String, dynamic>? params}) {
    return _apiService.export(params: params);
  }

  @override
  Future<Map<String, dynamic>> checkSyncNeeded(int id, {List<int>? processIds}) {
    return _apiService.checkSyncNeeded(id, processIds: processIds);
  }

  @override
  Future<Map<String, dynamic>> syncTasksPreview(int id, {List<int>? processIds}) {
    return _apiService.syncTasksPreview(id, processIds: processIds);
  }

  @override
  Future<Map<String, dynamic>> syncTasksExecute(int id, {List<int>? processIds}) {
    return _apiService.syncTasksExecute(id, processIds: processIds);
  }
}
