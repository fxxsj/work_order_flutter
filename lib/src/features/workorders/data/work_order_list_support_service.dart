import 'dart:typed_data';

import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_list_support.dart';

class WorkOrderListSupportService {
  WorkOrderListSupportService(this._client);

  final ApiClient _client;

  Future<WorkOrderListFilterOptions> loadFilterOptions() async {
    final customerFuture = CustomerApiService(
      _client,
    ).fetchCustomers(page: 1, pageSize: 50);
    final productFuture = ProductApiService(
      _client,
    ).fetchProducts(pageSize: 50, isActive: true);
    final processFuture = ProcessApiService(
      _client,
    ).fetchProcesses(page: 1, pageSize: 50);

    final customerPage = await customerFuture;
    final productOptions = await productFuture;
    final processPage = await processFuture;

    return WorkOrderListFilterOptions(
      customers: customerPage.items.map((item) => item.toEntity()).toList(),
      products: productOptions,
      processes: processPage.items.map((item) => item.toEntity()).toList(),
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

  String _resolveExportFilename(dynamic response, {required String fallback}) {
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '')
        .split('.')
        .first;
    try {
      final headers = response.headers;
      final contentDisposition =
          headers.value('content-disposition') ??
          headers.value('Content-Disposition');
      if (contentDisposition != null) {
        final match = RegExp(
          'filename=\"?([^\";]+)\"?',
        ).firstMatch(contentDisposition);
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
