import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';

/// 间距设计令牌
///
/// 统一所有间距值，禁止在业务代码中硬编码 SizedBox height/width 和 EdgeInsets 数值。
///
/// 使用示例：
/// ```dart
/// // 替代 SizedBox(height: 12) 或 SizedBox(height: 16)
/// SpacingTokens.vMd  // 12.0
/// SpacingTokens.vLg  // 16.0
///
/// // 替代 EdgeInsets.all(12)
/// SpacingTokens.allMd  // EdgeInsets.all(12)
///
/// // 替代 EdgeInsets.symmetric(horizontal: 12, vertical: 16)
/// SpacingTokens.h12v16  // EdgeInsets.symmetric(horizontal: 12, vertical: 16)
/// ```
class SpacingTokens {
  const SpacingTokens._();

  // ── 基础间距值 ──────────────────────────────────────────

  static const double xxxs = 2;
  static const double xxs = 6;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // ── 垂直间距快捷方式（用于 SizedBox(height: ...)） ─────

  static const SizedBox vXxxs = SizedBox(height: xxxs);
  static const SizedBox vXxs = SizedBox(height: xxs);
  static const SizedBox vXs = SizedBox(height: xs);
  static const SizedBox vSm = SizedBox(height: sm);
  static const SizedBox vMd = SizedBox(height: md);
  static const SizedBox vLg = SizedBox(height: lg);
  static const SizedBox vXl = SizedBox(height: xl);

  // ── 水平间距快捷方式（用于 SizedBox(width: ...)） ──────

  static const SizedBox hXs = SizedBox(width: xs);
  static const SizedBox hSm = SizedBox(width: sm);
  static const SizedBox hMd = SizedBox(width: md);
  static const SizedBox hLg = SizedBox(width: lg);
  static const SizedBox hXl = SizedBox(width: xl);

  // ── EdgeInsets 快捷方式 ─────────────────────────────────

  static const EdgeInsets allXs = EdgeInsets.all(xs);
  static const EdgeInsets allSm = EdgeInsets.all(sm);
  static const EdgeInsets allMd = EdgeInsets.all(md);
  static const EdgeInsets allLg = EdgeInsets.all(lg);
  static const EdgeInsets allXl = EdgeInsets.all(xl);

  /// 8 水平 + 12 垂直
  static const EdgeInsets h8v12 =
      EdgeInsets.symmetric(horizontal: sm, vertical: md);

  /// 12 水平 + 12 垂直
  static const EdgeInsets h12v12 =
      EdgeInsets.symmetric(horizontal: md, vertical: md);

  /// 12 水平 + 16 垂直
  static const EdgeInsets h12v16 =
      EdgeInsets.symmetric(horizontal: md, vertical: lg);

  /// 16 水平 + 12 垂直
  static const EdgeInsets h16v12 =
      EdgeInsets.symmetric(horizontal: lg, vertical: md);

  /// 16 水平 + 16 垂直
  static const EdgeInsets h16v16 =
      EdgeInsets.symmetric(horizontal: lg, vertical: lg);

  /// 24 水平 + 12 垂直
  static const EdgeInsets h24v12 =
      EdgeInsets.symmetric(horizontal: xl, vertical: md);

  /// 24 水平 + 16 垂直
  static const EdgeInsets h24v16 =
      EdgeInsets.symmetric(horizontal: xl, vertical: lg);

  // ── 响应式间距方法 ──────────────────────────────────────

  static EdgeInsets pagePadding(BuildContext context) {
    final isXs = ResponsiveLayout.isXs(context);
    final isSm = ResponsiveLayout.isSm(context);
    final isMd = ResponsiveLayout.isMd(context);
    final isXl = ResponsiveLayout.isXl(context);
    if (isXs) return const EdgeInsets.fromLTRB(12, 12, 12, 16);
    if (isSm) return const EdgeInsets.fromLTRB(16, 14, 16, 18);
    if (isMd) return const EdgeInsets.fromLTRB(20, 18, 20, 22);
    if (isXl) return const EdgeInsets.fromLTRB(24, 20, 24, 24);
    return const EdgeInsets.fromLTRB(28, 22, 28, 28);
  }

  static EdgeInsets pageHeaderPadding(BuildContext context) {
    final isXs = ResponsiveLayout.isXs(context);
    final isSm = ResponsiveLayout.isSm(context);
    final isMd = ResponsiveLayout.isMd(context);
    final isXl = ResponsiveLayout.isXl(context);
    if (isXs) return const EdgeInsets.fromLTRB(12, 12, 12, 8);
    if (isSm) return const EdgeInsets.fromLTRB(14, 14, 14, 10);
    if (isMd) return const EdgeInsets.fromLTRB(18, 16, 18, 12);
    if (isXl) return const EdgeInsets.fromLTRB(20, 18, 20, 12);
    return const EdgeInsets.fromLTRB(22, 20, 22, 14);
  }

  static EdgeInsets cardPadding(BuildContext context) {
    final isXs = ResponsiveLayout.isXs(context);
    final isSm = ResponsiveLayout.isSm(context);
    if (isXs) return const EdgeInsets.all(12);
    if (isSm) return const EdgeInsets.all(14);
    return const EdgeInsets.all(16);
  }

  static double sectionSpacing(BuildContext context) {
    if (ResponsiveLayout.isXs(context)) return 14;
    if (ResponsiveLayout.isSm(context)) return 16;
    if (ResponsiveLayout.isMd(context)) return 18;
    return 20;
  }

  static double formSectionSpacing(BuildContext context) {
    final isXs = ResponsiveLayout.isXs(context);
    final isSm = ResponsiveLayout.isSm(context);
    if (isXs) return 14;
    if (isSm) return 16;
    return 18;
  }

  static double formColumnSpacing(BuildContext context) {
    return ResponsiveLayout.isXs(context) ? 14 : 28;
  }

  static double formActionSpacing(BuildContext context) {
    return ResponsiveLayout.isXs(context) ? 14 : 20;
  }

  static double formPageSpacing(BuildContext context) {
    return ResponsiveLayout.isXs(context) ? 8 : 10;
  }
}
