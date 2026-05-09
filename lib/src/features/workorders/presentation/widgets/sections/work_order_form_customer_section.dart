import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_card.dart';

/// Customer information section for work order form.
class WorkOrderCustomerSection extends StatelessWidget {
  const WorkOrderCustomerSection({
    super.key,
    required this.customerId,
    required this.customers,
    required this.onCustomerChanged,
    this.requiredSelection = true,
    this.onCreateCustomer,
  });

  final int? customerId;
  final List<Customer> customers;
  final ValueChanged<int?> onCustomerChanged;
  final bool requiredSelection;
  final VoidCallback? onCreateCustomer;

  @override
  Widget build(BuildContext context) {
    final options = customers
        .map(
          (item) => AppDropdownOption<int>(
            value: item.id,
            label: item.name,
          ),
        )
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

    return WorkOrderFormSectionCard(
      title: '客户信息',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelect<int>(
            value: customerId,
            options: options,
            decoration: const InputDecoration(labelText: '客户'),
            selectHintText: customers.isEmpty ? '新增客户' : '请选择',
            minOptionsForSearch: 1,
            onChanged: (value) => onCustomerChanged(value),
            validator: (value) =>
                requiredSelection && value == null ? '请选择客户' : null,
          ),
          if (customers.isEmpty && onCreateCustomer != null) ...[
            const SizedBox(height: LayoutTokens.gapSm),
            TextButton.icon(
              onPressed: onCreateCustomer,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('新增客户'),
            ),
          ],
        ],
      ),
    );
  }
}
