import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class RiskActionHintPanel extends StatelessWidget {
  const RiskActionHintPanel({
    super.key,
    required this.summary,
    this.impacts = const [],
    this.auditHint,
    this.destructive = false,
  });

  final String summary;
  final List<String> impacts;
  final String? auditHint;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = theme.extension<AppSemanticColors>();
    final tone = destructive
        ? (semantic?.danger ?? scheme.error)
        : (semantic?.info ?? scheme.primary);
    final bg = tone.withValues(alpha: 0.08);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: tone.withValues(alpha: 0.18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                destructive
                    ? Icons.warning_amber_rounded
                    : Icons.info_outline,
                color: tone,
                size: LayoutTokens.iconLg,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  summary,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: destructive ? scheme.onSurface : null,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          if (impacts.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...impacts.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: tone,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if ((auditHint ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              auditHint!.trim(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Future<bool> showRiskActionConfirmDialog(
  BuildContext context, {
  required String title,
  required String summary,
  List<String> impacts = const [],
  String? auditHint,
  String confirmText = '确认',
  bool destructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final dialogWidth = (screenWidth < 600)
          ? screenWidth - 32
          : (screenWidth < 900 ? 520.0 : 600.0);

      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: dialogWidth,
          child: RiskActionHintPanel(
            summary: summary,
            impacts: impacts,
            auditHint: auditHint,
            destructive: destructive,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).extension<AppSemanticColors>()?.danger ??
                        Theme.of(context).colorScheme.error,
                    foregroundColor:
                        Theme.of(context).colorScheme.onError,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
  return confirmed == true;
}
