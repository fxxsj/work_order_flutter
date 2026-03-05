import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement_repository.dart';

class StatementViewModel extends PaginatedViewModel<Statement> {
  StatementViewModel(this._repository);

  final StatementRepository _repository;

  List<Statement> get statements => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadStatements({bool resetPage = false}) => loadItems(resetPage: resetPage);

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
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
