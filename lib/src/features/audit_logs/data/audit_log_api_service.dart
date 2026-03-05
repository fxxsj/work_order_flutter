import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/audit_logs/data/audit_log_dto.dart';

class AuditLogApiService {
  AuditLogApiService(this._client);

  final ApiClient _client;

  Future<AuditLogPageDto> fetchAuditLogs({
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

    final response = await _client.get('/audit-logs/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => AuditLogDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <AuditLogDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return AuditLogPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => AuditLogDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return AuditLogPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const AuditLogPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }
}
