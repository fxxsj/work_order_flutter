import 'package:work_order_app/src/core/data/page_data.dart';

abstract class StockOutRepository {
  Future<PageData<Map<String, dynamic>>> getStockOuts({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  });

  Future<Map<String, dynamic>> getStockOut(int id);

  Future<Map<String, dynamic>> createStockOut(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> updateStockOut(int id, Map<String, dynamic> payload);

  Future<void> deleteStockOut(int id);
}
