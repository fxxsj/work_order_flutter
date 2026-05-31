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
  )
  formatProcessNames,
}) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _WorkOrderSyncPreviewDialog(
      canSync: canSync,
      processes: processes,
      emptyText: emptyText,
      loadPreview: loadPreview,
      executeSync: executeSync,
      formatProcessNames: formatProcessNames,
    ),
  );
}

class _WorkOrderSyncPreviewDialog extends StatefulWidget {
  const _WorkOrderSyncPreviewDialog({
    required this.canSync,
    required this.processes,
    required this.emptyText,
    required this.loadPreview,
    required this.executeSync,
    required this.formatProcessNames,
  });

  final bool canSync;
  final List<WorkOrderProcessItem> processes;
  final String emptyText;
  final Future<WorkOrderSyncPreviewResult> Function(List<int> selectedIds)
  loadPreview;
  final Future<void> Function(List<int> selectedIds) executeSync;
  final String Function(
    List<int> ids,
    Map<int, WorkOrderProcessItem> processMap,
  )
  formatProcessNames;

  @override
  State<_WorkOrderSyncPreviewDialog> createState() =>
      _WorkOrderSyncPreviewDialogState();
}

class _WorkOrderSyncPreviewDialogState
    extends State<_WorkOrderSyncPreviewDialog> {
  late final Map<int, WorkOrderProcessItem> processMap = {
    for (final item in widget.processes) item.id: item,
  };
  late final Set<int> selectedIds = widget.processes
      .map((item) => item.id)
      .toSet();
  Map<String, dynamic>? preview;
  String? warningMessage;
  bool loading = false;
  bool executing = false;

  Future<void> handleLoadPreview() async {
    if (!widget.canSync) return;
    setState(() {
      loading = true;
      warningMessage = null;
    });
    try {
      final result = await widget.loadPreview(selectedIds.toList());
      if (!mounted) return;
      setState(() {
        preview = result.preview;
        warningMessage = result.warningMessage;
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> handleExecute() async {
    if (!widget.canSync || preview == null) return;
    setState(() => executing = true);
    try {
      await widget.executeSync(selectedIds.toList());
      if (mounted) {
        Navigator.of(context).maybePop();
      }
    } finally {
      if (mounted) {
        setState(() => executing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final previewData = preview;
    final removedIds = _readIdList(previewData?['removed_process_ids']);
    final addedIds = _readIdList(previewData?['added_process_ids']);
    final missingIds = _readIdList(previewData?['missing_process_ids']);
    final blockedIds = _readIdList(previewData?['blocked_task_ids']);
    final orphanTaskIds = _readIdList(previewData?['orphan_task_ids']);
    final tasksToRemove = _readInt(previewData?['tasks_to_remove']);
    final tasksToAdd = _readInt(previewData?['tasks_to_add']);
    final tasksBlocked = _readInt(previewData?['tasks_blocked']);
    final affected = previewData?['affected'] == true;

    return AppDialog(
      title: '同步工序任务',
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
            if (!widget.canSync) ...[
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
            if (widget.processes.isEmpty)
              Text('暂无工序可同步', style: theme.textTheme.bodyMedium)
            else
              Column(
                children: [
                  for (final process in widget.processes)
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
                        process.processName ?? widget.emptyText,
                        style: theme.textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        process.processCode ?? widget.emptyText,
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
              _InfoRow(label: '将删除未开始任务', value: '$tasksToRemove'),
              _InfoRow(label: '预计新增任务', value: '$tasksToAdd'),
              _InfoRow(
                label: '阻断任务',
                value: '${tasksBlocked > 0 ? tasksBlocked : blockedIds.length}',
              ),
              _InfoRow(
                label: '移除工序',
                value: widget.formatProcessNames(removedIds, processMap),
              ),
              _InfoRow(
                label: '新增工序',
                value: widget.formatProcessNames(addedIds, processMap),
              ),
              _InfoRow(
                label: '缺失任务工序',
                value: widget.formatProcessNames(missingIds, processMap),
              ),
              _InfoRow(
                label: '多余任务',
                value: orphanTaskIds.isEmpty ? '无' : orphanTaskIds.join(', '),
              ),
              _InfoRow(
                label: '阻断任务ID',
                value: blockedIds.isEmpty ? '无' : blockedIds.join(', '),
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
          onPressed: (!widget.canSync || loading) ? null : handleLoadPreview,
          child: const Text('预览变更'),
        ),
        FilledButton(
          onPressed:
              (!widget.canSync ||
                  loading ||
                  executing ||
                  preview == null ||
                  previewData?['affected'] != true ||
                  tasksBlocked > 0)
              ? null
              : handleExecute,
          child: Text(executing ? '同步中' : '执行同步'),
        ),
      ],
    );
  }
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
