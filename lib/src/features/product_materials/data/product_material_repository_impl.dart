import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/product_materials/data/product_material_api_service.dart';
import 'package:work_order_app/src/features/product_materials/domain/product_material_repository.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

class ProductMaterialRepositoryImpl implements ProductMaterialRepository {
  ProductMaterialRepositoryImpl(this._apiService);

  final ProductMaterialApiService _apiService;

  @override
  Future<PageData<Map<String, dynamic>>> getProductMaterials({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  }) {
    return _apiService.fetchProductMaterials(
      page: page,
      pageSize: pageSize,
      params: params,
    );
  }

  @override
  Future<Map<String, dynamic>> getProductMaterial(int id) {
    return _apiService.fetchProductMaterial(id);
  }

  @override
  Future<Map<String, dynamic>> createProductMaterial(
    Map<String, dynamic> payload,
  ) {
    return _apiService.createProductMaterial(payload);
  }

  @override
  Future<Map<String, dynamic>> updateProductMaterial(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.updateProductMaterial(id, payload);
  }

  @override
  Future<void> deleteProductMaterial(int id) {
    return _apiService.deleteProductMaterial(id);
  }

  @override
  Future<bool> saveProductMaterials(
    int productId,
    List<ProductMaterialItem> materials,
  ) async {
    var hasError = false;
    try {
      final existing = await _apiService.fetchProductMaterials(
        page: 1,
        pageSize: 50,
        params: {'product': productId},
      );
      for (final item in existing.items) {
        final rawId = item['id'];
        final id = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
        if (id != null) {
          try {
            await _apiService.deleteProductMaterial(id);
          } catch (_) {
            hasError = true;
          }
        }
      }
    } catch (_) {
      hasError = true;
    }

    for (var i = 0; i < materials.length; i++) {
      final material = materials[i];
      if (material.materialId == 0) {
        continue;
      }
      try {
        await _apiService.createProductMaterial({
          'product': productId,
          'material': material.materialId,
          'material_size': material.materialSize,
          'material_usage': material.materialUsage,
          'need_cutting': material.needCutting,
          'notes': material.notes,
          'sort_order': i,
        });
      } catch (_) {
        hasError = true;
      }
    }
    return hasError;
  }
}
