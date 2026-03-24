import 'package:dio/dio.dart';
import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_dto.dart';

abstract class QualityInspectionRepository {
  Future<QualityInspectionPageDto> getQualityInspections({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? result,
    String? inspectionType,
  });

  Future<Map<String, dynamic>> complete(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> uploadAttachment(
      int id, MultipartFile attachment);

  Future<Map<String, dynamic>> getSummary();
}
