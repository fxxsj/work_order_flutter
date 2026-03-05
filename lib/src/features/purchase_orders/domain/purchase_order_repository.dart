import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_dto.dart';

abstract class PurchaseOrderRepository {
  Future<PurchaseOrderPageDto> getPurchaseOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
