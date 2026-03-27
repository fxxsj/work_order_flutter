import 'package:flutter/material.dart';

typedef InventoryDocumentFieldsBuilder = List<Widget> Function(
  BuildContext context,
  StateSetter setState,
  bool submitting,
);

typedef InventoryDocumentSubmit = Future<void> Function();

Future<void> showInventoryDocumentFormDialog(
  BuildContext context, {
  required String title,
  required String dateLabel,
  required TextEditingController dateController,
  required TextEditingController notesController,
  required InventoryDocumentFieldsBuilder fieldsBuilder,
  required InventoryDocumentSubmit onSubmit,
  String cancelText = '取消',
  String submitText = '保存',
  double width = 520,
}) {
  bool submitting = false;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> submit() async {
            if (submitting) return;
            setState(() => submitting = true);
            await onSubmit();
            if (dialogContext.mounted) {
              setState(() => submitting = false);
            }
          }

          final fields = fieldsBuilder(context, setState, submitting);

          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._withSpacing(fields),
                    if (fields.isNotEmpty) const SizedBox(height: 12),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      enabled: !submitting,
                      decoration: InputDecoration(
                        labelText: dateLabel,
                        border: const OutlineInputBorder(),
                        suffixIcon:
                            const Icon(Icons.calendar_today_outlined, size: 18),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              _parseDate(dateController.text) ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          dateController.text = _formatDate(picked);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      enabled: !submitting,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: '备注',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    submitting ? null : () => Navigator.of(dialogContext).pop(),
                child: Text(cancelText),
              ),
              FilledButton(
                onPressed: submitting ? null : submit,
                child: Text(submitting ? '保存中...' : submitText),
              ),
            ],
          );
        },
      );
    },
  );
}

List<Widget> _withSpacing(List<Widget> children) {
  if (children.isEmpty) return const [];
  final result = <Widget>[];
  for (var i = 0; i < children.length; i++) {
    if (i > 0) {
      result.add(const SizedBox(height: 12));
    }
    result.add(children[i]);
  }
  return result;
}

DateTime? _parseDate(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return DateTime.tryParse(trimmed);
}

String _formatDate(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
