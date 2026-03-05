import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock_repository.dart';

class ProductStockViewModel extends PaginatedViewModel<ProductStock> {
  ProductStockViewModel(this._repository);

  final ProductStockRepository _repository;

  List<ProductStock> get stocks => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadStocks({bool resetPage = false}) => loadItems(resetPage: resetPage);

  @override
  Future<PageData<ProductStock>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getProductStocks(
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
