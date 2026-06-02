import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/import_export_util.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';

class MaterialApiService {
  MaterialApiService(this._client);

  final ApiClient _client;

  ImportExportService get importExportService => ImportExportService(_client);

  Future<PageData<MaterialDto>> fetchMaterials({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
    String? ordering,
  }) async {
    final params = <String, dynamic>{'page': page, 'page_size': pageSize};
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    if (isActive != null) {
      params['is_active'] = isActive;
    }
    final trimmedOrdering = ordering?.trim();
    if (trimmedOrdering != null && trimmedOrdering.isNotEmpty) {
      params['ordering'] = trimmedOrdering;
    }

    final response = await _client.get('/materials/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
                .whereType<Map>()
                .map(
                  (item) =>
                      MaterialDto.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : <MaterialDto>[];
      return PageData.fromPayload(
        payload: payload,
        page: page,
        pageSize: pageSize,
        results: list,
      );
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => MaterialDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return PageData(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    return PageData(items: const [], total: 0, page: page, pageSize: pageSize);
  }

  Future<MaterialDto> createMaterial(MaterialDto dto) async {
    final response = await _client.post('/materials/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return MaterialDto.fromJson(map);
  }

  Future<MaterialDto> updateMaterial(MaterialDto dto) async {
    final response = await _client.put(
      '/materials/${dto.id}/',
      data: dto.toPayload(),
    );
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return MaterialDto.fromJson(map);
  }

  Future<void> deleteMaterial(int id) async {
    await _client.delete('/materials/$id/');
  }

  Future<List<MaterialSupplierOption>> fetchActiveSupplierOptions() async {
    final response = await _client.get(
      '/suppliers/',
      queryParameters: {
        'page_size': 100,
        'status': 'active',
        'ordering': 'code',
      },
    );
    final payload = response.data;
    final source = payload is Map<String, dynamic>
        ? payload['results']
        : payload;
    if (source is! List) return const [];
    return source
        .whereType<Map>()
        .map(
          (item) =>
              MaterialSupplierOption.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.id > 0)
        .toList();
  }
}
