import 'package:flutter/material.dart';

class RowAction {
  const RowAction({
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool destructive;
}

class RowActionGroup extends StatelessWidget {
  const RowActionGroup({
    super.key,
    required this.actions,
    this.primaryCount = 2,
    this.spacing = 6,
    this.overflowLabel = '更多',
  });

  final List<RowAction> actions;
  final int primaryCount;
  final double spacing;
  final String overflowLabel;

  @override
  Widget build(BuildContext context) {
    final available = actions
        .where((action) => action.label.trim().isNotEmpty)
        .where((action) => action.onPressed != null)
        .toList();
    if (available.isEmpty) {
      return const SizedBox.shrink();
    }

    final primary = available.take(primaryCount).toList();
    final overflow = available.skip(primaryCount).toList();
    final theme = Theme.of(context);

    return Wrap(
      spacing: spacing,
      runSpacing: 4,
      children: [
        for (final action in primary)
          TextButton(
            onPressed: action.onPressed,
            style: action.destructive
                ? TextButton.styleFrom(foregroundColor: theme.colorScheme.error)
                : null,
            child: Text(action.label),
          ),
        if (overflow.isNotEmpty)
          PopupMenuButton<int>(
            tooltip: overflowLabel,
            itemBuilder: (context) => [
              for (var i = 0; i < overflow.length; i++)
                PopupMenuItem<int>(
                  value: i,
                  child: Text(
                    overflow[i].label,
                    style: overflow[i].destructive
                        ? TextStyle(color: theme.colorScheme.error)
                        : null,
                  ),
                ),
            ],
            onSelected: (index) => overflow[index].onPressed?.call(),
            child: TextButton.icon(
              onPressed: null,
              icon: const Icon(Icons.more_horiz, size: 16),
              label: Text(overflowLabel),
            ),
          ),
      ],
    );
  }
}
