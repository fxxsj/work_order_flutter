import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

class GenericApiService {
  GenericApiService(this._client, {required this.resourcePath});

  final ApiClient _client;
  final String resourcePath;

  Future<PageData<GenericRecord>> fetchPage({
    int page = 1,
    int pageSize = 20,
    String? search,
    Map<String, dynamic>? extraParams,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    if (extraParams != null) {
      params.addAll(extraParams);
    }

    final response = await _client.get(resourcePath, queryParameters: params);
    final payload = response.data;

    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => _mapRecord(Map<String, dynamic>.from(item)))
              .toList()
          : <GenericRecord>[];
      final total = toInt(payload['count']) ?? list.length;
      return PageData(
          items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => _mapRecord(Map<String, dynamic>.from(item)))
          .toList();
      return PageData(
          items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return PageData(items: const [], total: 0, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> fetchSummary({
    Map<String, dynamic>? extraParams,
  }) async {
    final response = await _client.get(
      '${resourcePath}summary/',
      queryParameters: extraParams,
    );
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      return Map<String, dynamic>.from(payload);
    }
    if (payload is Map) {
      return Map<String, dynamic>.from(payload);
    }
    return const {};
  }

  Future<GenericRecord> create(Map<String, dynamic> payload) async {
    final response = await _client.post(resourcePath, data: payload);
    return _mapRecord(_ensureMap(response.data));
  }

  Future<GenericRecord> update(int id, Map<String, dynamic> payload) async {
    final response = await _client.put('$resourcePath$id/', data: payload);
    return _mapRecord(_ensureMap(response.data));
  }

  Future<void> delete(int id) async {
    await _client.delete('$resourcePath$id/');
  }

  Map<String, dynamic> _ensureMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  GenericRecord _mapRecord(Map<String, dynamic> json) {
    final idValue = json['id'];
    final id =
        idValue is int ? idValue : int.tryParse(idValue?.toString() ?? '') ?? 0;
    return GenericRecord(id: id, data: json);
  }
}
