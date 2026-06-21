import 'package:dio/dio.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_dto.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_form_options.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';

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

  Future<DeliveryOrderDetail> createDeliveryOrder(Map<String, dynamic> payload);

  Future<DeliveryOrderDetail> updateDeliveryOrder(
    int id,
    Map<String, dynamic> payload,
  );

  Future<void> deleteDeliveryOrder(int id);

  Future<Map<String, dynamic>> ship(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> receive(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> reject(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> resolveException(
    int id,
    Map<String, dynamic> payload,
  );

  Future<DeliveryOrderDetail> uploadReceiverSignature(
    int id,
    MultipartFile receiverSignature,
  );

  Future<Map<String, dynamic>> getSummary({
    int? departmentId,
    String? status,
    int? customerId,
    String? todo,
    String? startDate,
    String? endDate,
  });

  Future<DeliveryOrderFormOptions> loadFormOptions();

  Future<SalesOrderDetail> fetchSalesOrderDetail(int id);
}
