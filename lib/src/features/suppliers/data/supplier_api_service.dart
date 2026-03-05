import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_dto.dart';

class SupplierApiService {
  SupplierApiService(this._client);

  final ApiClient _client;

  Future<SupplierPageDto> fetchSuppliers({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    final trimmed = search?.trim();
    final response = await _client.get(
      '/suppliers/',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (trimmed != null && trimmed.isNotEmpty) 'search': trimmed,
      },
    );
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => SupplierDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <SupplierDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return SupplierPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => SupplierDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return SupplierPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const SupplierPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<SupplierDto> createSupplier(SupplierDto dto) async {
    final response = await _client.post('/suppliers/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return SupplierDto.fromJson(map);
  }

  Future<SupplierDto> updateSupplier(SupplierDto dto) async {
    final response = await _client.put('/suppliers/${dto.id}/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return SupplierDto.fromJson(map);
  }

  Future<void> deleteSupplier(int id) async {
    await _client.delete('/suppliers/$id/');
  }
}
