import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_dto.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';

class EmbossingPlateApiService {
  EmbossingPlateApiService(this._client);

  final ApiClient _client;

  Future<EmbossingPlatePageDto> fetchEmbossingPlates({
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
    final response = await _client.get('/embossing-plates/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => EmbossingPlateDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <EmbossingPlateDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return EmbossingPlatePageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => EmbossingPlateDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return EmbossingPlatePageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const EmbossingPlatePageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<EmbossingPlateDto> createEmbossingPlate(EmbossingPlateDto dto) async {
    final response = await _client.post('/embossing-plates/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return EmbossingPlateDto.fromJson(map);
  }

  Future<EmbossingPlateDto> updateEmbossingPlate(EmbossingPlateDto dto) async {
    final response = await _client.put('/embossing-plates/${dto.id}/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return EmbossingPlateDto.fromJson(map);
  }

  Future<EmbossingPlateDto> fetchEmbossingPlate(int id) async {
    final response = await _client.get('/embossing-plates/$id/');
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return EmbossingPlateDto.fromJson(map);
  }

  Future<void> deleteEmbossingPlate(int id) async {
    await _client.delete('/embossing-plates/$id/');
  }

  Future<void> confirmEmbossingPlate(int id) async {
    await _client.post('/embossing-plates/$id/confirm/');
  }

  Future<EmbossingPlateImage> uploadImage(int plateId, MultipartFile imageFile, {int sortOrder = 0, String? description}) async {
    final formData = FormData.fromMap({
      'image': imageFile,
      'sort_order': sortOrder,
      if (description != null && description.isNotEmpty) 'description': description,
    });
    final response = await _client.requestRaw(
      '/embossing-plates/$plateId/upload_image/',
      method: 'post',
      data: formData,
    );
    final body = response.data;
    final map = body is Map
        ? (body['data'] is Map ? Map<String, dynamic>.from(body['data']) : Map<String, dynamic>.from(body))
        : <String, dynamic>{};
    return _parseEmbossingPlateImage(map);
  }

  Future<void> deleteImage(int plateId, int imageId) async {
    await _client.delete('/embossing-plates/$plateId/images/$imageId/');
  }

  EmbossingPlateImage _parseEmbossingPlateImage(Map<String, dynamic> json) {
    return EmbossingPlateImage(
      id: toInt(json['id']) ?? 0,
      imageUrl: json['image']?.toString() ?? '',
      sortOrder: toInt(json['sort_order']) ?? 0,
      description: toStringOrNull(json['description']),
      createdAt: toDateTime(json['created_at']),
    );
  }
}
