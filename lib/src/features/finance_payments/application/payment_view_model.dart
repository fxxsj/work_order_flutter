import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_repository.dart';

class PaymentViewModel extends PaginatedViewModel<Payment> {
  PaymentViewModel(this._repository);

  final PaymentRepository _repository;
  Map<String, dynamic> _summary = const {};
  String _todoFilter = '';

  List<Payment> get payments => items;
  Map<String, dynamic> get summary => _summary;
  String get todoFilter => _todoFilter;

  Future<void> initialize() => loadPayments(resetPage: true);

  Future<void> loadPayments({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    await _loadSummary();
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? todo,
  }) async {
    setSearchText(search?.trim() ?? '');
    _todoFilter = todo?.trim() ?? '';
    await loadPayments(resetPage: true);
  }

  Future<void> _loadSummary() async {
    try {
      _summary = await _repository.getSummary();
      safeNotify();
    } catch (_) {
      // Keep the list usable even if the summary endpoint fails.
    }
  }

  @override
  Future<PageData<Payment>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getPayments(
      page: page,
      pageSize: pageSize,
      search: search,
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
