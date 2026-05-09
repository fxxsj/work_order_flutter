import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';

class WorkOrderSyncPreviewResult {
  const WorkOrderSyncPreviewResult({
    required this.preview,
    this.warningMessage,
  });

  final Map<String, dynamic>? preview;
  final String? warningMessage;
}

Future<void> showWorkOrderSyncPreviewDialog(
  BuildContext context, {
  required bool canSync,
  required List<WorkOrderProcessItem> processes,
  required String emptyText,
  required Future<WorkOrderSyncPreviewResult> Function(List<int> selectedIds)
      loadPreview,
  required Future<void> Function(List<int> selectedIds) executeSync,
  required String Function(
    List<int> ids,
    Map<int, WorkOrderProcessItem> processMap,
  ) formatProcessNames,
}) async {
  final processMap = {for (final item in processes) item.id: item};
  final selectedIds = processes.map((item) => item.id).toSet();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      Map<String, dynamic>? preview;
      String? warningMessage;
      bool loading = false;
      bool executing = false;

      return StatefulBuilder(
        builder: (context, setState) {
          final theme = Theme.of(context);
          final colors = theme.extension<AppColors>();
          final previewData = preview;
          final removedIds = _readIdList(previewData?['removed_process_ids']);
          final addedIds = _readIdList(previewData?['added_process_ids']);
          final tasksToRemove = _readInt(previewData?['tasks_to_remove']);
          final tasksToAdd = _readInt(previewData?['tasks_to_add']);
          final affected = previewData?['affected'] == true;

          Future<void> handleLoadPreview() async {
            if (!canSync) return;
            setState(() {
              loading = true;
              warningMessage = null;
            });
            try {
              final result = await loadPreview(selectedIds.toList());
              preview = result.preview;
              warningMessage = result.warningMessage;
            } finally {
              if (context.mounted) {
                setState(() => loading = false);
              }
            }
          }

          Future<void> handleExecute() async {
            if (!canSync || preview == null) return;
            setState(() => executing = true);
            try {
              await executeSync(selectedIds.toList());
              if (context.mounted) {
                Navigator.of(dialogContext).maybePop();
              }
            } finally {
              if (context.mounted) {
                setState(() => executing = false);
              }
            }
          }

          return AppDialog(
            title: '任务同步预览',
            maxWidth: LayoutTokens.dialogWidthMd,
            content: SizedBox(
              width: LayoutTokens.dialogWidthMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '选择要保留的工序，预览同步后将删除被移除工序的任务，并为新增工序生成任务。',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  if (!canSync) ...[
                    SizedBox(height: LayoutTokens.gapSm),
                    Text(
                      '已审核的施工单不能同步任务。',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                  SizedBox(height: LayoutTokens.gapMd),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => setState(() {
                          selectedIds
                            ..clear()
                            ..addAll(processMap.keys);
                        }),
                        child: const Text('全选'),
                      ),
                      TextButton(
                        onPressed: () => setState(selectedIds.clear),
                        child: const Text('清空'),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  SizedBox(height: LayoutTokens.gapSm),
                  if (processes.isEmpty)
                    Text('暂无工序可同步', style: theme.textTheme.bodyMedium)
                  else
                    Column(
                      children: [
                        for (final process in processes)
                          CheckboxListTile(
                            value: selectedIds.contains(process.id),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  selectedIds.add(process.id);
                                } else {
                                  selectedIds.remove(process.id);
                                }
                              });
                            },
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              process.processName ?? emptyText,
                              style: theme.textTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              process.processCode ?? emptyText,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors?.subtleText,
                              ),
                            ),
                          ),
                      ],
                    ),
                  if (loading) ...[
                    SizedBox(height: LayoutTokens.gapMd),
                    const LinearProgressIndicator(minHeight: 2),
                  ],
                  if (warningMessage != null) ...[
                    SizedBox(height: LayoutTokens.gapMd),
                    Text(
                      warningMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                  if (previewData != null) ...[
                    SizedBox(height: LayoutTokens.gapLg),
                    Text(
                      '预览结果',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors?.sidebarText,
                      ),
                    ),
                    SizedBox(height: LayoutTokens.gapSm),
                    _InfoRow(label: '将删除草稿任务', value: '$tasksToRemove'),
                    _InfoRow(label: '预计新增草稿任务', value: '$tasksToAdd'),
                    _InfoRow(
                      label: '移除工序',
                      value: formatProcessNames(removedIds, processMap),
                    ),
                    _InfoRow(
                      label: '新增工序',
                      value: formatProcessNames(addedIds, processMap),
                    ),
                    _InfoRow(label: '是否有变更', value: affected ? '是' : '否'),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('关闭'),
              ),
              FilledButton(
                onPressed: (!canSync || loading) ? null : handleLoadPreview,
                child: const Text('预览变更'),
              ),
              FilledButton(
                onPressed: (!canSync ||
                        loading ||
                        executing ||
                        preview == null ||
                        previewData?['affected'] != true)
                    ? null
                    : handleExecute,
                child: Text(executing ? '同步中' : '执行同步'),
              ),
            ],
          );
        },
      );
    },
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: colors?.subtleText),
        ),
        SpacingTokens.vXs,
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

List<int> _readIdList(dynamic value) {
  if (value is List) {
    return value
        .map((item) => int.tryParse(item.toString()) ?? 0)
        .where((id) => id > 0)
        .toList();
  }
  return const [];
}

int _readInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
