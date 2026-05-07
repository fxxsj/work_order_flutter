import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';

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
  final formKey = GlobalKey<FormState>();
  bool submitting = false;

  return showAdaptiveFilterDrawer(
    context,
    isMobile: BreakpointsUtil.isMobile(context),
    title: title,
    desktopWidth: width,
    child: StatefulBuilder(
      builder: (context, setState) {
        Future<void> submit() async {
          if (submitting) return;
          setState(() => submitting = true);
          await onSubmit();
          if (context.mounted) {
            setState(() => submitting = false);
          }
        }

        final fields = fieldsBuilder(context, setState, submitting);

        return AdaptiveFormPanel(
          formKey: formKey,
          submitText: submitText,
          cancelText: cancelText,
          submitting: submitting,
          onSubmit: submit,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._withSpacing(fields),
              if (fields.isNotEmpty) const SizedBox(height: LayoutTokens.gapMd),
              CrudFieldConfig.text(
                label: dateLabel,
                controller: dateController,
                enabled: !submitting,
                readOnly: true,
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
              ).build(context),
              const SizedBox(height: LayoutTokens.gapMd),
              CrudFieldConfig.textarea(
                label: '备注',
                controller: notesController,
                enabled: !submitting,
                maxLines: 3,
              ).build(context),
            ],
          ),
        );
      },
    ),
  );
}

List<Widget> _withSpacing(List<Widget> children) {
  if (children.isEmpty) return const [];
  final result = <Widget>[];
  for (var i = 0; i < children.length; i++) {
    if (i > 0) {
      result.add(const SizedBox(height: LayoutTokens.gapMd));
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
