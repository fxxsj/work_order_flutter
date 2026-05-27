import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_api_service.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock_repository.dart';

class ProductStockRepositoryImpl implements ProductStockRepository {
  ProductStockRepositoryImpl(this._apiService);

  final ProductStockApiService _apiService;

  @override
  Future<PageData<ProductStock>> getProductStocks({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? ordering,
  }) async {
    final result = await _apiService.fetchProductStocks(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      ordering: ordering,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
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
  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params}) {
    return _apiService.fetchSummary(params: params);
  }

  @override
  Future<Map<String, dynamic>> adjustStock(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.adjustStock(id, payload);
  }
}
