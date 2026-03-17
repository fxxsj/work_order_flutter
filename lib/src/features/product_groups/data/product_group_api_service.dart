import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_dto.dart';

class ProductGroupApiService {
  ProductGroupApiService(this._client);

  final ApiClient _client;

  Future<ProductGroupPageDto> fetchProductGroups({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (isActive != null) {
      params['is_active'] = isActive;
    }
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }

    final response = await _client.get('/product-groups/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => ProductGroupDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <ProductGroupDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return ProductGroupPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => ProductGroupDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return ProductGroupPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const ProductGroupPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<ProductGroupDto> createProductGroup(ProductGroupDto dto) async {
    final response = await _client.post('/product-groups/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ProductGroupDto.fromJson(map);
  }

  Future<ProductGroupDto> updateProductGroup(ProductGroupDto dto) async {
    final response = await _client.put('/product-groups/${dto.id}/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ProductGroupDto.fromJson(map);
  }

  Future<void> deleteProductGroup(int id) async {
    await _client.delete('/product-groups/$id/');
  }
}
