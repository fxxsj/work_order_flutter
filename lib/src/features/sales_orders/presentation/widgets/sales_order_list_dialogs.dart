import 'package:flutter/material.dart';

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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(labelText: '取消原因（可选）'),
          maxLines: 3,
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
