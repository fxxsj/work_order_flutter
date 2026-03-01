import 'package:flutter/material.dart';

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.surfaceAlt,
    required this.shadowStrong,
  });

  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color surfaceAlt;
  final Color shadowStrong;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? surfaceAlt,
    Color? shadowStrong,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      shadowStrong: shadowStrong ?? this.shadowStrong,
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
    );
  }
}

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
