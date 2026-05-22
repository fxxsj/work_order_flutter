import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';

abstract class PaymentRepository {
  Future<PageData<Payment>> getPayments({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? todo,
  });

  Future<Map<String, dynamic>> getSummary();
}
