import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_list_tile.dart';

class TaskBoardFilterDrawerContent extends StatelessWidget {
  const TaskBoardFilterDrawerContent({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            LayoutTokens.gapLg,
            LayoutTokens.gapMd,
            LayoutTokens.gapSm,
            LayoutTokens.gapSm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: '关闭',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}

class TimelineGroup {
  const TimelineGroup({
    required this.date,
    required this.label,
    required this.tasks,
  });

  final DateTime? date;
  final String label;
  final List<Task> tasks;
}

class TaskBoardQuickFilterItem {
  const TaskBoardQuickFilterItem({
    required this.label,
    required this.value,
    required this.count,
  });

  final String label;
  final String? value;
  final int count;
}

class TaskBoardColumnData {
  const TaskBoardColumnData({
    required this.key,
    required this.title,
    required this.icon,
    required this.tasks,
    required this.totalCount,
  });

  final String key;
  final String title;
  final IconData icon;
  final List<Task> tasks;
  final int totalCount;
}

class TaskDragData {
  const TaskDragData({
    required this.task,
    required this.fromStatus,
  });

  final Task task;
  final String fromStatus;
}

class TaskBoardColumn extends StatelessWidget {
  const TaskBoardColumn({
    super.key,
    required this.data,
    required this.onTapTask,
    this.onDrop,
    this.canAccept,
    this.onDragStart,
    this.onDragEnd,
    this.updatingTaskId,
    this.draggingTaskId,
    this.useLongPress = false,
    this.width,
    this.fullWidth = false,
  });

  final TaskBoardColumnData data;
  final ValueChanged<Task> onTapTask;
  final ValueChanged<TaskDragData>? onDrop;
  final bool Function(TaskDragData data)? canAccept;
  final ValueChanged<Task>? onDragStart;
  final VoidCallback? onDragEnd;
  final int? updatingTaskId;
  final int? draggingTaskId;
  final bool useLongPress;
  final double? width;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final resolvedWidth = fullWidth ? double.infinity : (width ?? 320);
    double? resolvedFeedbackWidth;
    if (resolvedWidth.isFinite) {
      final value = (resolvedWidth - 24).clamp(220.0, 520.0);
      resolvedFeedbackWidth = value.toDouble();
    }
    final share = data.totalCount == 0
        ? 0
        : (data.tasks.length / data.totalCount * 100).round();

    return DragTarget<TaskDragData>(
      onWillAcceptWithDetails: (details) =>
          canAccept?.call(details.data) ?? false,
      onAcceptWithDetails: (details) => onDrop?.call(details.data),
      builder: (context, candidates, rejected) {
        final highlight = candidates.isNotEmpty;
        return Container(
          width: resolvedWidth,
          padding: LayoutTokens.cardPadding(context),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
            border: Border.all(
              color: highlight ? theme.colorScheme.primary : colors.borderColor,
              width: highlight ? 1.4 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(data.icon, size: 18, color: colors.subtleText),
                  SizedBox(width: LayoutTokens.gapSm),
                  Expanded(
                    child: Text(
                      data.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.sidebarText,
                      ),
                    ),
                  ),
                  Text(
                    '${data.tasks.length} · $share%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.subtleText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: LayoutTokens.gapMd),
              if (data.tasks.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: LayoutTokens.gapMd),
                  child: Text(
                    '暂无任务',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.subtleText,
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    for (var i = 0; i < data.tasks.length; i++) ...[
                      _DraggableTaskCard(
                        task: data.tasks[i],
                        onTap: () => onTapTask(data.tasks[i]),
                        onDragStart: onDragStart,
                        onDragEnd: onDragEnd,
                        isBusy: updatingTaskId == data.tasks[i].id,
                        isDragging: draggingTaskId == data.tasks[i].id,
                        useLongPress: useLongPress,
                        feedbackWidth: resolvedFeedbackWidth,
                      ),
                      if (i != data.tasks.length - 1)
                        SizedBox(height: LayoutTokens.gapSm),
                    ],
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class TaskTimelineList extends StatelessWidget {
  const TaskTimelineList({
    super.key,
    required this.groups,
    required this.sectionSpacing,
    required this.isOverdue,
    required this.onTapTask,
  });

  final List<TimelineGroup> groups;
  final double sectionSpacing;
  final bool Function(DateTime date) isOverdue;
  final ValueChanged<Task> onTapTask;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return ListView.separated(
      padding: EdgeInsets.only(bottom: sectionSpacing),
      itemCount: groups.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final group = groups[index];
        final overdue = group.date != null &&
            isOverdue(group.date!) &&
            group.tasks.any((task) => task.status != 'completed');

        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.borderColor),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                  LayoutTokens.gapMd,
                  LayoutTokens.gapSm,
                  LayoutTokens.gapMd,
                  LayoutTokens.gapSm,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  border: Border(bottom: BorderSide(color: colors.borderColor)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        group.label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.sidebarText,
                        ),
                      ),
                    ),
                    if (overdue)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: LayoutTokens.gapSm,
                          vertical: LayoutTokens.gapXs,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            LayoutTokens.radiusPill,
                          ),
                          border: Border.all(
                            color:
                                theme.colorScheme.error.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '已逾期',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    SizedBox(width: LayoutTokens.gapSm),
                    Text(
                      '${group.tasks.length} 项',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.subtleText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              for (var i = 0; i < group.tasks.length; i++)
                TaskListTile(
                  task: group.tasks[i],
                  onTap: () => onTapTask(group.tasks[i]),
                  showDivider: i != group.tasks.length - 1,
                  showAssignee: true,
                ),
            ],
          ),
        );
      },
    );
  }
}

class TaskBoardQuickFilters extends StatelessWidget {
  const TaskBoardQuickFilters({
    super.key,
    required this.filters,
    required this.selectedStatus,
    required this.hideEmptyColumns,
    required this.sortByDeliveryDate,
    required this.onSelectStatus,
    required this.onToggleHideEmptyColumns,
    required this.onToggleSortByDeliveryDate,
  });

