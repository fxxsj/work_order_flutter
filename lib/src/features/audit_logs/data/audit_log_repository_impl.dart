import 'package:work_order_app/src/features/audit_logs/data/audit_log_api_service.dart';
import 'package:work_order_app/src/features/audit_logs/data/audit_log_dto.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log_repository.dart';

class AuditLogRepositoryImpl implements AuditLogRepository {
  AuditLogRepositoryImpl(this._apiService);

  final AuditLogApiService _apiService;

  @override
  Future<AuditLogPageDto> getAuditLogs({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchAuditLogs(page: page, pageSize: pageSize, search: search);
  }
}
