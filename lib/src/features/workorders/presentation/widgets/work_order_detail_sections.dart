import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/attachment_open_button.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/file_link_util.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';

class WorkOrderInfoItem {
  const WorkOrderInfoItem(this.label, this.value);

  final String label;
  final String value;
}

class WorkOrderDetailOverviewSection extends StatelessWidget {
  const WorkOrderDetailOverviewSection({
    super.key,
    required this.detail,
    required this.statusOptions,
    required this.statusSelection,
    required this.actionLoading,
    required this.onUploadDesignFile,
    required this.onStatusChanged,
    required this.onUpdateStatus,
    required this.buildSection,
    required this.emptyText,
  });

  final WorkOrderDetail detail;
  final List<AppDropdownOption<String>> statusOptions;
  final String? statusSelection;
  final bool actionLoading;
  final VoidCallback? onUploadDesignFile;
  final ValueChanged<String?>? onStatusChanged;
  final VoidCallback? onUpdateStatus;
  final Widget Function(String title, Widget child) buildSection;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final summary = buildSection(
        '施工单信息',
        _SummaryContent(
          detail: detail,
          sectionSpacing: sectionSpacing,
          emptyText: emptyText,
          actionLoading: actionLoading,
          onUploadDesignFile: onUploadDesignFile,
        ));
    final actions = buildSection(
      '流程操作',
      WorkOrderActionPanel(
        statusOptions: statusOptions,
        statusSelection: statusSelection,
        actionLoading: actionLoading,
        onStatusChanged: onStatusChanged,
        onUpdateStatus: onUpdateStatus,
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < Breakpoints.lg;
        if (isNarrow) {
          return Column(
            children: [
              summary,
              SizedBox(height: sectionSpacing),
              actions,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: summary),
            SizedBox(width: sectionSpacing),
            SizedBox(width: 300, child: actions),
          ],
        );
      },
    );
  }
}

class WorkOrderActionPanel extends StatelessWidget {
  const WorkOrderActionPanel({
    super.key,
    required this.statusOptions,
    required this.statusSelection,
    required this.actionLoading,
    required this.onStatusChanged,
    required this.onUpdateStatus,
  });

  final List<AppDropdownOption<String>> statusOptions;
  final String? statusSelection;
  final bool actionLoading;
  final ValueChanged<String?>? onStatusChanged;
  final VoidCallback? onUpdateStatus;

  @override
  Widget build(BuildContext context) {
    final spacing = LayoutTokens.gapSm;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSelect<String>(
              value: statusSelection,
              decoration: const InputDecoration(labelText: '状态'),
              options: statusOptions,
              onChanged: actionLoading || onStatusChanged == null
                  ? null
                  : onStatusChanged,
            ),
            SizedBox(height: spacing),
            FilledButton(
              onPressed: actionLoading || onUpdateStatus == null
                  ? null
                  : onUpdateStatus,
              child: const Text('更新状态'),
            ),
          ],
        );
      },
    );
  }
}

class WorkOrderApprovalSection extends StatelessWidget {
  const WorkOrderApprovalSection({
    super.key,
    required this.detail,
    required this.actionLoading,
    required this.onSubmitApproval,
    required this.onApprove,
    required this.onReject,
    required this.onResubmit,
    required this.onMarkUrgent,
    required this.emptyText,
  });

  final WorkOrderDetail detail;
  final bool actionLoading;
  final VoidCallback onSubmitApproval;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onResubmit;
  final VoidCallback onMarkUrgent;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return _SingleApprovalContent(
      detail: detail,
      actionLoading: actionLoading,
      onApprove: onApprove,
      onReject: onReject,
      onSubmitApproval: onSubmitApproval,
      onResubmit: onResubmit,
      onMarkUrgent: onMarkUrgent,
      emptyText: emptyText,
    );
  }
}

class _SingleApprovalContent extends StatelessWidget {
  const _SingleApprovalContent({
    required this.detail,
    required this.actionLoading,
    required this.onApprove,
    required this.onReject,
    required this.onSubmitApproval,
    required this.onResubmit,
    required this.onMarkUrgent,
    required this.emptyText,
  });

