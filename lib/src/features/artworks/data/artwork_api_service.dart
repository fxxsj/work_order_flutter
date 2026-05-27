import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_dto.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';

class ArtworkApiService {
  ArtworkApiService(this._client);

  final ApiClient _client;

  Future<ArtworkPageDto> fetchArtworks({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? confirmed,
    String? ordering,
  }) async {
    final params = <String, dynamic>{'page': page, 'page_size': pageSize};
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    if (confirmed != null) {
      params['confirmed'] = confirmed.toString();
    }
    if (ordering != null && ordering.trim().isNotEmpty) {
      params['ordering'] = ordering.trim();
    }
    final response = await _client.get('/artworks/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final pageData = PageData.fromPayload(
        payload: payload,
        page: page,
        pageSize: pageSize,
        results: _parseArtworkList(payload['results']),
      );
      return ArtworkPageDto(
        items: pageData.items,
        total: pageData.total,
        page: pageData.page,
        pageSize: pageData.pageSize,
      );
    }
    if (payload is List) {
      final list = _parseArtworkList(payload);
      return ArtworkPageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    throw _unexpectedPayload('图稿分页列表', payload);
  }

  Future<ArtworkDto> createArtwork(ArtworkDto dto) async {
    final response = await _client.post('/artworks/', data: dto.toPayload());
    return ArtworkDto.fromJson(_requireMap('创建图稿', response.data));
  }

  Future<ArtworkDto> updateArtwork(ArtworkDto dto) async {
    final response = await _client.put(
      '/artworks/${dto.id}/',
      data: dto.toPayload(),
    );
    return ArtworkDto.fromJson(_requireMap('更新图稿', response.data));
  }

  Future<ArtworkDto> fetchArtwork(int id) async {
    final response = await _client.get('/artworks/$id/');
    return ArtworkDto.fromJson(_requireMap('图稿详情', response.data));
  }

  Future<void> deleteArtwork(int id) async {
    await _client.delete('/artworks/$id/');
  }

  Future<void> confirmArtwork(int id) async {
    await _client.post('/artworks/$id/confirm/');
  }

  Future<void> createVersion(int id) async {
    await _client.post('/artworks/$id/create_version/');
  }

  /// 上传图片到指定图稿
  /// 使用 requestRaw 发送 FormData，避免 HttpClient.post 的 contentType 强制覆盖
  Future<ArtworkImage> uploadImage(
    int artworkId,
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
      '/artworks/$artworkId/upload_image/',
      method: 'post',
      data: formData,
    );
    final body = _requireMap('上传图稿图片', response.data);
    final map = body['data'] is Map
        ? Map<String, dynamic>.from(body['data'] as Map)
        : body;
    return _parseArtworkImage(map);
  }

  /// 删除图稿指定图片
  Future<void> deleteImage(int artworkId, int imageId) async {
    await _client.delete('/artworks/$artworkId/images/$imageId/');
  }

  ArtworkImage _parseArtworkImage(Map<String, dynamic> json) {
    return ArtworkImage(
      id: toInt(json['id']) ?? 0,
      imageUrl: json['image']?.toString() ?? '',
      sortOrder: toInt(json['sort_order']) ?? 0,
      description: toStringOrNull(json['description']),
      createdAt: toDateTime(json['created_at']),
    );
  }

  List<ArtworkDto> _parseArtworkList(dynamic payload) {
    if (payload is! List) {
      return const <ArtworkDto>[];
    }
    return payload
        .whereType<Map>()
        .map((item) => ArtworkDto.fromJson(Map<String, dynamic>.from(item)))
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
