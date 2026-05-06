import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';

/// 设计令牌统一导出
export 'opacity_tokens.dart' show OpacityTokens, OpacityExtension;
export 'shadow_tokens.dart' show ShadowTokens, ShadowExtension;
export 'text_tokens.dart' show TextTokens, TextStyleExtension, TextBuilder;
export 'animation_tokens.dart'
    show AnimationTokens, AnimationBuilderExtension, PresetAnimations;
export 'color_tokens.dart' show ColorTokens, ColorExtension;

class LayoutTokens {
  const LayoutTokens._();

  static const double maxContentWidth = 1440;
  static const double maxContentWidthWide = 1680;
  static const double dialogWidthXs = 360;
  static const double dialogWidthSm = 420;
  static const double dialogWidthMd = 540;
  static const double dialogWidthLg = 720;
  static const double dialogWidthXl = 860;
  static const double sidebarWidth = 220;
  static const double sidebarWidthWide = 280;
  static const double searchWidth = 320;
  static const double pageWidthNarrow = 520;
  static const double pageWidthWide = 700;
  static const double pageWidthXwide = 760;
  static const double barrierOpacity = 0.3;
  static const double timelineChartMinWidth = 560;
  static const double timelineLabelWidth = 140;
  static const double timelineRowHeight = 36;
  static const double timelineBarHeight = 12;
  static const double infoItemWidth = 132;
  static const double statItemWidth = 180;
  static const double minContentRailWidth = 320;

  /// 统一圆角规范: 6/8/12/14 - shadcn 风格更柔和
  static const double radiusXs = 6;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 14;
  static const double radiusXl = 16;
  static const double radiusPill = 9999;
  static const double navItemHeight = 40;

  static const double gapXs = 4;
  static const double gapXxxs = 2;
  static const double gapXxs = 6;
  static const double gapSm = 8;
  static const double gapMd = 12;
  static const double gapLg = 16;
  static const double gapXl = 24;
  static const double cardPaddingSm = 12;
  static const double progressStrokeWidth = 2;

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
