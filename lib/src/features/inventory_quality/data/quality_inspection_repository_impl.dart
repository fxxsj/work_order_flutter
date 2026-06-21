import 'package:dio/dio.dart';
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
    String? result,
    String? inspectionType,
    int? departmentId,
    String? todo,
    String? startDate,
    String? endDate,
    String? ordering,
  }) {
    return _apiService.fetchQualityInspections(
      page: page,
      pageSize: pageSize,
      search: search,
      result: result,
      inspectionType: inspectionType,
      departmentId: departmentId,
      todo: todo,
      startDate: startDate,
      endDate: endDate,
      ordering: ordering,
    );
  }

  @override
  Future<Map<String, dynamic>> complete(int id, Map<String, dynamic> payload) {
    return _apiService.complete(id, payload);
  }

  @override
  Future<Map<String, dynamic>> uploadAttachment(
    int id,
    MultipartFile attachment,
  ) {
    return _apiService.uploadAttachment(id, attachment);
  }

  @override
  Future<Map<String, dynamic>> getSummary({
    int? departmentId,
    String? result,
    String? inspectionType,
    String? todo,
    String? startDate,
    String? endDate,
  }) {
    return _apiService.fetchSummary(
      departmentId: departmentId,
      result: result,
      inspectionType: inspectionType,
      todo: todo,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<void> updateInspection(int id, Map<String, dynamic> payload) {
    return _apiService.updateInspection(id, payload);
  }
}