  final WorkOrderDetail detail;
  final bool actionLoading;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback onSubmitApproval;
  final VoidCallback? onResubmit;
  final VoidCallback onMarkUrgent;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusText =
        detail.approvalStatusDisplay ?? detail.approvalStatus ?? emptyText;
    final comment = (detail.approvalComment ?? '').trim();
    final status = detail.approvalStatus ?? '';
    final spacing = LayoutTokens.gapSm;
    final useColumnButtons = BreakpointsUtil.isMobile(context);

    final actions = <Widget>[];
    if (status == 'draft') {
      actions.add(
        FilledButton.icon(
          onPressed: actionLoading ? null : onSubmitApproval,
          icon: const Icon(Icons.fact_check_outlined, size: 18),
          label: Text(actionLoading ? '提交中' : '提交审核'),
        ),
      );
    }
    if ((status == 'submitted' || status == 'pending') &&
        onApprove != null &&
        onReject != null) {
      if (useColumnButtons) {
        actions.addAll([
          FilledButton(
            onPressed: actionLoading ? null : onApprove,
            child: const Text('审核通过'),
          ),
          SizedBox(height: spacing),
          OutlinedButton(
            onPressed: actionLoading ? null : onReject,
            child: const Text('审核拒绝'),
          ),
        ]);
      } else {
        actions.add(
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: actionLoading ? null : onApprove,
                  child: const Text('审核通过'),
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: OutlinedButton(
                  onPressed: actionLoading ? null : onReject,
                  child: const Text('审核拒绝'),
                ),
              ),
            ],
          ),
        );
      }
    }
    if (status == 'rejected' && onResubmit != null) {
      actions.add(
        FilledButton.icon(
          onPressed: actionLoading ? null : onResubmit,
          icon: const Icon(Icons.send_outlined, size: 18),
          label: const Text('重新提交审核'),
        ),
      );
    }
    if (detail.priority != 'urgent') {
      actions.add(
        OutlinedButton.icon(
          onPressed: actionLoading ? null : onMarkUrgent,
          icon: const Icon(Icons.priority_high, size: 18),
          label: const Text('标记紧急'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: LayoutTokens.gapLg,
          runSpacing: LayoutTokens.gapSm,
          children: [
            _InfoRow(label: '审批状态', value: statusText),
            _InfoRow(
              label: '审核人',
              value: detail.approvedByName?.trim().isNotEmpty == true
                  ? detail.approvedByName!
                  : emptyText,
            ),
          ],
        ),
        if (comment.isNotEmpty) ...[
          SizedBox(height: LayoutTokens.gapMd),
          Text(
            comment,
            style: theme.textTheme.bodyMedium,
          ),
        ],
        if (actions.isNotEmpty) ...[
          SizedBox(height: LayoutTokens.gapMd),
          Wrap(
            spacing: LayoutTokens.gapSm,
            runSpacing: LayoutTokens.gapSm,
            children: actions,
          ),
        ],
      ],
    );
  }
}

// ---- Summary Content (描述列表风格) ----

class _SummaryContent extends StatelessWidget {
  const _SummaryContent({
    required this.detail,
    required this.sectionSpacing,
    required this.emptyText,
    required this.actionLoading,
    required this.onUploadDesignFile,
  });

