import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

class PurchaseReceiveRecordApiService {
  PurchaseReceiveRecordApiService(this._client);

  final ApiClient _client;

  Future<PageData<Map<String, dynamic>>> fetchReceiveRecords({
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
      '/purchase-receive-records/',
      queryParameters: query,
    );
    return _pageFromResponse(response.data, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> confirmInspection(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/purchase-receive-records/$id/confirm_inspection/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> stockIn(int id) async {
    final response = await _client.post(
      '/purchase-receive-records/$id/stock_in/',
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> processReturn(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/purchase-receive-records/$id/process_return/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<PageData<Map<String, dynamic>>> fetchPendingList({
    Map<String, dynamic>? params,
  }) async {
    final response = await _client.get(
      '/purchase-receive-records/pending_list/',
      queryParameters: params,
    );
    return _pageFromResponse(response.data, page: 1, pageSize: 20);
  }

  Future<PageData<Map<String, dynamic>>> fetchPendingStockIn({
    Map<String, dynamic>? params,
  }) async {
    final response = await _client.get(
      '/purchase-receive-records/pending_stock_in/',
      queryParameters: params,
    );
    return _pageFromResponse(response.data, page: 1, pageSize: 20);
  }

  Future<PageData<Map<String, dynamic>>> fetchPendingReturn({
    Map<String, dynamic>? params,
  }) async {
    final response = await _client.get(
      '/purchase-receive-records/pending_return/',
      queryParameters: params,
    );
    return _pageFromResponse(response.data, page: 1, pageSize: 20);
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
