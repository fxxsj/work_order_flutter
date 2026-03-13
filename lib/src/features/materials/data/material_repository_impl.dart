import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';
import 'package:work_order_app/src/features/materials/domain/material_repository.dart';

class MaterialRepositoryImpl implements MaterialRepository {
  MaterialRepositoryImpl(this._apiService);

  final MaterialApiService _apiService;

  @override
  Future<MaterialPageDto> getMaterials({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchMaterials(page: page, pageSize: pageSize, search: search);
  }

  @override
  Future<MaterialDto> createMaterial(MaterialDto dto) {
    return _apiService.createMaterial(dto);
  }

  @override
  Future<MaterialDto> updateMaterial(MaterialDto dto) {
    return _apiService.updateMaterial(dto);
  }

  @override
  Future<void> deleteMaterial(int id) {
    return _apiService.deleteMaterial(id);
  }
}
