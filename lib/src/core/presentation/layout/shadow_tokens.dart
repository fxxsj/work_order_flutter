import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'color_tokens.dart';
import 'opacity_tokens.dart';

/// 阴影令牌系统
///
/// 统一所有阴影效果，确保视觉一致性
/// 参考 shadcn/ui 阴影风格：更柔和、更微妙
class ShadowTokens {
  const ShadowTokens._();

  // ==================== 基础阴影 ====================

  /// 无阴影
  static const List<BoxShadow> none = [];

  /// 极小阴影（悬浮元素边缘）
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  /// 小阴影（按钮、卡片悬浮）
  /// shadcn 风格：更轻、更弥散
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x08000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  /// 中等阴影（卡片、对话框）
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x10000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x08000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  /// 大阴影（弹出菜单、悬浮面板）
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  /// 超大阴影（模态对话框）
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x1E000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  /// 极大阴影（页面级覆盖层）
  static const List<BoxShadow> xxl = [
    BoxShadow(
      color: Color(0x28000000),
      offset: Offset(0, 16),
      blurRadius: 40,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // ==================== 内阴影 ====================

  /// 近似内阴影
  static const List<BoxShadow> inner = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  // ==================== 语义阴影 ====================

  /// 成功状态阴影
  static List<BoxShadow> success(BuildContext context) {
    final color = Theme.of(context).extension<AppSemanticColors>()?.success ??
        ColorTokens.success;
    return [
      BoxShadow(
        color: color.withValues(alpha: OpacityTokens.weak),
        offset: const Offset(0, 2),
        blurRadius: 8,
        spreadRadius: 0,
      ),
    ];
  }

  /// 警告状态阴影
  static List<BoxShadow> warning(BuildContext context) {
    final color = Theme.of(context).extension<AppSemanticColors>()?.warning ??
        ColorTokens.warning;
    return [
      BoxShadow(
        color: color.withValues(alpha: OpacityTokens.weak),
        offset: const Offset(0, 2),
        blurRadius: 8,
        spreadRadius: 0,
      ),
    ];
  }

  /// 危险状态阴影
  static List<BoxShadow> danger(BuildContext context) {
    final color = Theme.of(context).extension<AppSemanticColors>()?.danger ??
        ColorTokens.danger;
    return [
      BoxShadow(
        color: color.withValues(alpha: OpacityTokens.weak),
        offset: const Offset(0, 2),
        blurRadius: 8,
        spreadRadius: 0,
      ),
    ];
  }

  /// 信息状态阴影
  static List<BoxShadow> info(BuildContext context) {
    final color = Theme.of(context).extension<AppSemanticColors>()?.info ??
        ColorTokens.info;
    return [
      BoxShadow(
        color: color.withValues(alpha: OpacityTokens.weak),
        offset: const Offset(0, 2),
        blurRadius: 8,
        spreadRadius: 0,
      ),
    ];
  }

  // ==================== 特殊用途阴影 ====================

  /// 悬浮状态阴影
  static const List<BoxShadow> hover = sm;

  /// 按下状态阴影
  static const List<BoxShadow> pressed = xs;

  /// 聚焦阴影
  static const List<BoxShadow> focus = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 0),
      blurRadius: 4,
      spreadRadius: 2,
    ),
  ];

  /// 卡片阴影
  static const List<BoxShadow> card = md;

  /// 按钮阴影
  static const List<BoxShadow> button = sm;

  /// 对话框阴影
  static const List<BoxShadow> dialog = xl;

  /// 抽屉阴影
  static const List<BoxShadow> drawer = lg;

  /// 下拉菜单阴影
  static const List<BoxShadow> dropdown = lg;

  /// 工具提示阴影
  static const List<BoxShadow> tooltip = md;
}

/// 阴影扩展方法
extension ShadowExtension on List<BoxShadow> {
  /// 调整阴影不透明度
  List<BoxShadow> withOpacity(double opacity) {
    return map((shadow) {
      final color = shadow.color;
      return BoxShadow(
        color: color.withValues(alpha: opacity),
        offset: shadow.offset,
        blurRadius: shadow.blurRadius,
        spreadRadius: shadow.spreadRadius,
      );
    }).toList();
  }
}
