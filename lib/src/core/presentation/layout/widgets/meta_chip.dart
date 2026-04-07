import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// 通用标签-值元信息芯片组件
///
/// 用于列表项中展示键值对形式的元信息，如"客户: xxx"、"状态: xxx"。
/// 从 TaskListTile 和 WorkOrderListTile 中提取的共享组件。
class MetaChip extends StatelessWidget {
  const MetaChip({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: colors.subtleText,
    );
    final valueStyle = theme.textTheme.labelSmall?.copyWith(
      color: colors.sidebarText,
      fontWeight: FontWeight.w700,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: LayoutTokens.gapMd,
        vertical: LayoutTokens.gapXs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: OpacityTokens.faint),
        borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
        border: Border.all(color: colors.borderColor),
      ),
      child: RichText(
        text: TextSpan(
          style: labelStyle,
          children: [
            TextSpan(text: '$label '),
            TextSpan(
              text: value,
              style: valueStyle,
            ),
          ],
        ),
      ),
    );
  }
}
