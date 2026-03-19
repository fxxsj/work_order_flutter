import 'package:flutter/material.dart';

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
  required String content,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('删除'),
        ),
      ],
    ),
  );
  return confirmed == true;
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
        title: Text(approved ? '审核通过' : '审核拒绝'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: commentController,
              decoration: const InputDecoration(labelText: '备注说明'),
              maxLines: 3,
            ),
            if (!approved) ...[
              const SizedBox(height: 12),
              TextField(
                controller: rejectionController,
                decoration: const InputDecoration(labelText: '拒绝原因'),
                maxLines: 3,
              ),
            ],
          ],
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
  return showWorkOrderReasonDialog(
    context,
    title: '审批${decision == 'approve' ? '通过' : '拒绝'}',
    label: '备注说明',
    confirmText: '确定',
  );
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
