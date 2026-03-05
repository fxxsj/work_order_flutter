import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_dto.dart';

class PurchaseOrderApiService {
  PurchaseOrderApiService(this._client);

  final ApiClient _client;

  Future<PurchaseOrderPageDto> fetchPurchaseOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }

    final response = await _client.get('/purchase-orders/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => PurchaseOrderDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <PurchaseOrderDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return PurchaseOrderPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => PurchaseOrderDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return PurchaseOrderPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const PurchaseOrderPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }
}
