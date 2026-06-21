import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';

abstract class ProductStockRepository {
  Future<PageData<ProductStock>> getProductStocks({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? ordering,
  });

  Future<List<ProductStock>> fetchLowStock();

  Future<List<ProductStock>> fetchExpired();

  Future<Map<String, dynamic>> getExpiringSoon({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params});

  Future<void> adjustStock(
    int id, {
    required String adjustType,
    required double quantity,
    required String reason,
  });
}
