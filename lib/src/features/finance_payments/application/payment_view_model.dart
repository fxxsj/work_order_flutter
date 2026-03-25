import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_repository.dart';

class PaymentViewModel extends PaginatedViewModel<Payment> {
  PaymentViewModel(this._repository);

  final PaymentRepository _repository;
  Map<String, dynamic> _summary = const {};

  List<Payment> get payments => items;
  Map<String, dynamic> get summary => _summary;

  Future<void> initialize() => loadPayments(resetPage: true);

  Future<void> loadPayments({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    await _loadSummary();
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
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
