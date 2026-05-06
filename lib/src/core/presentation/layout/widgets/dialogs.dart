import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Shared dialog shell for consistent width, scrolling and action layout.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.maxWidth = LayoutTokens.dialogWidthLg,
    this.scrollable = true,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;
  final double maxWidth;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final body = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: scrollable ? SingleChildScrollView(child: content) : content,
    );

    return AlertDialog(
      title: Text(title),
      content: body,
      actions: actions,
    );
  }
}

/// Dialog wrapper that embeds a [Form] and standardized submit/cancel actions.
class AppFormDialog extends StatelessWidget {
  const AppFormDialog({
    super.key,
    required this.title,
    required this.formKey,
    required this.content,
    required this.onSubmit,
    this.onCancel,
    this.submitText = '提交',
    this.cancelText = '取消',
    this.submitting = false,
    this.maxWidth = LayoutTokens.dialogWidthLg,
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final Widget content;
  final Future<void> Function() onSubmit;
  final VoidCallback? onCancel;
  final String submitText;
  final String cancelText;
  final bool submitting;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      maxWidth: maxWidth,
      content: Form(
        key: formKey,
        child: content,
      ),
      actions: [
        TextButton(
          onPressed: submitting
              ? null
              : (onCancel ?? () => Navigator.of(context).pop()),
          child: Text(cancelText),
        ),
        FilledButton(
          onPressed: submitting ? null : onSubmit,
          child: Text(submitting ? '$submitText中...' : submitText),
        ),
      ],
    );
  }
}
