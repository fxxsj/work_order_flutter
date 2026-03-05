import 'package:work_order_app/src/features/finance_statements/data/statement_api_service.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_dto.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement_repository.dart';

class StatementRepositoryImpl implements StatementRepository {
  StatementRepositoryImpl(this._apiService);

  final StatementApiService _apiService;

  @override
  Future<StatementPageDto> getStatements({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchStatements(page: page, pageSize: pageSize, search: search);
  }
}
