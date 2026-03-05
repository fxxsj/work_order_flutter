import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/dies/data/die_dto.dart';

class DieApiService {
  DieApiService(this._client);

  final ApiClient _client;

  Future<DiePageDto> fetchDies({
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
      return DiePageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => DieDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return DiePageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const DiePageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<DieDto> createDie(DieDto dto) async {
    final response = await _client.post('/dies/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return DieDto.fromJson(map);
  }

  Future<DieDto> updateDie(DieDto dto) async {
    final response = await _client.put('/dies/${dto.id}/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return DieDto.fromJson(map);
  }

  Future<void> deleteDie(int id) async {
    await _client.delete('/dies/$id/');
  }

  Future<void> confirmDie(int id) async {
    await _client.post('/dies/$id/confirm/');
  }
}
