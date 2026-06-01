import 'package:work_order_app/src/core/data/page_data.dart';

abstract class WorkOrderMaterialRepository {
  Future<PageData<Map<String, dynamic>>> getMaterials({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  });

  Future<Map<String, dynamic>> getMaterial(int id);

  Future<Map<String, dynamic>> createMaterial(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> updateMaterial(
    int id,
    Map<String, dynamic> payload,
  );

  Future<void> deleteMaterial(int id);

  Future<Map<String, dynamic>> batchCheckout(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> batchCheckin(Map<String, dynamic> payload);
}
