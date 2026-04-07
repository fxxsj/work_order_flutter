import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/risk_action_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';

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

          return AlertDialog(
            title: Text(title),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                child: Column(
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
                      UnifiedDropdown<T>(
                        key: ValueKey<T?>(selection),
                        value: selection,
                        options: options
                            .map(
                              (option) => DropdownOption<T>(
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
                            ? (value) =>
                                value == null ? selectionErrorText : null
                            : null,
                      ),
                      if (showNotes) const SizedBox(height: 12),
                    ],
                    if (showNotes)
                      TextFormField(
                        controller: notesController,
                        enabled: !submitting,
                        maxLines: notesMaxLines,
                        decoration: InputDecoration(
                          labelText: notesLabel,
                          hintText: notesHint,
                        ),
                      ),
                    if (showExtraNotes) ...[
                      if (showNotes) const SizedBox(height: 12),
                      TextFormField(
                        controller: extraNotesController,
                        enabled: !submitting,
                        maxLines: extraNotesMaxLines,
                        decoration: InputDecoration(
                          labelText: extraNotesLabel,
                          hintText: extraNotesHint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(selectionErrorText)),
                          );
                          return;
                        }
                        if (requireNotes && trimmedNotes.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(notesErrorText)),
                          );
                          return;
                        }
                        if (requireExtraNotes && trimmedExtraNotes.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(extraNotesErrorText)),
                          );
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
