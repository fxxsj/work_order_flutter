import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_dto.dart';

abstract class DeliveryOrderRepository {
  Future<DeliveryOrderPageDto> getDeliveryOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    int? customerId,
  });

  Future<Map<String, dynamic>> ship(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> receive(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> reject(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> getSummary();
}
