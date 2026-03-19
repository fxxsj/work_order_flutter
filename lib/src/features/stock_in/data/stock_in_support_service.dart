import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/stock_in/data/stock_in_api_service.dart';

class StockInSupportService {
  StockInSupportService(this._client);

  final ApiClient _client;

  Future<void> save({
    required Map<String, dynamic> payload,
    int? id,
  }) async {
    final apiService = StockInApiService(_client);
    if (id != null) {
      await apiService.updateStockIn(id, payload);
      return;
    }
    await apiService.createStockIn(payload);
  }

  Future<void> submit(int id) async {
    final apiService = StockInApiService(_client);
    await apiService.submit(id);
  }

  Future<void> approve(int id) async {
    final apiService = StockInApiService(_client);
    await apiService.approve(id);
  }
}
