import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/utils/import_export_util.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

abstract class ProductRepository {
  Future<PageData<Product>> getProducts({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
    String? ordering,
  });

  Future<Product> createProduct(Product product);

  Future<Product> updateProduct(Product product);

  Future<void> deleteProduct(int id);

  Future<ProductImage> uploadProductImage(
    int productId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  });

  Future<void> deleteProductImage(int productId, int imageId);

  /// 导出产品列表 Excel。
  Future<void> exportProducts();

  /// 导入产品 Excel。
  Future<ImportResult> importProducts(PlatformFile file);
}
