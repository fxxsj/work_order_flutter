import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/product_materials/data/product_material_api_service.dart';
import 'package:work_order_app/src/features/product_materials/domain/product_material_repository.dart';

class ProductMaterialRepositoryImpl implements ProductMaterialRepository {
  ProductMaterialRepositoryImpl(this._apiService);

  final ProductMaterialApiService _apiService;

  @override
  Future<PageData<Map<String, dynamic>>> getProductMaterials({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  }) {
    return _apiService.fetchProductMaterials(page: page, pageSize: pageSize, params: params);
  }

  @override
  Future<Map<String, dynamic>> getProductMaterial(int id) {
    return _apiService.fetchProductMaterial(id);
  }

  @override
  Future<Map<String, dynamic>> createProductMaterial(Map<String, dynamic> payload) {
    return _apiService.createProductMaterial(payload);
  }

  @override
  Future<Map<String, dynamic>> updateProductMaterial(int id, Map<String, dynamic> payload) {
    return _apiService.updateProductMaterial(id, payload);
  }

  @override
  Future<void> deleteProductMaterial(int id) {
    return _apiService.deleteProductMaterial(id);
  }
}
