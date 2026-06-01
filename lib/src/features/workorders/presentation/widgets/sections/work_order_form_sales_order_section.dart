import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_sales_order_candidate.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_card.dart';

/// Sales order section for work order form.
class WorkOrderSalesOrderSection extends StatelessWidget {
  const WorkOrderSalesOrderSection({
    super.key,
    required this.salesOrderId,
    required this.salesOrders,
    required this.onSalesOrderChanged,
  });

  final int? salesOrderId;
  final List<WorkOrderSalesOrderCandidate> salesOrders;
  final ValueChanged<int?> onSalesOrderChanged;

  @override
  Widget build(BuildContext context) {
    final options = <AppDropdownOption<int>>[
      const AppDropdownOption<int>(value: -1, label: '不关联客户订单'),
      ...salesOrders.map(
        (item) => AppDropdownOption<int>(
          value: item.id,
          label: item.orderNumber,
          secondaryLabel: [
            if (item.customerName?.isNotEmpty == true) item.customerName!,
            if (item.statusDisplay?.isNotEmpty == true) item.statusDisplay!,
          ].join(' · '),
        ),
      ),
    ];

    return WorkOrderFormSectionCard(
      title: '来源客户订单',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelect<int>(
            value: salesOrderId,
            options: options,
            decoration: const InputDecoration(
              labelText: '客户订单',
              helperText: '仅显示仍有未开施工单产品的客户订单，选择后会同步限制可选产品',
            ),
            selectHintText: salesOrders.isEmpty ? '暂无可关联客户订单' : '请选择',
            minOptionsForSearch: 1,
            onChanged: onSalesOrderChanged,
          ),
        ],
      ),
    );
  }
}
