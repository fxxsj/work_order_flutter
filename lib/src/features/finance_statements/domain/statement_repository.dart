import 'package:work_order_app/src/features/finance_statements/data/statement_dto.dart';

abstract class StatementRepository {
  Future<StatementPageDto> getStatements({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
