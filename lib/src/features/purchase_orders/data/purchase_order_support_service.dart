import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_receive_record_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_form_options.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';

class PurchaseOrderSupportService {
  PurchaseOrderSupportService(this._client);

  final ApiClient _client;

  Future<PurchaseOrderFormOptions> loadFormOptions() async {
    final supplierApi = SupplierApiService(_client);
    final materialApi = MaterialApiService(_client);
    final workOrderApi = WorkOrderApiService(_client);

    final supplierFuture = supplierApi.fetchSuppliers(pageSize: 50);
    final materialFuture = materialApi.fetchMaterials(
      pageSize: 400,
      isActive: true,
      specificationLevel: 'stock',
    );
    final workOrderFuture = workOrderApi.fetchWorkOrders(
      pageSize: 50,
      approvalStatus: 'approved',
      ordering: '-created_at',
    );

    final supplierPage = await supplierFuture;
    final materialPage = await materialFuture;
    final workOrderPage = await workOrderFuture;

    return PurchaseOrderFormOptions(
      suppliers: supplierPage.items.map((dto) => dto.toEntity()).toList(),
      materials: materialPage.items.map((dto) => dto.toEntity()).toList(),
      workOrders: workOrderPage.items.map((dto) => dto.toEntity()).where((
        order,
      ) {
        return order.status != 'completed' && order.status != 'cancelled';
      }).toList(),
    );
  }

  Future<List<Map<String, dynamic>>> loadInspectionRecords(int orderId) async {
    final apiService = PurchaseOrderApiService(_client);
    final response = await apiService.getReceiveRecords(orderId);
    final data = response['data'] ?? response['results'] ?? response;
    if (data is! List) {
      return const [];
    }
    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> confirmInspection(
    int recordId,
    Map<String, dynamic> payload,
  ) async {
    final apiService = PurchaseReceiveRecordApiService(_client);
    await apiService.confirmInspection(recordId, payload);
  }

  Future<void> stockIn(int recordId) async {
    final apiService = PurchaseReceiveRecordApiService(_client);
    await apiService.stockIn(recordId);
  }

  Future<PurchaseOrderDetail> fetchDetail(int id) async {
    final apiService = PurchaseOrderApiService(_client);
    return apiService.fetchDetail(id);
  }

  Future<List<Map<String, dynamic>>> loadLowStockMaterials() async {
    final apiService = PurchaseOrderApiService(_client);
    final response = await apiService.getLowStockMaterials();
    final list = response['materials'];
    if (list is! List) {
      return const [];
    }
    return list
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
