import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';

class WorkOrderViewModel extends PaginatedViewModel<WorkOrder> {
  WorkOrderViewModel(this._repository);

  final WorkOrderRepository _repository;
  String? _statusFilter;
  String? _priorityFilter;
  String? _approvalStatusFilter;
  int? _customerFilterId;
  int? _productFilterId;
  int? _processFilterId;

  List<WorkOrder> get workOrders => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadWorkOrders({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  String? get statusFilter => _statusFilter;
  String? get priorityFilter => _priorityFilter;
  String? get approvalStatusFilter => _approvalStatusFilter;
  int? get customerFilterId => _customerFilterId;
  int? get productFilterId => _productFilterId;
  int? get processFilterId => _processFilterId;

  void setStatusFilter(String? value) {
    _statusFilter = value?.trim().isEmpty == true ? null : value;
  }

  void setPriorityFilter(String? value) {
    _priorityFilter = value?.trim().isEmpty == true ? null : value;
  }

  void setApprovalStatusFilter(String? value) {
    _approvalStatusFilter = value?.trim().isEmpty == true ? null : value;
  }

  void setCustomerFilterId(int? value) {
    _customerFilterId = value;
  }

  void setProductFilterId(int? value) {
    _productFilterId = value;
  }

  void setProcessFilterId(int? value) {
    _processFilterId = value;
  }

  Future<WorkOrderDetail> fetchDetail(int id) async {
    final detail = await _repository.getWorkOrderDetail(id);
    return detail.toEntity();
  }

  Future<WorkOrderDetail> createWorkOrder(Map<String, dynamic> payload) async {
    final detail = await _repository.createWorkOrder(payload);
    return detail.toEntity();
  }

  Future<WorkOrderDetail> updateWorkOrder(
      int id, Map<String, dynamic> payload) async {
    final detail = await _repository.updateWorkOrder(id, payload);
    return detail.toEntity();
  }

  Future<void> deleteWorkOrder(int id) async {
    await _repository.deleteWorkOrder(id);
  }

  Future<WorkOrderDetail> updateStatus(int id, String status) async {
    final detail = await _repository.updateStatus(id, status);
    return detail.toEntity();
  }

  Future<WorkOrderDetail> approve({
    required int id,
    required String approvalStatus,
    String? approvalComment,
    String? rejectionReason,
  }) async {
    final detail = await _repository.approve(
      id: id,
      approvalStatus: approvalStatus,
      approvalComment: approvalComment,
      rejectionReason: rejectionReason,
    );
    return detail.toEntity();
  }

  Future<WorkOrderDetail> resubmitForApproval(int id) async {
    final detail = await _repository.resubmitForApproval(id);
    return detail.toEntity();
  }

  Future<WorkOrderDetail> requestReapproval(int id, String reason) async {
    final detail = await _repository.requestReapproval(id, reason);
    return detail.toEntity();
  }

  Future<Map<String, dynamic>> fetchApprovalStatus(int id) {
    return _repository.fetchApprovalStatus(id);
  }

  Future<Map<String, dynamic>> submitMultiApproval(int id) {
    return _repository.submitMultiApproval(id);
  }

  Future<Map<String, dynamic>> startApprovalStep(int stepId) {
    return _repository.startApprovalStep(stepId);
  }

  Future<Map<String, dynamic>> completeApprovalStep(
    int stepId, {
    required String decision,
    String? comments,
  }) {
    return _repository.completeApprovalStep(
      stepId,
      decision: decision,
      comments: comments,
    );
  }

  Future<Map<String, dynamic>> escalateApprovalStep(
    int stepId, {
    required String reason,
    int? toStepId,
  }) {
    return _repository.escalateApprovalStep(
      stepId,
      reason: reason,
      toStepId: toStepId,
    );
  }

  Future<Map<String, dynamic>> markUrgent(int id, {required String reason}) {
    return _repository.markUrgent(id, reason: reason);
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
      status: _statusFilter,
      priority: _priorityFilter,
      approvalStatus: _approvalStatusFilter,
      customerId: _customerFilterId,
      productId: _productFilterId,
      processId: _processFilterId,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
