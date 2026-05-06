import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';

class SalesOrderPaymentUpdateResult {
  const SalesOrderPaymentUpdateResult({
    required this.amountText,
    required this.dateText,
  });

  final String amountText;
  final String dateText;
}

class SalesOrderBatchCreateWorkOrderResult {
  const SalesOrderBatchCreateWorkOrderResult({
    required this.priority,
    required this.deliveryDateText,
    required this.notes,
  });

  final String priority;
  final String deliveryDateText;
  final String notes;
}

class SalesOrderCompleteResult {
  const SalesOrderCompleteResult({
    required this.completionReason,
  });

  final String completionReason;
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
      builder: (dialogContext) => AppFormDialog(
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
            CrudFormField.number(
              label: '已付金额',
              controller: amountController,
              decimal: true,
            ).build(dialogContext),
            SizedBox(height: LayoutTokens.gapMd),
            CrudFormField.text(
              label: '付款日期（YYYY-MM-DD）',
              controller: dateController,
            ).build(dialogContext),
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

Future<SalesOrderCompleteResult?> showSalesOrderCompleteDialog(
  BuildContext context, {
  required bool requireReason,
}) async {
  final formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();
  try {
    SalesOrderCompleteResult? result;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AppFormDialog(
        title: '完成订单',
        formKey: formKey,
        submitText: '完成',
        maxWidth: LayoutTokens.dialogWidthSm,
        onSubmit: () async {
          result = SalesOrderCompleteResult(
            completionReason: reasonController.text.trim(),
          );
          Navigator.of(dialogContext).pop();
        },
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              requireReason
                  ? '当前订单尚未全部发货。若业务决定先关闭订单，请填写人工完结原因。'
                  : '确认标记该订单为已完成吗？',
            ),
            if (requireReason) ...[
              SizedBox(height: LayoutTokens.gapMd),
              CrudFormField.textarea(
                label: '人工完结原因',
                controller: reasonController,
                maxLines: 3,
                hintText: '例如：客户确认尾差不再补发，按已交付数量结案',
                validator: (value) {
                  if (!requireReason) return null;
                  return (value?.trim().isEmpty ?? true) ? '请填写人工完结原因' : null;
                },
              ).build(dialogContext),
            ],
          ],
        ),
      ),
    );
    return result;
  } finally {
    reasonController.dispose();
  }
}

Future<SalesOrderBatchCreateWorkOrderResult?>
    showSalesOrderBatchCreateWorkOrdersDialog(
  BuildContext context, {
  required int selectedCount,
}) async {
  final formKey = GlobalKey<FormState>();
  final deliveryController = TextEditingController();
  final notesController = TextEditingController();
  String priority = 'normal';

  try {
    SalesOrderBatchCreateWorkOrderResult? result;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AppFormDialog(
          title: '批量生成施工单',
          formKey: formKey,
          submitText: '开始生成',
          maxWidth: LayoutTokens.dialogWidthSm,
          onSubmit: () async {
            result = SalesOrderBatchCreateWorkOrderResult(
              priority: priority,
              deliveryDateText: deliveryController.text.trim(),
              notes: notesController.text.trim(),
            );
            Navigator.of(dialogContext).pop();
          },
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('将为已选择的 $selectedCount 张客户订单批量生成施工单。'),
              SizedBox(height: LayoutTokens.gapMd),
              CrudFormField.text(
                label: '统一交货日期（YYYY-MM-DD，可选）',
                controller: deliveryController,
              ).build(dialogContext),
              SizedBox(height: LayoutTokens.gapMd),
              UnifiedDropdown<String>(
                decoration: const InputDecoration(labelText: '统一优先级'),
                value: priority,
                options: const [
                  DropdownOption(value: 'low', label: '低'),
                  DropdownOption(value: 'normal', label: '普通'),
                  DropdownOption(value: 'high', label: '高'),
                  DropdownOption(value: 'urgent', label: '紧急'),
                ],
                onChanged: (value) =>
                    setState(() => priority = value ?? 'normal'),
              ),
              SizedBox(height: LayoutTokens.gapMd),
              CrudFormField.textarea(
                label: '备注（可选）',
                controller: notesController,
                maxLines: 4,
                hintText: '补充本次批量排产的统一说明',
              ).build(dialogContext),
            ],
          ),
        ),
      ),
    );
    return result;
  } finally {
    deliveryController.dispose();
    notesController.dispose();
  }
}
