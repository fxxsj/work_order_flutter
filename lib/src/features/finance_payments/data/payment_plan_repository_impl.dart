import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_plan_api_service.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_plan_repository.dart';

class PaymentPlanRepositoryImpl implements PaymentPlanRepository {
  PaymentPlanRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<void> updateStatus(int id) {
    return PaymentPlanApiService(_client).updateStatus(id);
  }
}
