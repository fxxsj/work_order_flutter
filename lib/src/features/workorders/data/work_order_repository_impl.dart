import 'package:dio/dio.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_detail_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_flow_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_form_options_loader.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_list_support_service.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_form_options.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_list_support.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';

class WorkOrderRepositoryImpl implements WorkOrderRepository {
  WorkOrderRepositoryImpl(
    this._apiService, {
    WorkOrderFlowApiService? flowApiService,
  }) : _flowApiService =
           flowApiService ?? WorkOrderFlowApiService(_apiService.client);

  final WorkOrderApiService _apiService;
  final WorkOrderFlowApiService _flowApiService;

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
  Future<WorkOrderDetailDto> updateWorkOrder(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.updateWorkOrder(id, payload);
  }

  @override
  Future<WorkOrderDetailDto> uploadDesignFile(
    int id,
    MultipartFile designFile,
  ) {
    return _apiService.uploadDesignFile(id, designFile);
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
  Future<WorkOrderDetailDto> submitApproval(
    int id, {
    String? comment,
    Map<String, dynamic>? payload,
  }) {
    return _flowApiService.submitApproval(
      id,
      comment: comment,
      payload: payload,
    );
  }

  @override
  Future<WorkOrderDetailDto> approveWorkOrder(int id, {String? comment}) {
    return _flowApiService.approve(id, comment: comment);
  }

  @override
  Future<WorkOrderDetailDto> rejectWorkOrder(int id, {required String reason}) {
    return _flowApiService.reject(id, reason: reason);
  }

  @override
  Future<WorkOrderDetailDto> resubmitForApproval(int id) {
    return _flowApiService.submitApproval(id);
  }

  @override
  Future<Map<String, dynamic>> checkCompletion(int id) {
    return _flowApiService.checkCompletion(id);
  }

  @override
  Future<Map<String, dynamic>> markUrgent(int id, {required String reason}) {
    return _apiService.markUrgent(id, reason: reason);
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
  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params}) {
    return _apiService.fetchSummary(params: params);
  }

  @override
  Future<dynamic> export({Map<String, dynamic>? params}) {
    return _apiService.export(params: params);
  }

  @override
  Future<WorkOrderListFilterOptions> loadFilterOptions() {
    return WorkOrderListSupportService(_apiService.client).loadFilterOptions();
  }

  @override
  Future<WorkOrderExportResult> exportWorkOrders(Map<String, dynamic> params) {
    return WorkOrderListSupportService(_apiService.client).export(params);
  }

  @override
  Future<WorkOrderFormOptionsData> loadFormOptions({
    int? excludeWorkOrderId,
  }) {
    return WorkOrderFormOptionsLoader(
      _apiService.client,
      excludeWorkOrderId: excludeWorkOrderId,
    ).load();
  }

  @override
  Future<Map<String, dynamic>> checkSyncNeeded(
    int id, {
    List<int>? processIds,
  }) {
    return _apiService.checkSyncNeeded(id, processIds: processIds);
  }

  @override
  Future<Map<String, dynamic>> syncTasksPreview(
    int id, {
    List<int>? processIds,
  }) {
    return _apiService.syncTasksPreview(id, processIds: processIds);
  }

  @override
  Future<Map<String, dynamic>> syncTasksExecute(
    int id, {
    List<int>? processIds,
  }) {
    return _apiService.syncTasksExecute(id, processIds: processIds);
  }

  @override
  Future<List<WorkOrder>> searchWorkOrders(
    String query, {
    int pageSize = 20,
  }) async {
    final page = await getWorkOrders(
      pageSize: pageSize,
      search: query,
      approvalStatus: '',
    );
    return page.items.map((dto) => dto.toEntity()).toList();
  }
}
