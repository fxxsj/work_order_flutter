import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// 增强的按钮组件，内置动画效果
class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = AnimatedButtonVariant.filled,
    this.size = AnimatedButtonSize.medium,
    this.width,
    this.height,
    this.icon,
    this.loading = false,
    this.disabled = false,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final AnimatedButtonVariant variant;
  final AnimatedButtonSize size;
  final double? width;
  final double? height;
  final Widget? icon;
  final bool loading;
  final bool disabled;
  final String? tooltip;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  bool get _isEnabled =>
      widget.onPressed != null && !widget.disabled && !widget.loading;

  @override
  Widget build(BuildContext context) {
    // 根据尺寸获取配置
    final sizeConfig = _getSizeConfig();
    final effectiveHeight = widget.height ?? sizeConfig.height;

    // 构建按钮内容
    Widget buttonChild = _buildChild(context, sizeConfig);

    // 添加加载指示器
    if (widget.loading) {
      buttonChild = SizedBox(
        height: effectiveHeight,
        width: widget.width,
        child: Center(
          child: SizedBox(
            width: sizeConfig.iconSize,
            height: sizeConfig.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getTextColor(context),
              ),
            ),
          ),
        ),
      );
    }

    // 构建按钮
    final button = MouseRegion(
      cursor: _isEnabled ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTapDown: _isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: _isEnabled
            ? (_) {
                setState(() => _isPressed = false);
                widget.onPressed?.call();
              }
            : null,
        onTapCancel:
            _isEnabled ? () => setState(() => _isPressed = false) : null,
        child: AnimatedContainer(
          duration: AnimationTokens.buttonDuration,
          curve: AnimationTokens.buttonCurve,
          width: widget.width,
          height: effectiveHeight,
          decoration: BoxDecoration(
            color: _getBackgroundColor(context),
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            boxShadow: _getBoxShadow(context),
            border: widget.variant == AnimatedButtonVariant.outlined
                ? Border.all(
                    color: _getBorderColor(context),
                    width: _isPressed ? 2 : 1.5,
                  )
                : null,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.horizontalPadding,
            vertical: sizeConfig.verticalPadding,
          ),
          child: Center(
            child: buttonChild,
          ),
        ),
      ),
    );

    // 添加 tooltip
    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }

  Widget _buildChild(BuildContext context, _ButtonSizeConfig sizeConfig) {
    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(
              size: sizeConfig.iconSize,
              color: _getTextColor(context),
            ),
            child: widget.icon!,
          ),
          SizedBox(width: sizeConfig.iconTextSpacing),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: sizeConfig.fontSize,
              fontWeight: sizeConfig.fontWeight,
              color: _getTextColor(context),
            ),
            child: widget.child,
          ),
        ],
      );
    }

    return DefaultTextStyle(
      style: TextStyle(
        fontSize: sizeConfig.fontSize,
        fontWeight: sizeConfig.fontWeight,
        color: _getTextColor(context),
      ),
      child: widget.child,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>();

    if (!_isEnabled || widget.loading) {
      return theme.colorScheme.surfaceContainerHighest;
    }

    switch (widget.variant) {
      case AnimatedButtonVariant.filled:
        return theme.colorScheme.primary;
      case AnimatedButtonVariant.outlined:
        return _isPressed
            ? theme.colorScheme.primary.withValues(alpha: OpacityTokens.faint)
            : Colors.transparent;
      case AnimatedButtonVariant.text:
        return Colors.transparent;
      case AnimatedButtonVariant.danger:
        return semantic?.danger ?? theme.colorScheme.error;
      case AnimatedButtonVariant.success:
        return semantic?.success ?? ColorTokens.success;
      case AnimatedButtonVariant.warning:
        return semantic?.warning ?? ColorTokens.warning;
    }
  }

  Color _getTextColor(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isEnabled || widget.loading) {
      return theme.colorScheme.onSurface
          .withValues(alpha: OpacityTokens.disabled);
    }

    switch (widget.variant) {
      case AnimatedButtonVariant.filled:
        return theme.colorScheme.onPrimary;
      case AnimatedButtonVariant.outlined:
      case AnimatedButtonVariant.text:
        return theme.colorScheme.primary;
      case AnimatedButtonVariant.danger:
        return theme.colorScheme.onError;
      case AnimatedButtonVariant.success:
        return Colors.white;
      case AnimatedButtonVariant.warning:
        return Colors.white;
    }
  }

  Color _getBorderColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.primary.withValues(
      alpha: _isPressed ? OpacityTokens.medium : OpacityTokens.mild,
    );
  }

  List<BoxShadow> _getBoxShadow(BuildContext context) {
    switch (widget.variant) {
      case AnimatedButtonVariant.filled:
      case AnimatedButtonVariant.danger:
      case AnimatedButtonVariant.success:
      case AnimatedButtonVariant.warning:
        return _isPressed ? ShadowTokens.pressed : ShadowTokens.button;
      case AnimatedButtonVariant.outlined:
      case AnimatedButtonVariant.text:
        return ShadowTokens.none;
    }
  }

  _ButtonSizeConfig _getSizeConfig() {
    switch (widget.size) {
      case AnimatedButtonSize.small:
        return _ButtonSizeConfig(
          height: 32,
          horizontalPadding: 12,
          verticalPadding: 6,
          borderRadius: LayoutTokens.radiusSm,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          iconSize: 14,
          iconTextSpacing: 6,
        );
      case AnimatedButtonSize.medium:
        return _ButtonSizeConfig(
          height: 36,
          horizontalPadding: 16,
          verticalPadding: 8,
          borderRadius: LayoutTokens.radiusSm,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          iconSize: 16,
          iconTextSpacing: 8,
        );
      case AnimatedButtonSize.large:
        return _ButtonSizeConfig(
          height: 42,
          horizontalPadding: 20,
          verticalPadding: 10,
          borderRadius: LayoutTokens.radiusMd,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          iconSize: 18,
          iconTextSpacing: 8,
        );
    }
  }
}

