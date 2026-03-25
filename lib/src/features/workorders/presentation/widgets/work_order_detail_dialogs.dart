import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/risk_action_dialog.dart';

class WorkOrderApprovalDialogResult {
  const WorkOrderApprovalDialogResult({
    required this.comment,
    this.rejectionReason,
  });

  final String comment;
  final String? rejectionReason;
}

class WorkOrderEscalateDialogResult {
  const WorkOrderEscalateDialogResult({
    required this.reason,
    this.targetStepId,
  });

  final String reason;
  final int? targetStepId;
}

Future<bool> showWorkOrderDeleteConfirmDialog(
  BuildContext context, {
  required String title,
  required String number,
  String? customerName,
}) async {
  return showRiskActionConfirmDialog(
    context,
    title: title,
    summary: '即将删除施工单 $number。删除后，这张单据将不能继续排产、审核和追踪。',
    impacts: [
      if ((customerName ?? '').trim().isNotEmpty)
        '关联客户：${customerName!.trim()}',
      '已有任务、审批和跨单据关联需要人工重新核对',
      '删除后不能直接恢复，后续只能重新建单补数据',
    ],
    auditHint: '建议删除前先确认是否仍有任务推进、财务关联或审批争议需要保留追溯记录。',
    confirmText: '确认删除',
    destructive: true,
  );
}

Future<WorkOrderApprovalDialogResult?> showWorkOrderApprovalDialog(
  BuildContext context, {
  required bool approved,
}) async {
  final commentController = TextEditingController();
  final rejectionController = TextEditingController();
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(approved ? '通过施工单审核' : '退回施工单审核'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!approved) ...[
                const RiskActionHintPanel(
                  summary: '退回会中断当前审批流，提交人需要根据退回原因补料、补图或修改信息后重新发起。',
                  impacts: [
                    '请把“必须补什么、改什么、谁来补”写清楚',
                    '模糊备注会导致业务与生产反复确认，拖慢交期',
                  ],
                  auditHint: '本次退回意见会成为后续追责和复盘的重要依据。',
                  destructive: true,
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: approved ? '审批说明（可选）' : '补充说明（可选）',
                  hintText: approved ? '例如：资料齐全，可进入下一步' : '例如：请补充修改方式、责任人或截止时间',
                ),
                maxLines: 3,
              ),
              if (!approved) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: rejectionController,
                  decoration: const InputDecoration(
                    labelText: '退回原因',
                    hintText: '请明确写清需要补充或修改的内容',
                  ),
                  maxLines: 3,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(approved ? '确认通过' : '确认退回'),
          ),
        ],
      ),
    );
    if (confirmed != true) return null;
    return WorkOrderApprovalDialogResult(
      comment: commentController.text.trim(),
      rejectionReason: approved ? null : rejectionController.text.trim(),
    );
  } finally {
    commentController.dispose();
    rejectionController.dispose();
  }
}

Future<String?> showWorkOrderReasonDialog(
  BuildContext context, {
  required String title,
  required String label,
  String confirmText = '提交',
}) async {
  final controller = TextEditingController();
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    if (confirmed != true) return null;
    return controller.text.trim();
  } finally {
    controller.dispose();
  }
}

Future<String?> showWorkOrderApprovalStepDialog(
  BuildContext context, {
  required String decision,
}) async {
  final isReject = decision == 'reject';
  final controller = TextEditingController();
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('审批${isReject ? '拒绝' : '通过'}'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isReject) ...[
                const RiskActionHintPanel(
                  summary: '拒绝当前步骤后，审批链会停在这里，前序人员需要根据说明补充资料后再推进。',
                  impacts: [
                    '请直接写明拒绝原因和修正动作',
                    '不要只写“资料不全”这类无法执行的结论',
                  ],
                  auditHint: '审批步骤的拒绝说明会保留在审计和审批历史中。',
                  destructive: true,
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: isReject ? '拒绝说明' : '备注说明',
                  hintText: isReject ? '例如：缺少打样确认和设计稿版本号' : null,
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (confirmed != true) return null;
    return controller.text.trim();
  } finally {
    controller.dispose();
  }
}

Future<WorkOrderEscalateDialogResult?> showWorkOrderEscalateDialog(
  BuildContext context,
) async {
  final reasonController = TextEditingController();
  final targetController = TextEditingController();
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('上报审批步骤'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const RiskActionHintPanel(
                summary: '上报会把当前审批问题升级处理，适合职责不清、跨部门卡点或当前步骤无权决策的场景。',
                impacts: [
                  '请写清当前卡点、已沟通对象和需要谁介入',
                  '没有明确原因的上报，后续仍会回到原步骤反复沟通',
                ],
                auditHint: '上报动作和原因会进入审批与审计记录。',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: '上报原因'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: targetController,
                decoration: const InputDecoration(labelText: '目标步骤ID（可选）'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('提交'),
          ),
        ],
      ),
    );
    if (confirmed != true) return null;
    return WorkOrderEscalateDialogResult(
      reason: reasonController.text.trim(),
      targetStepId: int.tryParse(targetController.text.trim()),
    );
  } finally {
    reasonController.dispose();
    targetController.dispose();
  }
}
