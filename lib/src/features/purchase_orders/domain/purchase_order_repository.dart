import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_dto.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_form_options.dart';

abstract class PurchaseOrderRepository {
  Future<PurchaseOrderPageDto> getPurchaseOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    int? supplierId,
    String? ordering,
  });

  Future<PurchaseOrderFormOptions> loadFormOptions();

  Future<List<Map<String, dynamic>>> loadLowStockMaterials();

  Future<PurchaseOrderDetail> fetchDetail(int id);

  Future<PurchaseOrderDetail> createPurchaseOrder(
    Map<String, dynamic> payload,
  );

  Future<PurchaseOrderDetail> updatePurchaseOrder(
    int id,
    Map<String, dynamic> payload,
  );

  Future<Map<String, dynamic>> submit(int id, [Map<String, dynamic>? payload]);

  Future<Map<String, dynamic>> approve(int id);

  Future<Map<String, dynamic>> reject(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> placeOrder(
    int id,
    Map<String, dynamic> payload,
  );

  Future<Map<String, dynamic>> receive(int id, Map<String, dynamic> payload);

  Future<List<Map<String, dynamic>>> loadInspectionRecords(int id);

  Future<void> confirmInspection(
    int recordId,
    Map<String, dynamic> payload,
  );

  Future<void> stockIn(int recordId);

  Future<Map<String, dynamic>> cancel(int id);

  /// 根据施工单创建采购单。
  Future<Map<String, dynamic>> createFromWorkOrder(int workOrderId);
}
