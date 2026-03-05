import 'package:work_order_app/src/features/finance_payments/data/payment_api_service.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_dto.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this._apiService);

  final PaymentApiService _apiService;

  @override
  Future<PaymentPageDto> getPayments({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchPayments(page: page, pageSize: pageSize, search: search);
  }
}
