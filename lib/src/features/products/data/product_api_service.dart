import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/products/data/product_dto.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

class ProductApiService {
  ProductApiService(this._client);

  final ApiClient _client;

  Future<List<ProductOption>> fetchProducts({
    int pageSize = 100,
    bool? isActive,
  }) async {
    final params = <String, dynamic>{
      'page_size': pageSize,
    };
    if (isActive != null) {
      params['is_active'] = isActive;
    }
    final response = await _client.get('/products/', queryParameters: params);
    final payload = response.data;
    final items = <ProductOption>[];
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      if (results is List) {
        for (final item in results) {
          if (item is Map) {
            final map = Map<String, dynamic>.from(item);
            items.add(
              ProductOption(
                id: toInt(map['id']) ?? 0,
                name: map['name']?.toString() ?? '',
                code: map['code']?.toString() ?? '',
              ),
            );
          }
        }
      }
      return items.where((item) => item.id > 0).toList();
    }
    if (payload is List) {
      for (final item in payload) {
        if (item is Map) {
          final map = Map<String, dynamic>.from(item);
          items.add(
            ProductOption(
              id: toInt(map['id']) ?? 0,
              name: map['name']?.toString() ?? '',
              code: map['code']?.toString() ?? '',
            ),
          );
        }
      }
    }
    return items.where((item) => item.id > 0).toList();
  }

  Future<ProductPageDto> fetchProductPage({
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

    final response = await _client.get('/products/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => ProductDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <ProductDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return ProductPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => ProductDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return ProductPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const ProductPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }
}
