import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';

class WorkOrderProductsSection extends StatelessWidget {
  const WorkOrderProductsSection({
    super.key,
    required this.items,
    required this.emptyText,
  });

  final List<WorkOrderProductItem> items;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text('暂无产品信息', style: Theme.of(context).textTheme.bodyMedium);
    }
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _DetailListCard(
              title: item.productName ?? emptyText,
              subtitle: item.productCode ?? emptyText,
              fields: [
                _DetailField('数量', item.quantity?.toString() ?? emptyText),
                _DetailField('单位', item.unit ?? emptyText),
                _DetailField('规格', item.specification ?? emptyText),
                _DetailField(
                  '拼版数',
                  item.impositionQuantity?.toString() ?? emptyText,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class WorkOrderProcessesSection extends StatelessWidget {
  const WorkOrderProcessesSection({
    super.key,
    required this.items,
    required this.emptyText,
  });

  final List<WorkOrderProcessItem> items;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text('暂无工序信息', style: Theme.of(context).textTheme.bodyMedium);
    }
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _DetailListCard(
              title: item.processName ?? emptyText,
              subtitle: item.processCode ?? emptyText,
              fields: [
                _DetailField(
                  '状态',
                  item.statusDisplay ?? item.status ?? emptyText,
                ),
                _DetailField('操作员', item.operatorName ?? emptyText),
                _DetailField('部门', item.departmentName ?? emptyText),
                _DetailField('任务数', item.tasksCount?.toString() ?? emptyText),
                _DetailField(
                  '可开始',
                  item.canStart == null
                      ? emptyText
                      : (item.canStart! ? '可开始' : '不可开始'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class WorkOrderProcessGanttSection extends StatelessWidget {
  const WorkOrderProcessGanttSection({
    super.key,
    required this.items,
    required this.emptyText,
    required this.formatDateTime,
  });

  final List<WorkOrderProcessItem> items;
  final String emptyText;
  final String Function(dynamic value) formatDateTime;

  @override
  Widget build(BuildContext context) {
    final rows = _buildGanttRows(items);
    if (rows.isEmpty) {
      return Text('暂无排程信息', style: Theme.of(context).textTheme.bodyMedium);
    }

    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final semantic = theme.extension<AppSemanticColors>();
    final borderColor = colors?.borderColor ?? theme.dividerColor;
    final labelColor = colors?.sidebarText ?? theme.textTheme.bodyMedium?.color;

    final start =
        rows.map((row) => row.start).reduce((a, b) => a.isBefore(b) ? a : b);
    final end =
        rows.map((row) => row.end).reduce((a, b) => a.isAfter(b) ? a : b);
    final totalMs = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    final safeTotalMs = totalMs <= 0 ? 1 : totalMs;

    const labelWidth = 140.0;
    const rowHeight = 36.0;
    const barHeight = 12.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final minChartWidth = 560.0;
        final chartWidth = (constraints.maxWidth - labelWidth - 12)
            .clamp(320.0, double.infinity);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '排程区间：${formatDateTime(start)} ~ ${formatDateTime(end)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors?.subtleText ?? theme.hintColor,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minWidth: labelWidth + minChartWidth),
                child: SizedBox(
                  width: labelWidth + chartWidth,
                  child: Column(
                    children: [
                      for (final row in rows)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: labelWidth,
                                child: Text(
                                  row.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: labelColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: rowHeight,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: borderColor.withValues(
                                                alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: _clampDouble(
                                              (row.start.millisecondsSinceEpoch -
                                                      start
                                                          .millisecondsSinceEpoch) /
                                                  safeTotalMs,
                                            ) *
                                            chartWidth,
                                        top: (rowHeight - barHeight) / 2,
                                        child: Container(
                                          width: _resolveBarWidth(
                                            row,
                                            start,
                                            safeTotalMs,
                                            chartWidth,
                                          ),
                                          height: barHeight,
                                          decoration: BoxDecoration(
                                            color: _statusColor(
                                              row.status,
                                              theme,
                                              semantic,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<_GanttRow> _buildGanttRows(List<WorkOrderProcessItem> items) {
    final rows = <_GanttRow>[];
    for (final item in items) {
      var start = item.plannedStartTime ?? item.actualStartTime;
      var end = item.plannedEndTime ?? item.actualEndTime;
      if (start == null && end == null) continue;
      if (start == null && end != null) {
        start = end.subtract(const Duration(hours: 1));
      }
      if (end == null && start != null) {
        end = start.add(const Duration(hours: 1));
      }
      if (start == null || end == null) continue;
      if (end.isBefore(start)) {
        final temp = start;
        start = end;
        end = temp;
      }
      rows.add(
        _GanttRow(
          label: item.processName ?? '工序 #${item.id}',
          status: item.status,
          start: start,
          end: end,
          sequence: item.sequence,
        ),
      );
    }
    rows.sort((a, b) {
      final aSeq = a.sequence ?? 9999;
      final bSeq = b.sequence ?? 9999;
      if (aSeq != bSeq) return aSeq.compareTo(bSeq);
      return a.start.compareTo(b.start);
    });
    return rows;
  }

  double _resolveBarWidth(
    _GanttRow row,
    DateTime start,
    int totalMs,
    double chartWidth,
  ) {
    final durationMs =
        row.end.millisecondsSinceEpoch - row.start.millisecondsSinceEpoch;
    final safeDuration = durationMs <= 0 ? 1 : durationMs;
    final width = safeDuration / totalMs * chartWidth;
    return width < 6 ? 6 : width;
  }

  double _clampDouble(double value) {
    if (value.isNaN || value.isInfinite) return 0;
    if (value < 0) return 0;
    if (value > 1) return 1;
    return value;
  }

  Color _statusColor(
    String? status,
    ThemeData theme,
    AppSemanticColors? semantic,
  ) {
    switch (status) {
      case 'completed':
        return semantic?.success ?? theme.colorScheme.primary;
      case 'in_progress':
        return theme.colorScheme.primary;
      case 'paused':
        return semantic?.warning ?? theme.colorScheme.secondary;
      case 'cancelled':
        return semantic?.danger ?? theme.colorScheme.error;
      case 'pending':
        return semantic?.info ?? theme.colorScheme.secondary;
      default:
        return theme.colorScheme.primary.withValues(alpha: 0.7);
    }
  }
}

class WorkOrderMaterialsSection extends StatelessWidget {
  const WorkOrderMaterialsSection({
    super.key,
    required this.items,
    required this.emptyText,
  });

  final List<WorkOrderMaterialItem> items;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text('暂无物料信息', style: Theme.of(context).textTheme.bodyMedium);
    }
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _DetailListCard(
              title: item.materialName ?? emptyText,
              subtitle: item.materialCode ?? emptyText,
              fields: [
                _DetailField('单位', item.materialUnit ?? emptyText),
                _DetailField('规格', item.materialSize ?? emptyText),
                _DetailField('用量', item.materialUsage ?? emptyText),
                _DetailField(
                  '需裁切',
                  item.needCutting == null
                      ? emptyText
                      : (item.needCutting! ? '是' : '否'),
                ),
                _DetailField(
                  '采购状态',
                  item.purchaseStatusDisplay ??
                      item.purchaseStatus ??
                      emptyText,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class WorkOrderApprovalLogsSection extends StatelessWidget {
  const WorkOrderApprovalLogsSection({
    super.key,
    required this.logs,
    required this.emptyText,
    required this.formatDate,
  });

  final List<WorkOrderApprovalLog> logs;
  final String emptyText;
  final String Function(DateTime? value) formatDate;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Text('暂无审批记录', style: Theme.of(context).textTheme.bodyMedium);
    }
    final theme = Theme.of(context);
    return Column(
      children: logs.map((log) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
            border:
                Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                log.approvalStatusDisplay ?? log.approvalStatus ?? emptyText,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text('审核人: ${log.approvedByName ?? emptyText}'),
              Text('时间: ${formatDate(log.approvedAt)}'),
              if (log.approvalComment != null &&
                  log.approvalComment!.trim().isNotEmpty)
                Text('说明: ${log.approvalComment}'),
              if (log.rejectionReason != null &&
                  log.rejectionReason!.trim().isNotEmpty)
                Text('拒绝原因: ${log.rejectionReason}'),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _GanttRow {
  const _GanttRow({
    required this.label,
    required this.status,
    required this.start,
    required this.end,
    this.sequence,
  });

  final String label;
  final String? status;
  final DateTime start;
  final DateTime end;
  final int? sequence;
}

class _DetailField {
  const _DetailField(this.label, this.value);

  final String label;
  final String value;
}

class _DetailListCard extends StatelessWidget {
  const _DetailListCard({
    required this.title,
    required this.subtitle,
    required this.fields,
  });

  final String title;
  final String subtitle;
  final List<_DetailField> fields;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isXs = BreakpointsUtil.isXs(context);
    final itemWidth = isXs ? double.infinity : 132.0;
    final basePadding = LayoutTokens.cardPadding(context);
    final radius = isXs ? LayoutTokens.radiusMd : LayoutTokens.radiusLg;

    return Container(
      width: double.infinity,
      padding: basePadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.sidebarText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style:
                theme.textTheme.bodySmall?.copyWith(color: colors.subtleText),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: isXs ? 12 : 20,
            runSpacing: 10,
            children: fields
                .map(
                  (field) => SizedBox(
                    width: itemWidth,
                    child: _InfoRow(label: field.label, value: field.value),
                  ),
                )
                .toList(),
          ),
        ],
      ),
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
        const SizedBox(height: 4),
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
