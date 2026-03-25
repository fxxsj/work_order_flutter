import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/risk_action_dialog.dart';

class SalesOrderApprovalResult {
  const SalesOrderApprovalResult({
    required this.comment,
    this.reason,
  });

  final String comment;
  final String? reason;
}

class SalesOrderPaymentUpdateResult {
  const SalesOrderPaymentUpdateResult({
    required this.amountText,
    required this.dateText,
  });

  final String amountText;
  final String dateText;
}

class SalesOrderCreateWorkOrderResult {
  const SalesOrderCreateWorkOrderResult({
    required this.priority,
    required this.quantityText,
    required this.deliveryDateText,
    required this.notes,
  });

  final String priority;
  final String quantityText;
  final String deliveryDateText;
  final String notes;
}

Future<bool> showSalesOrderConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String confirmText,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  return confirmed == true;
}

Future<SalesOrderApprovalResult?> showSalesOrderApproveDialog(
  BuildContext context,
) async {
  final commentController = TextEditingController();
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('审核通过'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(labelText: '审核意见（可选）'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('通过'),
          ),
        ],
      ),
    );
    if (confirmed != true) return null;
    return SalesOrderApprovalResult(comment: commentController.text.trim());
  } finally {
    commentController.dispose();
  }
}

Future<SalesOrderApprovalResult?> showSalesOrderRejectDialog(
  BuildContext context,
) async {
  final reasonController = TextEditingController();
  final commentController = TextEditingController();
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('审核拒绝'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const RiskActionHintPanel(
                summary: '拒绝客户订单后，业务需要补充资料或重新确认交期后再提交。',
                impacts: [
                  '请把缺少的资料、需要修改的内容写清楚',
                  '只写“有问题”会导致业务反复确认，无法直接修正',
                ],
                auditHint: '拒绝原因会直接进入审批和审计记录，后续会被客户、业务、生产共同参考。',
                destructive: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: '拒绝原因'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(labelText: '审核意见（可选）'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('拒绝'),
          ),
        ],
      ),
    );
    if (confirmed != true) return null;
    return SalesOrderApprovalResult(
      reason: reasonController.text.trim(),
      comment: commentController.text.trim(),
    );
  } finally {
    reasonController.dispose();
    commentController.dispose();
  }
}

Future<String?> showSalesOrderCancelDialog(BuildContext context) async {
  final reasonController = TextEditingController();
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('取消订单'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const RiskActionHintPanel(
                summary: '取消客户订单会中断后续施工、发货和财务闭环，相关部门需要同步停单。',
                impacts: [
                  '如果已排产或已出货，请先确认是否应走变更、退货或异常流程',
                  '建议填写取消原因，便于业务和财务后续对账追踪',
                ],
                auditHint: '订单取消原因会影响后续争议处理和经营复盘。',
                destructive: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: '取消原因（可选）'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确认取消'),
          ),
        ],
      ),
    );
    if (confirmed != true) return null;
    return reasonController.text.trim();
  } finally {
    reasonController.dispose();
  }
}

Future<SalesOrderPaymentUpdateResult?> showSalesOrderPaymentDialog(
  BuildContext context,
) async {
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('更新付款信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: '已付金额'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: '付款日期（YYYY-MM-DD）',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('更新'),
          ),
        ],
      ),
    );
    if (confirmed != true) return null;
    return SalesOrderPaymentUpdateResult(
      amountText: amountController.text.trim(),
      dateText: dateController.text.trim(),
    );
  } finally {
    amountController.dispose();
    dateController.dispose();
  }
}

Future<SalesOrderCreateWorkOrderResult?> showSalesOrderCreateWorkOrderDialog(
  BuildContext context, {
  required String initialDeliveryDate,
}) async {
  String priority = 'normal';
  final quantityController = TextEditingController();
  final deliveryController = TextEditingController(text: initialDeliveryDate);
  final notesController = TextEditingController();
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('生成施工单'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '生产数量（可选）'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deliveryController,
                decoration: const InputDecoration(
                  labelText: '交货日期（YYYY-MM-DD，可选）',
                ),
              ),
              const SizedBox(height: 12),
              SearchableDropdownButton(
                value: priority,
                onChanged: (value) => setState(() => priority = value),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: '备注（可选）'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('生成'),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return null;
    return SalesOrderCreateWorkOrderResult(
      priority: priority,
      quantityText: quantityController.text.trim(),
      deliveryDateText: deliveryController.text.trim(),
      notes: notesController.text.trim(),
    );
  } finally {
    quantityController.dispose();
    deliveryController.dispose();
    notesController.dispose();
  }
}

Future<bool> showSalesOrderNavigateToWorkOrderDialog(
  BuildContext context,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('查看施工单'),
      content: const Text('施工单已生成，是否立即查看？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('稍后'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('查看'),
        ),
      ],
    ),
  );
  return confirmed == true;
}

class SearchableDropdownButton extends StatelessWidget {
  const SearchableDropdownButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(labelText: '优先级'),
      items: const [
        DropdownMenuItem(value: 'low', child: Text('低')),
        DropdownMenuItem(value: 'normal', child: Text('普通')),
        DropdownMenuItem(value: 'high', child: Text('高')),
        DropdownMenuItem(value: 'urgent', child: Text('紧急')),
      ],
      onChanged: (next) {
        if (next != null) onChanged(next);
      },
    );
  }
}
