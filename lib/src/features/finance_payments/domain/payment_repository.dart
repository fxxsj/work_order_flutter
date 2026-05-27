import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';

abstract class PaymentRepository {
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
  });

  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params});
}
