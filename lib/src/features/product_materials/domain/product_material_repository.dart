import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

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

  /// 保存产品的默认物料：先删除现有记录，再按顺序创建新记录。
  /// 返回 `true` 表示过程中出现错误（已尽力完成）。
  Future<bool> saveProductMaterials(
    int productId,
    List<ProductMaterialItem> materials,
  );
}
