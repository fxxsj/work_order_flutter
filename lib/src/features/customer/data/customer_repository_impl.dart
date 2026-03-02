import 'package:work_order_app/common/api_exception.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';
import 'package:work_order_app/src/features/customer/domain/salesperson.dart';

/// 客户仓库实现，负责与 API 通信并转换数据。
class CustomerRepositoryImpl implements CustomerRepository {
  CustomerRepositoryImpl(this._apiService);

  final CustomerApiService _apiService;

  /// 获取客户列表。
  @override
  Future<CustomerPage> getCustomers({int page = 1, int pageSize = 20, String? search}) async {
    try {
      final dto = await _apiService.fetchCustomers(page: page, pageSize: pageSize, search: search);
      return dto.toEntity();
    } on ApiException catch (err) {
      throw Exception(err.message.isNotEmpty ? err.message : '获取客户列表失败');
    } catch (err) {
      throw Exception('获取客户列表失败: $err');
    }
  }

  /// 创建客户。
  @override
  Future<Customer> createCustomer(Customer customer) async {
    try {
      final dto = CustomerDto.fromEntity(customer);
      final created = await _apiService.createCustomer(dto);
      return created.toEntity();
    } on ApiException catch (err) {
      throw Exception(err.message.isNotEmpty ? err.message : '创建客户失败');
    } catch (err) {
      throw Exception('创建客户失败: $err');
    }
  }

  /// 更新客户。
  @override
  Future<Customer> updateCustomer(Customer customer) async {
    try {
      final dto = CustomerDto.fromEntity(customer);
      final updated = await _apiService.updateCustomer(dto);
      return updated.toEntity();
    } on ApiException catch (err) {
      throw Exception(err.message.isNotEmpty ? err.message : '更新客户失败');
    } catch (err) {
      throw Exception('更新客户失败: $err');
    }
  }

  /// 删除客户。
  @override
  Future<void> deleteCustomer(int id) async {
    try {
      await _apiService.deleteCustomer(id);
    } on ApiException catch (err) {
      throw Exception(err.message.isNotEmpty ? err.message : '删除客户失败');
    } catch (err) {
      throw Exception('删除客户失败: $err');
    }
  }

  /// 获取业务员列表。
  @override
  Future<List<Salesperson>> getSalespersons() async {
    try {
      final dtoList = await _apiService.fetchSalespersons();
      return dtoList.map((item) => item.toEntity()).toList();
    } on ApiException catch (err) {
      throw Exception(err.message.isNotEmpty ? err.message : '获取业务员列表失败');
    } catch (err) {
      throw Exception('获取业务员列表失败: $err');
    }
  }
}
