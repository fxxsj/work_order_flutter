import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/models/traceability_summary_item.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';

class TraceabilitySummaryGroupData {
  const TraceabilitySummaryGroupData({
    required this.title,
    required this.items,
    this.actionLabel,
    this.onActionTap,
    this.onItemTap,
  });

  final String title;
  final List<TraceabilitySummaryItem> items;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final ValueChanged<TraceabilitySummaryItem>? onItemTap;
}

class TraceabilitySummarySection extends StatelessWidget {
  const TraceabilitySummarySection({
    super.key,
    required this.title,
    required this.groups,
    required this.emptyText,
  });

  final String title;
  final List<TraceabilitySummaryGroupData> groups;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return DetailSectionCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < groups.length; i++) ...[
            _TraceabilitySummaryGroup(
              title: groups[i].title,
              items: groups[i].items,
              actionLabel: groups[i].actionLabel,
              onActionTap: groups[i].onActionTap,
              onItemTap: groups[i].onItemTap,
              emptyText: emptyText,
            ),
            if (i != groups.length - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _TraceabilitySummaryGroup extends StatelessWidget {
  const _TraceabilitySummaryGroup({
    required this.title,
    required this.items,
    required this.actionLabel,
    required this.onActionTap,
    required this.onItemTap,
    required this.emptyText,
  });

  final String title;
  final List<TraceabilitySummaryItem> items;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final ValueChanged<TraceabilitySummaryItem>? onItemTap;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
            if (actionLabel != null &&
                actionLabel!.trim().isNotEmpty &&
                onActionTap != null)
              TextButton.icon(
                onPressed: onActionTap,
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text(actionLabel!),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Text(emptyText, style: theme.textTheme.bodyMedium)
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items
                .map(
                  (item) => _TraceabilitySummaryTile(
                    item: item,
                    onTap: onItemTap == null || item.id == null
                        ? null
                        : () => onItemTap!(item),
                    emptyText: emptyText,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _TraceabilitySummaryTile extends StatelessWidget {
  const _TraceabilitySummaryTile({
    required this.item,
    this.onTap,
    required this.emptyText,
  });

  final TraceabilitySummaryItem item;
  final VoidCallback? onTap;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final width =
        MediaQuery.sizeOf(context).width < 720 ? double.infinity : 280.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
        child: Container(
          width: width,
          padding: LayoutTokens.cardPadding(context),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
            border: Border.all(
              color: (colors?.borderColor ?? theme.dividerColor)
                  .withValues(alpha: 0.9),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.number,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_outward,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SummaryMetaPill(
                    label: '状态',
                    value: item.statusDisplay ?? emptyText,
                  ),
                  _SummaryMetaPill(
                    label: '来源',
                    value: item.sourceLabel ?? emptyText,
                  ),
                  _SummaryMetaPill(
                    label: '批次',
                    value: item.batchNo ?? emptyText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryMetaPill extends StatelessWidget {
  const _SummaryMetaPill({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
      ),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors?.sidebarText ?? theme.textTheme.bodySmall?.color,
          ),
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
