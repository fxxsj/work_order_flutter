import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_decision_dialog.dart';

export 'work_order_delete_confirm_dialog.dart';

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

Future<WorkOrderApprovalDialogResult?> showWorkOrderApprovalDialog(
  BuildContext context, {
  required bool approved,
}) async {
  final result = await showActionDecisionDialog<void>(
    context,
    title: approved ? '通过施工单审核' : '退回施工单审核',
    summary: approved
        ? '通过后，施工单会继续进入后续审批或执行流程。'
        : '退回会中断当前审批流，提交人需要根据退回原因补料、补图或修改信息后重新发起。',
    impacts: approved
        ? const [
            '请先确认资料、图稿、工艺和交期信息已核对完成',
            '通过后可能触发后续审批、排产或执行动作',
          ]
        : const [
            '请把“必须补什么、改什么、谁来补”写清楚',
            '模糊备注会导致业务与生产反复确认，拖慢交期',
          ],
    auditHint: approved ? '审批说明会进入施工单审批历史。' : '本次退回意见会成为后续追责和复盘的重要依据。',
    destructive: !approved,
    notesLabel: approved ? '审批说明（可选）' : '退回原因',
    notesHint: approved ? '例如：资料齐全，可进入下一步' : '请明确写清需要补充或修改的内容',
    requireNotes: !approved,
    notesErrorText: '请填写退回原因',
    extraNotesLabel: approved ? null : '补充说明（可选）',
    extraNotesHint: approved ? null : '例如：请补充修改方式、责任人或截止时间',
    submitText: approved ? '确认通过' : '确认退回',
  );
  if (result == null) return null;
  return WorkOrderApprovalDialogResult(
    comment: approved ? result.notes : result.extraNotes,
    rejectionReason: approved ? null : result.notes,
  );
}

Future<String?> showWorkOrderReasonDialog(
  BuildContext context, {
  required String title,
  required String label,
  String confirmText = '提交',
}) async {
  final result = await showActionDecisionDialog<void>(
    context,
    title: title,
    notesLabel: label,
    notesMaxLines: 3,
    submitText: confirmText,
  );
  return result?.notes;
}

Future<String?> showWorkOrderApprovalStepDialog(
  BuildContext context, {
  required String decision,
}) async {
  final isReject = decision == 'reject';
  final result = await showActionDecisionDialog<void>(
    context,
    title: '审批${isReject ? '拒绝' : '通过'}',
    summary: isReject ? '拒绝当前步骤后，审批链会停在这里，前序人员需要根据说明补充资料后再推进。' : null,
    impacts: isReject
        ? const [
            '请直接写明拒绝原因和修正动作',
            '不要只写“资料不全”这类无法执行的结论',
          ]
        : const [],
    auditHint: isReject ? '审批步骤的拒绝说明会保留在审计和审批历史中。' : null,
    destructive: isReject,
    notesLabel: isReject ? '拒绝说明' : '备注说明',
    notesHint: isReject ? '例如：缺少打样确认和设计稿版本号' : null,
    notesMaxLines: 3,
    submitText: '确定',
  );
  return result?.notes;
}

Future<WorkOrderEscalateDialogResult?> showWorkOrderEscalateDialog(
  BuildContext context,
) async {
  final result = await showActionDecisionDialog<void>(
    context,
    title: '上报审批步骤',
    summary: '上报会把当前审批问题升级处理，适合职责不清、跨部门卡点或当前步骤无权决策的场景。',
    impacts: const [
      '请写清当前卡点、已沟通对象和需要谁介入',
      '没有明确原因的上报，后续仍会回到原步骤反复沟通',
    ],
    auditHint: '上报动作和原因会进入审批与审计记录。',
    notesLabel: '上报原因',
    notesMaxLines: 3,
    extraNotesLabel: '目标步骤ID（可选）',
    extraNotesHint: '填写数字步骤 ID，留空则按系统默认流转',
    extraNotesMaxLines: 1,
    submitText: '提交',
  );
  if (result == null) return null;
  return WorkOrderEscalateDialogResult(
    reason: result.notes,
    targetStepId: int.tryParse(result.extraNotes.trim()),
  );
}
