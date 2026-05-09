import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_sales_order_candidate.dart';

/// Dropdown for selecting sales order.
class SalesOrderDropdown extends StatelessWidget {
  const SalesOrderDropdown({
    required this.salesOrderId,
    required this.salesOrders,
    required this.onChanged,
  });

  final int? salesOrderId;
  final List<WorkOrderSalesOrderCandidate> salesOrders;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = salesOrders
        .map((item) => AppDropdownOption<int>(
              value: item.id,
              label: item.orderNumber,
              secondaryLabel: [
                if (item.customerName?.isNotEmpty == true) item.customerName!,
                if (item.statusDisplay?.isNotEmpty == true) item.statusDisplay!,
              ].join(' · '),
            ))
        .toList();

    return AppSelect<int>(
      value: salesOrderId,
      options: options,
      decoration: const InputDecoration(labelText: '客户订单'),
      selectHintText: salesOrders.isEmpty ? '无可用订单' : '请选择客户订单',
      minOptionsForSearch: 1,
      onChanged: onChanged,
    );
  }
}

/// Dropdown for selecting customer.
class CustomerDropdown extends StatelessWidget {
  const CustomerDropdown({
    required this.customerId,
    required this.customers,
    required this.onChanged,
    this.onCreateCustomer,
  });

  final int? customerId;
  final List<Customer> customers;
  final ValueChanged<int?> onChanged;
  final VoidCallback? onCreateCustomer;

  @override
  Widget build(BuildContext context) {
    final options = customers
        .map((item) => AppDropdownOption<int>(
              value: item.id,
              label: item.name,
            ))
        .toList();
    if (onCreateCustomer != null) {
      options.add(
        AppDropdownOption<int>(
          value: -1,
          label: '新增客户',
          icon: Icons.add,
          onSelected: onCreateCustomer,
        ),
      );
    }

    return AppSelect<int>(
      value: customerId,
      options: options,
      decoration: const InputDecoration(labelText: '客户'),
      selectHintText: customers.isEmpty ? '新增客户' : '请选择客户',
      minOptionsForSearch: 1,
      onChanged: onChanged,
    );
  }
}
