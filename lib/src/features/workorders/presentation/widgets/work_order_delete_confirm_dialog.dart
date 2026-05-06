import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_dialogs.dart';

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
