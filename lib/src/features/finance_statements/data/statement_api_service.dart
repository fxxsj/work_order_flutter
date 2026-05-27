import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_dto.dart';

class StatementApiService {
  StatementApiService(this._client);

  final ApiClient _client;

  Future<StatementPageDto> fetchStatements({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? statementType,
    String? status,
    String? todo,
    String? customer,
    String? supplier,
    String? periodStart,
    String? periodEnd,
    String? ordering,
  }) async {
    final params = <String, dynamic>{'page': page, 'page_size': pageSize};
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    final typeValue = statementType?.trim();
    if (typeValue != null && typeValue.isNotEmpty) {
      params['statement_type'] = typeValue;
    }
    final statusValue = status?.trim();
    if (statusValue != null && statusValue.isNotEmpty) {
      params['status'] = statusValue;
    }
    final todoValue = todo?.trim();
    if (todoValue != null && todoValue.isNotEmpty) {
      params['todo'] = todoValue;
    }
    final customerValue = customer?.trim();
    if (customerValue != null && customerValue.isNotEmpty) {
      params['customer'] = customerValue;
    }
    final supplierValue = supplier?.trim();
    if (supplierValue != null && supplierValue.isNotEmpty) {
      params['supplier'] = supplierValue;
    }
    final startValue = periodStart?.trim();
    if (startValue != null && startValue.isNotEmpty) {
      params['period_start'] = startValue;
    }
    final endValue = periodEnd?.trim();
    if (endValue != null && endValue.isNotEmpty) {
      params['period_end'] = endValue;
    }
    final orderingValue = ordering?.trim();
    if (orderingValue != null && orderingValue.isNotEmpty) {
      params['ordering'] = orderingValue;
    }

    final response = await _client.get('/statements/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
                .whereType<Map>()
                .map(
                  (item) =>
                      StatementDto.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : <StatementDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return StatementPageDto(
        items: list,
        total: total,
        page: page,
        pageSize: pageSize,
      );
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => StatementDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return StatementPageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    return const StatementPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<Map<String, dynamic>> confirm(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/statements/$id/confirm/',
      data: payload,
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> createStatement(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post('/statements/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> generate({Map<String, dynamic>? params}) async {
    final response = await _client.get(
      '/statements/generate/',
      queryParameters: params,
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchSummary({
    Map<String, dynamic>? params,
  }) async {
    final response = await _client.get(
      '/statements/summary/',
      queryParameters: params,
    );
    return _mapFromResponse(response.data);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
