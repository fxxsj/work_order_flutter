import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_api_service.dart';
import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_dto.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection_repository.dart';

class QualityInspectionRepositoryImpl implements QualityInspectionRepository {
  QualityInspectionRepositoryImpl(this._apiService);

  final QualityInspectionApiService _apiService;

  @override
  Future<QualityInspectionPageDto> getQualityInspections({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchQualityInspections(page: page, pageSize: pageSize, search: search);
  }
}
