import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_dto.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';

class PurchaseOrderApiService {
  PurchaseOrderApiService(this._client);

  final ApiClient _client;

  ApiClient get client => _client;

  Future<PurchaseOrderPageDto> fetchPurchaseOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    int? supplierId,
    String? ordering,
  }) async {
    final params = <String, dynamic>{'page': page, 'page_size': pageSize};
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    if (status != null && status.isNotEmpty) {
      if (['draft', 'submitted', 'approved', 'rejected'].contains(status)) {
        params['approval_status'] = status;
      } else {
        params['status'] = status;
      }
    }
    if (supplierId != null && supplierId > 0) {
      params['supplier'] = supplierId;
    }
    final trimmedOrdering = ordering?.trim();
    if (trimmedOrdering != null && trimmedOrdering.isNotEmpty) {
      params['ordering'] = trimmedOrdering;
    }

    final response = await _client.get(
      '/purchase-orders/',
      queryParameters: params,
    );
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
                .whereType<Map>()
                .map(
                  (item) => PurchaseOrderDto.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : <PurchaseOrderDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return PurchaseOrderPageDto(
        items: list,
        total: total,
        page: page,
        pageSize: pageSize,
      );
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map(
            (item) =>
                PurchaseOrderDto.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
      return PurchaseOrderPageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    return const PurchaseOrderPageDto(
      items: [],
      total: 0,
      page: 1,
      pageSize: 20,
    );
  }

  Future<PurchaseOrderDetail> fetchDetail(int id) async {
    final response = await _client.get('/purchase-orders/$id/');
    final payload = response.data;
    final map = _unwrapDetail(payload);
    return PurchaseOrderDetail.fromJson(map);
  }

  Future<PurchaseOrderDetail> createPurchaseOrder(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post('/purchase-orders/', data: payload);
    return PurchaseOrderDetail.fromJson(_unwrapDetail(response.data));
  }

  Future<PurchaseOrderDetail> updatePurchaseOrder(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.put('/purchase-orders/$id/', data: payload);
    return PurchaseOrderDetail.fromJson(_unwrapDetail(response.data));
  }

  Map<String, dynamic> _unwrapDetail(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      if (payload['data'] is Map) {
        return Map<String, dynamic>.from(payload['data'] as Map);
      }
      return Map<String, dynamic>.from(payload);
    }
    return {};
  }

  Future<Map<String, dynamic>> submit(
    int id, [
    Map<String, dynamic>? payload,
  ]) async {
    final response = await _client.post(
      '/purchase-orders/$id/submit/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> approve(int id) async {
    final response = await _client.post('/purchase-orders/$id/approve/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> reject(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/purchase-orders/$id/reject/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> placeOrder(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/purchase-orders/$id/place_order/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> receive(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/purchase-orders/$id/receive/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> getReceiveRecords(int id) async {
    final response = await _client.get('/purchase-orders/$id/receive_records/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> getPendingInspections(int id) async {
    final response = await _client.get(
      '/purchase-orders/$id/pending_inspections/',
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> cancel(int id) async {
    final response = await _client.post('/purchase-orders/$id/cancel/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> getLowStockMaterials() async {
    final response = await _client.get('/purchase-orders/low_stock_materials/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> createFromWorkOrder(int workOrderId) async {
    final response = await _client.post(
      '/purchase-orders/create_from_work_order/',
      data: {'work_order_id': workOrderId},
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> getProcurementSummary({
    String? workOrderStatus,
  }) async {
    final params = <String, dynamic>{};
    if (workOrderStatus != null) params['work_order_status'] = workOrderStatus;
    final response = await _client.get(
      '/purchase-orders/procurement_summary/',
      queryParameters: params,
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> getDelayWarnings({String? severity}) async {
    final params = <String, dynamic>{};
    if (severity != null) params['severity'] = severity;
    final response = await _client.get(
      '/purchase-orders/delay_warnings/',
      queryParameters: params,
    );
    return _mapFromResponse(response.data);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
