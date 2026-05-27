import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

class StockOutApiService {
  StockOutApiService(this._client);

  final ApiClient _client;

  Future<PageData<Map<String, dynamic>>> fetchStockOuts({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      ...?params,
    };
    final response = await _client.get('/stock-outs/', queryParameters: query);
    return _pageFromResponse(response.data, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> fetchStockOut(int id) async {
    final response = await _client.get('/stock-outs/$id/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> createStockOut(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post('/stock-outs/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> updateStockOut(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.put('/stock-outs/$id/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<void> deleteStockOut(int id) async {
    await _client.delete('/stock-outs/$id/');
  }

  Future<Map<String, dynamic>> submit(int id) async {
    final response = await _client.post('/stock-outs/$id/submit/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> approve(int id) async {
    final response = await _client.post('/stock-outs/$id/approve/');
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
}
