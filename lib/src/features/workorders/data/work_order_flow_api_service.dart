import 'package:work_order_app/src/core/network/api_client.dart';

class WorkOrderFlowApiService {
  WorkOrderFlowApiService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> createFromSalesOrder(Map<String, dynamic> payload) async {
    final response = await _client.post('/workorders-flow/create_from_sales_order/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> createFromSalesOrders(Map<String, dynamic> payload) async {
    final response = await _client.post('/workorders-flow/create_from_sales_orders/', data: payload);
    return _mapFromResponse(response.data);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
