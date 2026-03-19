import 'package:work_order_app/src/core/network/api_client.dart';

class DeliveryItemApiService {
  DeliveryItemApiService(this._client);

  final ApiClient _client;

  Future<void> createItem(Map<String, dynamic> payload) async {
    await _client.post('/delivery-items/', data: payload);
  }

  Future<void> updateItem(int id, Map<String, dynamic> payload) async {
    await _client.put('/delivery-items/$id/', data: payload);
  }

  Future<void> deleteItem(int id) async {
    await _client.delete('/delivery-items/$id/');
  }
}
