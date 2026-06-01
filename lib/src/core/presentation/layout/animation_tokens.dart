import 'package:flutter/material.dart';

/// 动画和过渡效果配置
class AnimationTokens {
  const AnimationTokens._();

  // ==================== 时长配置 ====================

  /// 极快动画（微交互反馈）
  static const Duration fast = Duration(milliseconds: 150);

  /// 标准动画（常规过渡）
  static const Duration medium = Duration(milliseconds: 250);

  /// 较慢动画（复杂过渡）
  static const Duration slow = Duration(milliseconds: 350);

  /// 慢速动画（页面转场）
  static const Duration slower = Duration(milliseconds: 450);

  /// 极慢动画（特殊效果）
  static const Duration slowest = Duration(milliseconds: 600);

  // ==================== 曲线配置 ====================

  /// 标准缓动曲线
  static const Curve easeInOut = Curves.easeInOut;

  /// 减速曲线（进入动画）
  static const Curve decelerate = Curves.decelerate;

  /// 加速曲线（退出动画）
  static const Curve accelerate = Curves.easeIn;

  /// 弹性曲线
  static const Curve bounce = Curves.elasticOut;

  /// 平滑曲线
  static const Curve smooth = Curves.easeOutCubic;

  /// 自定义缓动曲线
  static const Curve customEase = Cubic(0.4, 0.0, 0.2, 1.0);

  // ==================== 组合配置 ====================

  /// 按钮按下效果
  static const Duration buttonDuration = Duration(milliseconds: 100);
  static const Curve buttonCurve = Curves.easeInOut;

  /// 对话框进入
  static const Duration dialogEnter = Duration(milliseconds: 250);
  static const Curve dialogCurve = Curves.easeOutCubic;

  /// 侧边栏滑动
  static const Duration sidebarSlide = Duration(milliseconds: 250);
  static const Curve sidebarCurve = Curves.easeOut;

  /// 列表项展开
  static const Duration expandDuration = Duration(milliseconds: 200);
  static const Curve expandCurve = Curves.easeInOut;

  /// 页面转场
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Curve pageTransitionCurve = Curves.easeInOut;

  /// 加载旋转
  static const Duration loadingRotation = Duration(milliseconds: 1000);

  /// 淡入淡出
  static const Duration fade = Duration(milliseconds: 150);
  static const Duration fadeSlow = Duration(milliseconds: 250);

  /// 缩放
  static const Duration scale = Duration(milliseconds: 150);

  /// 滑动
  static const Duration slide = Duration(milliseconds: 250);
}

/// 动画构建器扩展
extension AnimationBuilderExtension on Widget {
  /// 淡入动画
  Widget fadeIn({Duration? duration, Curve? curve, VoidCallback? onComplete}) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? AnimationTokens.fade,
      curve: curve ?? AnimationTokens.smooth,
      tween: Tween(begin: 0, end: 1),
      onEnd: onComplete,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: this,
    );
  }

  /// 滑入动画
  Widget slideIn({
    Duration? duration,
    Curve? curve,
    Offset begin = const Offset(0, 0.3),
    VoidCallback? onComplete,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration ?? AnimationTokens.slide,
      curve: curve ?? AnimationTokens.easeInOut,
      tween: Tween(begin: begin, end: Offset.zero),
      onEnd: onComplete,
      builder: (context, value, child) {
        return FractionalTranslation(translation: value, child: child);
      },
      child: this,
    );
  }

  /// 缩放动画
  Widget scaleIn({
    Duration? duration,
    Curve? curve,
    double begin = 0.9,
    VoidCallback? onComplete,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? AnimationTokens.scale,
      curve: curve ?? AnimationTokens.easeInOut,
      tween: Tween(begin: begin, end: 1),
      onEnd: onComplete,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: this,
    );
  }
}

/// 常用动画预设
class PresetAnimations {
  /// 淡入 + 上滑
  static Widget fadeInUp(Widget child) {
    return child
        .slideIn(begin: const Offset(0, 0.1), curve: Curves.easeOutCubic)
        .fadeIn(curve: Curves.easeOutCubic);
  }

  /// 淡入 + 下滑
  static Widget fadeInDown(Widget child) {
    return child
        .slideIn(begin: const Offset(0, -0.1), curve: Curves.easeOutCubic)
        .fadeIn(curve: Curves.easeOutCubic);
  }

  /// 缩放淡入
  static Widget scaleFadeIn(Widget child) {
    return child
        .scaleIn(begin: 0.95, curve: Curves.easeOutCubic)
        .fadeIn(curve: Curves.easeOutCubic);
  }

  /// 延迟动画列表
  static List<Widget> staggeredList(
    List<Widget> children, {
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return List.generate(
      children.length,
      (index) => TweenAnimationBuilder<double>(
        duration: AnimationTokens.medium,
        tween: Tween(begin: 0, end: 1),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: children[index],
      ),
    );
  }
}
