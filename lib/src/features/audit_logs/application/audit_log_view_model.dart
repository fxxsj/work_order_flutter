import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log_repository.dart';

class AuditLogViewModel extends PaginatedViewModel<AuditLog> {
  AuditLogViewModel(this._repository);

  final AuditLogRepository _repository;

  List<AuditLog> get logs => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadLogs({bool resetPage = false}) => loadItems(resetPage: resetPage);

  @override
  Future<PageData<AuditLog>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getAuditLogs(
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
