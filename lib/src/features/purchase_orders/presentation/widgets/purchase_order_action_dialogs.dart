import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';

Future<String?> showPurchaseReasonDialog(
  BuildContext context, {
  required String title,
  String cancelText = '取消',
  String confirmText = '确认',
  String fieldLabel = '原因',
}) async {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (dialogContext) => FormDialog(
      title: title,
      formKey: formKey,
      submitText: confirmText,
      cancelText: cancelText,
      maxWidth: 420,
      onSubmit: () async =>
          Navigator.of(dialogContext).pop(controller.text.trim()),
      content: TextFormField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(labelText: fieldLabel),
      ),
    ),
  );
  controller.dispose();
  if (result == null || result.trim().isEmpty) return null;
  return result.trim();
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
