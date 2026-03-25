import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_api_service.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection_repository.dart';

class QualityInspectionViewModel extends PaginatedViewModel<QualityInspection> {
  QualityInspectionViewModel(this._repository, this._apiService);

  final QualityInspectionRepository _repository;
  final QualityInspectionApiService _apiService;
  String _resultFilter = '';
  String _typeFilter = '';
  int _departmentId = 0;

  List<QualityInspection> get inspections => items;
  String get resultFilter => _resultFilter;
  String get typeFilter => _typeFilter;
  int get departmentId => _departmentId;

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
    int? departmentId,
  }) async {
    setSearchText(search?.trim() ?? '');
    _resultFilter = result?.trim() ?? '';
    _typeFilter = inspectionType?.trim() ?? '';
    _departmentId = departmentId != null && departmentId > 0 ? departmentId : 0;
    await loadInspections(resetPage: true);
  }

  Future<void> uploadAttachment(int id, MultipartFile attachment) {
    return _repository.uploadAttachment(id, attachment);
  }

  Future<void> updateInspection(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.updateInspection(id, payload);
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
      departmentId: _departmentId > 0 ? _departmentId : null,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
