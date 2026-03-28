import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';

class SalesOrderActionService {
  SalesOrderActionService(this._client);

  final ApiClient _client;

  Future<void> submit(int orderId) {
    return SalesOrderApiService(_client).submit(orderId);
  }

  Future<void> approve(int orderId, {required String comment}) {
    return SalesOrderApiService(_client).approve(orderId, {
      'approval_comment': comment,
    });
  }

  Future<void> reject(
    int orderId, {
    required String reason,
    required String comment,
  }) {
    return SalesOrderApiService(_client).reject(orderId, {
      'reason': reason,
      'approval_comment': comment,
    });
  }

  Future<void> complete(
    int orderId, {
    String completionReason = '',
  }) {
    final payload = <String, dynamic>{};
    if (completionReason.trim().isNotEmpty) {
      payload['completion_reason'] = completionReason.trim();
    }
    return SalesOrderApiService(_client).complete(
      orderId,
      payload.isEmpty ? null : payload,
    );
  }

  Future<void> cancel(int orderId, {required String reason}) {
    return SalesOrderApiService(_client).cancel(orderId, {
      'reason': reason,
    });
  }

  Future<void> updatePayment(int orderId, Map<String, dynamic> payload) {
    return SalesOrderApiService(_client).updatePayment(orderId, payload);
  }
}
