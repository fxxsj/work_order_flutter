import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_dto.dart';

abstract class QualityInspectionRepository {
  Future<QualityInspectionPageDto> getQualityInspections({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
