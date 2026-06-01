import 'package:work_order_app/src/core/data/page_data.dart';

abstract class PurchaseReceiveRecordRepository {
  Future<PageData<Map<String, dynamic>>> getReceiveRecords({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  });

  Future<Map<String, dynamic>> confirmInspection(
    int id,
    Map<String, dynamic> payload,
  );

  Future<Map<String, dynamic>> stockIn(int id);

  Future<Map<String, dynamic>> processReturn(
    int id,
    Map<String, dynamic> payload,
  );

  Future<PageData<Map<String, dynamic>>> getPendingList({
    Map<String, dynamic>? params,
  });

  Future<PageData<Map<String, dynamic>>> getPendingStockIn({
    Map<String, dynamic>? params,
  });

  Future<PageData<Map<String, dynamic>>> getPendingReturn({
    Map<String, dynamic>? params,
  });
}
