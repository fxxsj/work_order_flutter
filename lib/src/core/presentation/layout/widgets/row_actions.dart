import 'package:flutter/material.dart';

class RowAction {
  const RowAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool destructive;
}

class RowActionGroup extends StatelessWidget {
  const RowActionGroup({
    super.key,
    required this.actions,
    this.primaryCount = 2,
    this.spacing = 6,
    this.overflowLabel = '更多',
  });

  final List<RowAction> actions;
  final int primaryCount;
  final double spacing;
  final String overflowLabel;

  @override
  Widget build(BuildContext context) {
    final available = actions
        .where((action) => action.label.trim().isNotEmpty)
        .where((action) => action.onPressed != null)
        .toList();
    if (available.isEmpty) {
      return const SizedBox.shrink();
    }

    final primary = available.take(primaryCount).toList();
    final overflow = available.skip(primaryCount).toList();
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < primary.length; i++) ...[
          _ActionIconButton(
            label: primary[i].label,
            icon: primary[i].icon ?? _iconForLabel(primary[i].label),
            onPressed: primary[i].onPressed,
            color: primary[i].destructive ? theme.colorScheme.error : null,
          ),
          if (i != primary.length - 1 || overflow.isNotEmpty)
            SizedBox(width: spacing),
        ],
        if (overflow.isNotEmpty)
          PopupMenuButton<int>(
            tooltip: overflowLabel,
            itemBuilder: (context) => [
              for (var i = 0; i < overflow.length; i++)
                PopupMenuItem<int>(
                  value: i,
                  child: Row(
                    children: [
                      Icon(
                        overflow[i].icon ?? _iconForLabel(overflow[i].label),
                        size: 16,
                        color: overflow[i].destructive
                            ? theme.colorScheme.error
                            : theme.iconTheme.color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        overflow[i].label,
                        style: overflow[i].destructive
                            ? TextStyle(color: theme.colorScheme.error)
                            : null,
                      ),
                    ],
                  ),
                ),
            ],
            onSelected: (index) => overflow[index].onPressed?.call(),
            child: Tooltip(
              message: overflowLabel,
              child: IconButton(
                onPressed: null,
                icon: const Icon(Icons.more_horiz, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: label,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        color: color ?? theme.iconTheme.color,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

IconData _iconForLabel(String label) {
  switch (label) {
    case '查看':
    case '详情':
    case '预览':
    case '查看施工单':
      return Icons.visibility_outlined;
    case '编辑':
    case '修改':
      return Icons.edit_outlined;
    case '新版本':
      return Icons.fiber_new_outlined;
    case '删除':
      return Icons.delete_outline;
    case '新建':
    case '新增':
    case '添加':
      return Icons.add_circle_outline;
    case '分派':
    case '分派操作员':
    case '指派':
      return Icons.assignment_ind_outlined;
    case '更新进度':
      return Icons.update_outlined;
    case '处理':
      return Icons.task_alt_outlined;
    case '完成任务':
      return Icons.task_alt_outlined;
    case '审核':
      return Icons.fact_check_outlined;
    case '确认':
      return Icons.verified_outlined;
    case '完成':
      return Icons.check_circle_outline;
    case '完成检验':
      return Icons.check_circle_outline;
    case '库存调整':
      return Icons.tune_outlined;
    case '发货':
      return Icons.local_shipping_outlined;
    case '签收':
      return Icons.assignment_turned_in_outlined;
    case '拒收':
      return Icons.cancel_outlined;
    case '暂停':
      return Icons.pause_circle_outline;
    case '启用':
      return Icons.toggle_on_outlined;
    case '禁用':
    case '停用':
      return Icons.toggle_off_outlined;
    case '重置':
      return Icons.restart_alt;
    case '复制':
      return Icons.content_copy_outlined;
    case '下载':
      return Icons.download_outlined;
    case '导出':
      return Icons.file_download_outlined;
    case '导入':
      return Icons.file_upload_outlined;
    case '打印':
      return Icons.print_outlined;
    case '返回':
      return Icons.arrow_back;
    case '关闭':
      return Icons.close;
    default:
      return Icons.help_outline;
  }
}
