import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group_repository.dart';

class ProductGroupViewModel extends PaginatedViewModel<ProductGroup> {
  ProductGroupViewModel(this._repository);

  final ProductGroupRepository _repository;

  List<ProductGroup> get productGroups => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadProductGroups({bool resetPage = false}) => loadItems(resetPage: resetPage);

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
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
