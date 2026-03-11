import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/finance_costs/data/production_cost_dto.dart';

class ProductionCostApiService {
  ProductionCostApiService(this._client);

  final ApiClient _client;

  Future<ProductionCostPageDto> fetchCosts({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }

    final response = await _client.get('/production-costs/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => ProductionCostDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <ProductionCostDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return ProductionCostPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => ProductionCostDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return ProductionCostPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const ProductionCostPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<Map<String, dynamic>> calculateMaterial(int id) async {
    final response = await _client.post('/production-costs/$id/calculate_material/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> calculateTotal(int id) async {
    final response = await _client.post('/production-costs/$id/calculate_total/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchStats({Map<String, dynamic>? params}) async {
    final response = await _client.get('/production-costs/stats/', queryParameters: params);
    return _mapFromResponse(response.data);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