  final List<TaskBoardQuickFilterItem> filters;
  final String? selectedStatus;
  final bool hideEmptyColumns;
  final bool sortByDeliveryDate;
  final ValueChanged<String?> onSelectStatus;
  final ValueChanged<bool> onToggleHideEmptyColumns;
  final ValueChanged<bool> onToggleSortByDeliveryDate;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final filter in filters)
          ChoiceChip(
            label: Text('${filter.label} ${filter.count}'),
            selected: selectedStatus == filter.value,
            onSelected: (_) => onSelectStatus(filter.value),
          ),
        FilterChip(
          label: const Text('隐藏空列'),
          selected: hideEmptyColumns,
          onSelected: onToggleHideEmptyColumns,
        ),
        FilterChip(
          label: const Text('按交期排序'),
          selected: sortByDeliveryDate,
          onSelected: onToggleSortByDeliveryDate,
        ),
      ],
    );
  }
}

class _DraggableTaskCard extends StatelessWidget {
  const _DraggableTaskCard({
    required this.task,
    required this.onTap,
    required this.onDragStart,
    required this.onDragEnd,
    required this.isBusy,
    required this.isDragging,
    required this.useLongPress,
    this.feedbackWidth,
  });

  final Task task;
  final VoidCallback onTap;
  final ValueChanged<Task>? onDragStart;
  final VoidCallback? onDragEnd;
  final bool isBusy;
  final bool isDragging;
  final bool useLongPress;
  final double? feedbackWidth;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final card = Container(
      padding: const EdgeInsets.all(LayoutTokens.gapXxxs),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: colors.borderColor),
      ),
      child: TaskListTile(
        task: task,
        onTap: onTap,
        showDivider: false,
      ),
    );

    if (useLongPress) {
      return LongPressDraggable<TaskDragData>(
        data: TaskDragData(task: task, fromStatus: task.status ?? ''),
        onDragStarted: () => onDragStart?.call(task),
        onDragEnd: (_) => onDragEnd?.call(),
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(width: feedbackWidth ?? 280, child: card),
        ),
        childWhenDragging: Opacity(opacity: 0.4, child: card),
        child: _buildContent(colors, card),
      );
    }

    return Draggable<TaskDragData>(
      data: TaskDragData(task: task, fromStatus: task.status ?? ''),
      onDragStarted: () => onDragStart?.call(task),
      onDragEnd: (_) => onDragEnd?.call(),
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: feedbackWidth ?? 280, child: card),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: card),
      child: _buildContent(colors, card),
    );
  }

  Widget _buildContent(AppColors colors, Widget card) {
    return Stack(
      children: [
        card,
        if (isDragging)
          Positioned.fill(
            child: Container(
              color: colors.surface.withValues(alpha: 0.6),
              child: const Center(child: Icon(Icons.open_with, size: 18)),
            ),
          ),
        if (isBusy)
          Positioned.fill(
            child: Container(
              color: colors.surface.withValues(alpha: 0.7),
              child: const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
