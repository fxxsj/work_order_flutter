import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/departments/data/department_dto.dart';

class DepartmentApiService {
  DepartmentApiService(this._client);

  final ApiClient _client;

  Future<DepartmentPageDto> fetchDepartments({
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

    final response = await _client.get('/departments/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => DepartmentDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <DepartmentDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return DepartmentPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => DepartmentDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return DepartmentPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const DepartmentPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<DepartmentDto> createDepartment(DepartmentDto dto) async {
    final response = await _client.post('/departments/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return DepartmentDto.fromJson(map);
  }

  Future<DepartmentDto> updateDepartment(DepartmentDto dto) async {
    final response = await _client.put('/departments/${dto.id}/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return DepartmentDto.fromJson(map);
  }

  Future<void> deleteDepartment(int id) async {
    await _client.delete('/departments/$id/');
  }

  Future<List<ProcessOptionDto>> fetchProcesses() async {
    final response = await _client.get('/processes/', queryParameters: {
      'is_active': true,
      'page_size': 200,
    });
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      if (results is List) {
        return results
            .whereType<Map>()
            .map((item) => ProcessOptionDto.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    }
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map((item) => ProcessOptionDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return [];
  }
}
