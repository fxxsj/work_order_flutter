import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group_repository.dart';

class ProductGroupViewModel extends PaginatedViewModel<ProductGroup> {
  ProductGroupViewModel(this._repository);

  final ProductGroupRepository _repository;

  List<ProductGroup> get productGroups => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadProductGroups({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  Future<void> createProductGroup(ProductGroup group) async {
    await _repository.createProductGroup(group);
    await loadItems(resetPage: true);
  }

  Future<void> updateProductGroup(ProductGroup group) async {
    await _repository.updateProductGroup(group);
    await loadItems();
  }

  Future<void> deleteProductGroup(int id) async {
    await deleteAndReload(() => _repository.deleteProductGroup(id));
  }

  @override
  Future<PageData<ProductGroup>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getProductGroups(
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return result;
  }
}
