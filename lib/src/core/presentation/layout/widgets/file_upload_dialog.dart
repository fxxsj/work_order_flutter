import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/file_upload_field.dart';

/// Shows a standardized file upload dialog backed by [CrudFormField.fileUpload].
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
}) async {
  final formKey = GlobalKey<FormState>();
  CrudPickedFile? pickedFile;

  return showDialog<CrudPickedFile>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) {
        return AppFormDialog(
          title: title,
          formKey: formKey,
          submitText: submitText,
          maxWidth: maxWidth,
          onSubmit: () async {
            if (!(formKey.currentState?.validate() ?? false)) {
              return;
            }
            Navigator.of(dialogContext).pop(pickedFile);
          },
          content: CrudFormField.fileUpload(
            label: label,
            value: pickedFile,
            allowedExtensions: allowedExtensions,
            fallbackFilename: fallbackFilename,
            helperText: helperText,
            hintText: hintText,
            validator: (value) => value == null ? '请选择文件' : null,
            onChanged: (value) => setState(() => pickedFile = value),
          ).build(context),
        );
      },
    ),
  );
}
