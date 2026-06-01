import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_product_api_service.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_product_repository.dart';

class WorkOrderProductRepositoryImpl implements WorkOrderProductRepository {
  WorkOrderProductRepositoryImpl(this._apiService);

  final WorkOrderProductApiService _apiService;

  @override
  Future<PageData<Map<String, dynamic>>> getProducts({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  }) {
    return _apiService.fetchProducts(
      page: page,
      pageSize: pageSize,
      params: params,
    );
  }

  @override
  Future<Map<String, dynamic>> getProduct(int id) {
    return _apiService.fetchProduct(id);
  }

  @override
  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> payload) {
    return _apiService.createProduct(payload);
  }

  @override
  Future<Map<String, dynamic>> updateProduct(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.updateProduct(id, payload);
  }

  @override
  Future<void> deleteProduct(int id) {
    return _apiService.deleteProduct(id);
  }
}
