import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';

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
  const SalesOrderCompleteResult({required this.completionReason});

  final String completionReason;
}

Future<SalesOrderPaymentUpdateResult?> showSalesOrderPaymentDialog(
  BuildContext context, {
  String initialAmountText = '',
  String initialDateText = '',
}) async {
  return showDialog<SalesOrderPaymentUpdateResult>(
    context: context,
    builder: (_) => _SalesOrderPaymentDialog(
      initialAmountText: initialAmountText,
      initialDateText: initialDateText,
    ),
  );
}

Future<SalesOrderCompleteResult?> showSalesOrderCompleteDialog(
  BuildContext context, {
  required bool requireReason,
}) async {
  return showDialog<SalesOrderCompleteResult>(
    context: context,
    builder: (_) => _SalesOrderCompleteDialog(requireReason: requireReason),
  );
}

Future<SalesOrderBatchCreateWorkOrderResult?>
showSalesOrderBatchCreateWorkOrdersDialog(
  BuildContext context, {
  required int selectedCount,
}) async {
  return showDialog<SalesOrderBatchCreateWorkOrderResult>(
    context: context,
    builder: (_) =>
        _SalesOrderBatchCreateWorkOrdersDialog(selectedCount: selectedCount),
  );
}

class _SalesOrderPaymentDialog extends StatefulWidget {
  const _SalesOrderPaymentDialog({
    required this.initialAmountText,
    required this.initialDateText,
  });

  final String initialAmountText;
  final String initialDateText;

  @override
  State<_SalesOrderPaymentDialog> createState() =>
      _SalesOrderPaymentDialogState();
}

class _SalesOrderPaymentDialogState extends State<_SalesOrderPaymentDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController amountController = TextEditingController(
    text: widget.initialAmountText,
  );
  late final TextEditingController dateController = TextEditingController(
    text: widget.initialDateText,
  );

  @override
  void dispose() {
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: '更新付款信息',
      formKey: formKey,
      submitText: '更新',
      maxWidth: LayoutTokens.dialogWidthSm,
      onSubmit: _submit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CrudFieldConfig.number(
            label: '已付金额',
            controller: amountController,
            decimal: true,
          ).build(context),
          SizedBox(height: SpacingTokens.md),
          CrudFieldConfig.text(
            label: '付款日期（YYYY-MM-DD）',
            controller: dateController,
          ).build(context),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    Navigator.of(context).pop(
      SalesOrderPaymentUpdateResult(
        amountText: amountController.text.trim(),
        dateText: dateController.text.trim(),
      ),
    );
  }
}

class _SalesOrderCompleteDialog extends StatefulWidget {
  const _SalesOrderCompleteDialog({required this.requireReason});

  final bool requireReason;

  @override
  State<_SalesOrderCompleteDialog> createState() =>
      _SalesOrderCompleteDialogState();
}

class _SalesOrderCompleteDialogState extends State<_SalesOrderCompleteDialog> {
  final formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppActionFormDialog(
      title: '完成订单',
      formKey: formKey,
      submitText: '完成',
      maxWidth: LayoutTokens.dialogWidthSm,
      summary: widget.requireReason
          ? '当前订单尚未全部发货。若业务决定先关闭订单，请填写人工完结原因。'
          : '确认标记该订单为已完成吗？',
      impacts: widget.requireReason
          ? const ['订单会被视为业务已完结', '未发货差额需要已有客户或业务确认依据']
          : const ['订单会进入完成状态', '后续变更建议通过备注或异常流程补充记录'],
      auditHint: widget.requireReason ? '人工完结原因会进入订单流转和审计记录。' : null,
      onSubmit: _submit,
      content: widget.requireReason
          ? CrudFieldConfig.textarea(
              label: '人工完结原因',
              controller: reasonController,
              maxLines: 3,
              hintText: '例如：客户确认尾差不再补发，按已交付数量结案',
              validator: (value) {
                if (!widget.requireReason) return null;
                return (value?.trim().isEmpty ?? true) ? '请填写人工完结原因' : null;
              },
            ).build(context)
          : const SizedBox.shrink(),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      SalesOrderCompleteResult(completionReason: reasonController.text.trim()),
    );
  }
}

class _SalesOrderBatchCreateWorkOrdersDialog extends StatefulWidget {
  const _SalesOrderBatchCreateWorkOrdersDialog({required this.selectedCount});

  final int selectedCount;

  @override
  State<_SalesOrderBatchCreateWorkOrdersDialog> createState() =>
      _SalesOrderBatchCreateWorkOrdersDialogState();
}

class _SalesOrderBatchCreateWorkOrdersDialogState
    extends State<_SalesOrderBatchCreateWorkOrdersDialog> {
  final formKey = GlobalKey<FormState>();
  final deliveryController = TextEditingController();
  final notesController = TextEditingController();
  String priority = 'normal';

  @override
  void dispose() {
    deliveryController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: '批量生成施工单草稿',
      formKey: formKey,
      submitText: '开始生成',
      maxWidth: LayoutTokens.dialogWidthSm,
      onSubmit: _submit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('将为已选择的 ${widget.selectedCount} 张客户订单批量生成施工单草稿。'),
          SizedBox(height: SpacingTokens.md),
          CrudFieldConfig.text(
            label: '统一交货日期（YYYY-MM-DD，可选）',
            controller: deliveryController,
          ).build(context),
          SizedBox(height: SpacingTokens.md),
          AppSelect<String>(
            decoration: const InputDecoration(labelText: '统一优先级'),
            value: priority,
            options: const [
              AppDropdownOption(value: 'low', label: '低'),
              AppDropdownOption(value: 'normal', label: '普通'),
              AppDropdownOption(value: 'high', label: '高'),
              AppDropdownOption(value: 'urgent', label: '紧急'),
            ],
            onChanged: (value) => setState(() => priority = value ?? 'normal'),
          ),
          SizedBox(height: SpacingTokens.md),
          CrudFieldConfig.textarea(
            label: '备注（可选）',
            controller: notesController,
            maxLines: 4,
            hintText: '补充本次批量排产的统一说明',
          ).build(context),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    Navigator.of(context).pop(
      SalesOrderBatchCreateWorkOrderResult(
        priority: priority,
        deliveryDateText: deliveryController.text.trim(),
        notes: notesController.text.trim(),
      ),
    );
  }
}
