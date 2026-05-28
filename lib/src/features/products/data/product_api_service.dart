import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/image_upload_response.dart';
import 'package:work_order_app/src/core/utils/import_export_util.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/products/data/product_dto.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

class ProductApiService {
  ProductApiService(this._client);

  final ApiClient _client;

  /// 获取导入/导出服务
  ImportExportService get importExportService => ImportExportService(_client);

  Future<List<ProductOption>> fetchProducts({
    int pageSize = 100,
    bool? isActive,
  }) async {
    final params = <String, dynamic>{'page_size': pageSize};
    if (isActive != null) {
      params['is_active'] = isActive;
    }
    final response = await _client.get('/products/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      return _parseProductOptions(payload['results']);
    }
    if (payload is List) {
      return _parseProductOptions(payload);
    }
    throw _unexpectedPayload('产品选项列表', payload);
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Future<ProductPageDto> fetchProductPage({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
    String? ordering,
  }) async {
    final params = <String, dynamic>{'page': page, 'page_size': pageSize};
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    if (isActive != null) {
      params['is_active'] = isActive;
    }
    if (ordering != null && ordering.isNotEmpty) {
      params['ordering'] = ordering;
    }

    final response = await _client.get('/products/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final pageData = PageData.fromPayload(
        payload: payload,
        page: page,
        pageSize: pageSize,
        results: _parseProductDtoList(payload['results']),
      );
      return ProductPageDto(
        items: pageData.items,
        total: pageData.total,
        page: pageData.page,
        pageSize: pageData.pageSize,
      );
    }
    if (payload is List) {
      final list = _parseProductDtoList(payload);
      return ProductPageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    throw _unexpectedPayload('产品分页列表', payload);
  }

  Future<ProductDto> createProduct(ProductDto dto) async {
    final response = await _client.post('/products/', data: dto.toPayload());
    return ProductDto.fromJson(_requireMap('创建产品', response.data));
  }

  Future<ProductDto> fetchProduct(int id) async {
    final response = await _client.get('/products/$id/');
    return ProductDto.fromJson(_requireMap('产品详情', response.data));
  }

  Future<ProductDto> updateProduct(ProductDto dto) async {
    final response = await _client.put(
      '/products/${dto.id}/',
      data: dto.toPayload(),
    );
    return ProductDto.fromJson(_requireMap('更新产品', response.data));
  }

  Future<void> deleteProduct(int id) async {
    await _client.delete('/products/$id/');
  }

  Future<ProductImage> uploadImage(
    int productId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  }) async {
    final formData = FormData.fromMap({
      'image': imageFile,
      'sort_order': sortOrder,
      if (description != null && description.isNotEmpty)
        'description': description,
    });
    final response = await _client.requestRaw(
      '/products/$productId/upload_image/',
      method: 'post',
      data: formData,
    );
    final map = requireImageUploadResponseData(
      label: '上传产品图片',
      data: response.data,
    );
    return ProductImage(
      id: toInt(map['id']) ?? 0,
      imageUrl: map['image']?.toString() ?? '',
      sortOrder: toInt(map['sort_order']) ?? 0,
      description: toStringOrNull(map['description']),
      createdAt: toDateTime(map['created_at']),
    );
  }

  Future<void> deleteImage(int productId, int imageId) async {
    await _client.delete('/products/$productId/images/$imageId/');
  }

  List<ProductOption> _parseProductOptions(dynamic payload) {
    if (payload is! List) {
      return const <ProductOption>[];
    }
    final items = <ProductOption>[];
    for (final item in payload.whereType<Map>()) {
      final map = Map<String, dynamic>.from(item);
      items.add(
        ProductOption(
          id: toInt(map['id']) ?? 0,
          name: map['name']?.toString() ?? '',
          code: map['code']?.toString() ?? '',
          specification: toStringOrNull(map['specification']),
          unit: toStringOrNull(map['unit']),
          unitPrice: _toDouble(map['unit_price']),
        ),
      );
    }
    return items.where((item) => item.id > 0).toList();
  }

  List<ProductDto> _parseProductDtoList(dynamic payload) {
    if (payload is! List) {
      return const <ProductDto>[];
    }
    return payload
        .whereType<Map>()
        .map((item) => ProductDto.fromJson(Map<String, dynamic>.from(item)))
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
    return ApiException(message: '$label 响应格式异常', data: data);
  }
}
