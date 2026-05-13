import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/customer/data/salesperson_dto.dart';

/// 客户相关 API 服务。
class CustomerApiService {
  CustomerApiService(this._client);

  final ApiClient _client;

  /// 获取客户分页列表。
  Future<CustomerPageDto> fetchCustomers({
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

    final response = await _client.get('/customers/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      if (results is List) {
        final list = results
            .whereType<Map>()
            .map(
                (item) => CustomerDto.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        final total = toInt(payload['count']) ?? list.length;
        return CustomerPageDto(
          items: list,
          total: total,
          page: page,
          pageSize: pageSize,
        );
      }

      final items = payload['items'];
      if (items is List) {
        final list = items
            .whereType<Map>()
            .map(
                (item) => CustomerDto.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        final pagination = payload['pagination'];
        final total = pagination is Map<String, dynamic>
            ? toInt(pagination['total_items']) ?? list.length
            : toInt(payload['total']) ?? list.length;
        return CustomerPageDto(
          items: list,
          total: total,
          page: page,
          pageSize: pageSize,
        );
      }
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => CustomerDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return CustomerPageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    return const CustomerPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  /// 创建客户。
  Future<CustomerDto> createCustomer(CustomerDto dto) async {
    final response = await _client.post('/customers/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return CustomerDto.fromJson(map);
  }

  /// 更新客户。
  Future<CustomerDto> updateCustomer(CustomerDto dto) async {
    final response =
        await _client.put('/customers/${dto.id}/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    return CustomerDto.fromJson(map);
  }

  /// 删除客户。
  Future<void> deleteCustomer(int id) async {
    await _client.delete('/customers/$id/');
  }

  /// 获取业务员列表。
  Future<List<SalespersonDto>> fetchSalespersons() async {
    final response = await _client.get('/auth/salespersons/');
    final payload = response.data;
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map((item) =>
              SalespersonDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return [];
  }

  /// 导出客户列表 Excel。
  Future<Response<dynamic>> exportCustomers() {
    return _client.requestRaw(
      '/customers/export/',
      method: 'get',
      responseType: ResponseType.bytes,
    );
  }

  /// 导入客户 Excel。
  Future<ImportCustomersResult> importCustomers(MultipartFile file) async {
    final formData = FormData.fromMap({'file': file});
    final response = await _client.requestRaw(
      '/customers/import_customers/',
      method: 'post',
      data: formData,
    );
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final dataField = payload['data'];
      if (dataField is Map<String, dynamic>) {
        return ImportCustomersResult.fromJson(dataField);
      }
      return ImportCustomersResult.fromJson(payload);
    }
    return const ImportCustomersResult(successCount: 0, errorCount: 1, errors: ['未知响应格式']);
  }
}

/// 客户导入结果。
class ImportCustomersResult {
  const ImportCustomersResult({
    required this.successCount,
    required this.errorCount,
    this.errors,
  });

  final int successCount;
  final int errorCount;
  final List<String>? errors;

  factory ImportCustomersResult.fromJson(Map<String, dynamic> json) {
    return ImportCustomersResult(
      successCount: json['success_count'] as int? ?? 0,
      errorCount: json['error_count'] as int? ?? 0,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}
