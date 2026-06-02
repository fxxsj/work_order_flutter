import 'package:file_picker/file_picker.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/utils/import_export_util.dart';
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

  /// 导出物料列表 Excel。
  Future<void> exportMaterials();

  /// 导入物料 Excel。
  Future<ImportResult> importMaterials(PlatformFile file);
}
