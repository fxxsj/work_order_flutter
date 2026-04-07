import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/models/traceability_summary_item.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/traceability_summary_section.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';

class WorkOrderDetailInfoItem {
  const WorkOrderDetailInfoItem(this.label, this.value);

  final String label;
  final String value;
}

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
            padding: const EdgeInsets.only(bottom: LayoutTokens.cardPaddingSm),
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
            padding: const EdgeInsets.only(bottom: LayoutTokens.cardPaddingSm),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = (constraints.maxWidth -
                LayoutTokens.timelineLabelWidth -
                LayoutTokens.gapMd)
            .clamp(LayoutTokens.minContentRailWidth, double.infinity);

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
                constraints: BoxConstraints(
                  minWidth: LayoutTokens.timelineLabelWidth +
                      LayoutTokens.timelineChartMinWidth,
                ),
                child: SizedBox(
                  width: LayoutTokens.timelineLabelWidth + chartWidth,
                  child: Column(
                    children: [
                      for (final row in rows)
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: LayoutTokens.cardPaddingSm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: LayoutTokens.timelineLabelWidth,
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
                              const SizedBox(width: LayoutTokens.gapMd),
                              Expanded(
                                child: SizedBox(
                                  height: LayoutTokens.timelineRowHeight,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: borderColor.withValues(
                                                alpha: 0.12),
                                            borderRadius: BorderRadius.circular(
                                              LayoutTokens.radiusXs,
                                            ),
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
                                        top: (LayoutTokens.timelineRowHeight -
                                                LayoutTokens
                                                    .timelineBarHeight) /
                                            2,
                                        child: Container(
                                          width: _resolveBarWidth(
                                            row,
                                            start,
                                            safeTotalMs,
                                            chartWidth,
                                          ),
                                          height:
                                              LayoutTokens.timelineBarHeight,
                                          decoration: BoxDecoration(
                                            color: _statusColor(
                                              row.status,
                                              theme,
                                              semantic,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              LayoutTokens.radiusXs,
                                            ),
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
            padding: const EdgeInsets.only(bottom: LayoutTokens.cardPaddingSm),
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

class WorkOrderTraceabilitySection extends StatelessWidget {
  const WorkOrderTraceabilitySection({
    super.key,
    required this.salesOrderSummaries,
    required this.qualityInspectionSummaries,
    required this.invoiceSummaries,
    required this.onOpenSalesOrder,
    required this.onOpenSalesOrderPage,
    required this.onOpenQualityPage,
    required this.onOpenInvoicePage,
    required this.emptyText,
  });

  final List<TraceabilitySummaryItem> salesOrderSummaries;
  final List<TraceabilitySummaryItem> qualityInspectionSummaries;
  final List<TraceabilitySummaryItem> invoiceSummaries;
  final ValueChanged<TraceabilitySummaryItem> onOpenSalesOrder;
  final VoidCallback onOpenSalesOrderPage;
  final VoidCallback onOpenQualityPage;
  final VoidCallback onOpenInvoicePage;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return TraceabilitySummarySection(
      title: '上下游关联',
      emptyText: emptyText,
      groups: [
        TraceabilitySummaryGroupData(
          title: '来源客户订单',
          items: salesOrderSummaries,
          actionLabel: '客户订单列表',
          onActionTap: onOpenSalesOrderPage,
          onItemTap: onOpenSalesOrder,
        ),
        TraceabilitySummaryGroupData(
          title: '关联质检单',
          items: qualityInspectionSummaries,
          actionLabel: '质检列表',
          onActionTap: onOpenQualityPage,
        ),
        TraceabilitySummaryGroupData(
          title: '关联发票',
          items: invoiceSummaries,
          actionLabel: '发票列表',
          onActionTap: onOpenInvoicePage,
        ),
      ],
    );
  }
}

class WorkOrderFinanceSummarySection extends StatelessWidget {
  const WorkOrderFinanceSummarySection({
    super.key,
    required this.items,
    required this.onOpenSalesOrderPage,
    required this.onOpenInvoicePage,
    required this.onOpenPaymentPage,
  });

  final List<WorkOrderDetailInfoItem> items;
  final VoidCallback onOpenSalesOrderPage;
  final VoidCallback onOpenInvoicePage;
  final VoidCallback onOpenPaymentPage;

  @override
  Widget build(BuildContext context) {
    return DetailSectionCard(
      title: '财务闭环',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 20,
            runSpacing: LayoutTokens.gapMd,
            children: items
                .map(
                  (item) => SizedBox(
                    width: BreakpointsUtil.isXs(context)
                        ? double.infinity
                        : LayoutTokens.statItemWidth,
                    child: _InfoRow(label: item.label, value: item.value),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: LayoutTokens.gapLg),
          Wrap(
            spacing: LayoutTokens.gapSm,
            runSpacing: LayoutTokens.gapSm,
            children: [
              OutlinedButton.icon(
                onPressed: onOpenSalesOrderPage,
                icon: const Icon(
                  Icons.point_of_sale_outlined,
                  size: LayoutTokens.iconSm,
                ),
                label: const Text('客户订单列表'),
              ),
              OutlinedButton.icon(
                onPressed: onOpenInvoicePage,
                icon: const Icon(
                  Icons.receipt_long_outlined,
                  size: LayoutTokens.iconSm,
                ),
                label: const Text('发票列表'),
              ),
              OutlinedButton.icon(
                onPressed: onOpenPaymentPage,
                icon: const Icon(
                  Icons.payments_outlined,
                  size: LayoutTokens.iconSm,
                ),
                label: const Text('收款列表'),
              ),
            ],
          ),
        ],
      ),
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
          margin: const EdgeInsets.only(bottom: LayoutTokens.gapSm),
          padding: const EdgeInsets.all(LayoutTokens.gapMd),
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
    final itemWidth = isXs ? double.infinity : LayoutTokens.infoItemWidth;
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
          const SizedBox(height: LayoutTokens.gapMd),
          Wrap(
            spacing: isXs
                ? LayoutTokens.gapMd
                : LayoutTokens.gapXl - LayoutTokens.gapXs,
            runSpacing: LayoutTokens.cardPaddingSm,
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
        const SizedBox(height: LayoutTokens.gapXs),
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
