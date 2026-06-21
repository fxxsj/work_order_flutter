import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/utils/import_export_util.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_dto.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._apiService);

  final ProductApiService _apiService;

  /// 获取导入/导出服务
  ImportExportService get _importExport => _apiService.importExportService;

  @override
  Future<PageData<Product>> getProducts({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
    String? ordering,
  }) async {
    final result = await _apiService.fetchProductPage(
      page: page,
      pageSize: pageSize,
      search: search,
      isActive: isActive,
      ordering: ordering,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }

  @override
  Future<List<ProductOption>> getProductOptions({bool? isActive}) {
    return _apiService.fetchProducts(isActive: isActive);
  }

  @override
  Future<Product> getProduct(int id) async {
    final dto = await _apiService.fetchProduct(id);
    return dto.toEntity();
  }

  @override
  Future<Product> createProduct(Product product) async {
    final dto = await _apiService.createProduct(product.toDto());
    return dto.toEntity();
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final dto = await _apiService.updateProduct(product.toDto());
    return dto.toEntity();
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

  /// 导出产品列表 Excel。
  @override
  Future<void> exportProducts() async {
    await _importExport.export('/products/export/', 'products.xlsx');
  }

  /// 导入产品 Excel。
  @override
  Future<ImportResult> importProducts(PlatformFile file) async {
    return _importExport.import('/products/import_products/', file);
  }
}
