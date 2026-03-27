import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';

class LayoutTokens {
  const LayoutTokens._();

  static const double maxContentWidth = 1440;
  static const double maxContentWidthWide = 1680;

  /// 统一圆角规范: 8/12/16/20
  static const double radiusXs = 8;
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 24;
  static const double radiusPill = 999;
  static const double navItemHeight = 40;

  static const double gapXs = 4;
  static const double gapSm = 8;
  static const double gapMd = 12;
  static const double gapLg = 16;
  static const double gapXl = 24;

  /// 统一图标大小规范
  static const double iconXs = 14;
  static const double iconSm = 16;
  static const double iconMd = 18;
  static const double iconLg = 20;
  static const double iconXl = 24;
  static const double iconXxl = 32;
  static const double iconXxxl = 36;

  static EdgeInsets pagePadding(BuildContext context) {
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    final isMd = BreakpointsUtil.isMd(context);
    final isXl = BreakpointsUtil.isXl(context);
    if (isXs) {
      return const EdgeInsets.fromLTRB(12, 12, 12, 16);
    }
    if (isSm) {
      return const EdgeInsets.fromLTRB(16, 14, 16, 18);
    }
    if (isMd) {
      return const EdgeInsets.fromLTRB(20, 18, 20, 22);
    }
    if (isXl) {
      return const EdgeInsets.fromLTRB(24, 20, 24, 24);
    }
    return const EdgeInsets.fromLTRB(28, 22, 28, 28);
  }

  static EdgeInsets pageHeaderPadding(BuildContext context) {
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    final isMd = BreakpointsUtil.isMd(context);
    final isXl = BreakpointsUtil.isXl(context);
    if (isXs) {
      return const EdgeInsets.fromLTRB(12, 12, 12, 8);
    }
    if (isSm) {
      return const EdgeInsets.fromLTRB(14, 14, 14, 10);
    }
    if (isMd) {
      return const EdgeInsets.fromLTRB(18, 16, 18, 12);
    }
    if (isXl) {
      return const EdgeInsets.fromLTRB(20, 18, 20, 12);
    }
    return const EdgeInsets.fromLTRB(22, 20, 22, 14);
  }

  static EdgeInsets cardPadding(BuildContext context) {
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    if (isXs) {
      return const EdgeInsets.all(12);
    }
    if (isSm) {
      return const EdgeInsets.all(14);
    }
    return const EdgeInsets.all(16);
  }

  static double sectionSpacing(BuildContext context) {
    if (BreakpointsUtil.isXs(context)) return 14;
    if (BreakpointsUtil.isSm(context)) return 16;
    if (BreakpointsUtil.isMd(context)) return 18;
    return 20;
  }

  static double formSectionSpacing(BuildContext context) {
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    if (isXs) return 14;
    if (isSm) return 16;
    return 18;
  }

  static double formColumnSpacing(BuildContext context) {
    return BreakpointsUtil.isXs(context) ? 14 : 28;
  }

  static double formActionSpacing(BuildContext context) {
    return BreakpointsUtil.isXs(context) ? 14 : 20;
  }

  static double formPageSpacing(BuildContext context) {
    return BreakpointsUtil.isXs(context) ? 8 : 10;
  }
}
