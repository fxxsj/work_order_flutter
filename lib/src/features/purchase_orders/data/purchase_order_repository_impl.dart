import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_dto.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_support_service.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_form_options.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_repository.dart';

class PurchaseOrderRepositoryImpl implements PurchaseOrderRepository {
  PurchaseOrderRepositoryImpl(
    this._apiService, {
    PurchaseOrderSupportService? supportService,
  }) : _supportService = supportService ??
            PurchaseOrderSupportService(_apiService.client);

  final PurchaseOrderApiService _apiService;
  final PurchaseOrderSupportService _supportService;

  @override
  Future<PurchaseOrderPageDto> getPurchaseOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    int? supplierId,
    String? ordering,
  }) {
    return _apiService.fetchPurchaseOrders(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      supplierId: supplierId,
      ordering: ordering,
    );
  }

  @override
  Future<PurchaseOrderFormOptions> loadFormOptions() {
    return _supportService.loadFormOptions();
  }

  @override
  Future<List<Map<String, dynamic>>> loadLowStockMaterials() {
    return _supportService.loadLowStockMaterials();
  }

  @override
  Future<PurchaseOrderDetail> fetchDetail(int id) {
    return _supportService.fetchDetail(id);
  }

  @override
  Future<PurchaseOrderDetail> createPurchaseOrder(
    Map<String, dynamic> payload,
  ) {
    return _apiService.createPurchaseOrder(payload);
  }

  @override
  Future<PurchaseOrderDetail> updatePurchaseOrder(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.updatePurchaseOrder(id, payload);
  }

  @override
  Future<Map<String, dynamic>> submit(int id, [Map<String, dynamic>? payload]) {
    return _apiService.submit(id, payload);
  }

  @override
  Future<Map<String, dynamic>> approve(int id) {
    return _apiService.approve(id);
  }

  @override
  Future<Map<String, dynamic>> reject(int id, Map<String, dynamic> payload) {
    return _apiService.reject(id, payload);
  }

  @override
  Future<Map<String, dynamic>> placeOrder(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.placeOrder(id, payload);
  }

  @override
  Future<Map<String, dynamic>> receive(int id, Map<String, dynamic> payload) {
    return _apiService.receive(id, payload);
  }

  @override
  Future<List<Map<String, dynamic>>> loadInspectionRecords(int id) {
    return _supportService.loadInspectionRecords(id);
  }

  @override
  Future<void> confirmInspection(
    int recordId,
    Map<String, dynamic> payload,
  ) {
    return _supportService.confirmInspection(recordId, payload);
  }

  @override
  Future<void> stockIn(int recordId) {
    return _supportService.stockIn(recordId);
  }

  @override
  Future<Map<String, dynamic>> cancel(int id) {
    return _apiService.cancel(id);
  }
}
