import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'color_tokens.dart';
import 'opacity_tokens.dart';

/// 阴影令牌系统
///
/// 统一所有阴影效果，确保视觉一致性
class ShadowTokens {
  const ShadowTokens._();

  // ==================== 基础阴影 ====================

  /// 无阴影
  static const List<BoxShadow> none = [];

  /// 极小阴影（1px，微妙）
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0000000D),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  /// 小阴影（2px，按钮、卡片悬浮）
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x00000014),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0000000F),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  /// 中等阴影（4px，卡片、对话框）
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x0000001A),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x0000000F),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  /// 大阴影（8px，下拉菜单、弹窗）
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x0000001F),
      offset: Offset(0, 8),
      blurRadius: 10,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x00000014),
      offset: Offset(0, 3),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  /// 超大阴影（16px，模态对话框）
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x00000029),
      offset: Offset(0, 16),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  /// 极大阴影（24px，页面级覆盖层）
  static const List<BoxShadow> xxl = [
    BoxShadow(
      color: Color(0x00000033),
      offset: Offset(0, 24),
      blurRadius: 38,
      spreadRadius: 0,
    ),
  ];

  // ==================== 内阴影 ====================

  /// 近似内阴影，Flutter 原生 BoxShadow 不支持 inset。
  static const List<BoxShadow> inner = [
    BoxShadow(
      color: Color(0x0000000D),
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
      color: Color(0x14000000),
      offset: Offset(0, 0),
      blurRadius: 4,
      spreadRadius: 1,
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
