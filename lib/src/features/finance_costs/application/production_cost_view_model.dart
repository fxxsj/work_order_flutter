import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/finance_costs/domain/production_cost.dart';
import 'package:work_order_app/src/features/finance_costs/domain/production_cost_repository.dart';

class ProductionCostViewModel extends PaginatedViewModel<ProductionCost> {
  ProductionCostViewModel(this._repository);

  final ProductionCostRepository _repository;

  List<ProductionCost> get costs => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadCosts({bool resetPage = false}) => loadItems(resetPage: resetPage);

  @override
  Future<PageData<ProductionCost>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getCosts(
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
