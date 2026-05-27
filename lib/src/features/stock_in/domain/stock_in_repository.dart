import 'package:work_order_app/src/core/data/page_data.dart';

abstract class StockInRepository {
  Future<PageData<Map<String, dynamic>>> getStockIns({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  });

  Future<Map<String, dynamic>> getStockIn(int id);

  Future<Map<String, dynamic>> createStockIn(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> updateStockIn(
    int id,
    Map<String, dynamic> payload,
  );

  Future<void> deleteStockIn(int id);

  Future<Map<String, dynamic>> submit(int id);

  Future<Map<String, dynamic>> approve(int id);
}
