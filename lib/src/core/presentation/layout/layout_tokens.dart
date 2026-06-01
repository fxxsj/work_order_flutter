import 'package:flutter/material.dart';

// 本文件 const 初始化需要直接 import
import 'spacing_tokens.dart';
import 'radius_tokens.dart';

/// 设计令牌统一导出
export 'opacity_tokens.dart' show OpacityTokens, OpacityExtension;
export 'shadow_tokens.dart' show ShadowTokens, ShadowExtension;
export 'text_tokens.dart' show TextTokens, TextStyleExtension, TextBuilder;
export 'animation_tokens.dart'
    show AnimationTokens, AnimationBuilderExtension, PresetAnimations;
export 'color_tokens.dart' show ColorTokens, ColorExtension;
export 'spacing_tokens.dart' show SpacingTokens;
export 'radius_tokens.dart' show RadiusTokens;

/// 布局尺寸令牌（对话框宽度、侧边栏、导航等结构尺寸）
///
/// 间距相关请使用 [SpacingTokens]，圆角相关请使用 [RadiusTokens]。
class LayoutTokens {
  const LayoutTokens._();

  // ── 结构尺寸 ────────────────────────────────────────────

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
  static const double navItemHeight = 40;
  static const double progressStrokeWidth = 2;
  static const double cardPaddingSm = 12;

  /// 统一图标大小规范
  static const double iconXs = 14;
  static const double iconSm = 16;
  static const double iconMd = 18;
  static const double iconLg = 20;
  static const double iconXl = 24;
  static const double iconXxl = 32;
  static const double iconXxxl = 36;

  // ── 响应式间距 ──────────────────────────────────────────

  static EdgeInsets pagePadding(BuildContext context) =>
      SpacingTokens.pagePadding(context);

  static EdgeInsets pageHeaderPadding(BuildContext context) =>
      SpacingTokens.pageHeaderPadding(context);

  static EdgeInsets cardPadding(BuildContext context) =>
      SpacingTokens.cardPadding(context);

  static double sectionSpacing(BuildContext context) =>
      SpacingTokens.sectionSpacing(context);

  static double formSectionSpacing(BuildContext context) =>
      SpacingTokens.formSectionSpacing(context);

  static double formColumnSpacing(BuildContext context) =>
      SpacingTokens.formColumnSpacing(context);

  static double formActionSpacing(BuildContext context) =>
      SpacingTokens.formActionSpacing(context);

  static double formPageSpacing(BuildContext context) =>
      SpacingTokens.formPageSpacing(context);
}
