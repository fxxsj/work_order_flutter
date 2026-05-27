import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/dies/data/die_dto.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';

class DieApiService {
  DieApiService(this._client);

  final ApiClient _client;

  Future<DiePageDto> fetchDies({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? confirmed,
    String? dieType,
    String? ordering,
  }) async {
    final params = <String, dynamic>{'page': page, 'page_size': pageSize};
    if (confirmed != null) {
      params['confirmed'] = confirmed;
    }
    final trimmedDieType = dieType?.trim();
    if (trimmedDieType != null && trimmedDieType.isNotEmpty) {
      params['die_type'] = trimmedDieType;
    }
    final trimmedOrdering = ordering?.trim();
    if (trimmedOrdering != null && trimmedOrdering.isNotEmpty) {
      params['ordering'] = trimmedOrdering;
    }
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    final response = await _client.get('/dies/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
                .whereType<Map>()
                .map((item) => DieDto.fromJson(Map<String, dynamic>.from(item)))
                .toList()
          : <DieDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return DiePageDto(
        items: list,
        total: total,
        page: page,
        pageSize: pageSize,
      );
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => DieDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return DiePageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    return const DiePageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<DieDto> createDie(DieDto dto) async {
    final response = await _client.post('/dies/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return DieDto.fromJson(map);
  }

  Future<DieDto> updateDie(DieDto dto) async {
    final response = await _client.put(
      '/dies/${dto.id}/',
      data: dto.toPayload(),
    );
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return DieDto.fromJson(map);
  }

  Future<DieDto> fetchDie(int id) async {
    final response = await _client.get('/dies/$id/');
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return DieDto.fromJson(map);
  }

  Future<void> deleteDie(int id) async {
    await _client.delete('/dies/$id/');
  }

  Future<void> confirmDie(int id) async {
    await _client.post('/dies/$id/confirm/');
  }

  /// 上传图片到指定刀模
  /// 使用 requestRaw 发送 FormData，避免 HttpClient.post 的 contentType 强制覆盖
  Future<DieImage> uploadImage(
    int dieId,
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
      '/dies/$dieId/upload_image/',
      method: 'post',
      data: formData,
    );
    final body = response.data;
    final map = body is Map
        ? (body['data'] is Map
              ? Map<String, dynamic>.from(body['data'])
              : Map<String, dynamic>.from(body))
        : <String, dynamic>{};
    return _parseDieImage(map);
  }

  /// 删除刀模指定图片
  Future<void> deleteImage(int dieId, int imageId) async {
    await _client.delete('/dies/$dieId/images/$imageId/');
  }

  DieImage _parseDieImage(Map<String, dynamic> json) {
    return DieImage(
      id: toInt(json['id']) ?? 0,
      imageUrl: json['image']?.toString() ?? '',
      sortOrder: toInt(json['sort_order']) ?? 0,
      description: toStringOrNull(json['description']),
      createdAt: toDateTime(json['created_at']),
    );
  }
}
