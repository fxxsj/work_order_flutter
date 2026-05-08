import 'package:dio/dio.dart';
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
  Map<String, dynamic> _summary = const {};
  int _summaryRequestToken = 0;

  List<WorkOrder> get workOrders => items;
  Map<String, dynamic> get summary => _summary;

  Future<void> initialize() => loadWorkOrders(resetPage: true);

  Future<void> loadWorkOrders({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    await _loadSummary();
  }

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

  Future<void> applyRoutePrefill({
    String? search,
    String? approvalStatus,
  }) async {
    setSearchText(search?.trim() ?? '');
    _approvalStatusFilter =
        approvalStatus?.trim().isEmpty == true ? null : approvalStatus?.trim();
    await loadWorkOrders(resetPage: true);
  }

  Future<WorkOrderDetail> fetchDetail(int id) async {
    final detail = await _repository.getWorkOrderDetail(id);
    return detail.toEntity();
  }

  Future<WorkOrderDetail> createWorkOrder(Map<String, dynamic> payload) async {
    final detail = await _repository.createWorkOrder(payload);
    await loadWorkOrders(resetPage: true);
    return detail.toEntity();
  }

  Future<WorkOrderDetail> updateWorkOrder(
      int id, Map<String, dynamic> payload) async {
    final detail = await _repository.updateWorkOrder(id, payload);
    await loadWorkOrders();
    return detail.toEntity();
  }

  Future<WorkOrderDetail> uploadDesignFile(
      int id, MultipartFile designFile) async {
    final detail = await _repository.uploadDesignFile(id, designFile);
    return detail.toEntity();
  }

  Future<void> deleteWorkOrder(int id) async {
    await _repository.deleteWorkOrder(id);
    await loadWorkOrders();
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

  Future<WorkOrderDetail> submitApproval(int id, {String? comment}) async {
    final detail = await _repository.submitApproval(id, comment: comment);
    return detail.toEntity();
  }

  Future<WorkOrderDetail> resubmitForApproval(int id) async {
    final detail = await _repository.resubmitForApproval(id);
    return detail.toEntity();
  }

  Future<Map<String, dynamic>> checkCompletion(int id) {
    return _repository.checkCompletion(id);
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

  Future<void> _loadSummary() async {
    final token = ++_summaryRequestToken;
    try {
      final params = <String, dynamic>{};
      final trimmedSearch = searchText.trim();
      if (trimmedSearch.isNotEmpty) {
        params['search'] = trimmedSearch;
      }
      if (_statusFilter != null && _statusFilter!.isNotEmpty) {
        params['status'] = _statusFilter;
      }
      if (_priorityFilter != null && _priorityFilter!.isNotEmpty) {
        params['priority'] = _priorityFilter;
      }
      if (_approvalStatusFilter != null && _approvalStatusFilter!.isNotEmpty) {
        params['approval_status'] = _approvalStatusFilter;
      }
      if ((_customerFilterId ?? 0) > 0) {
        params['customer'] = _customerFilterId;
      }
      if ((_productFilterId ?? 0) > 0) {
        params['product'] = _productFilterId;
      }
      if ((_processFilterId ?? 0) > 0) {
        params['process'] = _processFilterId;
      }
      final summary = await _repository.getSummary(
        params: params.isEmpty ? null : params,
      );
      if (token != _summaryRequestToken) return;
      _summary = summary;
      safeNotify();
    } catch (_) {
      if (token != _summaryRequestToken) return;
      _summary = const {};
      safeNotify();
    }
  }
}
