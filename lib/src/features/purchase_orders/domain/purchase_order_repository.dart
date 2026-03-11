import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_dto.dart';

abstract class PurchaseOrderRepository {
  Future<PurchaseOrderPageDto> getPurchaseOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
  });

  Future<Map<String, dynamic>> submit(int id);

  Future<Map<String, dynamic>> approve(int id);

  Future<Map<String, dynamic>> reject(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> placeOrder(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> receive(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> getReceiveRecords(int id);

  Future<Map<String, dynamic>> getPendingInspections(int id);

  Future<Map<String, dynamic>> cancel(int id);

  Future<Map<String, dynamic>> getLowStockMaterials();
}
