import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';

// ─── Risk Action Dialog ────────────────────────────────────────────────────────

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
      padding: const EdgeInsets.all(LayoutTokens.gapLg),
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
                destructive ? Icons.warning_amber_rounded : Icons.info_outline,
                color: tone,
                size: LayoutTokens.iconLg,
              ),
              const SizedBox(width: LayoutTokens.gapMd),
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
            const SizedBox(height: LayoutTokens.gapMd),
            ...impacts.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: LayoutTokens.gapXxs),
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
            const SizedBox(height: LayoutTokens.gapMd),
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

      return AppDialog(
        title: title,
        maxWidth: dialogWidth,
        scrollable: false,
        content: SizedBox(
          width: dialogWidth,
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
                    backgroundColor: Theme.of(context)
                            .extension<AppSemanticColors>()
                            ?.danger ??
                        Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
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

// ─── Action Decision Dialog ───────────────────────────────────────────────────

class ActionDecisionOption<T> {
  const ActionDecisionOption({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

class ActionDecisionResult<T> {
  const ActionDecisionResult({
    this.selection,
    this.notes = '',
    this.extraNotes = '',
  });

  final T? selection;
  final String notes;
  final String extraNotes;
}

Future<ActionDecisionResult<T>?> showActionDecisionDialog<T>(
  BuildContext context, {
  required String title,
  String? summary,
  List<String> impacts = const [],
  String? auditHint,
  bool destructive = false,
  String cancelText = '取消',
  String submitText = '提交',
  double maxWidth = LayoutTokens.dialogWidthSm,
  String? selectionLabel,
  List<ActionDecisionOption<T>> options = const [],
  T? initialSelection,
  bool requireSelection = false,
  String selectionErrorText = '请选择处理结论',
  String? notesLabel,
  String? notesHint,
  String initialNotes = '',
  bool requireNotes = false,
  String notesErrorText = '请填写处理说明',
  int notesMaxLines = 4,
  String? extraNotesLabel,
  String? extraNotesHint,
  String initialExtraNotes = '',
  bool requireExtraNotes = false,
  String extraNotesErrorText = '请填写补充说明',
  int extraNotesMaxLines = 4,
}) async {
  T? selection = initialSelection;
  final notesController = TextEditingController(text: initialNotes);
  final extraNotesController = TextEditingController(text: initialExtraNotes);
  bool submitting = false;

  final result = await showDialog<ActionDecisionResult<T>>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          void submit() {
            final trimmedNotes = notesController.text.trim();
            final trimmedExtraNotes = extraNotesController.text.trim();
            if (requireSelection && selection == null) {
              return;
            }
            if (requireNotes && trimmedNotes.isEmpty) {
              return;
            }
            if (requireExtraNotes && trimmedExtraNotes.isEmpty) {
              return;
            }
            Navigator.of(dialogContext).pop(
              ActionDecisionResult<T>(
                selection: selection,
                notes: trimmedNotes,
                extraNotes: trimmedExtraNotes,
              ),
            );
          }

          final showSelection = selectionLabel != null && options.isNotEmpty;
          final showNotes = notesLabel != null;
          final showExtraNotes = extraNotesLabel != null;
          final showDecisionHint = (summary ?? '').trim().isNotEmpty ||
              impacts.isNotEmpty ||
              (auditHint ?? '').trim().isNotEmpty;

          return AppDialog(
            title: title,
            maxWidth: maxWidth,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showDecisionHint) ...[
                  RiskActionHintPanel(
                    summary: (summary ?? '').trim(),
                    impacts: impacts,
                    auditHint: auditHint,
                    destructive: destructive,
                  ),
                  const SizedBox(height: 12),
                ],
                if (showSelection) ...[
                  AppSelect<T>(
                    key: ValueKey<T?>(selection),
                    value: selection,
                    options: options
                        .map(
                          (option) => AppDropdownOption<T>(
                            value: option.value,
                            label: option.label,
                          ),
                        )
                        .toList(),
                    decoration: InputDecoration(labelText: selectionLabel),
                    onChanged: submitting
                        ? null
                        : (value) => setState(() => selection = value),
                    validator: requireSelection
                        ? (value) => value == null ? selectionErrorText : null
                        : null,
                  ),
                  if (showNotes) const SizedBox(height: 12),
                ],
                if (showNotes)
                  CrudFormField.textarea(
                    label: notesLabel,
                    controller: notesController,
                    enabled: !submitting,
                    maxLines: notesMaxLines,
                    hintText: notesHint,
                  ).build(dialogContext),
                if (showExtraNotes) ...[
                  if (showNotes) const SizedBox(height: 12),
                  CrudFormField.textarea(
                    label: extraNotesLabel,
                    controller: extraNotesController,
                    enabled: !submitting,
                    maxLines: extraNotesMaxLines,
                    hintText: extraNotesHint,
                  ).build(dialogContext),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed:
                    submitting ? null : () => Navigator.of(dialogContext).pop(),
                child: Text(cancelText),
              ),
              FilledButton(
                onPressed: submitting
                    ? null
                    : () {
                        final trimmedNotes = notesController.text.trim();
                        final trimmedExtraNotes =
                            extraNotesController.text.trim();
                        if (requireSelection && selection == null) {
                          ToastUtil.showError(selectionErrorText);
                          return;
                        }
                        if (requireNotes && trimmedNotes.isEmpty) {
                          ToastUtil.showError(notesErrorText);
                          return;
                        }
                        if (requireExtraNotes && trimmedExtraNotes.isEmpty) {
                          ToastUtil.showError(extraNotesErrorText);
                          return;
                        }
                        setState(() => submitting = true);
                        submit();
                      },
                child: Text(submitting ? '提交中...' : submitText),
              ),
            ],
          );
        },
      );
    },
  );

  notesController.dispose();
  extraNotesController.dispose();
  return result;
}
