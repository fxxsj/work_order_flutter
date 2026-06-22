import 'dart:typed_data';

import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

/// 施工单列表筛选项。
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

/// 施工单导出结果。
class WorkOrderExportResult {
  const WorkOrderExportResult({required this.bytes, required this.filename});

  final Uint8List bytes;
  final String filename;
}
