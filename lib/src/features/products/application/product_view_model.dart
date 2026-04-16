import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/products/data/product_dto.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';

class ProductViewModel extends PaginatedViewModel<Product> {
  ProductViewModel(this._repository);

  final ProductRepository _repository;

  List<Product> get products => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadProducts({bool resetPage = false}) => loadItems(resetPage: resetPage);

  Future<Product> createProduct(Product product) async {
    final dto = await _repository.createProduct(product.toDto());
    await loadItems(resetPage: true);
    return dto.toEntity();
  }

  Future<Product> updateProduct(Product product) async {
    final dto = await _repository.updateProduct(product.toDto());
    await loadItems();
    return dto.toEntity();
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
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
