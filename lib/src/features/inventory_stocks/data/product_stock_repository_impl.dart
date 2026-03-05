import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_api_service.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_dto.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock_repository.dart';

class ProductStockRepositoryImpl implements ProductStockRepository {
  ProductStockRepositoryImpl(this._apiService);

  final ProductStockApiService _apiService;

  @override
  Future<ProductStockPageDto> getProductStocks({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchProductStocks(page: page, pageSize: pageSize, search: search);
  }
}
