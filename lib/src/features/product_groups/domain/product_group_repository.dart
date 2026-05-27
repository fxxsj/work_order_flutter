import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';

abstract class ProductGroupRepository {
  Future<PageData<ProductGroup>> getProductGroups({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
    String? ordering,
  });

  Future<ProductGroup> createProductGroup(ProductGroup group);

  Future<ProductGroup> updateProductGroup(ProductGroup group);

  Future<void> deleteProductGroup(int id);
}