  final WorkOrderDetail detail;
  final double sectionSpacing;
  final String emptyText;
  final bool actionLoading;
  final VoidCallback? onUploadDesignFile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final dividerColor =
        colors?.borderColor.withValues(alpha: OpacityTokens.heavy);
    final showPrinting =
        detail.printingType != null && detail.printingType != 'none';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 基本信息描述列表
        _buildDescriptionGrid(context, [
          _DescItem('客户', detail.customerName ?? emptyText),
          _DescItem('业务员', detail.salespersonName ?? emptyText),
          _DescItem('负责人', detail.managerName ?? emptyText),
          _DescItem('创建人', detail.createdByName ?? emptyText),
          _DescItem('审核人', detail.approvedByName ?? emptyText),
          _DescItem(
            '状态',
            detail.statusDisplay ?? detail.status ?? emptyText,
            isStatus: true,
            statusType: 'status',
            statusValue: detail.status,
          ),
          _DescItem(
            '审核状态',
            detail.approvalStatusDisplay ?? detail.approvalStatus ?? emptyText,
            isStatus: true,
            statusType: 'approval',
            statusValue: detail.approvalStatus,
          ),
          _DescItem(
            '优先级',
            detail.priorityDisplay ?? detail.priority ?? emptyText,
            isStatus: true,
            statusType: 'priority',
            statusValue: detail.priority,
          ),
          _DescItem(
            '进度',
            '${detail.progressPercentage ?? 0}%',
            isProgress: true,
            progressValue: (detail.progressPercentage ?? 0).toDouble(),
          ),
          _DescItem('下单日期', _formatDate(detail.orderDate)),
          _DescItem('交货日期', _formatDate(detail.deliveryDate)),
          _DescItem('实际交货', _formatDate(detail.actualDeliveryDate)),
          _DescItem(
            '生产数量',
            detail.productionQuantity?.toString() ?? emptyText,
          ),
          _DescItem(
            '不良数量',
            detail.defectiveQuantity?.toString() ?? emptyText,
          ),
          _DescItem(
            '总金额',
            detail.totalAmount == null
                ? emptyText
                : '¥${detail.totalAmount!.toStringAsFixed(2)}',
          ),
          _DescItem(
            '任务数',
            detail.totalTaskCount?.toString() ?? emptyText,
          ),
          _DescItem(
            '印刷形式',
            detail.printingTypeDisplay ?? detail.printingType ?? emptyText,
          ),
          _DescItem('印刷色数', detail.printingColorsDisplay ?? emptyText),
          _DescItem(
            '审批说明',
            detail.approvalComment ?? emptyText,
            spanFull: true,
          ),
        ]),
        SizedBox(height: sectionSpacing),
        Divider(height: sectionSpacing, color: dividerColor),
        SizedBox(height: sectionSpacing),

        // 图稿和版信息
        Text(
          '图稿和版信息',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors?.sidebarText,
          ),
        ),
        SizedBox(height: LayoutTokens.gapSm),
        _buildDescriptionGrid(context, [
          _DescItem(
            '图稿（CTP版）',
            _joinResourceItems(detail.artworkCodes, detail.artworkNames),
          ),
          if (showPrinting)
            _DescItem(
              '印刷要求',
              [
                detail.printingColorsDisplay,
                detail.printingTypeDisplay ?? detail.printingType,
              ].where((s) => s != null && s.isNotEmpty).join(' '),
            ),
          _DescItem(
            '刀模',
            _joinResourceItems(detail.dieCodes, detail.dieNames),
          ),
          _DescItem(
            '烫金版',
            _joinResourceItems(
                detail.foilingPlateCodes, detail.foilingPlateNames),
          ),
          _DescItem(
            '压凸版',
            _joinResourceItems(
                detail.embossingPlateCodes, detail.embossingPlateNames),
          ),
        ]),
        SizedBox(height: sectionSpacing),
        Divider(height: sectionSpacing, color: dividerColor),
        SizedBox(height: sectionSpacing),

        // 设计文件
        if (_hasDesignFile) ...[
          Wrap(
            spacing: LayoutTokens.gapSm,
            runSpacing: LayoutTokens.gapSm,
            children: [
              AttachmentOpenButton(
                fileUrl: detail.designFileUrl,
                label: '查看设计文件',
                errorPrefix: '打开设计文件失败',
              ),
              if (onUploadDesignFile != null)
                OutlinedButton.icon(
                  onPressed: actionLoading ? null : onUploadDesignFile,
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
                  label: const Text('重新上传'),
                ),
            ],
          ),
          SizedBox(height: sectionSpacing),
        ] else if (onUploadDesignFile != null) ...[
          OutlinedButton.icon(
            onPressed: actionLoading ? null : onUploadDesignFile,
            icon: const Icon(Icons.upload_file_outlined, size: 18),
            label: const Text('上传设计文件'),
          ),
          SizedBox(height: sectionSpacing),
        ],

        // 备注
        _buildDescriptionGrid(context, [
          _DescItem('备注', detail.notes ?? emptyText, spanFull: true),
        ]),
      ],
    );
  }

  Widget _buildDescriptionGrid(BuildContext context, List<_DescItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final columns = maxWidth < Breakpoints.sm
            ? 1
            : maxWidth < Breakpoints.lg
                ? 2
                : 3;
        final rows = <Widget>[];
        for (var i = 0; i < items.length;) {
          final rowItems = <_DescItem>[];
          var rowSpan = 0;
          while (i < items.length && rowSpan < columns) {
            final item = items[i];
            if (item.spanFull && rowSpan > 0) break;
            rowItems.add(item);
            rowSpan += item.spanFull ? columns : 1;
            i++;
          }
          rows.add(Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowItems.map((item) {
              final flex = item.spanFull ? columns : 1;
              return Expanded(
                flex: flex,
                child: _DescriptionCell(
                  label: item.label,
                  value: item.value,
                  isStatus: item.isStatus,
                  statusType: item.statusType,
                  statusValue: item.statusValue,
                  isProgress: item.isProgress,
                  progressValue: item.progressValue,
                ),
              );
            }).toList(),
          ));
        }
        return Column(children: rows);
      },
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) return emptyText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  bool get _hasDesignFile {
    return FileLinkUtil.hasLink(detail.designFileUrl);
  }

  String _joinResourceItems(List<String> codes, List<String> names) {
    if (codes.isEmpty && names.isEmpty) return emptyText;
    if (codes.isEmpty) return names.join('、');
    if (names.isEmpty) return codes.join('、');
    final parts = <String>[];
    for (var i = 0; i < codes.length; i++) {
      final name = i < names.length ? names[i] : '';
      parts.add(name.isNotEmpty ? '${codes[i]} - $name' : codes[i]);
    }
    return parts.join('、');
  }
}

