import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_detail_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_sales_order_candidate.dart';

class WorkOrderApiService {
  WorkOrderApiService(this._client);

  final ApiClient _client;

  ApiClient get client => _client;

  Future<WorkOrderPageDto> fetchWorkOrders({
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
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    if (status != null && status.isNotEmpty) {
      params['status'] = status;
    }
    if (priority != null && priority.isNotEmpty) {
      params['priority'] = priority;
    }
    if (approvalStatus != null && approvalStatus.isNotEmpty) {
      params['approval_status'] = approvalStatus;
    }
    if (customerId != null && customerId > 0) {
      params['customer'] = customerId;
    }
    if (productId != null && productId > 0) {
      params['product'] = productId;
    }
    if (processId != null && processId > 0) {
      params['process'] = processId;
    }
    if (ordering != null && ordering.trim().isNotEmpty) {
      params['ordering'] = ordering.trim();
    }

    final response = await _client.get('/workorders/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) =>
                  WorkOrderDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <WorkOrderDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return WorkOrderPageDto(
          items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => WorkOrderDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return WorkOrderPageDto(
          items: list, total: list.length, page: 1, pageSize: list.length);
    }
    throw _unexpectedPayload('施工单列表', payload);
  }

  Future<Map<String, dynamic>> fetchSummary({
    Map<String, dynamic>? params,
  }) async {
    final response =
        await _client.get('/workorders/summary/', queryParameters: params);
    return _requireMap('施工单汇总', response.data);
  }

  Future<List<WorkOrderSalesOrderCandidate>> fetchSalesOrderCandidates({
    int? excludeWorkOrderId,
  }) async {
    final params = <String, dynamic>{};
    if (excludeWorkOrderId != null && excludeWorkOrderId > 0) {
      params['exclude_work_order_id'] = excludeWorkOrderId;
    }
    final response = await _client.get(
      '/workorders/sales_order_candidates/',
      queryParameters: params.isEmpty ? null : params,
    );
    final payload = response.data;
    if (payload is! List) {
      throw _unexpectedPayload('施工单来源客户订单候选列表', payload);
    }
    return payload
        .whereType<Map>()
        .map(
          (item) => WorkOrderSalesOrderCandidate.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(growable: false);
  }

  Future<WorkOrderDetailDto> fetchWorkOrder(int id) async {
    final response = await _client.get('/workorders/$id/');
    return _detailFromResponse(response.data, label: '施工单详情');
  }

  Future<WorkOrderDetailDto> createWorkOrder(
      Map<String, dynamic> payload) async {
    final response = await _client.post('/workorders/', data: payload);
    return _detailFromResponse(response.data, label: '创建施工单');
  }

  Future<WorkOrderDetailDto> updateWorkOrder(
      int id, Map<String, dynamic> payload) async {
    final response = await _client.put('/workorders/$id/', data: payload);
    return _detailFromResponse(response.data, label: '更新施工单');
  }

  Future<WorkOrderDetailDto> uploadDesignFile(
      int id, MultipartFile designFile) async {
    final response = await _client.patch(
      '/workorders/$id/',
      data: FormData.fromMap({'design_file': designFile}),
    );
    return _detailFromResponse(response.data, label: '上传设计文件');
  }

  Future<void> deleteWorkOrder(int id) async {
    await _client.delete('/workorders/$id/');
  }

  Future<WorkOrderDetailDto> updateStatus(int id, String status) async {
    final response = await _client
        .post('/workorders/$id/update_status/', data: {'status': status});
    return _detailFromResponse(response.data, label: '更新施工单状态');
  }

  Future<WorkOrderDetailDto> approve({
    required int id,
    required String approvalStatus,
    String? approvalComment,
    String? rejectionReason,
  }) async {
    final payload = <String, dynamic>{
      'approval_status': approvalStatus,
      'approval_comment': approvalComment ?? '',
    };
    if (rejectionReason != null && rejectionReason.trim().isNotEmpty) {
      payload['rejection_reason'] = rejectionReason.trim();
    }
    final response =
        await _client.post('/workorders/$id/approve/', data: payload);
    return _detailFromResponse(response.data, label: '审核施工单');
  }

  Future<WorkOrderDetailDto> resubmitForApproval(int id) async {
    final response =
        await _client.post('/workorders/$id/resubmit_for_approval/');
    return _detailFromResponse(response.data, label: '重新提交施工单审核');
  }

  Future<WorkOrderDetailDto> requestReapproval(int id, String reason) async {
    final response = await _client
        .post('/workorders/$id/request_reapproval/', data: {'reason': reason});
    return _detailFromResponse(response.data, label: '请求施工单重新审核');
  }

  Future<Map<String, dynamic>> fetchApprovalStatus(int id) async {
    final response = await _client.get(
      '/multi-level-approval/get_approval_status/',
      queryParameters: {'order_id': id},
    );
    return _requireMap('施工单审批状态', response.data);
  }

  Future<Map<String, dynamic>> submitMultiApproval(int id) async {
    final response = await _client.post(
      '/multi-level-approval/submit_for_approval/',
      data: {'order_id': id},
    );
    return _requireMap('提交多级审批', response.data);
  }

  Future<Map<String, dynamic>> startApprovalStep(int stepId) async {
    final response = await _client.post('/approval-steps/$stepId/start_step/');
    return _requireMap('开始审批步骤', response.data);
  }

  Future<Map<String, dynamic>> completeApprovalStep(
    int stepId, {
    required String decision,
    String? comments,
  }) async {
    final response = await _client.post(
      '/approval-steps/$stepId/complete_step/',
      data: {
        'decision': decision,
        if (comments != null) 'comments': comments,
      },
    );
    return _requireMap('完成审批步骤', response.data);
  }

  Future<Map<String, dynamic>> escalateApprovalStep(
    int stepId, {
    required String reason,
    int? toStepId,
  }) async {
    final response = await _client.post(
      '/approval-steps/$stepId/escalate_step/',
      data: {
        'escalation_reason': reason,
        if (toStepId != null) 'to_step_id': toStepId,
      },
    );
    return _requireMap('上报审批步骤', response.data);
  }

  Future<Map<String, dynamic>> markUrgent(int id,
      {required String reason}) async {
    final response = await _client.post(
      '/urgent-orders/mark_urgent/',
      data: {
        'order_id': id,
        'reason': reason,
      },
    );
    return _requireMap('标记紧急施工单', response.data);
  }

  Future<WorkOrderDetailDto> addProcess(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/workorders/$id/add_process/', data: payload);
    return _detailFromResponse(response.data, label: '添加施工单工序');
  }

  Future<WorkOrderDetailDto> addMaterial(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/workorders/$id/add_material/', data: payload);
    return _detailFromResponse(response.data, label: '添加施工单物料');
  }

  Future<Map<String, dynamic>> getStatistics(
      {Map<String, dynamic>? params}) async {
    final response =
        await _client.get('/workorders/statistics/', queryParameters: params);
    return _requireMap('施工单统计', response.data);
  }

  Future<Response<dynamic>> export({Map<String, dynamic>? params}) {
    return _client.requestRaw(
      '/workorders/export/',
      method: 'get',
      queryParameters: params,
      responseType: ResponseType.bytes,
    );
  }

  Future<Map<String, dynamic>> checkSyncNeeded(int id,
      {List<int>? processIds}) async {
    final params = <String, dynamic>{};
    if (processIds != null && processIds.isNotEmpty) {
      params['process_ids'] = processIds.join(',');
    }
    final response = await _client.get('/workorders/$id/check_sync_needed/',
        queryParameters: params);
    return _requireMap('检查任务同步', response.data);
  }

  Future<Map<String, dynamic>> syncTasksPreview(int id,
      {List<int>? processIds}) async {
    final payload = <String, dynamic>{
      if (processIds != null && processIds.isNotEmpty)
        'process_ids': processIds,
    };
    final response = await _client.post('/workorders/$id/sync_tasks_preview/',
        data: payload);
    return _requireMap('任务同步预览', response.data);
  }

  Future<Map<String, dynamic>> syncTasksExecute(int id,
      {List<int>? processIds}) async {
    final payload = <String, dynamic>{
      if (processIds != null && processIds.isNotEmpty)
        'process_ids': processIds,
      'confirmed': true,
    };
    final response = await _client.post('/workorders/$id/sync_tasks_execute/',
        data: payload);
    return _requireMap('执行任务同步', response.data);
  }

  WorkOrderDetailDto _detailFromResponse(
    dynamic data, {
    required String label,
  }) {
    return WorkOrderDetailDto.fromJson(_requireMap(label, data));
  }

  Map<String, dynamic> _requireMap(String label, dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw _unexpectedPayload(label, data);
  }

  ApiException _unexpectedPayload(String label, dynamic data) {
    return ApiException(
      message: '$label 响应格式异常',
      data: data,
    );
  }
}
