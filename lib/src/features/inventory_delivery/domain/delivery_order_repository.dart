import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_dto.dart';

abstract class DeliveryOrderRepository {
  Future<DeliveryOrderPageDto> getDeliveryOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
