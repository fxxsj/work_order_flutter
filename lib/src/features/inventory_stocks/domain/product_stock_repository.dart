import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';

abstract class ProductStockRepository {
  Future<PageData<ProductStock>> getProductStocks({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
  });

  Future<Map<String, dynamic>> getLowStock({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> getExpired({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> getExpiringSoon({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> adjustStock(
      int id, Map<String, dynamic> payload);
}
