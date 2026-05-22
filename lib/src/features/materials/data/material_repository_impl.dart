import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/materials/domain/material_repository.dart';

class MaterialRepositoryImpl implements MaterialRepository {
  MaterialRepositoryImpl(this._apiService);

  final MaterialApiService _apiService;

  @override
  Future<PageData<MaterialItem>> getMaterials({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    final result = await _apiService.fetchMaterials(
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }

  @override
  Future<MaterialItem> createMaterial(MaterialItem material) async {
    final dto = await _apiService.createMaterial(material.toDto());
    return dto.toEntity();
  }

  @override
  Future<MaterialItem> updateMaterial(MaterialItem material) async {
    final dto = await _apiService.updateMaterial(material.toDto());
    return dto.toEntity();
  }

  @override
  Future<void> deleteMaterial(int id) {
    return _apiService.deleteMaterial(id);
  }
}
