import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/finance_costs/domain/production_cost.dart';
import 'package:work_order_app/src/features/finance_costs/domain/production_cost_repository.dart';

class ProductionCostViewModel extends PaginatedViewModel<ProductionCost> {
  ProductionCostViewModel(this._repository);

  final ProductionCostRepository _repository;
  Map<String, dynamic> _stats = const {};
  String _periodStartFilter = '';
  String _periodEndFilter = '';
  String _ordering = '-period';
  int _statsRequestToken = 0;

  List<ProductionCost> get costs => items;
  Map<String, dynamic> get stats => _stats;
  String get periodStartFilter => _periodStartFilter;
  String get periodEndFilter => _periodEndFilter;
  String get ordering => _ordering;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadCosts({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    await _loadStats();
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? periodStart,
    String? periodEnd,
    String? ordering,
  }) async {
    setSearchText(search?.trim() ?? '');
    _periodStartFilter = periodStart?.trim() ?? '';
    _periodEndFilter = periodEnd?.trim() ?? '';
    _ordering = ordering?.trim().isNotEmpty == true
        ? ordering!.trim()
        : '-period';
    await loadCosts(resetPage: true);
  }

  Future<void> setPeriodStartFilter(String value) async {
    _periodStartFilter = value.trim();
    await loadCosts(resetPage: true);
  }

  Future<void> setPeriodEndFilter(String value) async {
    _periodEndFilter = value.trim();
    await loadCosts(resetPage: true);
  }

  Future<void> setOrdering(String value) async {
    final next = value.trim().isEmpty ? '-period' : value.trim();
    if (_ordering == next) return;
    _ordering = next;
    await loadCosts(resetPage: true);
  }

  void setFiltersSilently({
    String? periodStart,
    String? periodEnd,
    String? ordering,
  }) {
    _periodStartFilter = periodStart?.trim() ?? '';
    _periodEndFilter = periodEnd?.trim() ?? '';
    _ordering = ordering?.trim().isNotEmpty == true
        ? ordering!.trim()
        : '-period';
  }

  Future<void> _loadStats() async {
    final token = ++_statsRequestToken;
    try {
      final params = <String, dynamic>{};
      final trimmedSearch = searchText.trim();
      if (trimmedSearch.isNotEmpty) {
        params['search'] = trimmedSearch;
      }
      if (_periodStartFilter.isNotEmpty) {
        params['period_start'] = _periodStartFilter;
      }
      if (_periodEndFilter.isNotEmpty) {
        params['period_end'] = _periodEndFilter;
      }
      _stats = await _repository.getStats(
        params: params.isEmpty ? null : params,
      );
      if (token != _statsRequestToken) return;
      safeNotify();
    } catch (_) {
      if (token != _statsRequestToken) return;
      _stats = const {};
      safeNotify();
    }
  }

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
      periodStart: _periodStartFilter.isEmpty ? null : _periodStartFilter,
      periodEnd: _periodEndFilter.isEmpty ? null : _periodEndFilter,
      ordering: _ordering,
    );
    return result;
  }
}
