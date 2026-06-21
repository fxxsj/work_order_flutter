import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_dto.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';

abstract class DeliveryOrderRepository {
  Future<DeliveryOrderPageDto> getDeliveryOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    int? customerId,
    int? departmentId,
    String? todo,
    String? startDate,
    String? endDate,
    String? ordering,
  });

  Future<DeliveryOrderDetail> getDeliveryOrderDetail(int id);

  Future<Map<String, dynamic>> ship(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> receive(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> reject(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> getSummary({
    int? departmentId,
    String? status,
    int? customerId,
    String? todo,
    String? startDate,
    String? endDate,
  });
}
