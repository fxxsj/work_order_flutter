import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/file_link_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
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
    required this.hasMultiApproval,
    required this.onStatusChanged,
    required this.onUpdateStatus,
    required this.onApprove,
    required this.onReject,
    required this.onResubmit,
    required this.onRequestReapproval,
    required this.buildInfoGrid,
    required this.buildSection,
    required this.buildResourceGroup,
    required this.emptyText,
  });

  final WorkOrderDetail detail;
  final List<DropdownMenuItem<String>> statusOptions;
  final String? statusSelection;
  final bool actionLoading;
  final bool hasMultiApproval;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onUpdateStatus;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onResubmit;
  final VoidCallback onRequestReapproval;
  final Widget Function(List<WorkOrderInfoItem> items) buildInfoGrid;
  final Widget Function(String title, Widget child) buildSection;
  final Widget Function(String title, List<String> items) buildResourceGroup;
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
          buildInfoGrid: buildInfoGrid,
          buildResourceGroup: buildResourceGroup,
        ));
    final actions = buildSection(
      '流程操作',
      WorkOrderActionPanel(
        detail: detail,
        statusOptions: statusOptions,
        statusSelection: statusSelection,
        actionLoading: actionLoading,
        hasMultiApproval: hasMultiApproval,
        onStatusChanged: onStatusChanged,
        onUpdateStatus: onUpdateStatus,
        onApprove: onApprove,
        onReject: onReject,
        onResubmit: onResubmit,
        onRequestReapproval: onRequestReapproval,
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
    required this.detail,
    required this.statusOptions,
    required this.statusSelection,
    required this.actionLoading,
    required this.hasMultiApproval,
    required this.onStatusChanged,
    required this.onUpdateStatus,
    required this.onApprove,
    required this.onReject,
    required this.onResubmit,
    required this.onRequestReapproval,
  });

  final WorkOrderDetail detail;
  final List<DropdownMenuItem<String>> statusOptions;
  final String? statusSelection;
  final bool actionLoading;
  final bool hasMultiApproval;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onUpdateStatus;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onResubmit;
  final VoidCallback onRequestReapproval;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final spacing = LayoutTokens.gapSm;
    final dividerColor = colors?.borderColor.withValues(alpha: 0.6);

    return LayoutBuilder(
      builder: (context, constraints) {
        final useColumnButtons = constraints.maxWidth < 320;
        final approvalActions = <Widget>[];

        if (!hasMultiApproval && detail.approvalStatus == 'pending') {
          if (useColumnButtons) {
            approvalActions.addAll([
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
            approvalActions.add(
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
        if (!hasMultiApproval && detail.approvalStatus == 'rejected') {
          approvalActions.add(
            FilledButton(
              onPressed: actionLoading ? null : onResubmit,
              child: const Text('重新提交审核'),
            ),
          );
        }
        if (!hasMultiApproval && detail.approvalStatus == 'approved') {
          approvalActions.add(
            OutlinedButton(
              onPressed: actionLoading ? null : onRequestReapproval,
              child: const Text('请求重新审核'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchableDropdownFormField<String>(
              initialValue: statusSelection,
              isExpanded: true,
              decoration: const InputDecoration(labelText: '状态'),
              items: statusOptions,
              onChanged: actionLoading ? null : onStatusChanged,
            ),
            SizedBox(height: spacing),
            FilledButton(
              onPressed: actionLoading ? null : onUpdateStatus,
              child: const Text('更新状态'),
            ),
            if (approvalActions.isNotEmpty) ...[
              SizedBox(height: LayoutTokens.gapMd),
              Divider(height: LayoutTokens.gapMd, color: dividerColor),
              Text(
                '审批操作',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colors?.sidebarText,
                ),
              ),
              SizedBox(height: spacing),
              ...approvalActions,
            ],
          ],
        );
      },
    );
  }
}

class WorkOrderMultiApprovalSection extends StatelessWidget {
  const WorkOrderMultiApprovalSection({
    super.key,
    required this.detail,
    required this.approvalLoading,
    required this.approvalActionLoading,
    required this.approvalErrorMessage,
    required this.approvalStatus,
    required this.currentUserName,
    required this.formatPercentage,
    required this.formatDateTime,
    required this.onRetry,
    required this.onSubmitApproval,
    required this.onMarkUrgent,
    required this.onStartStep,
    required this.onApproveStep,
    required this.onRejectStep,
    required this.onEscalateStep,
    required this.emptyText,
  });

  final WorkOrderDetail detail;
  final bool approvalLoading;
  final bool approvalActionLoading;
  final String? approvalErrorMessage;
  final Map<String, dynamic>? approvalStatus;
  final String? currentUserName;
  final String Function(dynamic value) formatPercentage;
  final String Function(dynamic value) formatDateTime;
  final VoidCallback onRetry;
  final VoidCallback onSubmitApproval;
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
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRetry,
            child: const Text('重试'),
          ),
        ],
      );
    }

    if (approvalStatus == null || steps.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('尚未启动多级审批', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
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
        const SizedBox(height: 12),
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
        const SizedBox(height: 16),
        Text(
          '审批步骤',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors?.sidebarText,
          ),
        ),
        const SizedBox(height: 8),
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
                    padding: const EdgeInsets.only(bottom: 12),
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

class _SummaryContent extends StatelessWidget {
  const _SummaryContent({
    required this.detail,
    required this.sectionSpacing,
    required this.emptyText,
    required this.buildInfoGrid,
    required this.buildResourceGroup,
  });

  final WorkOrderDetail detail;
  final double sectionSpacing;
  final String emptyText;
  final Widget Function(List<WorkOrderInfoItem> items) buildInfoGrid;
  final Widget Function(String title, List<String> items) buildResourceGroup;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final dividerColor = colors?.borderColor.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInfoGrid([
          WorkOrderInfoItem('客户', detail.customerName ?? emptyText),
          WorkOrderInfoItem('业务员', detail.salespersonName ?? emptyText),
          WorkOrderInfoItem('负责人', detail.managerName ?? emptyText),
          WorkOrderInfoItem('创建人', detail.createdByName ?? emptyText),
          WorkOrderInfoItem('审核人', detail.approvedByName ?? emptyText),
          WorkOrderInfoItem(
              '状态', detail.statusDisplay ?? detail.status ?? emptyText),
          WorkOrderInfoItem(
            '优先级',
            detail.priorityDisplay ?? detail.priority ?? emptyText,
          ),
          WorkOrderInfoItem(
            '审批状态',
            detail.approvalStatusDisplay ?? detail.approvalStatus ?? emptyText,
          ),
          WorkOrderInfoItem('审批说明', detail.approvalComment ?? emptyText),
          WorkOrderInfoItem('下单日期', _formatDate(detail.orderDate, emptyText)),
          WorkOrderInfoItem(
              '交货日期', _formatDate(detail.deliveryDate, emptyText)),
          WorkOrderInfoItem(
              '实际交货', _formatDate(detail.actualDeliveryDate, emptyText)),
          WorkOrderInfoItem(
            '生产数量',
            detail.productionQuantity?.toString() ?? emptyText,
          ),
          WorkOrderInfoItem(
            '不良数量',
            detail.defectiveQuantity?.toString() ?? emptyText,
          ),
          WorkOrderInfoItem(
            '任务数',
            detail.totalTaskCount?.toString() ?? emptyText,
          ),
          WorkOrderInfoItem(
            '草稿任务',
            detail.draftTaskCount?.toString() ?? emptyText,
          ),
          WorkOrderInfoItem(
            '总金额',
            detail.totalAmount == null
                ? emptyText
                : detail.totalAmount!.toStringAsFixed(2),
          ),
          WorkOrderInfoItem(
            '进度',
            detail.progressPercentage == null
                ? emptyText
                : '${detail.progressPercentage}%',
          ),
          WorkOrderInfoItem(
            '印刷形式',
            detail.printingTypeDisplay ?? detail.printingType ?? emptyText,
          ),
          WorkOrderInfoItem('印刷色数', detail.printingColorsDisplay ?? emptyText),
        ]),
        SizedBox(height: sectionSpacing),
        Divider(height: sectionSpacing, color: dividerColor),
        SizedBox(height: sectionSpacing),
        buildInfoGrid([
          WorkOrderInfoItem('备注', detail.notes ?? emptyText),
          WorkOrderInfoItem(
            'CMYK 颜色',
            detail.printingCmykColors.isEmpty
                ? emptyText
                : detail.printingCmykColors.join(', '),
          ),
          WorkOrderInfoItem(
            '其他颜色',
            detail.printingOtherColors.isEmpty
                ? emptyText
                : detail.printingOtherColors.join(', '),
          ),
          WorkOrderInfoItem(
            '设计文件',
            _hasDesignFile ? '已上传' : emptyText,
          ),
        ]),
        if (_hasDesignFile) ...[
          SizedBox(height: sectionSpacing),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () => _openDesignFile(),
              icon: const Icon(Icons.attach_file_outlined, size: 18),
              label: const Text('查看设计文件'),
            ),
          ),
        ],
        SizedBox(height: sectionSpacing),
        buildResourceGroup(
          '图稿',
          detail.artworkNames.isNotEmpty
              ? detail.artworkNames
              : detail.artworkCodes,
        ),
        SizedBox(height: sectionSpacing),
        buildResourceGroup(
          '刀模',
          detail.dieNames.isNotEmpty ? detail.dieNames : detail.dieCodes,
        ),
        SizedBox(height: sectionSpacing),
        buildResourceGroup(
          '烫金版',
          detail.foilingPlateNames.isNotEmpty
              ? detail.foilingPlateNames
              : detail.foilingPlateCodes,
        ),
        SizedBox(height: sectionSpacing),
        buildResourceGroup(
          '压凸版',
          detail.embossingPlateNames.isNotEmpty
              ? detail.embossingPlateNames
              : detail.embossingPlateCodes,
        ),
      ],
    );
  }

  String _formatDate(DateTime? value, String fallback) {
    if (value == null) return fallback;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  bool get _hasDesignFile {
    return (detail.designFileUrl ?? '').trim().isNotEmpty;
  }

  Future<void> _openDesignFile() async {
    try {
      await FileLinkUtil.open(detail.designFileUrl);
    } catch (err) {
      ToastUtil.showError('打开设计文件失败: $err');
    }
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
