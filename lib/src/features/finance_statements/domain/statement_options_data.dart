import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';

class StatementOptionsData {
  const StatementOptionsData({
    required this.customers,
    required this.suppliers,
  });

  final List<Customer> customers;
  final List<Supplier> suppliers;
}
