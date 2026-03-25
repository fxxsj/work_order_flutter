import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_dto.dart';

class QualityInspectionApiService {
  QualityInspectionApiService(this._client);

  final ApiClient _client;

  Future<QualityInspectionPageDto> fetchQualityInspections({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? result,
    String? inspectionType,
    int? departmentId,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    final resultTrimmed = result?.trim();
    if (resultTrimmed != null && resultTrimmed.isNotEmpty) {
      params['result'] = resultTrimmed;
    }
    final typeTrimmed = inspectionType?.trim();
    if (typeTrimmed != null && typeTrimmed.isNotEmpty) {
      params['type'] = typeTrimmed;
    }
    if (departmentId != null && departmentId > 0) {
      params['department_id'] = departmentId;
    }

    final response =
        await _client.get('/quality-inspections/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => QualityInspectionDto.fromJson(
                  Map<String, dynamic>.from(item)))
              .toList()
          : <QualityInspectionDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return QualityInspectionPageDto(
          items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) =>
              QualityInspectionDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return QualityInspectionPageDto(
          items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const QualityInspectionPageDto(
        items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<Map<String, dynamic>> complete(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/quality-inspections/$id/complete/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> uploadAttachment(
    int id,
    MultipartFile attachment,
  ) async {
    final response = await _client.patch(
      '/quality-inspections/$id/',
      data: FormData.fromMap({'attachment': attachment}),
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchSummary({int? departmentId}) async {
    final params = <String, dynamic>{};
    if (departmentId != null && departmentId > 0) {
      params['department_id'] = departmentId;
    }
    final response = await _client.get('/quality-inspections/summary/',
        queryParameters: params);
    return _mapFromResponse(response.data);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
