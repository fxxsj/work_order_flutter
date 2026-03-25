import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_repository.dart';

class DeliveryOrderViewModel extends PaginatedViewModel<DeliveryOrder> {
  DeliveryOrderViewModel(this._repository);

  final DeliveryOrderRepository _repository;
  String _statusFilter = '';
  int _customerId = 0;
  int _departmentId = 0;
  String _todoFilter = '';
  Map<String, dynamic> _summary = const {};

  List<DeliveryOrder> get deliveryOrders => items;
  String get statusFilter => _statusFilter;
  int get customerId => _customerId;
  int get departmentId => _departmentId;
  String get todoFilter => _todoFilter;
  Map<String, dynamic> get summary => _summary;

  Future<void> initialize() => loadDeliveryOrders(resetPage: true);

  Future<void> loadDeliveryOrders({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    await _loadSummary();
  }

  Future<void> setStatusFilter(String value) async {
    _statusFilter = value;
    await loadDeliveryOrders(resetPage: true);
  }

  Future<void> setCustomerId(int value) async {
    _customerId = value;
    await loadDeliveryOrders(resetPage: true);
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? status,
    int? customerId,
    int? departmentId,
    String? todo,
  }) async {
    setSearchText(search?.trim() ?? '');
    _statusFilter = status?.trim() ?? '';
    _customerId = customerId != null && customerId > 0 ? customerId : 0;
    _departmentId = departmentId != null && departmentId > 0 ? departmentId : 0;
    _todoFilter = todo?.trim() ?? '';
    await loadDeliveryOrders(resetPage: true);
  }

  Future<void> _loadSummary() async {
    try {
      _summary = await _repository.getSummary(
        departmentId: _departmentId > 0 ? _departmentId : null,
        status: _statusFilter.isEmpty ? null : _statusFilter,
        customerId: _customerId > 0 ? _customerId : null,
        todo: _todoFilter.isEmpty ? null : _todoFilter,
      );
      safeNotify();
    } catch (_) {
      // Keep the list usable even if summary loading fails.
    }
  }

  @override
  Future<PageData<DeliveryOrder>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getDeliveryOrders(
      page: page,
      pageSize: pageSize,
      search: search,
      status: _statusFilter.isEmpty ? null : _statusFilter,
      customerId: _customerId > 0 ? _customerId : null,
      departmentId: _departmentId > 0 ? _departmentId : null,
      todo: _todoFilter.isEmpty ? null : _todoFilter,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
