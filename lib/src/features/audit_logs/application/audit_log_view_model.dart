import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log_repository.dart';

class AuditLogViewModel extends PaginatedViewModel<AuditLog> {
  AuditLogViewModel(this._repository);

  final AuditLogRepository _repository;
  String? _actionType;
  String? _model;
  String? _username;
  String? _objectId;
  String? _ipAddress;
  String? _requestMethod;
  String? _startDate;
  String? _endDate;
  String _ordering = '-created_at';

  List<AuditLog> get logs => items;
  String? get actionType => _actionType;
  String? get model => _model;
  String? get username => _username;
  String? get objectId => _objectId;
  String? get ipAddress => _ipAddress;
  String? get requestMethod => _requestMethod;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String get ordering => _ordering;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadLogs({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  void setFilters({
    String? actionType,
    String? model,
    String? username,
    String? objectId,
    String? ipAddress,
    String? requestMethod,
    String? startDate,
    String? endDate,
    String? ordering,
  }) {
    _actionType = _normalize(actionType);
    _model = _normalize(model);
    _username = _normalize(username);
    _objectId = _normalize(objectId);
    _ipAddress = _normalize(ipAddress);
    _requestMethod = _normalize(requestMethod);
    _startDate = _normalize(startDate);
    _endDate = _normalize(endDate);
    final nextOrdering = _normalize(ordering);
    _ordering = nextOrdering ?? '-created_at';
    loadItems(resetPage: true);
  }

  void resetFilters() {
    setSearchText('');
    _actionType = null;
    _model = null;
    _username = null;
    _objectId = null;
    _ipAddress = null;
    _requestMethod = null;
    _startDate = null;
    _endDate = null;
    _ordering = '-created_at';
    loadItems(resetPage: true);
  }

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
      actionType: _actionType,
      model: _model,
      username: _username,
      objectId: _objectId,
      ipAddress: _ipAddress,
      requestMethod: _requestMethod,
      startDate: _startDate,
      endDate: _endDate,
      ordering: _ordering,
    );
    return result;
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
