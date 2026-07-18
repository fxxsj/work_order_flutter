import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

class WorkOrderMaterialApiService {
  WorkOrderMaterialApiService(this._client);

  final ApiClient _client;

  Future<PageData<Map<String, dynamic>>> fetchMaterials({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      ...?params,
    };
    final response = await _client.get(
      '/workorder-materials/',
      queryParameters: query,
    );
    return _pageFromResponse(response.data, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> fetchMaterial(int id) async {
    final response = await _client.get('/workorder-materials/$id/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> createMaterial(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post('/workorder-materials/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> updateMaterial(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.patch(
      '/workorder-materials/$id/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<void> deleteMaterial(int id) async {
    await _client.delete('/workorder-materials/$id/');
  }

  Future<List<Map<String, dynamic>>> fetchStockMaterials() async {
    final response = await _client.get(
      '/materials/',
      queryParameters: {
        'specification_level': 'stock',
        'material_type': 'paper',
        'is_active': true,
        'page_size': 200,
      },
    );
    final payload = response.data;
    final results = payload is Map<String, dynamic>
        ? payload['results']
        : payload;
    if (results is! List) return const [];
    return results
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  Future<Map<String, dynamic>> calculatePlan(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/workorder-materials/$id/calculate_plan/',
      data: payload,
    );
    return _unwrapData(response.data);
  }

  Future<Map<String, dynamic>> confirmPlan(int id) async {
    final response = await _client.post(
      '/workorder-materials/$id/confirm_plan/',
      data: const <String, dynamic>{},
    );
    return _unwrapData(response.data);
  }

  Future<Map<String, dynamic>> invalidatePlan(
    int id, {
    required String reason,
  }) async {
    final response = await _client.post(
      '/workorder-materials/$id/invalidate_plan/',
      data: {'reason': reason},
    );
    return _unwrapData(response.data);
  }

  Future<Map<String, dynamic>> batchCheckout(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/workorder-materials/batch_action/',
      data: {'action': 'checkout', ...payload},
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> batchCheckin(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/workorder-materials/batch_action/',
      data: {'action': 'checkin', ...payload},
    );
    return _mapFromResponse(response.data);
  }

  PageData<Map<String, dynamic>> _pageFromResponse(
    dynamic data, {
    required int page,
    required int pageSize,
  }) {
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      final list = results is List
          ? results
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList()
          : <Map<String, dynamic>>[];
      final total = toInt(data['count']) ?? list.length;
      return PageData(
        items: list,
        total: total,
        page: page,
        pageSize: pageSize,
      );
    }
    if (data is List) {
      final list = data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      return PageData(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    return const PageData(items: [], total: 0, page: 1, pageSize: 20);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }

  Map<String, dynamic> _unwrapData(dynamic data) {
    final mapped = _mapFromResponse(data);
    final nested = mapped['data'];
    return nested is Map ? Map<String, dynamic>.from(nested) : mapped;
  }
}
