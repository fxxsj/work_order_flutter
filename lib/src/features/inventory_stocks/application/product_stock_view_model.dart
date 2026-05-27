import 'dart:async';

import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock_repository.dart';

class ProductStockViewModel extends PaginatedViewModel<ProductStock> {
  ProductStockViewModel(this._repository);

  final ProductStockRepository _repository;
  String _statusFilter = '';
  String _ordering = '-created_at';
  Map<String, dynamic> _summary = const {};
  int _summaryRequestToken = 0;

  List<ProductStock> get stocks => items;
  String get statusFilter => _statusFilter;
  String get ordering => _ordering;
  Map<String, dynamic> get summary => _summary;

  Future<void> initialize() => loadStocks(resetPage: true);

  Future<void> loadStocks({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    unawaited(_loadSummary());
  }

  Future<void> setStatusFilter(String value) async {
    _statusFilter = value;
    await loadStocks(resetPage: true);
  }

  void setStatusFilterSilently(String value) {
    _statusFilter = value;
  }

  Future<void> setOrdering(String value) async {
    final next = value.trim().isEmpty ? '-created_at' : value.trim();
    if (_ordering == next) return;
    _ordering = next;
    await loadStocks(resetPage: true);
  }

  void setOrderingSilently(String value) {
    _ordering = value.trim().isEmpty ? '-created_at' : value.trim();
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? status,
    String? ordering,
  }) async {
    setSearchText(search?.trim() ?? '');
    _statusFilter = status?.trim() ?? '';
    _ordering = ordering?.trim().isNotEmpty == true
        ? ordering!.trim()
        : '-created_at';
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
      ordering: _ordering,
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
