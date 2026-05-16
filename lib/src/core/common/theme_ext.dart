import 'package:flutter/material.dart';

import '../../core/presentation/layout/opacity_tokens.dart';

/// Linear 语义色扩展
///
/// 提供语义化颜色（成功、警告、危险、信息）和表面层级颜色
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.surfaceAlt,
    required this.shadowStrong,
    required this.unreadBackground,
    this.successBg,
    this.warningBg,
    this.dangerBg,
    this.infoBg,
  });

  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color surfaceAlt;
  final Color shadowStrong;
  final Color unreadBackground;
  final Color? successBg;
  final Color? warningBg;
  final Color? dangerBg;
  final Color? infoBg;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? surfaceAlt,
    Color? shadowStrong,
    Color? unreadBackground,
    Color? successBg,
    Color? warningBg,
    Color? dangerBg,
    Color? infoBg,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      shadowStrong: shadowStrong ?? this.shadowStrong,
      unreadBackground: unreadBackground ?? this.unreadBackground,
      successBg: successBg ?? this.successBg,
      warningBg: warningBg ?? this.warningBg,
      dangerBg: dangerBg ?? this.dangerBg,
      infoBg: infoBg ?? this.infoBg,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) {
      return this;
    }
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      info: Color.lerp(info, other.info, t) ?? info,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t) ?? surfaceAlt,
      shadowStrong: Color.lerp(shadowStrong, other.shadowStrong, t) ?? shadowStrong,
      unreadBackground: Color.lerp(unreadBackground, other.unreadBackground, t) ?? unreadBackground,
      successBg: Color.lerp(successBg, other.successBg, t) ?? successBg,
      warningBg: Color.lerp(warningBg, other.warningBg, t) ?? warningBg,
      dangerBg: Color.lerp(dangerBg, other.dangerBg, t) ?? dangerBg,
      infoBg: Color.lerp(infoBg, other.infoBg, t) ?? infoBg,
    );
  }

  /// 获取语义色对应的浅色背景
  Color getSuccessBg() => successBg ?? success.withValues(alpha: OpacityTokens.subtle);
  Color getWarningBg() => warningBg ?? warning.withValues(alpha: OpacityTokens.subtle);
  Color getDangerBg() => dangerBg ?? danger.withValues(alpha: OpacityTokens.subtle);
  Color getInfoBg() => infoBg ?? info.withValues(alpha: OpacityTokens.subtle);
}

/// Linear 应用色扩展
///
/// 提供表面层级、文本和边框颜色
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.sidebar,
    required this.subtleText,
    required this.sidebarText,
    required this.borderColor,
  });

  final Color background;
  final Color surface;
  final Color sidebar;
  final Color subtleText;
  final Color sidebarText;
  final Color borderColor;

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? sidebar,
    Color? subtleText,
    Color? sidebarText,
    Color? borderColor,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      sidebar: sidebar ?? this.sidebar,
      subtleText: subtleText ?? this.subtleText,
      sidebarText: sidebarText ?? this.sidebarText,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      sidebar: Color.lerp(sidebar, other.sidebar, t) ?? sidebar,
      subtleText: Color.lerp(subtleText, other.subtleText, t) ?? subtleText,
      sidebarText: Color.lerp(sidebarText, other.sidebarText, t) ?? sidebarText,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
    );
  }
}