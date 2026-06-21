import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';

/// 收款表单所需的基础选项数据（客户、客户订单、发票）。
class PaymentFormOptions {
  const PaymentFormOptions({
    required this.customers,
    required this.salesOrders,
    required this.invoices,
  });

  final List<Customer> customers;
  final List<SalesOrder> salesOrders;
  final List<Invoice> invoices;
}
