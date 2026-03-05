import 'package:work_order_app/src/features/finance_payments/data/payment_dto.dart';

abstract class PaymentRepository {
  Future<PaymentPageDto> getPayments({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
