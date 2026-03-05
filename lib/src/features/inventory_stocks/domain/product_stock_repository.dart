import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_dto.dart';

abstract class ProductStockRepository {
  Future<ProductStockPageDto> getProductStocks({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
