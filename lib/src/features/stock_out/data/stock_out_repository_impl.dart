import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/stock_out/data/stock_out_api_service.dart';
import 'package:work_order_app/src/features/stock_out/domain/stock_out_repository.dart';

class StockOutRepositoryImpl implements StockOutRepository {
  StockOutRepositoryImpl(this._apiService);

  final StockOutApiService _apiService;

  @override
  Future<PageData<Map<String, dynamic>>> getStockOuts({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  }) {
    return _apiService.fetchStockOuts(page: page, pageSize: pageSize, params: params);
  }

  @override
  Future<Map<String, dynamic>> getStockOut(int id) {
    return _apiService.fetchStockOut(id);
  }

  @override
  Future<Map<String, dynamic>> createStockOut(Map<String, dynamic> payload) {
    return _apiService.createStockOut(payload);
  }

  @override
  Future<Map<String, dynamic>> updateStockOut(int id, Map<String, dynamic> payload) {
    return _apiService.updateStockOut(id, payload);
  }

  @override
  Future<void> deleteStockOut(int id) {
    return _apiService.deleteStockOut(id);
  }
}
