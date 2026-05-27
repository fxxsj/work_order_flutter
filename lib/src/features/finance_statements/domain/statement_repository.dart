import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement.dart';

abstract class StatementRepository {
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
  });

  Future<Map<String, dynamic>> confirm(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> generate({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params});
}
