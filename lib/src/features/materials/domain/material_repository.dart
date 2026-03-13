import 'package:work_order_app/src/features/materials/data/material_dto.dart';

abstract class MaterialRepository {
  Future<MaterialPageDto> getMaterials({
    int page = 1,
    int pageSize = 20,
    String? search,
  });

  Future<MaterialDto> createMaterial(MaterialDto dto);

  Future<MaterialDto> updateMaterial(MaterialDto dto);

  Future<void> deleteMaterial(int id);
}
