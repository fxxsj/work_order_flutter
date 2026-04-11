import 'package:dio/dio.dart';
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
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    final response = await _client.get('/artworks/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => ArtworkDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <ArtworkDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return ArtworkPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => ArtworkDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return ArtworkPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const ArtworkPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<ArtworkDto> createArtwork(ArtworkDto dto) async {
    final response = await _client.post('/artworks/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ArtworkDto.fromJson(map);
  }

  Future<ArtworkDto> updateArtwork(ArtworkDto dto) async {
    final response = await _client.put('/artworks/${dto.id}/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ArtworkDto.fromJson(map);
  }

  Future<ArtworkDto> fetchArtwork(int id) async {
    final response = await _client.get('/artworks/$id/');
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ArtworkDto.fromJson(map);
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
  Future<ArtworkImage> uploadImage(int artworkId, MultipartFile imageFile, {int sortOrder = 0, String? description}) async {
    final formData = FormData.fromMap({
      'image': imageFile,
      'sort_order': sortOrder,
      if (description != null && description.isNotEmpty) 'description': description,
    });
    final response = await _client.post('/artworks/$artworkId/upload_image/', data: formData);
    final payload = response.data;
    // ApiResponse.data 已经是解包后的数据，但后端可能嵌套了 data 字段
    final map = payload is Map
        ? (payload['data'] is Map ? Map<String, dynamic>.from(payload['data']) : Map<String, dynamic>.from(payload))
        : <String, dynamic>{};
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
}
