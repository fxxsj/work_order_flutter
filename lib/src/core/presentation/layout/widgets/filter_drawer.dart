import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';

Future<void> showAdaptiveFilterDrawer(
  BuildContext context, {
  required bool isMobile,
  required Widget child,
  String title = '筛选',
  double desktopWidth = LayoutTokens.dialogWidthXs,
}) {
  if (isMobile) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (sheetContext) {
        return FilterDrawerShell(
          title: title,
          child: child,
        );
      },
    );
  }

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    barrierColor: Theme.of(context).shadowColor.withValues(
          alpha: LayoutTokens.barrierOpacity,
        ),
    transitionDuration: AnimationTokens.slide,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Theme.of(dialogContext).colorScheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: SizedBox(
            width: desktopWidth,
            height: double.infinity,
            child: SafeArea(
              child: FilterDrawerShell(
                title: title,
                child: child,
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final offsetTween =
          Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
      return SlideTransition(
        position: animation
            .drive(CurveTween(curve: Curves.easeOutCubic))
            .drive(offsetTween),
        child: child,
      );
    },
  );
}

class FilterDrawerShell extends StatelessWidget {
  const FilterDrawerShell({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: '关闭',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}

class FilterPanelBody extends StatelessWidget {
  const FilterPanelBody({
    super.key,
    required this.fields,
    required this.onReset,
    required this.bottomSpacing,
    this.resetLabel = '重置筛选',
    this.doneLabel = '完成',
    this.padding = const EdgeInsets.fromLTRB(
      LayoutTokens.gapLg,
      LayoutTokens.gapMd,
      LayoutTokens.gapLg,
      LayoutTokens.gapLg + LayoutTokens.gapXs,
    ),
  });

  final List<Widget> fields;
  final VoidCallback onReset;
  final double bottomSpacing;
  final String resetLabel;
  final String doneLabel;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    return ListView(
      padding: padding,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < fields.length; index++) ...[
              if (index > 0) SizedBox(height: spacing),
              fields[index],
            ],
            SizedBox(height: bottomSpacing < spacing ? spacing : bottomSpacing),
            Row(
              children: [
                PageActionButton.outlined(
                  onPressed: onReset,
                  icon: const Icon(Icons.restart_alt, size: 16),
                  label: resetLabel,
                ),
                SizedBox(width: spacing),
                PageActionButton.filled(
                  onPressed: () => Navigator.of(context).maybePop(),
                  label: doneLabel,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class AdaptiveFormPanel extends StatelessWidget {
  const AdaptiveFormPanel({
    super.key,
    required this.formKey,
    required this.child,
    required this.onSubmit,
    this.onCancel,
    this.submitText = '提交',
    this.cancelText = '取消',
    this.submitting = false,
    this.submitEnabled = true,
    this.padding = const EdgeInsets.fromLTRB(
      LayoutTokens.gapLg,
      LayoutTokens.gapLg,
      LayoutTokens.gapLg,
      LayoutTokens.gapLg + LayoutTokens.gapXs,
    ),
    this.footerPadding = const EdgeInsets.fromLTRB(
      LayoutTokens.gapLg,
      LayoutTokens.gapMd,
      LayoutTokens.gapLg,
      LayoutTokens.gapLg,
    ),
  });

  final GlobalKey<FormState> formKey;
  final Widget child;
  final Future<void> Function() onSubmit;
  final VoidCallback? onCancel;
  final String submitText;
  final String cancelText;
  final bool submitting;
  final bool submitEnabled;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry footerPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.dividerColor.withValues(
      alpha: OpacityTokens.border,
    );

    return Column(
      children: [
        Expanded(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: padding,
              child: child,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(top: BorderSide(color: dividerColor)),
          ),
          child: Padding(
            padding: footerPadding,
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: submitting
                      ? null
                      : (onCancel ?? () => Navigator.of(context).maybePop()),
                  child: Text(cancelText),
                ),
                const SizedBox(width: LayoutTokens.gapSm),
                FilledButton(
                  onPressed: submitting || !submitEnabled ? null : onSubmit,
                  child: Text(submitting ? '$submitText中...' : submitText),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
