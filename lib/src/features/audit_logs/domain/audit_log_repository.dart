import 'package:work_order_app/src/features/audit_logs/data/audit_log_dto.dart';

abstract class AuditLogRepository {
  Future<AuditLogPageDto> getAuditLogs({
    int page = 1,
    int pageSize = 20,
    String? search,
  });

  Future<Map<String, dynamic>> getStatistics({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> getDiff(int id);

  Future<Map<String, dynamic>> exportLogs(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> getExportList({Map<String, dynamic>? params});

  Future<dynamic> downloadExport(int id);
}
