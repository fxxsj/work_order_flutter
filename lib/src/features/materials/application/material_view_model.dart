import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/materials/domain/material_repository.dart';

class MaterialViewModel extends PaginatedViewModel<MaterialItem> {
  MaterialViewModel(this._repository);

  final MaterialRepository _repository;

  List<MaterialItem> get materials => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadMaterials({bool resetPage = false}) => loadItems(resetPage: resetPage);

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
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
