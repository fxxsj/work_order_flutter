import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';

/// Shows a standardized file upload dialog backed by [CrudFieldConfig.fileUpload].
Future<CrudPickedFile?> showFileUploadDialog(
  BuildContext context, {
  required String title,
  required String label,
  required List<String> allowedExtensions,
  required String fallbackFilename,
  String? helperText,
  String? hintText,
  String submitText = '上传',
  double maxWidth = LayoutTokens.dialogWidthMd,
  FileUploadPicker? picker,
}) async {
  return showDialog<CrudPickedFile>(
    context: context,
    builder: (_) => _FileUploadDialog(
      title: title,
      label: label,
      allowedExtensions: allowedExtensions,
      fallbackFilename: fallbackFilename,
      helperText: helperText,
      hintText: hintText,
      submitText: submitText,
      maxWidth: maxWidth,
      picker: picker,
    ),
  );
}

class _FileUploadDialog extends StatefulWidget {
  const _FileUploadDialog({
    required this.title,
    required this.label,
    required this.allowedExtensions,
    required this.fallbackFilename,
    required this.submitText,
    required this.maxWidth,
    this.helperText,
    this.hintText,
    this.picker,
  });

  final String title;
  final String label;
  final List<String> allowedExtensions;
  final String fallbackFilename;
  final String? helperText;
  final String? hintText;
  final String submitText;
  final double maxWidth;
  final FileUploadPicker? picker;

  @override
  State<_FileUploadDialog> createState() => _FileUploadDialogState();
}

class _FileUploadDialogState extends State<_FileUploadDialog> {
  final formKey = GlobalKey<FormState>();
  CrudPickedFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: widget.title,
      formKey: formKey,
      submitText: widget.submitText,
      maxWidth: widget.maxWidth,
      onSubmit: _submit,
      content: CrudFieldConfig.fileUpload(
        label: widget.label,
        value: pickedFile,
        allowedExtensions: widget.allowedExtensions,
        fallbackFilename: widget.fallbackFilename,
        helperText: widget.helperText,
        hintText: widget.hintText,
        picker: widget.picker,
        validator: (value) => value == null ? '请选择文件' : null,
        onChanged: (value) => setState(() => pickedFile = value),
      ).build(context),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    Navigator.of(context).pop(pickedFile);
  }
}
