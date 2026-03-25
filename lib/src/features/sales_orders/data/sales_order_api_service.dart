import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_detail_dto.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';

class SalesOrderApiService {
  SalesOrderApiService(this._client);

  final ApiClient _client;

  Future<SalesOrderPageDto> fetchSalesOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? paymentStatus,
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
    if (paymentStatus != null && paymentStatus.isNotEmpty) {
      params['payment_status'] = paymentStatus;
    }

    final response =
        await _client.get('/sales-orders/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) =>
                  SalesOrderDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <SalesOrderDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return SalesOrderPageDto(
          items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map(
              (item) => SalesOrderDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return SalesOrderPageDto(
          items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const SalesOrderPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<Map<String, dynamic>> fetchSummary({
    Map<String, dynamic>? params,
  }) async {
    final response =
        await _client.get('/sales-orders/summary/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      return Map<String, dynamic>.from(payload);
    }
    if (payload is Map) {
      return Map<String, dynamic>.from(payload);
    }
    return const {};
  }

  Future<SalesOrderDetailDto> fetchSalesOrder(int id) async {
    final response = await _client.get('/sales-orders/$id/');
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return SalesOrderDetailDto.fromJson(map);
  }

  Future<SalesOrderDetailDto> createSalesOrder(
      Map<String, dynamic> payload) async {
    final response = await _client.post('/sales-orders/', data: payload);
    final body = response.data;
    final map =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return SalesOrderDetailDto.fromJson(map);
  }

  Future<SalesOrderDetailDto> updateSalesOrder(
      int id, Map<String, dynamic> payload) async {
    final response = await _client.put('/sales-orders/$id/', data: payload);
    final body = response.data;
    final map =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    return SalesOrderDetailDto.fromJson(map);
  }

  Future<SalesOrderDetailDto> submit(int id) async {
    final response = await _client.post('/sales-orders/$id/submit/');
    return _detailFromResponse(response.data);
  }

  Future<SalesOrderDetailDto> approve(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/sales-orders/$id/approve/', data: payload);
    return _detailFromResponse(response.data);
  }

  Future<SalesOrderDetailDto> reject(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/sales-orders/$id/reject/', data: payload);
    return _detailFromResponse(response.data);
  }

  Future<SalesOrderDetailDto> startProduction(int id) async {
    final response = await _client.post('/sales-orders/$id/start_production/');
    return _detailFromResponse(response.data);
  }

  Future<SalesOrderDetailDto> complete(int id) async {
    final response = await _client.post('/sales-orders/$id/complete/');
    return _detailFromResponse(response.data);
  }

  Future<SalesOrderDetailDto> cancel(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/sales-orders/$id/cancel/', data: payload);
    return _detailFromResponse(response.data);
  }

  Future<SalesOrderDetailDto> updatePayment(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/sales-orders/$id/update_payment/', data: payload);
    return _detailFromResponse(response.data);
  }

  Future<void> deleteSalesOrder(int id) async {
    await _client.delete('/sales-orders/$id/');
  }

  SalesOrderDetailDto _detailFromResponse(dynamic data) {
    final map =
        data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    return SalesOrderDetailDto.fromJson(map);
  }
}
