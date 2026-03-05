import 'package:work_order_app/src/features/finance_costs/data/production_cost_api_service.dart';
import 'package:work_order_app/src/features/finance_costs/data/production_cost_dto.dart';
import 'package:work_order_app/src/features/finance_costs/domain/production_cost_repository.dart';

class ProductionCostRepositoryImpl implements ProductionCostRepository {
  ProductionCostRepositoryImpl(this._apiService);

  final ProductionCostApiService _apiService;

  @override
  Future<ProductionCostPageDto> getCosts({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchCosts(page: page, pageSize: pageSize, search: search);
  }
}
