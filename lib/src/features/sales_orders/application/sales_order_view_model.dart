import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';

class SalesOrderViewModel extends PaginatedViewModel<SalesOrder> {
  SalesOrderViewModel(this._repository);

  final SalesOrderRepository _repository;
  String _statusFilter = '';
  Map<String, dynamic> _summary = const {};
  int _summaryRequestToken = 0;

  List<SalesOrder> get salesOrders => items;
  String get statusFilter => _statusFilter;
  Map<String, dynamic> get summary => _summary;

  Future<void> initialize() => loadSalesOrders(resetPage: true);

  Future<void> loadSalesOrders({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    await _loadSummary();
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? status,
  }) async {
    setSearchText(search?.trim() ?? '');
    _statusFilter = status?.trim() ?? '';
    await loadSalesOrders(resetPage: true);
  }

  Future<SalesOrderDetail> fetchDetail(int id) async {
    final detail = await _repository.getSalesOrderDetail(id);
    return detail.toEntity();
  }

  Future<SalesOrderDetail> createSalesOrder(
      Map<String, dynamic> payload) async {
    final detail = await _repository.createSalesOrder(payload);
    return detail.toEntity();
  }

  Future<SalesOrderDetail> updateSalesOrder(
      int id, Map<String, dynamic> payload) async {
    final detail = await _repository.updateSalesOrder(id, payload);
    return detail.toEntity();
  }

  Future<SalesOrderDetail> submit(int id) async {
    final detail = await _repository.submit(id);
    return detail.toEntity();
  }

  Future<SalesOrderDetail> approve(int id, Map<String, dynamic> payload) async {
    final detail = await _repository.approve(id, payload);
    return detail.toEntity();
  }

  Future<SalesOrderDetail> reject(int id, Map<String, dynamic> payload) async {
    final detail = await _repository.reject(id, payload);
    return detail.toEntity();
  }

  Future<SalesOrderDetail> complete(
    int id, [
    Map<String, dynamic>? payload,
  ]) async {
    final detail = await _repository.complete(id, payload);
    return detail.toEntity();
  }

  Future<SalesOrderDetail> cancel(int id, Map<String, dynamic> payload) async {
    final detail = await _repository.cancel(id, payload);
    return detail.toEntity();
  }

  Future<SalesOrderDetail> updatePayment(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final detail = await _repository.updatePayment(id, payload);
    return detail.toEntity();
  }

  Future<int?> createWorkOrderFromSalesOrder(Map<String, dynamic> payload) {
    return _repository.createWorkOrderFromSalesOrder(payload);
  }

  @override
  Future<PageData<SalesOrder>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getSalesOrders(
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
