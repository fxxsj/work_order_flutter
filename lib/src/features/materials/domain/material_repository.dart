import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';

abstract class MaterialRepository {
  Future<PageData<MaterialItem>> getMaterials({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
    String? ordering,
  });

  Future<MaterialItem> createMaterial(MaterialItem material);

  Future<MaterialItem> updateMaterial(MaterialItem material);

  Future<void> deleteMaterial(int id);

  Future<List<MaterialSupplierOption>> getActiveSupplierOptions();
}
