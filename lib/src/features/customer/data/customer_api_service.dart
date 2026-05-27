import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/import_export_util.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/customer/data/salesperson_dto.dart';

/// 客户相关 API 服务。
class CustomerApiService {
  CustomerApiService(this._client);

  final ApiClient _client;

  /// 获取导入/导出服务
  ImportExportService get importExportService => ImportExportService(_client);

  /// 获取客户分页列表。
  Future<CustomerPageDto> fetchCustomers({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? ordering,
  }) async {
    final params = <String, dynamic>{'page': page, 'page_size': pageSize};
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    final trimmedOrdering = ordering?.trim();
    if (trimmedOrdering != null && trimmedOrdering.isNotEmpty) {
      params['ordering'] = trimmedOrdering;
    }

    final response = await _client.get('/customers/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      if (results is List) {
        final list = results
            .whereType<Map>()
            .map(
              (item) => CustomerDto.fromJson(Map<String, dynamic>.from(item)),
            )
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
              (item) => CustomerDto.fromJson(Map<String, dynamic>.from(item)),
            )
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
    final response = await _client.put(
      '/customers/${dto.id}/',
      data: dto.toPayload(),
    );
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

  /// 根据 ID 获取单个客户。
  Future<CustomerDto?> fetchCustomerById(int id) async {
    try {
      final response = await _client.get('/customers/$id/');
      final payload = response.data;
      if (payload is Map<String, dynamic>) {
        return CustomerDto.fromJson(payload);
      }
    } catch (_) {
      // ignore
    }
    return null;
  }

  /// 获取业务员列表。
  Future<List<SalespersonDto>> fetchSalespersons() async {
    final response = await _client.get('/auth/salespersons/');
    final payload = response.data;
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map(
            (item) => SalespersonDto.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    }
    return [];
  }

  /// 检查客户名称是否已存在（用于表单实时验证）
  Future<bool> checkNameExists(String name, {int? excludeId}) async {
    final params = <String, dynamic>{'name': name};
    if (excludeId != null) {
      params['exclude_id'] = excludeId.toString();
    }
    final response = await _client.get(
      '/customers/check_name/',
      queryParameters: params,
    );
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final data = payload['data'];
      if (data is Map<String, dynamic>) {
        return data['exists'] == true;
      }
    }
    return false;
  }
}
