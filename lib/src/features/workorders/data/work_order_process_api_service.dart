import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

class WorkOrderProcessApiService {
  WorkOrderProcessApiService(this._client);

  final ApiClient _client;

  Future<PageData<Map<String, dynamic>>> fetchProcesses({
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
      '/workorder-processes/',
      queryParameters: query,
    );
    return _pageFromResponse(response.data, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> fetchProcess(int id) async {
    final response = await _client.get('/workorder-processes/$id/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> createProcess(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post('/workorder-processes/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> updateProcess(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.patch(
      '/workorder-processes/$id/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<void> deleteProcess(int id) async {
    await _client.delete('/workorder-processes/$id/');
  }

  Future<Map<String, dynamic>> start(
    int id, {
    Map<String, dynamic>? payload,
  }) async {
    final response = await _client.post(
      '/workorder-processes/$id/start/',
      data: payload ?? {},
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> complete(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/workorder-processes/$id/complete/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> addLog(int id, String content) async {
    final response = await _client.post(
      '/workorder-processes/$id/add_log/',
      data: {'content': content},
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> reassignTasks(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/workorder-processes/$id/reassign_tasks/',
      data: payload,
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
}
