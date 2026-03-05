import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_repository.dart';

class PaymentViewModel extends PaginatedViewModel<Payment> {
  PaymentViewModel(this._repository);

  final PaymentRepository _repository;

  List<Payment> get payments => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadPayments({bool resetPage = false}) => loadItems(resetPage: resetPage);

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
