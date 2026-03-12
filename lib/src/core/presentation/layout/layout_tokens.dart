import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';

class LayoutTokens {
  const LayoutTokens._();

  static const double maxContentWidth = 1240;

  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 18;
  static const double radiusXl = 20;
  static const double radiusPill = 999;
  static const double navItemHeight = 40;

  static const double gapXs = 4;
  static const double gapSm = 8;
  static const double gapMd = 12;
  static const double gapLg = 16;

  static EdgeInsets pagePadding(BuildContext context) {
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    final isMd = BreakpointsUtil.isMd(context);
    final isXl = BreakpointsUtil.isXl(context);
    if (isXs) {
      return const EdgeInsets.fromLTRB(16, 16, 16, 24);
    }
    if (isSm) {
      return const EdgeInsets.fromLTRB(20, 20, 20, 28);
    }
    if (isMd) {
      return const EdgeInsets.fromLTRB(24, 24, 24, 32);
    }
    if (isXl) {
      return const EdgeInsets.fromLTRB(28, 28, 28, 36);
    }
    return const EdgeInsets.fromLTRB(32, 32, 32, 40);
  }

  static EdgeInsets pageHeaderPadding(BuildContext context) {
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    final isMd = BreakpointsUtil.isMd(context);
    final isXl = BreakpointsUtil.isXl(context);
    if (isXs) {
      return const EdgeInsets.fromLTRB(12, 12, 12, 10);
    }
    if (isSm) {
      return const EdgeInsets.fromLTRB(14, 14, 14, 12);
    }
    if (isMd) {
      return const EdgeInsets.fromLTRB(16, 16, 16, 12);
    }
    if (isXl) {
      return const EdgeInsets.fromLTRB(18, 18, 18, 14);
    }
    return const EdgeInsets.fromLTRB(20, 20, 20, 16);
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
    return BreakpointsUtil.isXs(context) ? 10 : 12;
  }

  static double formSectionSpacing(BuildContext context) {
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    if (isXs) return 12;
    if (isSm) return 14;
    return 16;
  }

  static double formColumnSpacing(BuildContext context) {
    return BreakpointsUtil.isXs(context) ? 12 : 24;
  }

  static double formActionSpacing(BuildContext context) {
    return BreakpointsUtil.isXs(context) ? 16 : 24;
  }

  static double formPageSpacing(BuildContext context) {
    return BreakpointsUtil.isXs(context) ? 8 : 10;
  }
}
