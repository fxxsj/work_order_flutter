import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/connectivity_service.dart';
import 'package:work_order_app/src/core/presentation/layout/color_tokens.dart';

/// 感知网络状态的按钮
///
/// 当设备离线时自动禁用，并展示提示 Tooltip。
/// 用法：将原有 ElevatedButton / FilledButton 替换为 OfflineAwareButton，
/// 传入相同的 [onPressed] 和 [child]。
///
/// 如果需要在离线时完全隐藏按钮，可设置 [hideWhenOffline] 为 true。
class OfflineAwareButton extends StatelessWidget {
  const OfflineAwareButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.hideWhenOffline = false,
    this.tooltipMessage = '网络异常，请检查网络连接后重试',
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool hideWhenOffline;
  final String tooltipMessage;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ConnectivityService>();
    final isOffline = service.isOffline;

    if (hideWhenOffline && isOffline) {
      return const SizedBox.shrink();
    }

    return Tooltip(
      message: isOffline ? tooltipMessage : '',
      child: ElevatedButton(
        onPressed: isOffline ? null : onPressed,
        style: isOffline
            ? ElevatedButton.styleFrom(
                disabledBackgroundColor: ColorTokens.surface3,
                disabledForegroundColor: ColorTokens.inkTertiary,
              )
            : null,
        child: child,
      ),
    );
  }
}
