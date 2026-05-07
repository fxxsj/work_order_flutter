import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
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

    final response =
        await _client.get('/product-groups/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final pageData = PageData.fromPayload(
        payload: payload,
        page: page,
        pageSize: pageSize,
        results: _parseProductGroupList(payload['results']),
      );
      return ProductGroupPageDto(
        items: pageData.items,
        total: pageData.total,
        page: pageData.page,
        pageSize: pageData.pageSize,
      );
    }
    if (payload is List) {
      final list = _parseProductGroupList(payload);
      return ProductGroupPageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    throw _unexpectedPayload('产品组分页列表', payload);
  }

  Future<ProductGroupDto> createProductGroup(ProductGroupDto dto) async {
    final response =
        await _client.post('/product-groups/', data: dto.toPayload());
    return ProductGroupDto.fromJson(_requireMap('创建产品组', response.data));
  }

  Future<ProductGroupDto> updateProductGroup(ProductGroupDto dto) async {
    final response =
        await _client.put('/product-groups/${dto.id}/', data: dto.toPayload());
    return ProductGroupDto.fromJson(_requireMap('更新产品组', response.data));
  }

  Future<void> deleteProductGroup(int id) async {
    await _client.delete('/product-groups/$id/');
  }

  List<ProductGroupDto> _parseProductGroupList(dynamic payload) {
    if (payload is! List) {
      return const <ProductGroupDto>[];
    }
    return payload
        .whereType<Map>()
        .map(
          (item) => ProductGroupDto.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
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
    return ApiException(
      message: '$label 响应格式异常',
      data: data,
    );
  }
}
