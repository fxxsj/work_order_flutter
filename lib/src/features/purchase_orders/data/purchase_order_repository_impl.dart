import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_dto.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_repository.dart';

class PurchaseOrderRepositoryImpl implements PurchaseOrderRepository {
  PurchaseOrderRepositoryImpl(this._apiService);

  final PurchaseOrderApiService _apiService;

  @override
  Future<PurchaseOrderPageDto> getPurchaseOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    int? supplierId,
  }) {
    return _apiService.fetchPurchaseOrders(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      supplierId: supplierId,
    );
  }

  @override
  Future<Map<String, dynamic>> submit(int id) {
    return _apiService.submit(id);
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
  Future<Map<String, dynamic>> placeOrder(int id, Map<String, dynamic> payload) {
    return _apiService.placeOrder(id, payload);
  }

  @override
  Future<Map<String, dynamic>> receive(int id, Map<String, dynamic> payload) {
    return _apiService.receive(id, payload);
  }

  @override
  Future<Map<String, dynamic>> getReceiveRecords(int id) {
    return _apiService.getReceiveRecords(id);
  }

  @override
  Future<Map<String, dynamic>> getPendingInspections(int id) {
    return _apiService.getPendingInspections(id);
  }

  @override
  Future<Map<String, dynamic>> cancel(int id) {
    return _apiService.cancel(id);
  }

  @override
  Future<Map<String, dynamic>> getLowStockMaterials() {
    return _apiService.getLowStockMaterials();
  }

}
