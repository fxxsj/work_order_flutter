import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/utils/file_download.dart';
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

  /// 导出客户列表 Excel。
  @override
  Future<void> exportCustomers() async {
    try {
      final response = await _apiService.exportCustomers();
      final bytes = response.data;
      if (bytes is List<int>) {
        await saveBytes(Uint8List.fromList(bytes), 'customers.xlsx');
      }
    } on ApiException catch (err) {
      throw Exception(err.message.isNotEmpty ? err.message : '导出客户列表失败');
    } catch (err) {
      throw Exception('导出客户列表失败: $err');
    }
  }

  /// 导入客户 Excel。
  @override
  Future<ImportCustomersResult> importCustomers(PlatformFile file) async {
    try {
      final extension = file.extension?.toLowerCase();
      String contentType;
      if (extension == 'xlsx') {
        contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      } else if (extension == 'xls') {
        contentType = 'application/vnd.ms-excel';
      } else {
        contentType = 'application/octet-stream';
      }
      final multipartFile = MultipartFile.fromBytes(
        file.bytes!,
        filename: file.name,
        contentType: DioMediaType.parse(contentType),
      );
      return await _apiService.importCustomers(multipartFile);
    } on ApiException catch (err) {
      throw Exception(err.message.isNotEmpty ? err.message : '导入客户列表失败');
    } catch (err) {
      throw Exception('导入客户列表失败: $err');
    }
  }
}
