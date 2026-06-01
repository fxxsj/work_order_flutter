import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';

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
    final bg = tone.withValues(alpha: OpacityTokens.subtle);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        border: Border.all(color: tone.withValues(alpha: OpacityTokens.medium)),
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
              const SizedBox(width: SpacingTokens.md),
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
            const SizedBox(height: SpacingTokens.md),
            ...impacts.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: SpacingTokens.xxs),
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
            const SizedBox(height: SpacingTokens.md),
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
    useRootNavigator: false,
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
                    backgroundColor:
                        Theme.of(
                          context,
                        ).extension<AppSemanticColors>()?.danger ??
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
  const ActionDecisionOption({required this.value, required this.label});

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

/// Standard shell for action forms that need risk/context copy plus submit state.
class AppActionFormDialog extends StatelessWidget {
  const AppActionFormDialog({
    super.key,
    required this.title,
    required this.formKey,
    required this.onSubmit,
    required this.content,
    this.summary,
    this.impacts = const [],
    this.auditHint,
    this.destructive = false,
    this.cancelText = '取消',
    this.submitText = '提交',
    this.submitting = false,
    this.maxWidth = LayoutTokens.dialogWidthSm,
    this.onCancel,
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final Future<void> Function() onSubmit;
  final Widget content;
  final String? summary;
  final List<String> impacts;
  final String? auditHint;
  final bool destructive;
  final String cancelText;
  final String submitText;
  final bool submitting;
  final double maxWidth;
  final VoidCallback? onCancel;

  bool get _showDecisionHint =>
      (summary ?? '').trim().isNotEmpty ||
      impacts.isNotEmpty ||
      (auditHint ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: title,
      formKey: formKey,
      onSubmit: onSubmit,
      onCancel: onCancel,
      submitText: submitText,
      cancelText: cancelText,
      submitting: submitting,
      maxWidth: maxWidth,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showDecisionHint) ...[
            RiskActionHintPanel(
              summary: (summary ?? '').trim(),
              impacts: impacts,
              auditHint: auditHint,
              destructive: destructive,
            ),
            SizedBox(height: SpacingTokens.md),
          ],
          content,
        ],
      ),
    );
  }
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
  return showDialog<ActionDecisionResult<T>>(
    context: context,
    useRootNavigator: false,
    builder: (_) => _ActionDecisionDialog<T>(
      title: title,
      summary: summary,
      impacts: impacts,
      auditHint: auditHint,
      destructive: destructive,
      cancelText: cancelText,
      submitText: submitText,
      maxWidth: maxWidth,
      selectionLabel: selectionLabel,
      options: options,
      initialSelection: initialSelection,
      requireSelection: requireSelection,
      selectionErrorText: selectionErrorText,
      notesLabel: notesLabel,
      notesHint: notesHint,
      initialNotes: initialNotes,
      requireNotes: requireNotes,
      notesErrorText: notesErrorText,
      notesMaxLines: notesMaxLines,
      extraNotesLabel: extraNotesLabel,
      extraNotesHint: extraNotesHint,
      initialExtraNotes: initialExtraNotes,
      requireExtraNotes: requireExtraNotes,
      extraNotesErrorText: extraNotesErrorText,
      extraNotesMaxLines: extraNotesMaxLines,
    ),
  );
}

class _ActionDecisionDialog<T> extends StatefulWidget {
  const _ActionDecisionDialog({
    required this.title,
    required this.cancelText,
    required this.submitText,
    required this.maxWidth,
    required this.options,
    required this.requireSelection,
    required this.selectionErrorText,
    required this.initialNotes,
    required this.requireNotes,
    required this.notesErrorText,
    required this.notesMaxLines,
    required this.initialExtraNotes,
    required this.requireExtraNotes,
    required this.extraNotesErrorText,
    required this.extraNotesMaxLines,
    this.summary,
    this.impacts = const [],
    this.auditHint,
    this.destructive = false,
    this.selectionLabel,
    this.initialSelection,
    this.notesLabel,
    this.notesHint,
    this.extraNotesLabel,
    this.extraNotesHint,
  });

