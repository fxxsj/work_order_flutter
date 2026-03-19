import 'package:work_order_app/src/core/network/api_client.dart';

class PurchaseOrderItemApiService {
  PurchaseOrderItemApiService(this._client);

  final ApiClient _client;

  Future<void> createItem(Map<String, dynamic> payload) async {
    await _client.post('/purchase-order-items/', data: payload);
  }

  Future<void> updateItem(int id, Map<String, dynamic> payload) async {
    await _client.put('/purchase-order-items/$id/', data: payload);
  }

  Future<void> deleteItem(int id) async {
    await _client.delete('/purchase-order-items/$id/');
  }
}
