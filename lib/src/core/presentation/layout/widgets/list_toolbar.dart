import 'package:flutter/material.dart';

class ListToolbar extends StatelessWidget {
  const ListToolbar({
    super.key,
    required this.isMobile,
    required this.actions,
    this.searchField,
    this.spacing = 8,
    this.runSpacing = 6,
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
      return Column(
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
