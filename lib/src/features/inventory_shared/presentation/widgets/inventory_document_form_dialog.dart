import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_date_picker.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';

typedef InventoryDocumentFieldsBuilder = List<Widget> Function(
  BuildContext context,
  VoidCallback refresh,
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
  return showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: title,
    desktopWidth: width,
    child: _InventoryDocumentFormPanel(
      dateLabel: dateLabel,
      dateController: dateController,
      notesController: notesController,
      fieldsBuilder: fieldsBuilder,
      onSubmit: onSubmit,
      cancelText: cancelText,
      submitText: submitText,
    ),
  );
}

class _InventoryDocumentFormPanel extends StatefulWidget {
  const _InventoryDocumentFormPanel({
    required this.dateLabel,
    required this.dateController,
    required this.notesController,
    required this.fieldsBuilder,
    required this.onSubmit,
    required this.cancelText,
    required this.submitText,
  });

  final String dateLabel;
  final TextEditingController dateController;
  final TextEditingController notesController;
  final InventoryDocumentFieldsBuilder fieldsBuilder;
  final InventoryDocumentSubmit onSubmit;
  final String cancelText;
  final String submitText;

  @override
  State<_InventoryDocumentFormPanel> createState() =>
      _InventoryDocumentFormPanelState();
}

class _InventoryDocumentFormPanelState
    extends State<_InventoryDocumentFormPanel> {
  final formKey = GlobalKey<FormState>();
  bool submitting = false;

  @override
  Widget build(BuildContext context) {
    final fields = widget.fieldsBuilder(context, _refresh, submitting);

    return AdaptiveFormPanel(
      formKey: formKey,
      submitText: widget.submitText,
      cancelText: widget.cancelText,
      submitting: submitting,
      onSubmit: _submit,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._withSpacing(fields),
          if (fields.isNotEmpty) const SizedBox(height: LayoutTokens.gapMd),
          CrudFieldConfig.text(
            label: widget.dateLabel,
            controller: widget.dateController,
            enabled: !submitting,
            readOnly: true,
            onTap: _pickDate,
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFieldConfig.textarea(
            label: '备注',
            controller: widget.notesController,
            enabled: !submitting,
            maxLines: 3,
          ).build(context),
        ],
      ),
    );
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _submit() async {
    if (submitting) return;
    setState(() => submitting = true);
    await widget.onSubmit();
    if (mounted) {
      setState(() => submitting = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showAppDatePicker(
      context: context,
      initialDate: _parseDate(widget.dateController.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      widget.dateController.text = _formatDate(picked);
    }
  }
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
