import 'package:flutter/material.dart';

/// 透明度令牌系统
///
/// 统一所有不透明度值，确保视觉一致性
class OpacityTokens {
  const OpacityTokens._();

  /// 基础透明度值
  static const double invisible = 0;
  static const double faint = 0.03;
  static const double weak = 0.06;
  static const double subtle = 0.08;
  static const double mild = 0.12;
  static const double medium = 0.16;
  static const double distinct = 0.24;
  static const double distinctStrong = 0.4;
  static const double strong = 0.45;
  static const double heavy = 0.55;
  static const double intense = 0.7;
  static const double solid = 1;

  /// 常用组合
  static const double border = medium;
  static const double borderMedium = 0.5;
  static const double borderStrong = 0.75;
  static const double divider = medium;
  static const double iconSubtle = strong;
  static const double textSecondary = intense;
  static const double textMuted = 0.78;
  static const double textProminent = 0.9;
  static const double disabled = 0.38;
  static const double hover = weak;
  static const double focus = subtle;
  static const double pressed = mild;
  static const double dragged = weak;
  static const double scrim = 0.32;
  static const double splash = 0.12;
  static const double surfaceOverlay = 0.92;

  /// 获取带透明度的颜色
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// 常用语义色透明度
  static Color successBg(Color color) => color.withValues(alpha: weak);
  static Color warningBg(Color color) => color.withValues(alpha: weak);
  static Color dangerBg(Color color) => color.withValues(alpha: weak);
  static Color infoBg(Color color) => color.withValues(alpha: weak);

  static Color successBorder(Color color) => color.withValues(alpha: medium);
  static Color warningBorder(Color color) => color.withValues(alpha: medium);
  static Color dangerBorder(Color color) => color.withValues(alpha: medium);
  static Color infoBorder(Color color) => color.withValues(alpha: medium);
}

/// 透明度扩展方法
extension OpacityExtension on Color {
  /// 常用透明度快捷方法
  Color withOpacity(double opacity) => withValues(alpha: opacity);

  Color get faint => withValues(alpha: OpacityTokens.faint);
  Color get weak => withValues(alpha: OpacityTokens.weak);
  Color get subtle => withValues(alpha: OpacityTokens.subtle);
  Color get mild => withValues(alpha: OpacityTokens.mild);
  Color get medium => withValues(alpha: OpacityTokens.medium);
  Color get distinct => withValues(alpha: OpacityTokens.distinct);
  Color get strong => withValues(alpha: OpacityTokens.strong);
  Color get heavy => withValues(alpha: OpacityTokens.heavy);
}
