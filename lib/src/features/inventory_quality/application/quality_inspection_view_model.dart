import 'dart:async';

import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection_repository.dart';

class QualityInspectionViewModel extends PaginatedViewModel<QualityInspection> {
  QualityInspectionViewModel(this._repository);

  final QualityInspectionRepository _repository;
  String _resultFilter = '';
  String _typeFilter = '';
  int _departmentId = 0;
  String _todoFilter = '';
  String _startDateFilter = '';
  String _endDateFilter = '';
  String _ordering = '-inspection_date';
  Map<String, dynamic> _summary = const {};

  List<QualityInspection> get inspections => items;
  String get resultFilter => _resultFilter;
  String get typeFilter => _typeFilter;
  int get departmentId => _departmentId;
  String get todoFilter => _todoFilter;
  String get startDateFilter => _startDateFilter;
  String get endDateFilter => _endDateFilter;
  String get ordering => _ordering;
  Map<String, dynamic> get summary => _summary;

  Future<void> initialize() => loadInspections(resetPage: true);

  Future<void> loadInspections({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    unawaited(_loadSummary());
  }

  Future<void> setResultFilter(String value) async {
    _resultFilter = value;
    await loadInspections(resetPage: true);
  }

  Future<void> setTypeFilter(String value) async {
    _typeFilter = value;
    await loadInspections(resetPage: true);
  }

  Future<void> setTodoFilter(String value) async {
    _todoFilter = value.trim();
    await loadInspections(resetPage: true);
  }

  Future<void> setStartDateFilter(String value) async {
    _startDateFilter = value.trim();
    await loadInspections(resetPage: true);
  }

  Future<void> setEndDateFilter(String value) async {
    _endDateFilter = value.trim();
    await loadInspections(resetPage: true);
  }

  Future<void> setOrdering(String value) async {
    final next = value.trim().isEmpty ? '-inspection_date' : value.trim();
    if (_ordering == next) return;
    _ordering = next;
    await loadInspections(resetPage: true);
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? result,
    String? inspectionType,
    int? departmentId,
    String? todo,
    String? startDate,
    String? endDate,
    String? ordering,
  }) async {
    setSearchText(search?.trim() ?? '');
    _resultFilter = result?.trim() ?? '';
    _typeFilter = inspectionType?.trim() ?? '';
    _departmentId = departmentId != null && departmentId > 0 ? departmentId : 0;
    _todoFilter = todo?.trim() ?? '';
    _startDateFilter = startDate?.trim() ?? '';
    _endDateFilter = endDate?.trim() ?? '';
    _ordering = ordering?.trim().isNotEmpty == true
        ? ordering!.trim()
        : '-inspection_date';
    await loadInspections(resetPage: true);
  }

  void setFiltersSilently({
    String? result,
    String? inspectionType,
    int? departmentId,
    String? todo,
    String? startDate,
    String? endDate,
    String? ordering,
  }) {
    _resultFilter = result?.trim() ?? '';
    _typeFilter = inspectionType?.trim() ?? '';
    _departmentId = departmentId != null && departmentId > 0 ? departmentId : 0;
    _todoFilter = todo?.trim() ?? '';
    _startDateFilter = startDate?.trim() ?? '';
    _endDateFilter = endDate?.trim() ?? '';
    _ordering = ordering?.trim().isNotEmpty == true
        ? ordering!.trim()
        : '-inspection_date';
  }

  Future<void> uploadAttachment(int id, MultipartFile attachment) {
    return _repository.uploadAttachment(id, attachment);
  }

  Future<void> updateInspection(int id, Map<String, dynamic> payload) {
    return _repository.updateInspection(id, payload);
  }

  Future<void> _loadSummary() async {
    try {
      _summary = await _repository.getSummary(
        departmentId: _departmentId > 0 ? _departmentId : null,
        result: _resultFilter.isEmpty ? null : _resultFilter,
        inspectionType: _typeFilter.isEmpty ? null : _typeFilter,
        todo: _todoFilter.isEmpty ? null : _todoFilter,
        startDate: _startDateFilter.isEmpty ? null : _startDateFilter,
        endDate: _endDateFilter.isEmpty ? null : _endDateFilter,
      );
      safeNotify();
    } catch (_) {
      // Keep the list usable even if summary loading fails.
    }
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
      todo: _todoFilter.isEmpty ? null : _todoFilter,
      startDate: _startDateFilter.isEmpty ? null : _startDateFilter,
      endDate: _endDateFilter.isEmpty ? null : _endDateFilter,
      ordering: _ordering,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
