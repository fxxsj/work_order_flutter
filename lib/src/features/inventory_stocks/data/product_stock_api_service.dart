import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_dto.dart';

class ProductStockApiService {
  ProductStockApiService(this._client);

  final ApiClient _client;

  Future<ProductStockPageDto> fetchProductStocks({
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

    final response = await _client.get('/product-stocks/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => ProductStockDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <ProductStockDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return ProductStockPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => ProductStockDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return ProductStockPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const ProductStockPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<Map<String, dynamic>> fetchLowStock({Map<String, dynamic>? params}) async {
    final response = await _client.get('/product-stocks/low_stock/', queryParameters: params);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchExpired({Map<String, dynamic>? params}) async {
    final response = await _client.get('/product-stocks/expired/', queryParameters: params);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchExpiringSoon({Map<String, dynamic>? params}) async {
    final response = await _client.get('/product-stocks/expiring_soon/', queryParameters: params);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchSummary() async {
    final response = await _client.get('/product-stocks/summary/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> adjustStock(int id, Map<String, dynamic> payload) async {
    final response = await _client.post('/product-stocks/$id/adjust/', data: payload);
    return _mapFromResponse(response.data);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
