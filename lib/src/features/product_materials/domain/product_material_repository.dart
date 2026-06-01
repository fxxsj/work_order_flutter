import 'package:work_order_app/src/core/data/page_data.dart';

abstract class ProductMaterialRepository {
  Future<PageData<Map<String, dynamic>>> getProductMaterials({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  });

  Future<Map<String, dynamic>> getProductMaterial(int id);

  Future<Map<String, dynamic>> createProductMaterial(
    Map<String, dynamic> payload,
  );

  Future<Map<String, dynamic>> updateProductMaterial(
    int id,
    Map<String, dynamic> payload,
  );

  Future<void> deleteProductMaterial(int id);
}
