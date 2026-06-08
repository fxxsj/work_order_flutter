import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/color_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/radius_tokens.dart';

/// 骨架屏加载组件
///
/// 自研 Shimmer 效果，无需额外依赖。颜色使用 [ColorTokens] 设计系统。
/// 用法：将需要骨架屏的区域包裹在 [ShimmerLoading] 中，或直接使用
/// [ShimmerBox] / [ShimmerListTile] / [ShimmerCard] 预设。
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
    this.enabled = true,
  });

  /// 要显示骨架屏的子 widget（通常是不带内容的占位形状）
  final Widget child;

  /// 是否启用 shimmer 动画
  final bool enabled;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ShimmerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: const Alignment(-1, 0),
              end: const Alignment(1, 0),
              colors: [
                ColorTokens.surface2,
                ColorTokens.surface3,
                ColorTokens.surface2,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlideGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  const _SlideGradientTransform(this.percent);

  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * percent, 0, 0);
  }
}

// ==================== 预设骨架形状 ====================

/// 矩形骨架块
///
/// 常用作列表项、卡片中的文本行或图片占位。
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorTokens.surface2,
        borderRadius: borderRadius ?? RadiusTokens.bSm,
      ),
    );
  }
}

/// 列表项骨架
///
/// 模拟一个带图标/头像 + 两行文本的列表项。
class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({
    super.key,
    this.leadingSize = 40,
    this.titleWidth = double.infinity,
    this.subtitleWidth = 120,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final double leadingSize;
  final double titleWidth;
  final double subtitleWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShimmerBox(
            width: leadingSize,
            height: leadingSize,
            borderRadius: BorderRadius.circular(leadingSize / 2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: titleWidth, height: 14),
                const SizedBox(height: 8),
                ShimmerBox(width: subtitleWidth, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 卡片骨架
///
/// 模拟一个带标题行 + 3 行内容 + 底部操作栏的卡片。
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.padding = const EdgeInsets.all(16),
  });

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(width: 120, height: 16),
              ShimmerBox(width: 60, height: 12),
            ],
          ),
          const SizedBox(height: 16),
          // 内容行
          ShimmerBox(width: double.infinity, height: 12),
          const SizedBox(height: 8),
          ShimmerBox(width: double.infinity, height: 12),
          const SizedBox(height: 8),
          ShimmerBox(width: 180, height: 12),
          const SizedBox(height: 16),
          // 底部分割线 + 操作栏
          Divider(color: ColorTokens.hairline, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShimmerBox(width: 60, height: 28, borderRadius: RadiusTokens.bMd),
              const SizedBox(width: 8),
              ShimmerBox(width: 60, height: 28, borderRadius: RadiusTokens.bMd),
            ],
          ),
        ],
      ),
    );
  }
}

/// 列表骨架（多个 [ShimmerListTile]）
class ShimmerList extends StatelessWidget {
  const ShimmerList({
    super.key,
    this.itemCount = 6,
    this.separator = const Divider(height: 1, color: ColorTokens.hairline),
  });

  final int itemCount;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount * 2 - 1, (index) {
        if (index.isEven) {
          return const ShimmerListTile();
        }
        return separator ?? const SizedBox.shrink();
      }),
    );
  }
}
