import 'package:work_order_app/src/features/audit_logs/data/audit_log_dto.dart';

abstract class AuditLogRepository {
  Future<AuditLogPageDto> getAuditLogs({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
