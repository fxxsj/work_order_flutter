import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

class WorkOrderProductApiService {
  WorkOrderProductApiService(this._client);

  final ApiClient _client;

  Future<PageData<Map<String, dynamic>>> fetchProducts({
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
      '/workorder-products/',
      queryParameters: query,
    );
    return _pageFromResponse(response.data, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> fetchProduct(int id) async {
    final response = await _client.get('/workorder-products/$id/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> createProduct(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post('/workorder-products/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> updateProduct(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.put(
      '/workorder-products/$id/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<void> deleteProduct(int id) async {
    await _client.delete('/workorder-products/$id/');
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
}
