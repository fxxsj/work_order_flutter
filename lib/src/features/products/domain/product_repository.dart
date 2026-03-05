import 'package:work_order_app/src/features/products/data/product_dto.dart';

abstract class ProductRepository {
  Future<ProductPageDto> getProducts({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
