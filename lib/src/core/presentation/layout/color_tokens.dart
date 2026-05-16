import 'package:flutter/material.dart';

/// Linear 设计系统颜色令牌
///
/// 基于 Linear App UI 风格：深色画布 + 薰衣草蓝强调色
/// 参考 /DESIGN.md 规范
class ColorTokens {
  const ColorTokens._();

  // ==================== 画布与表面层级 ====================

  /// 深色画布背景 - #010102，近乎纯黑带微弱蓝色调
  static const Color canvas = Color(0xFF010102);

  /// 表面层级 1 - 卡片/面板，比画布高一个层级
  static const Color surface1 = Color(0xFF0f1011);

  /// 表面层级 2 - 特惠/悬浮状态
  static const Color surface2 = Color(0xFF141516);

  /// 表面层级 3 - 子导航、下拉菜单
  static const Color surface3 = Color(0xFF18191a);

  /// 表面层级 4 - 最深的悬浮表面
  static const Color surface4 = Color(0xFF191a1b);

  // ==================== hairline 边框 ====================

  /// 卡片和分割线的 1px 边框
  static const Color hairline = Color(0xFF23252a);

  /// 较强的 1px 边框 - 输入框聚焦环
  static const Color hairlineStrong = Color(0xFF34343a);

  /// 嵌套表面的第三级边框
  static const Color hairlineTertiary = Color(0xFF3e3e44);

  // ==================== 主色调 - 薰衣草蓝 ====================

  /// Linear 标志色 - 主要 CTA、品牌标记
  static const Color primary = Color(0xFF5e6ad2);

  /// 主色上的文本
  static const Color onPrimary = Color(0xFFffffff);

  /// 主色悬浮状态 - 较浅薰衣草
  static const Color primaryHover = Color(0xFF828fff);

  /// 主色聚焦状态 - 聚焦环色调
  static const Color primaryFocus = Color(0xFF5e69d1);

  /// 品牌安全色 - 柔和薰衣草灰
  static const Color brandSecure = Color(0xFF7a7fad);

  // ==================== Ink 文本层级 ====================

  /// 主要文本 - 浅灰色 #f7f8f8
  static const Color ink = Color(0xFFf7f8f8);

  /// 次要文本 - #d0d6e0
  static const Color inkMuted = Color(0xFFd0d6e0);

  /// 第三级文本 - #8a8f98
  static const Color inkSubtle = Color(0xFF8a8f98);

  /// 第四级文本 - #62666d，用于禁用和脚注
  static const Color inkTertiary = Color(0xFF62666d);

  // ==================== 反向（浅色）调色板 ====================

  /// 反向画布 - 纯白
  static const Color inverseCanvas = Color(0xFFffffff);

  /// 反向表面 1
  static const Color inverseSurface1 = Color(0xFFf5f6f6);

  /// 反向表面 2
  static const Color inverseSurface2 = Color(0xFFf6f7f7);

  /// 反向墨水 - 白色表面上的文本
  static const Color inverseInk = Color(0xFF000000);

  // ==================== 语义色 ====================

  /// 成功绿 - 状态药丸和成功指示器
  static const Color semanticSuccess = Color(0xFF27a644);

  /// 遮罩叠加层 - 模态框黑色叠加
  static const Color semanticOverlay = Color(0xFF000000);

  // ==================== 状态色映射 ====================

  /// 状态颜色映射表
  static const Map<String, Color> statusColors = {
    'success': semanticSuccess,
    'completed': semanticSuccess,
    'approved': semanticSuccess,
    'done': semanticSuccess,
    'warning': inkSubtle,
    'pending': inkMuted,
    'waiting': inkMuted,
    'in_progress': inkMuted,
    'danger': Color(0xFFef4444),
    'failed': Color(0xFFdc2626),
    'rejected': Color(0xFFdc2626),
    'cancelled': Color(0xFFef4444),
    'error': Color(0xFFef4444),
    'info': primary,
    'processing': inkMuted,
    'new': primary,
  };

