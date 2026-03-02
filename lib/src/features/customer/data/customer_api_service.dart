import 'package:work_order_app/common/http_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/customer/data/salesperson_dto.dart';

/// 客户相关 API 服务。
class CustomerApiService {
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

    final response = await HttpClient.get('/customers/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => CustomerDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <CustomerDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return CustomerPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => CustomerDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return CustomerPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const CustomerPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  /// 创建客户。
  Future<CustomerDto> createCustomer(CustomerDto dto) async {
    final response = await HttpClient.post('/customers/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return CustomerDto.fromJson(map);
  }

  /// 更新客户。
  Future<CustomerDto> updateCustomer(CustomerDto dto) async {
    final response = await HttpClient.put('/customers/${dto.id}/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return CustomerDto.fromJson(map);
  }

  /// 删除客户。
  Future<void> deleteCustomer(int id) async {
    await HttpClient.delete('/customers/$id/');
  }

  /// 获取业务员列表。
  Future<List<SalespersonDto>> fetchSalespersons() async {
    final response = await HttpClient.get('/auth/salespersons/');
    final payload = response.data;
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map((item) => SalespersonDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return [];
  }
}