  final String title;
  final String? summary;
  final List<String> impacts;
  final String? auditHint;
  final bool destructive;
  final String cancelText;
  final String submitText;
  final double maxWidth;
  final String? selectionLabel;
  final List<ActionDecisionOption<T>> options;
  final T? initialSelection;
  final bool requireSelection;
  final String selectionErrorText;
  final String? notesLabel;
  final String? notesHint;
  final String initialNotes;
  final bool requireNotes;
  final String notesErrorText;
  final int notesMaxLines;
  final String? extraNotesLabel;
  final String? extraNotesHint;
  final String initialExtraNotes;
  final bool requireExtraNotes;
  final String extraNotesErrorText;
  final int extraNotesMaxLines;

  @override
  State<_ActionDecisionDialog<T>> createState() =>
      _ActionDecisionDialogState<T>();
}

class _ActionDecisionDialogState<T> extends State<_ActionDecisionDialog<T>> {
  final formKey = GlobalKey<FormState>();
  late T? selection = widget.initialSelection;
  late final TextEditingController notesController = TextEditingController(
    text: widget.initialNotes,
  );
  late final TextEditingController extraNotesController = TextEditingController(
    text: widget.initialExtraNotes,
  );
  bool submitting = false;

  bool get showSelection =>
      widget.selectionLabel != null && widget.options.isNotEmpty;
  bool get showNotes => widget.notesLabel != null;
  bool get showExtraNotes => widget.extraNotesLabel != null;

  @override
  void dispose() {
    notesController.dispose();
    extraNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppActionFormDialog(
      title: widget.title,
      formKey: formKey,
      onSubmit: _submit,
      maxWidth: widget.maxWidth,
      cancelText: widget.cancelText,
      submitText: widget.submitText,
      submitting: submitting,
      summary: widget.summary,
      impacts: widget.impacts,
      auditHint: widget.auditHint,
      destructive: widget.destructive,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showSelection) ...[
            AppSelect<T>(
              key: ValueKey<T?>(selection),
              value: selection,
              options: widget.options
                  .map(
                    (option) => AppDropdownOption<T>(
                      value: option.value,
                      label: option.label,
                    ),
                  )
                  .toList(),
              decoration: InputDecoration(labelText: widget.selectionLabel),
              onChanged: submitting
                  ? null
                  : (value) => setState(() => selection = value),
              validator: widget.requireSelection
                  ? (value) => value == null ? widget.selectionErrorText : null
                  : null,
            ),
            if (showNotes) SizedBox(height: SpacingTokens.md),
          ],
          if (showNotes)
            CrudFieldConfig.textarea(
              label: widget.notesLabel!,
              controller: notesController,
              enabled: !submitting,
              maxLines: widget.notesMaxLines,
              hintText: widget.notesHint,
              validator: widget.requireNotes
                  ? (value) => (value?.trim().isEmpty ?? true)
                        ? widget.notesErrorText
                        : null
                  : null,
            ).build(context),
          if (showExtraNotes) ...[
            if (showNotes) SizedBox(height: SpacingTokens.md),
            CrudFieldConfig.textarea(
              label: widget.extraNotesLabel!,
              controller: extraNotesController,
              enabled: !submitting,
              maxLines: widget.extraNotesMaxLines,
              hintText: widget.extraNotesHint,
              validator: widget.requireExtraNotes
                  ? (value) => (value?.trim().isEmpty ?? true)
                        ? widget.extraNotesErrorText
                        : null
                  : null,
            ).build(context),
          ],
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    final trimmedNotes = notesController.text.trim();
    final trimmedExtraNotes = extraNotesController.text.trim();
    setState(() => submitting = true);
    Navigator.of(context).pop(
      ActionDecisionResult<T>(
        selection: selection,
        notes: trimmedNotes,
        extraNotes: trimmedExtraNotes,
      ),
    );
  }
}
