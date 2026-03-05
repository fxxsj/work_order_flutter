import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection_repository.dart';

class QualityInspectionViewModel extends PaginatedViewModel<QualityInspection> {
  QualityInspectionViewModel(this._repository);

  final QualityInspectionRepository _repository;

  List<QualityInspection> get inspections => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadInspections({bool resetPage = false}) => loadItems(resetPage: resetPage);

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
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
