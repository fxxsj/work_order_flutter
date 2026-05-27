import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
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
    String? ordering,
  }) async {
    final params = <String, dynamic>{'page': page, 'page_size': pageSize};
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
    if (ordering != null && ordering.isNotEmpty) {
      params['ordering'] = ordering;
    }

    final response = await _client.get(
      '/sales-orders/',
      queryParameters: params,
    );
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final pageData = PageData.fromPayload(
        payload: payload,
        page: page,
        pageSize: pageSize,
        results: _parseSalesOrderList(payload['results']),
      );
      return SalesOrderPageDto(
        items: pageData.items,
        total: pageData.total,
        page: pageData.page,
        pageSize: pageData.pageSize,
      );
    }
    if (payload is List) {
      final list = _parseSalesOrderList(payload);
      return SalesOrderPageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    throw _unexpectedPayload('客户订单列表', payload);
  }

  Future<Map<String, dynamic>> fetchSummary({
    Map<String, dynamic>? params,
  }) async {
    final response = await _client.get(
      '/sales-orders/summary/',
      queryParameters: params,
    );
    return _requireMap('客户订单汇总', response.data);
  }

  Future<SalesOrderDetailDto> fetchSalesOrder(int id) async {
    final response = await _client.get('/sales-orders/$id/');
    return _detailFromResponse(response.data, label: '客户订单详情');
  }

  Future<SalesOrderDetailDto> createSalesOrder(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post('/sales-orders/', data: payload);
    return _detailFromResponse(response.data, label: '创建客户订单');
  }

  Future<SalesOrderDetailDto> updateSalesOrder(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.put('/sales-orders/$id/', data: payload);
    return _detailFromResponse(response.data, label: '更新客户订单');
  }

  Future<SalesOrderDetailDto> submit(int id) async {
    final response = await _client.post('/sales-orders/$id/submit/');
    return _detailFromResponse(response.data, label: '提交客户订单');
  }

  Future<SalesOrderDetailDto> approve(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/sales-orders/$id/approve/',
      data: payload,
    );
    return _detailFromResponse(response.data, label: '审核客户订单');
  }

  Future<SalesOrderDetailDto> reject(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/sales-orders/$id/reject/',
      data: payload,
    );
    return _detailFromResponse(response.data, label: '拒绝客户订单');
  }

  Future<SalesOrderDetailDto> startProduction(int id) async {
    final response = await _client.post('/sales-orders/$id/start_production/');
    return _detailFromResponse(response.data, label: '开始生产');
  }

  Future<SalesOrderDetailDto> complete(
    int id, [
    Map<String, dynamic>? payload,
  ]) async {
    final response = await _client.post(
      '/sales-orders/$id/complete/',
      data: payload,
    );
    return _detailFromResponse(response.data, label: '完成客户订单');
  }

  Future<SalesOrderDetailDto> cancel(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/sales-orders/$id/cancel/',
      data: payload,
    );
    return _detailFromResponse(response.data, label: '取消客户订单');
  }

  Future<SalesOrderDetailDto> updatePayment(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/sales-orders/$id/update_payment/',
      data: payload,
    );
    return _detailFromResponse(response.data, label: '更新付款信息');
  }

  Future<void> deleteSalesOrder(int id) async {
    await _client.delete('/sales-orders/$id/');
  }

  SalesOrderDetailDto _detailFromResponse(
    dynamic data, {
    required String label,
  }) {
    return SalesOrderDetailDto.fromJson(_requireMap(label, data));
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
    return ApiException(message: '$label 响应格式异常', data: data);
  }

  List<SalesOrderDto> _parseSalesOrderList(dynamic payload) {
    if (payload is! List) {
      return const <SalesOrderDto>[];
    }
    return payload
        .whereType<Map>()
        .map((item) => SalesOrderDto.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
