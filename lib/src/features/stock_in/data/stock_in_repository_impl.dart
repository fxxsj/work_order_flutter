import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/stock_in/data/stock_in_api_service.dart';
import 'package:work_order_app/src/features/stock_in/domain/stock_in_repository.dart';

class StockInRepositoryImpl implements StockInRepository {
  StockInRepositoryImpl(this._apiService);

  final StockInApiService _apiService;

  @override
  Future<PageData<Map<String, dynamic>>> getStockIns({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  }) {
    return _apiService.fetchStockIns(page: page, pageSize: pageSize, params: params);
  }

  @override
  Future<Map<String, dynamic>> getStockIn(int id) {
    return _apiService.fetchStockIn(id);
  }

  @override
  Future<Map<String, dynamic>> createStockIn(Map<String, dynamic> payload) {
    return _apiService.createStockIn(payload);
  }

  @override
  Future<Map<String, dynamic>> updateStockIn(int id, Map<String, dynamic> payload) {
    return _apiService.updateStockIn(id, payload);
  }

  @override
  Future<void> deleteStockIn(int id) {
    return _apiService.deleteStockIn(id);
  }

  @override
  Future<Map<String, dynamic>> submit(int id) {
    return _apiService.submit(id);
  }

  @override
  Future<Map<String, dynamic>> approve(int id) {
    return _apiService.approve(id);
  }
}
