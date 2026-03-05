import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';

abstract class SalesOrderRepository {
  Future<SalesOrderPageDto> getSalesOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
