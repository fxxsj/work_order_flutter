import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_dto.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';

class DeliveryOrderApiService {
  DeliveryOrderApiService(this._client);

  final ApiClient _client;

  Future<DeliveryOrderPageDto> fetchDeliveryOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    int? customerId,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    final statusTrimmed = status?.trim();
    if (statusTrimmed != null && statusTrimmed.isNotEmpty) {
      params['status'] = statusTrimmed;
    }
    if (customerId != null && customerId > 0) {
      params['customer'] = customerId;
    }

    final response =
        await _client.get('/delivery-orders/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) =>
                  DeliveryOrderDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <DeliveryOrderDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return DeliveryOrderPageDto(
          items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) =>
              DeliveryOrderDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return DeliveryOrderPageDto(
          items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const DeliveryOrderPageDto(
        items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<Map<String, dynamic>> ship(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/delivery-orders/$id/ship/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> receive(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/delivery-orders/$id/receive/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> reject(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/delivery-orders/$id/reject/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchSummary() async {
    final response = await _client.get('/delivery-orders/summary/');
    return _mapFromResponse(response.data);
  }

  Future<DeliveryOrderDetail> fetchDetail(int id) async {
    final response = await _client.get('/delivery-orders/$id/');
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return DeliveryOrderDetail.fromJson(map);
  }

  Future<DeliveryOrderDetail> createDeliveryOrder(
      Map<String, dynamic> payload) async {
    final response = await _client.post('/delivery-orders/', data: payload);
    final map = response.data is Map
        ? Map<String, dynamic>.from(response.data)
        : <String, dynamic>{};
    return DeliveryOrderDetail.fromJson(map);
  }

  Future<DeliveryOrderDetail> updateDeliveryOrder(
      int id, Map<String, dynamic> payload) async {
    final response = await _client.put('/delivery-orders/$id/', data: payload);
    final map = response.data is Map
        ? Map<String, dynamic>.from(response.data)
        : <String, dynamic>{};
    return DeliveryOrderDetail.fromJson(map);
  }

  Future<DeliveryOrderDetail> uploadReceiverSignature(
    int id,
    MultipartFile receiverSignature,
  ) async {
    final response = await _client.patch(
      '/delivery-orders/$id/',
      data: FormData.fromMap({'receiver_signature': receiverSignature}),
    );
    final map = response.data is Map
        ? Map<String, dynamic>.from(response.data)
        : <String, dynamic>{};
    return DeliveryOrderDetail.fromJson(map);
  }

  Future<void> deleteDeliveryOrder(int id) async {
    await _client.delete('/delivery-orders/$id/');
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