  /// 根据状态字符串获取对应颜色
  static Color colorForStatus(String? status, {Color? fallback}) {
    if (status == null) return fallback ?? inkMuted;
    return statusColors[status.toLowerCase()] ?? fallback ?? inkMuted;
  }

  // ==================== 标签色系 ====================

  /// 常用标签颜色（Linear 产品内使用，不用于营销）
  static const List<Color> tagColors = [
    Color(0xFFef4444), // red
    Color(0xFFf97316), // orange
    Color(0xFFeab308), // yellow
    Color(0xFF22c55e), // green
    Color(0xFF14b8a6), // teal
    Color(0xFF3b82f6), // blue
    Color(0xFF6366f1), // indigo
    Color(0xFFec4899), // pink
  ];

  /// 根据索引获取标签颜色
  static Color tagColorForIndex(int index) {
    return tagColors[index % tagColors.length];
  }

  // ==================== 兼容性别名 ====================

  /// @deprecated 请使用 surface1
  static const Color surfaceDark = surface1;

  /// @deprecated 请使用 inverseCanvas
  static const Color surfaceLight = inverseCanvas;

  /// @deprecated 请使用 hairline
  static const Color border = hairline;

  /// @deprecated 请使用 hairlineStrong
  static const Color borderDark = hairlineStrong;

  /// @deprecated 请使用 hairline
  static const Color borderLight = hairline;

  /// @deprecated 请使用 semanticSuccess
  static const Color success = semanticSuccess;

  /// @deprecated 请使用 semanticSuccess (success dark variant)
  static const Color successDark = Color(0xFF16A34A);

  /// @deprecated 请使用 semanticSuccess
  static const Color successBg = Color(0xFF27a644);

  // ── 兼容性别名：warning/danger/info ──────────────────────

  /// @deprecated 请使用 inkSubtle (Linear 没有营销 warning 色)
  static const Color warning = inkSubtle;

  /// @deprecated 请使用 inkSubtle
  static const Color warningDark = inkTertiary;

  /// @deprecated 请使用 inkSubtle
  static const Color warningBg = Color(0xFF8a8f98);

  /// @deprecated 请使用 semanticSuccess
  static const Color danger = Color(0xFFef4444);

  /// @deprecated 请使用 semanticSuccess
  static const Color dangerDark = Color(0xFFdc2626);

  /// @deprecated 请使用 primary
  static const Color info = primary;

  /// @deprecated 请使用 primary
  static const Color infoDark = Color(0xFF5e69d1);

  /// @deprecated 请使用 primary
  static const Color infoBg = Color(0xFF5e6ad2);

  /// @deprecated 请使用 ink

  /// @deprecated 请使用 ink
  static const Color textOnDark = ink;

  /// @deprecated 请使用 inverseInk
  static const Color textDark = inverseInk;

  /// @deprecated 请使用 inkSubtle
  static const Color textSecondary = inkSubtle;

  /// @deprecated 请使用 inkTertiary
  static const Color textDisabled = inkTertiary;

  /// @deprecated 请使用 canvas
  static const Color backgroundBaseDark = canvas;

  /// @deprecated 请使用 inverseCanvas
  static const Color backgroundBaseLight = inverseCanvas;

  /// @deprecated 请使用 surface1
  static const Color sidebarBaseDark = surface1;

  /// @deprecated 请使用 inverseCanvas
  static const Color sidebarBaseLight = inverseCanvas;

  /// @deprecated 请使用 inkMuted
  static const Color sidebarTextDark = inkMuted;

  /// @deprecated 请使用 inkSubtle
  static const Color sidebarTextLight = inkSubtle;

  /// 深色模式阴影
  static const Color shadowDark = semanticOverlay;

  /// 浅色模式阴影
  static const Color shadowLight = Color(0xFF0f172a);
}

/// 颜色扩展方法
extension ColorExtension on Color {
  /// 获取带透明度的颜色
  Color withOpacityValue(double opacity) {
    return withValues(alpha: opacity);
  }

  /// 将颜色调亮
  Color lighten([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// 将颜色调暗
  Color darken([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}