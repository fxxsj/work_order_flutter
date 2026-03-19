import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_api_service.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';

class ProductStockSupportService {
  ProductStockSupportService(this._client);

  final ApiClient _client;

  Future<List<ProductStock>> fetchLowStock() async {
    final response = await ProductStockApiService(_client).fetchLowStock();
    return _parseStockList(response);
  }

  Future<List<ProductStock>> fetchExpired() async {
    final response = await ProductStockApiService(_client).fetchExpired();
    return _parseStockList(response);
  }

  Future<void> adjustStock(
    int stockId, {
    required String adjustType,
    required double quantity,
    required String reason,
  }) {
    return ProductStockApiService(_client).adjustStock(stockId, {
      'adjust_type': adjustType,
      'quantity': quantity,
      'reason': reason,
    });
  }

  List<ProductStock> _parseStockList(Map<String, dynamic> response) {
    final results = response['results'];
    if (results is List) {
      return results
          .whereType<Map>()
          .map((item) => ProductStock.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return const [];
  }
}
