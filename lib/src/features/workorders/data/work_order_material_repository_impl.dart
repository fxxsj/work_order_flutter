import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_material_api_service.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_material_repository.dart';

class WorkOrderMaterialRepositoryImpl implements WorkOrderMaterialRepository {
  WorkOrderMaterialRepositoryImpl(this._apiService);

  final WorkOrderMaterialApiService _apiService;

  @override
  Future<PageData<Map<String, dynamic>>> getMaterials({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  }) {
    return _apiService.fetchMaterials(
      page: page,
      pageSize: pageSize,
      params: params,
    );
  }

  @override
  Future<Map<String, dynamic>> getMaterial(int id) {
    return _apiService.fetchMaterial(id);
  }

  @override
  Future<Map<String, dynamic>> createMaterial(Map<String, dynamic> payload) {
    return _apiService.createMaterial(payload);
  }

  @override
  Future<Map<String, dynamic>> updateMaterial(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.updateMaterial(id, payload);
  }

  @override
  Future<void> deleteMaterial(int id) {
    return _apiService.deleteMaterial(id);
  }

  @override
  Future<List<Map<String, dynamic>>> getStockMaterials() {
    return _apiService.fetchStockMaterials();
  }

  @override
  Future<Map<String, dynamic>> calculatePlan(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.calculatePlan(id, payload);
  }

  @override
  Future<Map<String, dynamic>> confirmPlan(int id) {
    return _apiService.confirmPlan(id);
  }

  @override
  Future<Map<String, dynamic>> invalidatePlan(
    int id, {
    required String reason,
  }) {
    return _apiService.invalidatePlan(id, reason: reason);
  }

  @override
  Future<Map<String, dynamic>> batchCheckout(Map<String, dynamic> payload) {
    return _apiService.batchCheckout(payload);
  }

  @override
  Future<Map<String, dynamic>> batchCheckin(Map<String, dynamic> payload) {
    return _apiService.batchCheckin(payload);
  }
}
