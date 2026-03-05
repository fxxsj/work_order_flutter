import 'package:work_order_app/src/features/product_groups/data/product_group_dto.dart';

abstract class ProductGroupRepository {
  Future<ProductGroupPageDto> getProductGroups({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
