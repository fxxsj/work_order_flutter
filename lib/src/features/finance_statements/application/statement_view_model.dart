import 'dart:async';

import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement_repository.dart';

class StatementViewModel extends PaginatedViewModel<Statement> {
  StatementViewModel(this._repository);

  final StatementRepository _repository;
  Map<String, dynamic> _summary = const {};
  String _statementTypeFilter = '';
  String _statusFilter = '';
  String _todoFilter = '';
  String _ordering = '-period';
  String _customerFilter = '';
  String _supplierFilter = '';
  String _periodStartFilter = '';
  String _periodEndFilter = '';
  int _summaryRequestToken = 0;

  List<Statement> get statements => items;
  Map<String, dynamic> get summary => _summary;
  String get statementTypeFilter => _statementTypeFilter;
  String get statusFilter => _statusFilter;
  String get todoFilter => _todoFilter;
  String get ordering => _ordering;
  String get customerFilter => _customerFilter;
  String get supplierFilter => _supplierFilter;
  String get periodStartFilter => _periodStartFilter;
  String get periodEndFilter => _periodEndFilter;

  Future<void> initialize() => loadStatements(resetPage: true);

  Future<void> loadStatements({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    unawaited(_loadSummary());
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? statementType,
    String? status,
    String? todo,
    String? customer,
    String? supplier,
    String? periodStart,
    String? periodEnd,
    String? ordering,
  }) async {
    setSearchText(search?.trim() ?? '');
    _statementTypeFilter = statementType?.trim() ?? '';
    _statusFilter = status?.trim() ?? '';
    _todoFilter = todo?.trim() ?? '';
    _customerFilter = customer?.trim() ?? '';
    _supplierFilter = supplier?.trim() ?? '';
    _periodStartFilter = periodStart?.trim() ?? '';
    _periodEndFilter = periodEnd?.trim() ?? '';
    _ordering = ordering?.trim().isNotEmpty == true
        ? ordering!.trim()
        : '-period';
    await loadStatements(resetPage: true);
  }

  Future<void> setStatementTypeFilter(String value) async {
    _statementTypeFilter = value.trim();
    await loadStatements(resetPage: true);
  }

  Future<void> setStatusFilter(String value) async {
    _statusFilter = value.trim();
    await loadStatements(resetPage: true);
  }

  Future<void> setTodoFilter(String value) async {
    _todoFilter = value.trim();
    await loadStatements(resetPage: true);
  }

  Future<void> setOrdering(String value) async {
    final next = value.trim().isEmpty ? '-period' : value.trim();
    if (_ordering == next) return;
    _ordering = next;
    await loadStatements(resetPage: true);
  }

  Future<void> _loadSummary() async {
    final token = ++_summaryRequestToken;
    try {
      final params = <String, dynamic>{};
      final trimmedSearch = searchText.trim();
      if (trimmedSearch.isNotEmpty) params['search'] = trimmedSearch;
      if (_statementTypeFilter.isNotEmpty) {
        params['statement_type'] = _statementTypeFilter;
      }
      if (_statusFilter.isNotEmpty) params['status'] = _statusFilter;
      if (_todoFilter.isNotEmpty) params['todo'] = _todoFilter;
      if (_customerFilter.isNotEmpty) params['customer'] = _customerFilter;
      if (_supplierFilter.isNotEmpty) params['supplier'] = _supplierFilter;
      if (_periodStartFilter.isNotEmpty) {
        params['period_start'] = _periodStartFilter;
      }
      if (_periodEndFilter.isNotEmpty) {
        params['period_end'] = _periodEndFilter;
      }
      _summary = await _repository.getSummary(
        params: params.isEmpty ? null : params,
      );
      if (token != _summaryRequestToken) return;
      safeNotify();
    } catch (_) {
      if (token != _summaryRequestToken) return;
      _summary = const {};
      safeNotify();
      // Keep the list usable even if the summary endpoint fails.
    }
  }

  @override
  Future<PageData<Statement>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getStatements(
      page: page,
      pageSize: pageSize,
      search: search,
      statementType: _statementTypeFilter.isEmpty ? null : _statementTypeFilter,
      status: _statusFilter.isEmpty ? null : _statusFilter,
      todo: _todoFilter.isEmpty ? null : _todoFilter,
      customer: _customerFilter.isEmpty ? null : _customerFilter,
      supplier: _supplierFilter.isEmpty ? null : _supplierFilter,
      periodStart: _periodStartFilter.isEmpty ? null : _periodStartFilter,
      periodEnd: _periodEndFilter.isEmpty ? null : _periodEndFilter,
      ordering: _ordering,
    );
    return result;
  }
}
