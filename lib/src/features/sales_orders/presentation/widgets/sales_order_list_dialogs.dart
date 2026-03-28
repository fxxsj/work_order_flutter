import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';

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

Future<SalesOrderPaymentUpdateResult?> showSalesOrderPaymentDialog(
  BuildContext context, {
  String initialAmountText = '',
  String initialDateText = '',
}) async {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController(text: initialAmountText);
  final dateController = TextEditingController(text: initialDateText);
  try {
    SalesOrderPaymentUpdateResult? result;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => FormDialog(
        title: '更新付款信息',
        formKey: formKey,
        submitText: '更新',
        maxWidth: LayoutTokens.dialogWidthSm,
        onSubmit: () async {
          result = SalesOrderPaymentUpdateResult(
            amountText: amountController.text.trim(),
            dateText: dateController.text.trim(),
          );
          Navigator.of(dialogContext).pop();
        },
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: '已付金额'),
            ),
            SizedBox(height: LayoutTokens.gapMd),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: '付款日期（YYYY-MM-DD）',
              ),
            ),
          ],
        ),
      ),
    );
    return result;
  } finally {
    amountController.dispose();
    dateController.dispose();
  }
}

Future<SalesOrderCreateWorkOrderResult?> showSalesOrderCreateWorkOrderDialog(
  BuildContext context, {
  required String initialDeliveryDate,
}) async {
  final formKey = GlobalKey<FormState>();
  String priority = 'normal';
  final quantityController = TextEditingController();
  final deliveryController = TextEditingController(text: initialDeliveryDate);
  final notesController = TextEditingController();
  try {
    SalesOrderCreateWorkOrderResult? result;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return FormDialog(
            title: '生成施工单',
            formKey: formKey,
            submitText: '生成',
            maxWidth: LayoutTokens.dialogWidthSm,
            onSubmit: () async {
              result = SalesOrderCreateWorkOrderResult(
                priority: priority,
                quantityText: quantityController.text.trim(),
                deliveryDateText: deliveryController.text.trim(),
                notes: notesController.text.trim(),
              );
              Navigator.of(dialogContext).pop();
            },
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '生产数量（可选）'),
                ),
                SizedBox(height: LayoutTokens.gapMd),
                TextFormField(
                  controller: deliveryController,
                  decoration: const InputDecoration(
                    labelText: '交货日期（YYYY-MM-DD，可选）',
                  ),
                ),
                SizedBox(height: LayoutTokens.gapMd),
                SearchableDropdownButton(
                  value: priority,
                  onChanged: (value) => setState(() => priority = value),
                ),
                SizedBox(height: LayoutTokens.gapMd),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: '备注（可选）'),
                  maxLines: 3,
                ),
              ],
            ),
          );
        },
      ),
    );
    return result;
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
    builder: (context) => BaseDialog(
      title: '查看施工单',
      maxWidth: LayoutTokens.dialogWidthXs,
      scrollable: false,
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
