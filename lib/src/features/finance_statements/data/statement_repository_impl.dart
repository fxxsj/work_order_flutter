import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_api_service.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_support_service.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement_options_data.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement_repository.dart';

class StatementRepositoryImpl implements StatementRepository {
  StatementRepositoryImpl(this._apiService, this._supportService);

  final StatementApiService _apiService;
  final StatementSupportService _supportService;

  @override
  Future<PageData<Statement>> getStatements({
    int page = 1,
    int pageSize = 20,
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
    final result = await _apiService.fetchStatements(
      page: page,
      pageSize: pageSize,
      search: search,
      statementType: statementType,
      status: status,
      todo: todo,
      customer: customer,
      supplier: supplier,
      periodStart: periodStart,
      periodEnd: periodEnd,
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
  Future<Map<String, dynamic>> confirm(int id, Map<String, dynamic> payload) {
    return _apiService.confirm(id, payload);
  }

  @override
  Future<Map<String, dynamic>> generate({Map<String, dynamic>? params}) {
    return _apiService.generate(params: params);
  }

  @override
  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params}) {
    return _apiService.fetchSummary(params: params);
  }

  @override
  Future<StatementOptionsData> loadOptions() {
    return _supportService.loadOptions();
  }

  @override
  Future<void> createStatement(Map<String, dynamic> payload) {
    return _supportService.createStatement(payload);
  }

  @override
  Future<void> confirmStatement(
    int statementId, {
    required bool confirmed,
    required String notes,
  }) {
    return _supportService.confirmStatement(
      statementId,
      confirmed: confirmed,
      notes: notes,
    );
  }
}
