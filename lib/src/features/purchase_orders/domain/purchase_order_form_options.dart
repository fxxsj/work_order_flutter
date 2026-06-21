import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';

/// 采购单表单所需的基础选项数据。
class PurchaseOrderFormOptions {
  const PurchaseOrderFormOptions({
    required this.suppliers,
    required this.materials,
    required this.workOrders,
  });

  final List<Supplier> suppliers;
  final List<MaterialItem> materials;
  final List<WorkOrder> workOrders;
}
