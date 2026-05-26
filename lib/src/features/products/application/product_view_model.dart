import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/core/utils/import_export_util.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';

class ProductViewModel extends PaginatedViewModel<Product> {
  ProductViewModel(this._repository);

  final ProductRepository _repository;
  bool? _isActiveFilter;
  String? _ordering;

  List<Product> get products => items;

  bool? get isActiveFilter => _isActiveFilter;
  String? get ordering => _ordering;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadProducts({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  void setIsActiveFilter(bool? value) {
    _isActiveFilter = value;
    loadItems(resetPage: true);
  }

  void setOrdering(String? value) {
    _ordering = value;
    loadItems(resetPage: true);
  }

  Future<Product> createProduct(Product product) async {
    final created = await _repository.createProduct(product);
    await loadItems(resetPage: true);
    return created;
  }

  Future<Product> updateProduct(Product product) async {
    final updated = await _repository.updateProduct(product);
    await loadItems();
    return updated;
  }

  Future<void> deleteProduct(int id) async {
    await deleteAndReload(() => _repository.deleteProduct(id));
  }

  Future<ProductImage> uploadProductImage(
    int productId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  }) {
    return _repository.uploadProductImage(
      productId,
      imageFile,
      sortOrder: sortOrder,
      description: description,
    );
  }

  Future<void> deleteProductImage(int productId, int imageId) async {
    await _repository.deleteProductImage(productId, imageId);
    await loadItems();
  }

  @override
  Future<PageData<Product>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getProducts(
      page: page,
      pageSize: pageSize,
      search: search,
      isActive: _isActiveFilter,
      ordering: _ordering,
    );
    return result;
  }

  /// 导出产品列表 Excel。
  Future<void> exportProducts() async {
    await _repository.exportProducts();
  }

  /// 导入产品 Excel。
  Future<ImportResult> importProducts(PlatformFile file) async {
    final result = await _repository.importProducts(file);
    await loadItems(resetPage: true);
    return result;
  }
}
