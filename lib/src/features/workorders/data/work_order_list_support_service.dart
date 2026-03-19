import 'dart:typed_data';

import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_dto.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';

class WorkOrderListFilterOptions {
  const WorkOrderListFilterOptions({
    required this.customers,
    required this.products,
    required this.processes,
  });

  final List<Customer> customers;
  final List<ProductOption> products;
  final List<Process> processes;
}

class WorkOrderExportResult {
  const WorkOrderExportResult({
    required this.bytes,
    required this.filename,
  });

  final Uint8List bytes;
  final String filename;
}

class WorkOrderListSupportService {
  WorkOrderListSupportService(this._client);

  final ApiClient _client;

  Future<WorkOrderListFilterOptions> loadFilterOptions() async {
    final results = await Future.wait([
      CustomerApiService(_client).fetchCustomers(page: 1, pageSize: 200),
      ProductApiService(_client).fetchProducts(pageSize: 200, isActive: true),
      ProcessApiService(_client).fetchProcesses(page: 1, pageSize: 200),
    ]);
    final customerPage = results[0] as CustomerPageDto;
    final productOptions = results[1] as List<ProductOption>;
    final processPage = results[2] as ProcessPageDto;
    return WorkOrderListFilterOptions(
      customers:
          customerPage.items.map<Customer>((item) => item.toEntity()).toList(),
      products: productOptions,
      processes:
          processPage.items.map<Process>((item) => item.toEntity()).toList(),
    );
  }

  Future<WorkOrderExportResult> export(Map<String, dynamic> params) async {
    final response = await WorkOrderApiService(_client).export(params: params);
    final data = response.data;
    final bytes = data is Uint8List
        ? data
        : data is List<int>
            ? Uint8List.fromList(data)
            : null;
    if (bytes == null) {
      throw const FormatException('返回格式不支持');
    }
    return WorkOrderExportResult(
      bytes: bytes,
      filename: _resolveExportFilename(response, fallback: '施工单列表'),
    );
  }

  String _resolveExportFilename(
    dynamic response, {
    required String fallback,
  }) {
    final timestamp =
        DateTime.now().toIso8601String().replaceAll(':', '').split('.').first;
    try {
      final headers = response.headers;
      final contentDisposition = headers.value('content-disposition') ??
          headers.value('Content-Disposition');
      if (contentDisposition != null) {
        final match =
            RegExp('filename=\"?([^\";]+)\"?').firstMatch(contentDisposition);
        if (match != null) {
          return match.group(1) ?? '${fallback}_$timestamp.xlsx';
        }
      }
    } catch (_) {
      // ignore header parsing errors
    }
    return '${fallback}_$timestamp.xlsx';
  }
}
