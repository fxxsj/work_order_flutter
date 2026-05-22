import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock_repository.dart';

class ProductStockViewModel extends PaginatedViewModel<ProductStock> {
  ProductStockViewModel(this._repository);

  final ProductStockRepository _repository;
  String _statusFilter = '';
  Map<String, dynamic> _summary = const {};
  int _summaryRequestToken = 0;

  List<ProductStock> get stocks => items;
  String get statusFilter => _statusFilter;
  Map<String, dynamic> get summary => _summary;

  Future<void> initialize() => loadStocks(resetPage: true);

  Future<void> loadStocks({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    await _loadSummary();
  }

  Future<void> setStatusFilter(String value) async {
    _statusFilter = value;
    await loadStocks(resetPage: true);
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? status,
  }) async {
    setSearchText(search?.trim() ?? '');
    _statusFilter = status?.trim() ?? '';
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
    return result;
  }

  Future<void> _loadSummary() async {
    final token = ++_summaryRequestToken;
    try {
      final params = <String, dynamic>{};
      final trimmedSearch = searchText.trim();
      if (trimmedSearch.isNotEmpty) {
        params['search'] = trimmedSearch;
      }
      if (_statusFilter.isNotEmpty) {
        params['status'] = _statusFilter;
      }
      final summary = await _repository.getSummary(
        params: params.isEmpty ? null : params,
      );
      if (token != _summaryRequestToken) return;
      _summary = summary;
      safeNotify();
    } catch (_) {
      if (token != _summaryRequestToken) return;
      _summary = const {};
      safeNotify();
    }
  }
}
