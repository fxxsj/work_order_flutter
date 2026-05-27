import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/processes/data/process_dto.dart';

class ProcessApiService {
  ProcessApiService(this._client);

  final ApiClient _client;

  Future<ProcessPageDto> fetchProcesses({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
    String? taskGenerationRule,
    String? ordering,
  }) async {
    final params = <String, dynamic>{'page': page, 'page_size': pageSize};
    if (isActive != null) {
      params['is_active'] = isActive;
    }
    final trimmedRule = taskGenerationRule?.trim();
    if (trimmedRule != null && trimmedRule.isNotEmpty) {
      params['task_generation_rule'] = trimmedRule;
    }
    final trimmedOrdering = ordering?.trim();
    if (trimmedOrdering != null && trimmedOrdering.isNotEmpty) {
      params['ordering'] = trimmedOrdering;
    }
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }

    final response = await _client.get('/processes/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final pageData = PageData.fromPayload(
        payload: payload,
        page: page,
        pageSize: pageSize,
        results: _parseProcessList(payload['results']),
      );
      return ProcessPageDto(
        items: pageData.items,
        total: pageData.total,
        page: pageData.page,
        pageSize: pageData.pageSize,
      );
    }
    if (payload is List) {
      final list = _parseProcessList(payload);
      return ProcessPageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    throw _unexpectedPayload('工序分页列表', payload);
  }

  Future<ProcessDto> createProcess(ProcessDto dto) async {
    final response = await _client.post('/processes/', data: dto.toPayload());
    return ProcessDto.fromJson(_requireMap('创建工序', response.data));
  }

  Future<ProcessDto> updateProcess(ProcessDto dto) async {
    final response = await _client.put(
      '/processes/${dto.id}/',
      data: dto.toPayload(),
    );
    return ProcessDto.fromJson(_requireMap('更新工序', response.data));
  }

  Future<void> deleteProcess(int id) async {
    await _client.delete('/processes/$id/');
  }

  List<ProcessDto> _parseProcessList(dynamic payload) {
    if (payload is! List) {
      return const <ProcessDto>[];
    }
    return payload
        .whereType<Map>()
        .map((item) => ProcessDto.fromJson(Map<String, dynamic>.from(item)))
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
