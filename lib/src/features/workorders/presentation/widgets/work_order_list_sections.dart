import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/risk_action_dialog.dart';

class WorkOrderListFilterDrawerContent extends StatelessWidget {
  const WorkOrderListFilterDrawerContent({
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
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
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
