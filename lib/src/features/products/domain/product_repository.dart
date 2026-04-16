import 'package:dio/dio.dart';
import 'package:work_order_app/src/features/products/data/product_dto.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

abstract class ProductRepository {
  Future<ProductPageDto> getProducts({
    int page = 1,
    int pageSize = 20,
    String? search,
  });

  Future<ProductDto> createProduct(ProductDto dto);

  Future<ProductDto> updateProduct(ProductDto dto);

  Future<void> deleteProduct(int id);

  Future<ProductImage> uploadProductImage(
    int productId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  });

  Future<void> deleteProductImage(int productId, int imageId);
}
