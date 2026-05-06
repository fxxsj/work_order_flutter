import 'package:flutter/material.dart';

/// 语义化颜色令牌系统
///
/// 用于整个应用的语义化颜色定义，确保视觉一致性
/// 参考 shadcn/ui 配色方案，优化柔和度与对比度
class ColorTokens {
  const ColorTokens._();

  // ==================== 语义色 ====================

  /// 成功色 (绿色) - shadcn 风格，略柔和
  static const Color success = Color(0xFF22C55E);
  static const Color successDark = Color(0xFF16A34A);
  static const Color successBg = Color(0x0D22C55E);
  static const Color successBorder = Color(0xFF86EFAC);

  /// 警告色 (橙色)
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningBg = Color(0x0DF97316);
  static const Color warningBorder = Color(0xFFFCD34D);

  /// 危险色 (红色)
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerDark = Color(0xFFDC2626);
  static const Color dangerBg = Color(0x0DEF4444);
  static const Color dangerBorder = Color(0xFFFCA5A5);

  /// 信息色 (蓝色)
  static const Color info = Color(0xFF3B82F6);
  static const Color infoDark = Color(0xFF0284C7);
  static const Color infoBg = Color(0x0D38BDF8);
  static const Color infoBorder = Color(0xFF93C5FD);

  // ==================== 状态色映射 ====================

  /// 状态颜色映射表
  static const Map<String, Color> statusColors = {
    'success': success,
    'completed': successDark,
    'approved': successDark,
    'done': success,
    'warning': warning,
    'pending': warning,
    'waiting': warning,
    'in_progress': warning,
    'danger': danger,
    'failed': dangerDark,
    'rejected': dangerDark,
    'cancelled': danger,
    'error': danger,
    'info': info,
    'processing': info,
    'new': info,
  };

  /// 根据状态字符串获取对应颜色
  static Color colorForStatus(String? status, {Color? fallback}) {
    if (status == null) return fallback ?? info;
    return statusColors[status.toLowerCase()] ?? fallback ?? info;
  }

  // ==================== 标签色系 ====================

  /// 常用标签颜色（shadcn 风格调色板）
  static const List<Color> tagColors = [
    Color(0xFFEF4444), // red
    Color(0xFFF97316), // orange
    Color(0xFFEAB308), // yellow
    Color(0xFF22C55E), // green
    Color(0xFF14B8A6), // teal
    Color(0xFF3B82F6), // blue
    Color(0xFF6366F1), // indigo
    Color(0xFFEC4899), // pink
  ];

  /// 根据索引获取标签颜色
  static Color tagColorForIndex(int index) {
    return tagColors[index % tagColors.length];
  }

  // ==================== 中性色 - shadcn slate 风格 ====================

  /// 主文本 - 浅色背景
  static const Color textDark = Color(0xFF0F172A);

  /// 深色模式主文本
  static const Color textOnDark = Color(0xFFF1F5F9);

  /// 次要文本 - 更柔和
  static const Color textSecondary = Color(0xFF64748B);

  /// 禁用文本
  static const Color textDisabled = Color(0xFF94A3B8);

  /// 边框色 - 更柔和的 slate-200
  static const Color border = Color(0xFFE2E8F0);

  /// 分割线
  static const Color divider = Color(0xFFE2E8F0);

  // ==================== 表面色 - 层次更分明 ====================

  /// 浅色模式表面
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// 深色模式表面
  static const Color surfaceDark = Color(0xFF0F172A);

  /// 次级表面（卡片/面板背景）
  static const Color surfaceAltLight = Color(0xFFF8FAFC);
  static const Color surfaceAltDark = Color(0xFF1E293B);

  /// 基础背景
  static const Color backgroundBaseLight = Color(0xFFF1F5F9);
  static const Color backgroundBaseDark = Color(0xFF0B1120);

  /// 侧边栏背景
  static const Color sidebarBaseLight = Color(0xFFFFFFFF);
  static const Color sidebarBaseDark = Color(0xFF0F172A);

  /// 深色模式边框
  static const Color borderDark = Color(0xFF334155);
  static const Color borderLight = Color(0xFFE2E8F0);

  /// 侧边栏文本
  static const Color sidebarTextLight = Color(0xFF475569);
  static const Color sidebarTextDark = Color(0xFFCBD5E1);

  // ==================== 阴影色 ====================

  /// 阴影基础色（深色模式）
  static const Color shadowDark = Color(0xFF000000);

  /// 阴影基础色（浅色模式）
  static const Color shadowLight = Color(0xFF0F172A);
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
