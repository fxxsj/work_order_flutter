import 'package:work_order_app/src/features/finance_statements/data/statement_dto.dart';

abstract class StatementRepository {
  Future<StatementPageDto> getStatements({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? todo,
  });

  Future<Map<String, dynamic>> confirm(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> generate({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> getSummary();
}
