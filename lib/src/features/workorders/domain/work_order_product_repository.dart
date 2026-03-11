import 'package:work_order_app/src/core/data/page_data.dart';

abstract class WorkOrderProductRepository {
  Future<PageData<Map<String, dynamic>>> getProducts({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  });

  Future<Map<String, dynamic>> getProduct(int id);

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> updateProduct(int id, Map<String, dynamic> payload);

  Future<void> deleteProduct(int id);
}
