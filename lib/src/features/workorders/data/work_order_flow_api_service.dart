import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_detail_dto.dart';

class WorkOrderFlowApiService {
  WorkOrderFlowApiService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> createFromSalesOrder(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/workorders-flow/create_from_sales_order/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> createFromSalesOrders(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/workorders-flow/create_from_sales_orders/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<WorkOrderDetailDto> submitApproval(
    int id, {
    String? comment,
    Map<String, dynamic>? payload,
  }) async {
    final data = <String, dynamic>{
      if (comment != null && comment.trim().isNotEmpty)
        'comment': comment.trim(),
    };
    if (payload != null) {
      data.addAll(payload);
    }

    final response = await _client.post(
      '/workorders-flow/$id/submit_approval/',
      data: data,
    );
    return _detailFromResponse(response.data);
  }

  Future<WorkOrderDetailDto> approve(int id, {String? comment}) async {
    final response = await _client.post(
      '/workorders-flow/$id/approve/',
      data: {
        if (comment != null && comment.trim().isNotEmpty)
          'comment': comment.trim(),
      },
    );
    return _detailFromResponse(response.data);
  }

  Future<WorkOrderDetailDto> reject(int id, {required String reason}) async {
    final response = await _client.post(
      '/workorders-flow/$id/reject/',
      data: {'reason': reason.trim()},
    );
    return _detailFromResponse(response.data);
  }

  Future<Map<String, dynamic>> checkCompletion(int id) async {
    final response = await _client.post(
      '/workorders-flow/$id/check_completion/',
    );
    return _mapFromResponse(response.data);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    throw StateError(
      'Unexpected work order flow response: ${data.runtimeType}',
    );
  }

  WorkOrderDetailDto _detailFromResponse(dynamic data) {
    final map = _mapFromResponse(data);
    return WorkOrderDetailDto.fromJson(map);
  }
}
