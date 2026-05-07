import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/attachment_open_button.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
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
    required this.hasMultiApproval,
    required this.approvalLoading,
    required this.approvalActionLoading,
    required this.approvalErrorMessage,
    required this.approvalStatus,
    required this.currentUserName,
    required this.formatPercentage,
    required this.formatDateTime,
    required this.onRetry,
    required this.onSubmitApproval,
    required this.onApprove,
    required this.onReject,
    required this.onResubmit,
    required this.onRequestReapproval,
    required this.onMarkUrgent,
    required this.onStartStep,
    required this.onApproveStep,
    required this.onRejectStep,
    required this.onEscalateStep,
    required this.emptyText,
  });

  final WorkOrderDetail detail;
  final bool hasMultiApproval;
  final bool approvalLoading;
  final bool approvalActionLoading;
  final String? approvalErrorMessage;
  final Map<String, dynamic>? approvalStatus;
  final String? currentUserName;
  final String Function(dynamic value) formatPercentage;
  final String Function(dynamic value) formatDateTime;
  final VoidCallback onRetry;
  final VoidCallback onSubmitApproval;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onResubmit;
  final VoidCallback? onRequestReapproval;
  final VoidCallback onMarkUrgent;
  final ValueChanged<int> onStartStep;
  final ValueChanged<int> onApproveStep;
  final ValueChanged<int> onRejectStep;
  final ValueChanged<int> onEscalateStep;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final isMobile = BreakpointsUtil.isMobile(context);
    final currentStep = _currentApprovalStep;
    final steps = _allApprovalSteps;

    if (approvalLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (approvalErrorMessage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(approvalErrorMessage!, style: theme.textTheme.bodyMedium),
          SizedBox(height: LayoutTokens.gapMd),
          FilledButton(
            onPressed: onRetry,
            child: const Text('重试'),
          ),
        ],
      );
    }

    if (!hasMultiApproval) {
      return _SingleApprovalContent(
        detail: detail,
        actionLoading: approvalActionLoading,
        onApprove: onApprove,
        onReject: onReject,
        onResubmit: onResubmit,
        onRequestReapproval: onRequestReapproval,
        emptyText: emptyText,
      );
    }

    if (approvalStatus == null || steps.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('尚未启动多级审批', style: theme.textTheme.bodyMedium),
          SizedBox(height: LayoutTokens.gapMd),
          Wrap(
            spacing: LayoutTokens.gapSm,
            runSpacing: LayoutTokens.gapSm,
            children: [
              FilledButton.icon(
                onPressed: approvalActionLoading ? null : onSubmitApproval,
                icon: const Icon(Icons.fact_check_outlined, size: 18),
                label: Text(approvalActionLoading ? '提交中' : '提交审批'),
              ),
              if (detail.priority != 'urgent')
                OutlinedButton.icon(
                  onPressed: approvalActionLoading ? null : onMarkUrgent,
                  icon: const Icon(Icons.priority_high, size: 18),
                  label: const Text('标记紧急'),
                ),
            ],
          ),
        ],
      );
    }

    final totalSteps = approvalStatus?['total_steps']?.toString() ?? emptyText;
    final completedSteps =
        approvalStatus?['completed_steps']?.toString() ?? emptyText;
    final progressText =
        formatPercentage(approvalStatus?['progress_percentage']);
    final approvalStatusText = approvalStatus?['approval_status']?.toString() ??
        detail.approvalStatusDisplay ??
        emptyText;

    final assignedTo = currentStep == null
        ? emptyText
        : currentStep['assigned_to_name']?.toString() ?? emptyText;
    final stepStatus = currentStep == null
        ? emptyText
        : currentStep['status']?.toString() ?? emptyText;
    final stepName = currentStep == null
        ? emptyText
        : currentStep['step_name']?.toString() ?? emptyText;
    final stepRawId = currentStep == null ? null : currentStep['id'];
    final stepId = stepRawId is int
        ? stepRawId
        : int.tryParse(stepRawId?.toString() ?? '');

    final canAct = currentUserName == null ||
        currentUserName!.isEmpty ||
        currentUserName == assignedTo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: LayoutTokens.gapLg,
          runSpacing: LayoutTokens.gapSm,
          children: [
            _InfoRow(label: '审批状态', value: approvalStatusText),
            _InfoRow(
              label: '进度',
              value: '$completedSteps / $totalSteps ($progressText)',
            ),
            _InfoRow(label: '当前步骤', value: stepName),
            _InfoRow(label: '负责人', value: assignedTo),
          ],
        ),
        SizedBox(height: LayoutTokens.gapMd),
        Wrap(
          spacing: LayoutTokens.gapSm,
          runSpacing: LayoutTokens.gapSm,
          children: [
            if (stepId != null && stepStatus == 'pending')
              FilledButton.icon(
                onPressed: approvalActionLoading || !canAct
                    ? null
                    : () => onStartStep(stepId),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('开始审核'),
              ),
            if (stepId != null &&
                (stepStatus == 'pending' || stepStatus == 'in_progress')) ...[
              FilledButton.icon(
                onPressed: approvalActionLoading || !canAct
                    ? null
                    : () => onApproveStep(stepId),
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text('通过'),
              ),
              OutlinedButton.icon(
                onPressed: approvalActionLoading || !canAct
                    ? null
                    : () => onRejectStep(stepId),
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: const Text('拒绝'),
              ),
              OutlinedButton.icon(
                onPressed: approvalActionLoading || !canAct
                    ? null
                    : () => onEscalateStep(stepId),
                icon: const Icon(Icons.trending_up, size: 18),
                label: const Text('上报'),
              ),
            ],
            FilledButton.icon(
              onPressed: approvalActionLoading ? null : onSubmitApproval,
              icon: const Icon(Icons.fact_check_outlined, size: 18),
              label: Text(approvalActionLoading ? '提交中' : '重新提交'),
            ),
            if (detail.priority != 'urgent')
              OutlinedButton.icon(
                onPressed: approvalActionLoading ? null : onMarkUrgent,
                icon: const Icon(Icons.priority_high, size: 18),
                label: const Text('标记紧急'),
              ),
          ],
        ),
        SizedBox(height: LayoutTokens.gapLg),
        Text(
          '审批步骤',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors?.sidebarText,
          ),
        ),
        SizedBox(height: LayoutTokens.gapSm),
        if (!isMobile)
          AppDataTable(
            columns: const [
              DataColumn(label: Text('序号')),
              DataColumn(label: Text('步骤')),
              DataColumn(label: Text('状态')),
              DataColumn(label: Text('负责人')),
              DataColumn(label: Text('决定')),
              DataColumn(label: Text('开始时间')),
              DataColumn(label: Text('完成时间')),
            ],
            rows: steps
                .map(
                  (step) => DataRow(
                    cells: [
                      DataCell(
                          Text(step['step_order']?.toString() ?? emptyText)),
                      DataCell(
                          Text(step['step_name']?.toString() ?? emptyText)),
                      DataCell(Text(step['status']?.toString() ?? emptyText)),
                      DataCell(Text(
                          step['assigned_to_name']?.toString() ?? emptyText)),
                      DataCell(Text(step['decision']?.toString() ?? emptyText)),
                      DataCell(Text(formatDateTime(step['started_at']))),
                      DataCell(Text(formatDateTime(step['completed_at']))),
                    ],
                  ),
                )
                .toList(),
          )
        else
          Column(
            children: steps
                .map(
                  (step) => Padding(
                    padding: EdgeInsets.only(bottom: LayoutTokens.gapMd),
                    child: DetailSectionCard(
                      title: step['step_name']?.toString() ?? emptyText,
                      child: Wrap(
                        spacing: LayoutTokens.gapLg,
                        runSpacing: LayoutTokens.gapSm,
                        children: [
                          _InfoRow(
                              label: '状态',
                              value: step['status']?.toString() ?? emptyText),
                          _InfoRow(
                              label: '负责人',
                              value: step['assigned_to_name']?.toString() ??
                                  emptyText),
                          _InfoRow(
                              label: '决定',
                              value: step['decision']?.toString() ?? emptyText),
                          _InfoRow(
                              label: '开始时间',
                              value: formatDateTime(step['started_at'])),
                          _InfoRow(
                              label: '完成时间',
                              value: formatDateTime(step['completed_at'])),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Map<String, dynamic>? get _currentApprovalStep {
    final data = approvalStatus?['current_step'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  List<Map<String, dynamic>> get _allApprovalSteps {
    final data = approvalStatus?['all_steps'];
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}

class _SingleApprovalContent extends StatelessWidget {
  const _SingleApprovalContent({
    required this.detail,
    required this.actionLoading,
    required this.onApprove,
    required this.onReject,
    required this.onResubmit,
    required this.onRequestReapproval,
    required this.emptyText,
  });

  final WorkOrderDetail detail;
  final bool actionLoading;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onResubmit;
  final VoidCallback? onRequestReapproval;
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
    if (status == 'pending' && onApprove != null && onReject != null) {
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
    if (status == 'approved' && onRequestReapproval != null) {
      actions.add(
        OutlinedButton.icon(
          onPressed: actionLoading ? null : onRequestReapproval,
          icon: const Icon(Icons.restart_alt, size: 18),
          label: const Text('请求重新审核'),
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
    final dividerColor = colors?.borderColor.withValues(alpha: OpacityTokens.heavy);
    final showPrinting = detail.printingType != null &&
        detail.printingType != 'none';

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
            detail.approvalStatusDisplay ??
                detail.approvalStatus ??
                emptyText,
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
            '草稿任务',
            detail.draftTaskCount?.toString() ?? emptyText,
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

  Widget _buildDescriptionGrid(
      BuildContext context, List<_DescItem> items) {
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
    final dividerColor = colors?.borderColor.withValues(alpha: OpacityTokens.strong);

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
          const SizedBox(height: 4),
          if (isProgress && progressValue != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
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
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: OpacityTokens.strong)),
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
