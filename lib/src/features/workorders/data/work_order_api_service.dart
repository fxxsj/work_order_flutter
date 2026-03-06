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

    final response = await _client.get('/workorders/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => WorkOrderDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <WorkOrderDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return WorkOrderPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => WorkOrderDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return WorkOrderPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const WorkOrderPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<WorkOrderDetailDto> fetchWorkOrder(int id) async {
    final response = await _client.get('/workorders/$id/');
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<WorkOrderDetailDto> createWorkOrder(Map<String, dynamic> payload) async {
    final response = await _client.post('/workorders/', data: payload);
    final body = response.data;
    final map = body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<WorkOrderDetailDto> updateWorkOrder(int id, Map<String, dynamic> payload) async {
    final response = await _client.put('/workorders/$id/', data: payload);
    final body = response.data;
    final map = body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<void> deleteWorkOrder(int id) async {
    await _client.delete('/workorders/$id/');
  }

  Future<WorkOrderDetailDto> updateStatus(int id, String status) async {
    final response = await _client.post('/workorders/$id/update_status/', data: {'status': status});
    final body = response.data;
    final map = body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
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
    final response = await _client.post('/workorders/$id/approve/', data: payload);
    final body = response.data;
    final map = body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<WorkOrderDetailDto> resubmitForApproval(int id) async {
    final response = await _client.post('/workorders/$id/resubmit_for_approval/');
    final body = response.data;
    final map = body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }

  Future<WorkOrderDetailDto> requestReapproval(int id, String reason) async {
    final response = await _client.post('/workorders/$id/request_reapproval/', data: {'reason': reason});
    final body = response.data;
    final map = body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return WorkOrderDetailDto.fromJson(map);
  }
}
