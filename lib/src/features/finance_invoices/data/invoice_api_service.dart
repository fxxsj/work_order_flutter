import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_dto.dart';

class InvoiceApiService {
  InvoiceApiService(this._client);

  final ApiClient _client;

  Future<InvoicePageDto> fetchInvoices({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? todo,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    final statusValue = status?.trim();
    if (statusValue != null && statusValue.isNotEmpty) {
      params['status'] = statusValue;
    }
    final todoValue = todo?.trim();
    if (todoValue != null && todoValue.isNotEmpty) {
      params['todo'] = todoValue;
    }

    final response = await _client.get('/invoices/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) =>
                  InvoiceDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <InvoiceDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return InvoicePageDto(
          items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => InvoiceDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return InvoicePageDto(
          items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const InvoicePageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<Map<String, dynamic>> submit(int id) async {
    final response = await _client.post('/invoices/$id/submit/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> createInvoice(
      Map<String, dynamic> payload) async {
    final response = await _client.post('/invoices/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> updateInvoice(
      int id, Map<String, dynamic> payload) async {
    final response = await _client.put('/invoices/$id/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> uploadAttachment(
    int id,
    MultipartFile attachment,
  ) async {
    final response = await _client.patch(
      '/invoices/$id/',
      data: FormData.fromMap({'attachment': attachment}),
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> approve(
      int id, Map<String, dynamic> payload) async {
    final response =
        await _client.post('/invoices/$id/approve/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchSummary() async {
    final response = await _client.get('/invoices/summary/');
    return _mapFromResponse(response.data);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
