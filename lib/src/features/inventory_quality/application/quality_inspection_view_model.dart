import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection_repository.dart';

class QualityInspectionViewModel extends PaginatedViewModel<QualityInspection> {
  QualityInspectionViewModel(this._repository);

  final QualityInspectionRepository _repository;
  String _resultFilter = '';
  String _typeFilter = '';

  List<QualityInspection> get inspections => items;
  String get resultFilter => _resultFilter;
  String get typeFilter => _typeFilter;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadInspections({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  Future<void> setResultFilter(String value) async {
    _resultFilter = value;
    await loadInspections(resetPage: true);
  }

  Future<void> setTypeFilter(String value) async {
    _typeFilter = value;
    await loadInspections(resetPage: true);
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? result,
    String? inspectionType,
  }) async {
    setSearchText(search?.trim() ?? '');
    _resultFilter = result?.trim() ?? '';
    _typeFilter = inspectionType?.trim() ?? '';
    await loadInspections(resetPage: true);
  }

  Future<void> uploadAttachment(int id, MultipartFile attachment) {
    return _repository.uploadAttachment(id, attachment);
  }

  @override
  Future<PageData<QualityInspection>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getQualityInspections(
      page: page,
      pageSize: pageSize,
      search: search,
      result: _resultFilter.isEmpty ? null : _resultFilter,
      inspectionType: _typeFilter.isEmpty ? null : _typeFilter,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
