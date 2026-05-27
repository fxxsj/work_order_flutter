import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_dto.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';

class FoilingPlateApiService {
  FoilingPlateApiService(this._client);

  final ApiClient _client;

  Future<FoilingPlatePageDto> fetchFoilingPlates({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? confirmed,
    String? foilingType,
    String? ordering,
  }) async {
    final params = <String, dynamic>{'page': page, 'page_size': pageSize};
    if (confirmed != null) {
      params['confirmed'] = confirmed;
    }
    final trimmedFoilingType = foilingType?.trim();
    if (trimmedFoilingType != null && trimmedFoilingType.isNotEmpty) {
      params['foiling_type'] = trimmedFoilingType;
    }
    final trimmedOrdering = ordering?.trim();
    if (trimmedOrdering != null && trimmedOrdering.isNotEmpty) {
      params['ordering'] = trimmedOrdering;
    }
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    final response = await _client.get(
      '/foiling-plates/',
      queryParameters: params,
    );
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
                .whereType<Map>()
                .map(
                  (item) =>
                      FoilingPlateDto.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : <FoilingPlateDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return FoilingPlatePageDto(
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
            (item) => FoilingPlateDto.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
      return FoilingPlatePageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    return const FoilingPlatePageDto(
      items: [],
      total: 0,
      page: 1,
      pageSize: 20,
    );
  }

  Future<FoilingPlateDto> createFoilingPlate(FoilingPlateDto dto) async {
    final response = await _client.post(
      '/foiling-plates/',
      data: dto.toPayload(),
    );
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return FoilingPlateDto.fromJson(map);
  }

  Future<FoilingPlateDto> updateFoilingPlate(FoilingPlateDto dto) async {
    final response = await _client.put(
      '/foiling-plates/${dto.id}/',
      data: dto.toPayload(),
    );
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return FoilingPlateDto.fromJson(map);
  }

  Future<FoilingPlateDto> fetchFoilingPlate(int id) async {
    final response = await _client.get('/foiling-plates/$id/');
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return FoilingPlateDto.fromJson(map);
  }

  Future<void> deleteFoilingPlate(int id) async {
    await _client.delete('/foiling-plates/$id/');
  }

  Future<void> confirmFoilingPlate(int id) async {
    await _client.post('/foiling-plates/$id/confirm/');
  }

  Future<FoilingPlateImage> uploadImage(
    int plateId,
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
      '/foiling-plates/$plateId/upload_image/',
      method: 'post',
      data: formData,
    );
    final body = response.data;
    final map = body is Map
        ? (body['data'] is Map
              ? Map<String, dynamic>.from(body['data'])
              : Map<String, dynamic>.from(body))
        : <String, dynamic>{};
    return _parseFoilingPlateImage(map);
  }

  Future<void> deleteImage(int plateId, int imageId) async {
    await _client.delete('/foiling-plates/$plateId/images/$imageId/');
  }

  FoilingPlateImage _parseFoilingPlateImage(Map<String, dynamic> json) {
    return FoilingPlateImage(
      id: toInt(json['id']) ?? 0,
      imageUrl: json['image']?.toString() ?? '',
      sortOrder: toInt(json['sort_order']) ?? 0,
      description: toStringOrNull(json['description']),
      createdAt: toDateTime(json['created_at']),
    );
  }
}
