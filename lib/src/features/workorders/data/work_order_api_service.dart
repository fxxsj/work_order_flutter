import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_detail_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';

class WorkOrderApiService {
  WorkOrderApiService(this._client);

  final ApiClient _client;

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
    return const WorkOrderPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<WorkOrderDetailDto> fetchWorkOrder(int id) async {
    final response = await _client.get('/workorders/$id/');
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<WorkOrderDetailDto> createWorkOrder(
      Map<String, dynamic> payload) async {
    final response = await _client.post('/workorders/', data: payload);
    final body = response.data;
    final map =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<WorkOrderDetailDto> updateWorkOrder(
      int id, Map<String, dynamic> payload) async {
    final response = await _client.put('/workorders/$id/', data: payload);
    final body = response.data;
    final map =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<WorkOrderDetailDto> uploadDesignFile(
      int id, MultipartFile designFile) async {
    final response = await _client.patch(
      '/workorders/$id/',
      data: FormData.fromMap({'design_file': designFile}),
    );
    final body = response.data;
    final map =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<void> deleteWorkOrder(int id) async {
    await _client.delete('/workorders/$id/');
  }

  Future<WorkOrderDetailDto> updateStatus(int id, String status) async {
    final response = await _client
        .post('/workorders/$id/update_status/', data: {'status': status});
    final body = response.data;
    final map =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
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
    final body = response.data;
    final map =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<WorkOrderDetailDto> resubmitForApproval(int id) async {
    final response =
        await _client.post('/workorders/$id/resubmit_for_approval/');
    final body = response.data;
    final map =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<WorkOrderDetailDto> requestReapproval(int id, String reason) async {
    final response = await _client
        .post('/workorders/$id/request_reapproval/', data: {'reason': reason});
    final body = response.data;
    final map =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<Map<String, dynamic>> fetchApprovalStatus(int id) async {
    final response = await _client.get(
      '/multi-level-approval/get_approval_status/',
      queryParameters: {'order_id': id},
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> submitMultiApproval(int id) async {
    final response = await _client.post(
      '/multi-level-approval/submit_for_approval/',
      data: {'order_id': id},
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> startApprovalStep(int stepId) async {
    final response = await _client.post('/approval-steps/$stepId/start_step/');
    return _mapFromResponse(response.data);
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
    return _mapFromResponse(response.data);
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
    return _mapFromResponse(response.data);
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
    return _mapFromResponse(response.data);
  }

  Future<WorkOrderDetailDto> addProcess(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/workorders/$id/add_process/', data: payload);
    return _detailFromResponse(response.data);
  }

  Future<WorkOrderDetailDto> addMaterial(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/workorders/$id/add_material/', data: payload);
    return _detailFromResponse(response.data);
  }

  Future<Map<String, dynamic>> getStatistics(
      {Map<String, dynamic>? params}) async {
    final response =
        await _client.get('/workorders/statistics/', queryParameters: params);
    return _mapFromResponse(response.data);
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
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> syncTasksPreview(int id,
      {List<int>? processIds}) async {
    final payload = <String, dynamic>{
      if (processIds != null && processIds.isNotEmpty)
        'process_ids': processIds,
    };
    final response = await _client.post('/workorders/$id/sync_tasks_preview/',
        data: payload);
    return _mapFromResponse(response.data);
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
    return _mapFromResponse(response.data);
  }

  WorkOrderDetailDto _detailFromResponse(dynamic data) {
    final map =
        data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
