import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';
import 'package:work_order_app/src/features/stock_out/data/stock_out_api_service.dart';

class StockOutSupportService {
  StockOutSupportService(this._client);

  final ApiClient _client;

  Future<void> save({
    required Map<String, dynamic> payload,
    int? id,
  }) async {
    final apiService = StockOutApiService(_client);
    if (id != null) {
      await apiService.updateStockOut(id, payload);
      return;
    }
    await apiService.createStockOut(payload);
  }

  Future<DeliveryOrderDetail> fetchDeliveryOrderDetail(int id) async {
    final apiService = DeliveryOrderApiService(_client);
    return apiService.fetchDetail(id);
  }
}
