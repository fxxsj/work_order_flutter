import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class EditPageScaffold extends StatelessWidget {
  const EditPageScaffold({
    super.key,
    required this.header,
    required this.body,
    this.footer,
    this.spacing,
    this.contentPadding,
  });

  final Widget header;
  final Widget body;
  final Widget? footer;
  final double? spacing;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final resolvedSpacing = spacing ?? LayoutTokens.formPageSpacing(context);
    final resolvedPadding = contentPadding ?? LayoutTokens.pagePadding(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        SizedBox(height: resolvedSpacing),
        Expanded(
          child: SingleChildScrollView(
            padding: resolvedPadding,
            child: body,
          ),
        ),
        if (footer != null) ...[
          SizedBox(height: resolvedSpacing),
          footer!,
        ],
      ],
    );
  }
}

class EditPageFooterBar extends StatelessWidget {
  const EditPageFooterBar({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final basePadding = LayoutTokens.pagePadding(context);
    final resolvedPadding = padding ??
        EdgeInsets.fromLTRB(
          basePadding.left,
          8,
          basePadding.right,
          basePadding.bottom * 0.7,
        );

    return Container(
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                (colors?.borderColor ?? theme.dividerColor).withValues(alpha: OpacityTokens.heavy),
          ),
        ),
      ),
      child: child,
    );
  }
}
