import 'package:work_order_app/src/core/network/api_client.dart';

class SalesOrderItemApiService {
  SalesOrderItemApiService(this._client);

  final ApiClient _client;

  Future<void> createItem(Map<String, dynamic> payload) async {
    await _client.post('/sales-order-items/', data: payload);
  }

  Future<void> updateItem(int id, Map<String, dynamic> payload) async {
    await _client.put('/sales-order-items/$id/', data: payload);
  }

  Future<void> deleteItem(int id) async {
    await _client.delete('/sales-order-items/$id/');
  }
}
