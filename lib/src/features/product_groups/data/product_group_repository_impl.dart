import 'package:work_order_app/src/features/product_groups/data/product_group_api_service.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_dto.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group_repository.dart';

class ProductGroupRepositoryImpl implements ProductGroupRepository {
  ProductGroupRepositoryImpl(this._apiService);

  final ProductGroupApiService _apiService;

  @override
  Future<ProductGroupPageDto> getProductGroups({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchProductGroups(page: page, pageSize: pageSize, search: search);
  }

  @override
  Future<ProductGroupDto> createProductGroup(ProductGroupDto dto) {
    return _apiService.createProductGroup(dto);
  }

  @override
  Future<ProductGroupDto> updateProductGroup(ProductGroupDto dto) {
    return _apiService.updateProductGroup(dto);
  }

  @override
  Future<void> deleteProductGroup(int id) {
    return _apiService.deleteProductGroup(id);
  }
}
