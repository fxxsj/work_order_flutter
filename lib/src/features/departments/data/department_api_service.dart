import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
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

    final response =
        await _client.get('/departments/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final pageData = PageData.fromPayload(
        payload: payload,
        page: page,
        pageSize: pageSize,
        results: _parseDepartmentList(payload['results']),
      );
      return DepartmentPageDto(
        items: pageData.items,
        total: pageData.total,
        page: pageData.page,
        pageSize: pageData.pageSize,
      );
    }
    if (payload is List) {
      final list = _parseDepartmentList(payload);
      return DepartmentPageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    throw _unexpectedPayload('部门分页列表', payload);
  }

  Future<List<DepartmentDto>> fetchDepartmentTree() async {
    final response = await _client.get('/departments/tree/');
    return _listFromResponse(response.data);
  }

  Future<List<DepartmentDto>> fetchAllDepartments({bool? isActive}) async {
    final params = <String, dynamic>{};
    if (isActive != null) {
      params['is_active'] = isActive.toString();
    }
    final response = await _client.get('/departments/all/',
        queryParameters: params.isEmpty ? null : params);
    return _listFromResponse(response.data);
  }

  Future<DepartmentDto> createDepartment(DepartmentDto dto) async {
    final response = await _client.post('/departments/', data: dto.toPayload());
    return DepartmentDto.fromJson(_requireMap('创建部门', response.data));
  }

  Future<DepartmentDto> updateDepartment(DepartmentDto dto) async {
    final response =
        await _client.put('/departments/${dto.id}/', data: dto.toPayload());
    return DepartmentDto.fromJson(_requireMap('更新部门', response.data));
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
            .map((item) =>
                ProcessOptionDto.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    }
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map((item) =>
              ProcessOptionDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return [];
  }

  List<DepartmentDto> _listFromResponse(dynamic payload) {
    if (payload is List) {
      return _parseDepartmentList(payload);
    }
    if (payload is Map<String, dynamic>) {
      return _parseDepartmentList(payload['results']);
    }
    return const <DepartmentDto>[];
  }

  List<DepartmentDto> _parseDepartmentList(dynamic payload) {
    if (payload is! List) {
      return const <DepartmentDto>[];
    }
    return payload
        .whereType<Map>()
        .map((item) => DepartmentDto.fromJson(Map<String, dynamic>.from(item)))
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
