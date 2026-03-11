import 'package:work_order_app/src/features/finance_costs/data/production_cost_dto.dart';

abstract class ProductionCostRepository {
  Future<ProductionCostPageDto> getCosts({
    int page = 1,
    int pageSize = 20,
    String? search,
  });

  Future<Map<String, dynamic>> calculateMaterial(int id);

  Future<Map<String, dynamic>> calculateTotal(int id);

  Future<Map<String, dynamic>> getStats({Map<String, dynamic>? params});
}
