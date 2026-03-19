import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_item_api_service.dart';

class SalesOrderItemSupportService {
  SalesOrderItemSupportService(this._client);

  final ApiClient _client;

  Future<void> deleteItem(int id) async {
    final apiService = SalesOrderItemApiService(_client);
    await apiService.deleteItem(id);
  }
}
