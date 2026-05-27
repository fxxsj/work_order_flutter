import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log.dart';

abstract class AuditLogRepository {
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
  });

  Future<Map<String, dynamic>> getStatistics({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> getDiff(String id);

  Future<Map<String, dynamic>> exportLogs(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> getExportList({Map<String, dynamic>? params});

  Future<dynamic> downloadExport(int id);
}
