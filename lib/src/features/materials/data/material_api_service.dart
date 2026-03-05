import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';

class MaterialApiService {
  MaterialApiService(this._client);

  final ApiClient _client;

  Future<MaterialPageDto> fetchMaterials({
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

    final response = await _client.get('/materials/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => MaterialDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <MaterialDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return MaterialPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => MaterialDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return MaterialPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const MaterialPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }
}
