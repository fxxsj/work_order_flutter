import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock_repository.dart';

class ProductStockViewModel extends PaginatedViewModel<ProductStock> {
  ProductStockViewModel(this._repository);

  final ProductStockRepository _repository;
  String _statusFilter = '';

  List<ProductStock> get stocks => items;
  String get statusFilter => _statusFilter;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadStocks({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  Future<void> setStatusFilter(String value) async {
    _statusFilter = value;
    await loadStocks(resetPage: true);
  }

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
      status: _statusFilter.isEmpty ? null : _statusFilter,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
