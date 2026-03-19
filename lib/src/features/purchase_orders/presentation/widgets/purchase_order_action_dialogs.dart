import 'package:flutter/material.dart';

Future<String?> showPurchaseReasonDialog(
  BuildContext context, {
  required String title,
  String cancelText = '取消',
  String confirmText = '确认',
  String fieldLabel = '原因',
}) async {
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: TextFormField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(labelText: fieldLabel),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(dialogContext).pop(controller.text.trim()),
          child: Text(confirmText),
        ),
      ],
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
