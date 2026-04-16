import 'package:dio/dio.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_dto.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._apiService);

  final ProductApiService _apiService;

  @override
  Future<ProductPageDto> getProducts({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchProductPage(page: page, pageSize: pageSize, search: search);
  }

  @override
  Future<ProductDto> createProduct(ProductDto dto) {
    return _apiService.createProduct(dto);
  }

  @override
  Future<ProductDto> updateProduct(ProductDto dto) {
    return _apiService.updateProduct(dto);
  }

  @override
  Future<void> deleteProduct(int id) {
    return _apiService.deleteProduct(id);
  }

  @override
  Future<ProductImage> uploadProductImage(
    int productId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  }) {
    return _apiService.uploadImage(
      productId,
      imageFile,
      sortOrder: sortOrder,
      description: description,
    );
  }

  @override
  Future<void> deleteProductImage(int productId, int imageId) {
    return _apiService.deleteImage(productId, imageId);
  }
}