class _DescItem {
  const _DescItem(
    this.label,
    this.value, {
    this.isStatus = false,
    this.statusType,
    this.statusValue,
    this.isProgress = false,
    this.progressValue,
    this.spanFull = false,
  });

  final String label;
  final String value;
  final bool isStatus;
  final String? statusType;
  final String? statusValue;
  final bool isProgress;
  final double? progressValue;
  final bool spanFull;
}

class _DescriptionCell extends StatelessWidget {
  const _DescriptionCell({
    required this.label,
    required this.value,
    this.isStatus = false,
    this.statusType,
    this.statusValue,
    this.isProgress = false,
    this.progressValue,
  });

  final String label;
  final String value;
  final bool isStatus;
  final String? statusType;
  final String? statusValue;
  final bool isProgress;
  final double? progressValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final dividerColor =
        colors?.borderColor.withValues(alpha: OpacityTokens.strong);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: dividerColor ?? Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors?.subtleText,
            ),
          ),
          SpacingTokens.vXs,
          if (isProgress && progressValue != null)
            ClipRRect(
              borderRadius: RadiusTokens.bXs,
              child: LinearProgressIndicator(
                value: progressValue! / 100,
                backgroundColor:
                    colors?.borderColor.withValues(alpha: OpacityTokens.medium),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressValue! >= 100
                      ? Colors.green
                      : theme.colorScheme.primary,
                ),
              ),
            )
          else if (isStatus && statusValue != null)
            _StatusBadge(
              text: value,
              type: statusType ?? '',
              statusValue: statusValue!,
            )
          else
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.text,
    required this.type,
    required this.statusValue,
  });

  final String text;
  final String type;
  final String statusValue;

  @override
  Widget build(BuildContext context) {
    final color = _badgeColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: OpacityTokens.mild),
        borderRadius: RadiusTokens.bXs,
        border:
            Border.all(color: color.withValues(alpha: OpacityTokens.strong)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Color get _badgeColor {
    switch (type) {
      case 'status':
        switch (statusValue) {
          case 'pending':
            return Colors.grey;
          case 'in_progress':
            return Colors.blue;
          case 'paused':
            return Colors.orange;
          case 'completed':
            return Colors.green;
          case 'cancelled':
            return Colors.red;
          default:
            return Colors.grey;
        }
      case 'approval':
        switch (statusValue) {
          case 'draft':
            return Colors.grey;
          case 'submitted':
          case 'pending':
            return Colors.orange;
          case 'approved':
            return Colors.green;
          case 'rejected':
            return Colors.red;
          default:
            return Colors.grey;
        }
      case 'priority':
        switch (statusValue) {
          case 'low':
            return Colors.grey;
          case 'normal':
            return Colors.blue;
          case 'high':
            return Colors.orange;
          case 'urgent':
            return Colors.red;
          default:
            return Colors.grey;
        }
      default:
        return Colors.grey;
    }
  }
}

// ---- Shared Info Row (used by WorkOrderMultiApprovalSection) ----

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
