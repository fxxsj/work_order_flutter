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
    String? status,
  }) {
    return _apiService.fetchProductStocks(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
    );
  }

  @override
  Future<Map<String, dynamic>> getLowStock({Map<String, dynamic>? params}) {
    return _apiService.fetchLowStock(params: params);
  }

  @override
  Future<Map<String, dynamic>> getExpired({Map<String, dynamic>? params}) {
    return _apiService.fetchExpired(params: params);
  }

  @override
  Future<Map<String, dynamic>> getExpiringSoon({Map<String, dynamic>? params}) {
    return _apiService.fetchExpiringSoon(params: params);
  }

  @override
  Future<Map<String, dynamic>> getSummary() {
    return _apiService.fetchSummary();
  }

  @override
  Future<Map<String, dynamic>> adjustStock(
      int id, Map<String, dynamic> payload) {
    return _apiService.adjustStock(id, payload);
  }
}
