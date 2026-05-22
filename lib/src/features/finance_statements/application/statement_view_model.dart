import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement_repository.dart';

class StatementViewModel extends PaginatedViewModel<Statement> {
  StatementViewModel(this._repository);

  final StatementRepository _repository;
  Map<String, dynamic> _summary = const {};
  String _statusFilter = '';
  String _todoFilter = '';

  List<Statement> get statements => items;
  Map<String, dynamic> get summary => _summary;
  String get statusFilter => _statusFilter;
  String get todoFilter => _todoFilter;

  Future<void> initialize() => loadStatements(resetPage: true);

  Future<void> loadStatements({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    await _loadSummary();
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? status,
    String? todo,
  }) async {
    setSearchText(search?.trim() ?? '');
    _statusFilter = status?.trim() ?? '';
    _todoFilter = todo?.trim() ?? '';
    await loadStatements(resetPage: true);
  }

  Future<void> _loadSummary() async {
    try {
      _summary = await _repository.getSummary();
      safeNotify();
    } catch (_) {
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
      status: _statusFilter.isEmpty ? null : _statusFilter,
      todo: _todoFilter.isEmpty ? null : _todoFilter,
    );
    return result;
  }
}