class _ButtonSizeConfig {
  const _ButtonSizeConfig({
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
    required this.fontSize,
    required this.fontWeight,
    required this.iconSize,
    required this.iconTextSpacing,
  });

  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final double iconSize;
  final double iconTextSpacing;
}

enum AnimatedButtonVariant {
  filled,
  outlined,
  text,
  danger,
  success,
  warning,
}

enum AnimatedButtonSize {
  small,
  medium,
  large,
}

/// 常用的预设按钮
class PresetButtons {
  /// 主要操作按钮
  static Widget primary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget label,
    Widget? icon,
    bool loading = false,
    bool disabled = false,
    AnimatedButtonSize size = AnimatedButtonSize.medium,
  }) {
    return AnimatedButton(
      key: key,
      onPressed: onPressed,
      variant: AnimatedButtonVariant.filled,
      size: size,
      icon: icon,
      loading: loading,
      disabled: disabled,
      child: label,
    );
  }

  /// 次要操作按钮
  static Widget secondary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget label,
    Widget? icon,
    bool loading = false,
    bool disabled = false,
    AnimatedButtonSize size = AnimatedButtonSize.medium,
  }) {
    return AnimatedButton(
      key: key,
      onPressed: onPressed,
      variant: AnimatedButtonVariant.outlined,
      size: size,
      icon: icon,
      loading: loading,
      disabled: disabled,
      child: label,
    );
  }

  /// 危险操作按钮
  static Widget danger({
    Key? key,
    required VoidCallback? onPressed,
    required Widget label,
    Widget? icon,
    bool loading = false,
    bool disabled = false,
    AnimatedButtonSize size = AnimatedButtonSize.medium,
  }) {
    return AnimatedButton(
      key: key,
      onPressed: onPressed,
      variant: AnimatedButtonVariant.danger,
      size: size,
      icon: icon,
      loading: loading,
      disabled: disabled,
      child: label,
    );
  }

  /// 文本按钮
  static Widget text({
    Key? key,
    required VoidCallback? onPressed,
    required Widget label,
    Widget? icon,
    bool loading = false,
    bool disabled = false,
    AnimatedButtonSize size = AnimatedButtonSize.medium,
  }) {
    return AnimatedButton(
      key: key,
      onPressed: onPressed,
      variant: AnimatedButtonVariant.text,
      size: size,
      icon: icon,
      loading: loading,
      disabled: disabled,
      child: label,
    );
  }
}
