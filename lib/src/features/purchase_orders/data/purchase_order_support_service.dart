import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_receive_record_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';

class PurchaseOrderSupportData {
  const PurchaseOrderSupportData({
    required this.suppliers,
    required this.materials,
    required this.workOrders,
  });

  final List<SupplierDto> suppliers;
  final List<MaterialDto> materials;
  final List<WorkOrderDto> workOrders;
}

class PurchaseOrderSupportService {
  PurchaseOrderSupportService(this._client);

  final ApiClient _client;

  Future<PurchaseOrderSupportData> loadFormOptions() async {
    final supplierApi = SupplierApiService(_client);
    final materialApi = MaterialApiService(_client);
    final workOrderApi = WorkOrderApiService(_client);

    final results = await Future.wait([
      supplierApi.fetchSuppliers(pageSize: 200),
      materialApi.fetchMaterials(pageSize: 400),
      workOrderApi.fetchWorkOrders(
        pageSize: 200,
        approvalStatus: 'approved',
        ordering: '-created_at',
      ),
    ]);

    final supplierPage = results[0] as dynamic;
    final materialPage = results[1] as dynamic;
    final workOrderPage = results[2] as dynamic;

    return PurchaseOrderSupportData(
      suppliers: List<SupplierDto>.from(supplierPage.items),
      materials: List<MaterialDto>.from(materialPage.items),
      workOrders: List<WorkOrderDto>.from(workOrderPage.items).where((order) {
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
