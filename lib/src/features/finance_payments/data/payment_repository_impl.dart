import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_api_service.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this._apiService);

  final PaymentApiService _apiService;

  @override
  Future<PageData<Payment>> getPayments({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? customer,
    String? paymentMethod,
    String? todo,
    String? ordering,
    String? startDate,
    String? endDate,
  }) async {
    final result = await _apiService.fetchPayments(
      page: page,
      pageSize: pageSize,
      search: search,
      customer: customer,
      paymentMethod: paymentMethod,
      todo: todo,
      ordering: ordering,
      startDate: startDate,
      endDate: endDate,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }

  @override
  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params}) {
    return _apiService.fetchSummary(params: params);
  }
}
