import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/audit_logs/data/audit_log_api_service.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log_repository.dart';

class AuditLogRepositoryImpl implements AuditLogRepository {
  AuditLogRepositoryImpl(this._apiService);

  final AuditLogApiService _apiService;

  @override
  Future<PageData<AuditLog>> getAuditLogs({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? actionType,
    String? model,
    String? username,
    String? objectId,
    String? ipAddress,
    String? requestMethod,
    String? startDate,
    String? endDate,
    String? ordering,
  }) async {
    final result = await _apiService.fetchAuditLogs(
      page: page,
      pageSize: pageSize,
      search: search,
      actionType: actionType,
      model: model,
      username: username,
      objectId: objectId,
      ipAddress: ipAddress,
      requestMethod: requestMethod,
      startDate: startDate,
      endDate: endDate,
      ordering: ordering,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }

  @override
  Future<Map<String, dynamic>> getStatistics({Map<String, dynamic>? params}) {
    return _apiService.fetchStatistics(params: params);
  }

  @override
  Future<Map<String, dynamic>> getDiff(String id) {
    return _apiService.fetchDiff(id);
  }

  @override
  Future<Map<String, dynamic>> exportLogs(Map<String, dynamic> payload) {
    return _apiService.exportLogs(payload);
  }

  @override
  Future<Map<String, dynamic>> getExportList({Map<String, dynamic>? params}) {
    return _apiService.fetchExportList(params: params);
  }

  @override
  Future<dynamic> downloadExport(int id) {
    return _apiService.downloadExport(id);
  }
}
