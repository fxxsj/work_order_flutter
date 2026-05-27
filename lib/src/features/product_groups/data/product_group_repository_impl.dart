import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_api_service.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_dto.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group_repository.dart';

class ProductGroupRepositoryImpl implements ProductGroupRepository {
  ProductGroupRepositoryImpl(this._apiService);

  final ProductGroupApiService _apiService;

  @override
  Future<PageData<ProductGroup>> getProductGroups({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
    String? ordering,
  }) async {
    final result = await _apiService.fetchProductGroups(
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
  Future<ProductGroup> createProductGroup(ProductGroup group) async {
    final dto = await _apiService.createProductGroup(group.toDto());
    return dto.toEntity();
  }

  @override
  Future<ProductGroup> updateProductGroup(ProductGroup group) async {
    final dto = await _apiService.updateProductGroup(group.toDto());
    return dto.toEntity();
  }

  @override
  Future<void> deleteProductGroup(int id) {
    return _apiService.deleteProductGroup(id);
  }
}
