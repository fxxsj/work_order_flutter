import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Shared modal shell with a consistent header, body and footer layout.
class AppModalShell extends StatelessWidget {
  const AppModalShell({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.leadingActions = const [],
    this.titleActions = const [],
    this.maxWidth = LayoutTokens.dialogWidthLg,
    this.maxHeight,
    this.scrollable = true,
    this.showCloseButton = false,
    this.bodyPadding = const EdgeInsets.fromLTRB(
      LayoutTokens.gapLg,
      LayoutTokens.gapMd,
      LayoutTokens.gapLg,
      LayoutTokens.gapLg,
    ),
    this.footerPadding = const EdgeInsets.fromLTRB(
      LayoutTokens.gapLg,
      LayoutTokens.gapMd,
      LayoutTokens.gapLg,
      LayoutTokens.gapLg,
    ),
    this.insetPadding = const EdgeInsets.all(LayoutTokens.gapLg),
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final List<Widget> leadingActions;
  final List<Widget> titleActions;
  final double maxWidth;
  final double? maxHeight;
  final bool scrollable;
  final bool showCloseButton;
  final EdgeInsetsGeometry bodyPadding;
  final EdgeInsetsGeometry footerPadding;
  final EdgeInsets insetPadding;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);
    final effectiveMaxHeight =
        maxHeight ?? (mediaSize.height - insetPadding.vertical);
    final effectiveMaxWidth =
        maxWidth.clamp(0, mediaSize.width - insetPadding.horizontal).toDouble();

    return Dialog(
      insetPadding: insetPadding,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: effectiveMaxWidth,
          maxHeight: effectiveMaxHeight,
        ),
        child: AppModalScaffold(
          title: title,
          body: body,
          actions: actions,
          leadingActions: leadingActions,
          titleActions: titleActions,
          scrollable: scrollable,
          showCloseButton: showCloseButton,
          bodyPadding: bodyPadding,
          footerPadding: footerPadding,
        ),
      ),
    );
  }
}

/// Embeddable modal layout for dialogs, bottom sheets and picker popups.
class AppModalScaffold extends StatelessWidget {
  const AppModalScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.leadingActions = const [],
    this.titleActions = const [],
    this.scrollable = true,
    this.showCloseButton = false,
    this.bodyPadding = const EdgeInsets.fromLTRB(
      LayoutTokens.gapLg,
      LayoutTokens.gapMd,
      LayoutTokens.gapLg,
      LayoutTokens.gapLg,
    ),
    this.footerPadding = const EdgeInsets.fromLTRB(
      LayoutTokens.gapLg,
      LayoutTokens.gapMd,
      LayoutTokens.gapLg,
      LayoutTokens.gapLg,
    ),
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final List<Widget> leadingActions;
  final List<Widget> titleActions;
  final bool scrollable;
  final bool showCloseButton;
  final EdgeInsetsGeometry bodyPadding;
  final EdgeInsetsGeometry footerPadding;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        );
    final hasFooter = leadingActions.isNotEmpty || actions.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            LayoutTokens.gapLg,
            LayoutTokens.gapMd,
            LayoutTokens.gapSm,
            LayoutTokens.gapSm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: titleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ...titleActions,
              if (showCloseButton)
                IconButton(
                  tooltip: '关闭',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Flexible(
          child: Padding(
            padding: bodyPadding,
            child: scrollable
                ? SingleChildScrollView(child: body)
                : ClipRect(child: body),
          ),
        ),
        if (hasFooter) ...[
          const Divider(height: 1),
          Padding(
            padding: footerPadding,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compactFooter = constraints.maxWidth < 360;
                final leadingGroup = _ModalActionGroup(
                  alignment:
                      compactFooter ? WrapAlignment.end : WrapAlignment.start,
                  children: leadingActions,
                );
                final trailingGroup = _ModalActionGroup(
                  alignment: WrapAlignment.end,
                  children: actions,
                );

                if (compactFooter) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (leadingActions.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: leadingGroup,
                        ),
                      if (leadingActions.isNotEmpty && actions.isNotEmpty)
                        SizedBox(height: LayoutTokens.gapSm),
                      if (actions.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: trailingGroup,
                        ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leadingActions.isNotEmpty)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: leadingGroup,
                        ),
                      ),
                    if (leadingActions.isNotEmpty && actions.isNotEmpty)
                      SizedBox(width: LayoutTokens.gapSm),
                    if (actions.isNotEmpty)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: trailingGroup,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _ModalActionGroup extends StatelessWidget {
  const _ModalActionGroup({
    required this.children,
    required this.alignment,
  });

  final List<Widget> children;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: LayoutTokens.gapSm,
      runSpacing: LayoutTokens.gapSm,
      alignment: alignment,
      children: children,
    );
  }
}

/// Shared dialog shell for consistent width, scrolling and action layout.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.maxWidth = LayoutTokens.dialogWidthLg,
    this.scrollable = true,
    this.showCloseButton = false,
    this.titleActions = const [],
  });

  final String title;
  final Widget content;
  final List<Widget> actions;
  final double maxWidth;
  final bool scrollable;
  final bool showCloseButton;
  final List<Widget> titleActions;

  @override
  Widget build(BuildContext context) {
    return AppModalShell(
      title: title,
      maxWidth: maxWidth,
      scrollable: scrollable,
      showCloseButton: showCloseButton,
      titleActions: titleActions,
      body: content,
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
