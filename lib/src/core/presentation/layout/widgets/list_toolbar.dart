import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class ListToolbar extends StatelessWidget {
  const ListToolbar({
    super.key,
    required this.isMobile,
    required this.actions,
    this.searchField,
    this.spacing = LayoutTokens.gapSm,
    this.runSpacing = LayoutTokens.gapSm,
    this.mobileActionAlignment = WrapAlignment.end,
  });

  final bool isMobile;
  final Widget? searchField;
  final List<Widget> actions;
  final double spacing;
  final double runSpacing;
  final WrapAlignment mobileActionAlignment;

  @override
  Widget build(BuildContext context) {
    final hasSearch = searchField != null;
    final hasActions = actions.isNotEmpty;

    if (isMobile) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          return SizedBox(
            width: maxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasSearch) searchField!,
                if (hasActions) ...[
                  SizedBox(height: spacing),
                  Wrap(
                    spacing: spacing,
                    runSpacing: runSpacing,
                    alignment: mobileActionAlignment,
                    children: actions,
                  ),
                ],
              ],
            ),
          );
        },
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (hasSearch) searchField!,
        ...actions,
      ],
    );
  }
}
