import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';

class WorkOrderListTile extends StatelessWidget {
  const WorkOrderListTile({
    super.key,
    required this.workOrder,
    this.onTap,
  });

  final WorkOrder workOrder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = <String>[];
    if (workOrder.customerName != null) subtitle.add(workOrder.customerName!);
    if (workOrder.productName != null) subtitle.add(workOrder.productName!);
    if (workOrder.statusDisplay != null) subtitle.add(workOrder.statusDisplay!);

    return ListTile(
      onTap: onTap,
      title: Text(workOrder.orderNumber.isEmpty ? '施工单 #${workOrder.id}' : workOrder.orderNumber),
      subtitle: subtitle.isEmpty ? null : Text(subtitle.join(' · ')),
      trailing: workOrder.deliveryDate == null
          ? null
          : Text(
              _formatDate(workOrder.deliveryDate),
              style: Theme.of(context).textTheme.bodySmall,
            ),
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '-';
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
