import 'package:work_order_app/src/core/network/api_client.dart';

class PaymentPlanApiService {
  PaymentPlanApiService(this._client);

  final ApiClient _client;

  Future<void> updateStatus(int id) async {
    await _client.post('/payment-plans/$id/update_status/');
  }
}
