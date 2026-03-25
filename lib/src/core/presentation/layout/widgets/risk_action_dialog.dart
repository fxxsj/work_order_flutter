import 'package:flutter/material.dart';

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
    final tone = destructive ? scheme.error : scheme.primary;
    final bg = tone.withValues(alpha: 0.08);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
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
                destructive ? Icons.warning_amber_rounded : Icons.info_outline,
                color: tone,
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
    builder: (context) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 520,
        child: RiskActionHintPanel(
          summary: summary,
          impacts: impacts,
          auditHint: auditHint,
          destructive: destructive,
        ),
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
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          child: Text(confirmText),
        ),
      ],
    ),
  );
  return confirmed == true;
}
