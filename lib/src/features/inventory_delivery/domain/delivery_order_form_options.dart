import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';

class DeliveryOrderFormOptions {
  const DeliveryOrderFormOptions({
    required this.customers,
    required this.salesOrders,
    required this.products,
  });

  final List<Customer> customers;
  final List<SalesOrder> salesOrders;
  final List<ProductOption> products;
}
