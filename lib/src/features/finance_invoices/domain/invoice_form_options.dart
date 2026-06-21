import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';

/// 发票表单所需的基础选项数据（客户、客户订单、施工单）。
class InvoiceFormOptions {
  const InvoiceFormOptions({
    required this.customers,
    required this.salesOrders,
    required this.workOrders,
  });

  final List<Customer> customers;
  final List<SalesOrder> salesOrders;
  final List<WorkOrder> workOrders;
}
