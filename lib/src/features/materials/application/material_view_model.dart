import 'package:file_picker/file_picker.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/core/utils/import_export_util.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/materials/domain/material_repository.dart';

class MaterialViewModel extends PaginatedViewModel<MaterialItem> {
  MaterialViewModel(this._repository);

  final MaterialRepository _repository;
  bool? _isActiveFilter;
  String? _ordering;
  List<MaterialSupplierOption> _supplierOptions = const [];
  bool _loadingSupplierOptions = false;

  List<MaterialItem> get materials => items;
  bool? get isActiveFilter => _isActiveFilter;
  String? get ordering => _ordering;
  List<MaterialSupplierOption> get supplierOptions => _supplierOptions;
  bool get loadingSupplierOptions => _loadingSupplierOptions;

  Future<void> initialize() async {
    await Future.wait([loadSupplierOptions(), loadItems(resetPage: true)]);
  }

  Future<void> loadMaterials({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  void setIsActiveFilter(bool? value) {
    _isActiveFilter = value;
    loadItems(resetPage: true);
  }

  void setOrdering(String? value) {
    _ordering = value;
    loadItems(resetPage: true);
  }

  Future<void> loadSupplierOptions() async {
    _loadingSupplierOptions = true;
    safeNotify();
    try {
      _supplierOptions = await _repository.getActiveSupplierOptions();
    } finally {
      _loadingSupplierOptions = false;
      safeNotify();
    }
  }

  Future<void> createMaterial(MaterialItem material) async {
    await _repository.createMaterial(material);
    await loadItems(resetPage: true);
  }

  Future<void> updateMaterial(MaterialItem material) async {
    await _repository.updateMaterial(material);
    await loadItems();
  }

  Future<void> deleteMaterial(int id) async {
    await deleteAndReload(() => _repository.deleteMaterial(id));
  }

  @override
  Future<PageData<MaterialItem>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getMaterials(
      page: page,
      pageSize: pageSize,
      search: search,
      isActive: _isActiveFilter,
      ordering: _ordering,
    );
    return result;
  }

  /// 导出物料列表 Excel。
  Future<void> exportMaterials() async {
    await _repository.exportMaterials();
  }

  /// 导入物料 Excel。
  Future<ImportResult> importMaterials(PlatformFile file) async {
    final result = await _repository.importMaterials(file);
    await loadItems(resetPage: true);
    return result;
  }
}
