import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';

Future<String?> showPurchaseReasonDialog(
  BuildContext context, {
  required String title,
  String cancelText = '取消',
  String confirmText = '确认',
  String fieldLabel = '原因',
}) async {
  final result = await showDialog<String>(
    context: context,
    builder: (_) => _PurchaseReasonDialog(
      title: title,
      cancelText: cancelText,
      confirmText: confirmText,
      fieldLabel: fieldLabel,
    ),
  );
  if (result == null || result.trim().isEmpty) return null;
  return result.trim();
}

class _PurchaseReasonDialog extends StatefulWidget {
  const _PurchaseReasonDialog({
    required this.title,
    required this.cancelText,
    required this.confirmText,
    required this.fieldLabel,
  });

  final String title;
  final String cancelText;
  final String confirmText;
  final String fieldLabel;

  @override
  State<_PurchaseReasonDialog> createState() => _PurchaseReasonDialogState();
}

class _PurchaseReasonDialogState extends State<_PurchaseReasonDialog> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppActionFormDialog(
      title: widget.title,
      formKey: formKey,
      submitText: widget.confirmText,
      cancelText: widget.cancelText,
      maxWidth: LayoutTokens.dialogWidthSm,
      destructive: true,
      summary: '请填写本次操作原因，提交后会进入采购单流转记录。',
      impacts: const [
        '原因会作为后续审批、退回或取消处理依据',
        '建议写清具体差异、责任方或下一步处理方式',
      ],
      onSubmit: _submit,
      content: CrudFieldConfig.textarea(
        label: widget.fieldLabel,
        controller: controller,
        maxLines: 3,
      ).build(context),
    );
  }

  Future<void> _submit() async {
    Navigator.of(context).pop(controller.text.trim());
  }
}

Future<DateTime?> showPurchaseDateDialog(
  BuildContext context, {
  required String title,
}) {
  final now = DateTime.now();
  return showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(now.year - 5),
    lastDate: DateTime(now.year + 5),
    helpText: title,
  );
}
