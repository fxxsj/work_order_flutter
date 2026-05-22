import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/finance_costs/domain/production_cost.dart';

abstract class ProductionCostRepository {
  Future<PageData<ProductionCost>> getCosts({
    int page = 1,
    int pageSize = 20,
    String? search,
  });

  Future<Map<String, dynamic>> calculateMaterial(int id);

  Future<Map<String, dynamic>> calculateTotal(int id);

  Future<Map<String, dynamic>> getStats({Map<String, dynamic>? params});
}
