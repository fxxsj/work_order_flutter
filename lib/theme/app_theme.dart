import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Theme factory — single source of truth for ThemeData.
///
/// Accepts a dynamic [seedColor] so users can switch accent color at runtime
/// via [LayoutSetting]. Semantic surfaces, typography, and component tokens
/// stay constant; only primary-related colors follow the seed.
class AppTheme {
  AppTheme._();

  static const Color defaultSeed = ColorTokens.primary;

  /// Build a complete [ThemeData] for the given brightness and seed color.
  static ThemeData build({
    required Brightness brightness,
    Color seedColor = defaultSeed,
  }) {
    final isDark = brightness == Brightness.dark;
    final primary = seedColor;

    final scheme = _buildColorScheme(primary, brightness, isDark);
    final textTheme = _buildTextTheme(brightness);
    final semantic = _buildSemanticColors(primary, isDark);
    final appColors = _buildAppColors(isDark);

    final pickerSurface = isDark ? ColorTokens.surface2 : ColorTokens.lightSurface;
    final pickerHeader = isDark ? ColorTokens.surface3 : ColorTokens.lightSurfaceAlt;
    final pickerDayOverlay = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return scheme.primary;
      }
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused)) {
        return scheme.primary.withValues(alpha: 0.10);
      }
      return null;
    });
    final pickerDayForeground = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return scheme.onPrimary;
      }
      if (states.contains(WidgetState.disabled)) {
        return appColors.subtleText.withValues(alpha: 0.44);
      }
      return isDark ? ColorTokens.ink : ColorTokens.lightInk;
    });
    final pickerDayShape = WidgetStateProperty.resolveWith<OutlinedBorder?>((states) {
      if (states.contains(WidgetState.selected)) {
        return const RoundedRectangleBorder(borderRadius: RadiusTokens.bMd);
      }
      return const RoundedRectangleBorder(borderRadius: RadiusTokens.bSm);
    });

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: textTheme,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: appColors.background,
      shadowColor: semantic.shadowStrong.withValues(alpha: OpacityTokens.mild),
      inputDecorationTheme: _buildInputDecorationTheme(primary, appColors, semantic),
      appBarTheme: _buildAppBarTheme(appColors, isDark),
      iconTheme: IconThemeData(color: scheme.primary),
      dividerTheme: DividerThemeData(
        color: appColors.borderColor.withValues(alpha: OpacityTokens.intense),
        thickness: 0.8,
      ),
      cardTheme: _buildCardTheme(appColors, semantic),
      dialogTheme: _buildDialogTheme(appColors, semantic, pickerSurface),
      datePickerTheme: _buildDatePickerTheme(
        scheme: scheme,
        appColors: appColors,
        textTheme: textTheme,
        semantic: semantic,
        pickerSurface: pickerSurface,
        pickerHeader: pickerHeader,
        pickerDayOverlay: pickerDayOverlay,
        pickerDayForeground: pickerDayForeground,
        pickerDayShape: pickerDayShape,
      ),
      timePickerTheme: _buildTimePickerTheme(
        scheme: scheme,
        appColors: appColors,
        textTheme: textTheme,
        pickerSurface: pickerSurface,
        isDark: isDark,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(scheme.primary.withAlpha(153)),
        radius: const Radius.circular(RadiusTokens.xs),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(scheme.primary),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
          textStyle: WidgetStateProperty.all(
            TextStyle(
              fontSize: TextTokens.fontSizeLabelMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStateProperty.all(
            BorderSide(color: scheme.primary.withAlpha(128)),
          ),
          foregroundColor: WidgetStateProperty.all(scheme.primary),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
          textStyle: WidgetStateProperty.all(
            TextStyle(
              fontSize: TextTokens.fontSizeLabelMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(scheme.primary),
        ),
      ),
      snackBarTheme: _buildSnackBarTheme(isDark),
      extensions: [semantic, appColors],
    );
  }

  // ── ColorScheme / TextTheme ─────────────────────────────

  static ColorScheme _buildColorScheme(
    Color primary,
    Brightness brightness,
    bool isDark,
  ) {
    return ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: Colors.white,
      surface: isDark ? ColorTokens.surface1 : Colors.white,
      surfaceTint: Colors.transparent,
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTextTheme = ThemeData(brightness: brightness).textTheme;
    const headingFont = 'AGENCYR';
    const bodyFont = 'Roboto';

    return baseTextTheme.copyWith(
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontFamily: headingFont,
        fontSize: TextTokens.fontSizeDisplaySmall,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        height: 1.2,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontFamily: headingFont,
        fontSize: TextTokens.fontSizeHeadlineMedium,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        height: 1.3,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontFamily: headingFont,
        fontSize: TextTokens.fontSizeTitleLarge,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.3,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: TextTokens.fontSizeTitleMedium,
        fontWeight: FontWeight.w600,
        height: 1.3,
        fontFamily: bodyFont,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: TextTokens.fontSizeTitleSmall,
        fontWeight: FontWeight.w600,
        height: 1.3,
        fontFamily: bodyFont,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: TextTokens.fontSizeBodyLarge,
        height: 1.5,
        fontFamily: bodyFont,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: TextTokens.fontSizeBodyMedium,
        height: 1.5,
        fontFamily: bodyFont,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: TextTokens.fontSizeBodySmall,
        height: 1.45,
        fontFamily: bodyFont,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: TextTokens.fontSizeLabelLarge,
        fontWeight: FontWeight.w500,
        height: 1.3,
        fontFamily: bodyFont,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: TextTokens.fontSizeLabelMedium,
        fontWeight: FontWeight.w500,
        height: 1.3,
        fontFamily: bodyFont,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: TextTokens.fontSizeLabelSmall,
        fontWeight: FontWeight.w500,
        height: 1.3,
        fontFamily: bodyFont,
      ),
    );
  }

  static AppSemanticColors _buildSemanticColors(Color primary, bool isDark) {
    return AppSemanticColors(
      success: ColorTokens.semanticSuccess,
      warning: isDark ? ColorTokens.inkSubtle : ColorTokens.inkSubtle,
      danger: ColorTokens.danger,
      info: primary,
      surfaceAlt: isDark ? ColorTokens.surface2 : ColorTokens.lightSurfaceAlt,
      shadowStrong: ColorTokens.semanticOverlay,
      unreadBackground: isDark
          ? ColorTokens.unreadBackgroundDark
          : ColorTokens.unreadBackgroundLight,
      successBg: ColorTokens.semanticSuccess.withValues(alpha: 0.12),
      warningBg: (isDark ? ColorTokens.inkSubtle : ColorTokens.inkSubtle)
          .withValues(alpha: 0.12),
      dangerBg: ColorTokens.danger.withValues(alpha: 0.12),
      infoBg: primary.withValues(alpha: 0.12),
    );
  }

  static AppColors _buildAppColors(bool isDark) {
    return AppColors(
      background: isDark ? ColorTokens.canvas : ColorTokens.lightBackground,
      surface: isDark ? ColorTokens.surface1 : Colors.white,
      sidebar: isDark ? ColorTokens.canvas : Colors.white,
      subtleText: isDark ? ColorTokens.inkSubtle : ColorTokens.lightInkSubtle,
      sidebarText: isDark ? ColorTokens.inkMuted : ColorTokens.lightInkMuted,
      borderColor: isDark ? ColorTokens.hairline : ColorTokens.lightHairline,
    );
  }

  // ── Component themes ────────────────────────────────────

  static InputDecorationTheme _buildInputDecorationTheme(
    Color primary,
    AppColors appColors,
    AppSemanticColors semantic,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: appColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: RadiusTokens.bMd,
        borderSide: BorderSide(
          color: appColors.borderColor.withValues(alpha: OpacityTokens.intense),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: RadiusTokens.bMd,
        borderSide: BorderSide(
          color: appColors.borderColor.withValues(alpha: OpacityTokens.intense),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: RadiusTokens.bMd,
        borderSide: BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: RadiusTokens.bMd,
        borderSide: BorderSide(
          color: semantic.danger.withValues(alpha: OpacityTokens.intense),
          width: 1.4,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: RadiusTokens.bMd,
        borderSide: BorderSide(color: semantic.danger, width: 2),
      ),
      errorStyle: TextStyle(
        color: semantic.danger,
        fontSize: TextTokens.fontSizeLabelSmall,
        height: 1.4,
      ),
      hintStyle: TextStyle(
        fontSize: TextTokens.fontSizeBodyMedium,
        color: appColors.subtleText,
      ),
      labelStyle: TextStyle(fontSize: TextTokens.fontSizeBodyMedium),
      floatingLabelStyle: TextStyle(fontSize: TextTokens.fontSizeLabelMedium),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  static AppBarTheme _buildAppBarTheme(AppColors appColors, bool isDark) {
    final foregroundColor = isDark ? ColorTokens.ink : ColorTokens.lightInk;
    return AppBarTheme(
      backgroundColor: appColors.surface,
      foregroundColor: foregroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: TextTokens.fontSizeTitleMedium,
        fontWeight: FontWeight.w600,
        color: foregroundColor,
      ),
    );
  }

  static CardThemeData _buildCardTheme(
    AppColors appColors,
    AppSemanticColors semantic,
  ) {
    return CardThemeData(
      color: appColors.surface,
      elevation: 0,
      shadowColor: semantic.shadowStrong.withValues(alpha: OpacityTokens.subtle),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: RadiusTokens.bLg,
        side: BorderSide(
          color: appColors.borderColor.withValues(alpha: OpacityTokens.strong),
        ),
      ),
    );
  }

  static DialogThemeData _buildDialogTheme(
    AppColors appColors,
    AppSemanticColors semantic,
    Color pickerSurface,
  ) {
    return DialogThemeData(
      backgroundColor: pickerSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 18,
      shadowColor: semantic.shadowStrong.withValues(alpha: 0.18),
      shape: RoundedRectangleBorder(
        borderRadius: RadiusTokens.bXl,
        side: BorderSide(
          color: appColors.borderColor.withValues(alpha: OpacityTokens.strong),
        ),
      ),
    );
  }

  static DatePickerThemeData _buildDatePickerTheme({
    required ColorScheme scheme,
    required AppColors appColors,
    required TextTheme textTheme,
    required AppSemanticColors semantic,
    required Color pickerSurface,
    required Color pickerHeader,
    required WidgetStateProperty<Color?> pickerDayOverlay,
    required WidgetStateProperty<Color?> pickerDayForeground,
    required WidgetStateProperty<OutlinedBorder?> pickerDayShape,
  }) {
    final fillColor =
        appColors.background == ColorTokens.canvas
            ? ColorTokens.surface3
            : ColorTokens.lightInputFill;

    return DatePickerThemeData(
      backgroundColor: pickerSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: RadiusTokens.bXl,
        side: BorderSide(
          color: appColors.borderColor.withValues(alpha: OpacityTokens.strong),
        ),
      ),
      headerBackgroundColor: pickerHeader,
      headerForegroundColor:
          appColors.background == ColorTokens.canvas ? ColorTokens.ink : ColorTokens.lightInk,
      headerHeadlineStyle: textTheme.headlineSmall?.copyWith(
        fontFamily: 'Roboto',
        fontSize: 20,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      headerHelpStyle: textTheme.labelMedium?.copyWith(
        color: appColors.subtleText,
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      dayBackgroundColor: pickerDayOverlay,
      dayForegroundColor: pickerDayForeground,
      dayOverlayColor: pickerDayOverlay,
      dayShape: pickerDayShape,
      todayForegroundColor: WidgetStateProperty.all(scheme.primary),
      todayBackgroundColor: WidgetStateProperty.all(
        scheme.primary.withValues(alpha: 0.10),
      ),
      todayBorder: BorderSide(color: scheme.primary, width: 1.2),
      rangeSelectionBackgroundColor: scheme.primary.withValues(alpha: 0.14),
      rangePickerBackgroundColor: pickerSurface,
      rangePickerSurfaceTintColor: Colors.transparent,
      rangePickerShape: RoundedRectangleBorder(
        borderRadius: RadiusTokens.bXl,
        side: BorderSide(
          color: appColors.borderColor.withValues(alpha: OpacityTokens.strong),
        ),
      ),
      rangePickerHeaderBackgroundColor: pickerHeader,
      rangePickerHeaderForegroundColor:
          appColors.background == ColorTokens.canvas ? ColorTokens.ink : ColorTokens.lightInk,
      rangePickerHeaderHeadlineStyle: textTheme.titleMedium?.copyWith(
        fontFamily: 'Roboto',
        fontSize: 18,
        height: 1.16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      rangePickerHeaderHelpStyle: textTheme.labelMedium?.copyWith(
        color: appColors.subtleText,
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      dividerColor: appColors.borderColor.withValues(alpha: OpacityTokens.strong),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: RadiusTokens.bMd,
          borderSide: BorderSide(color: appColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.bMd,
          borderSide: BorderSide(color: appColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.bMd,
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: scheme.onPrimary,
        backgroundColor: scheme.primary,
        shape: RoundedRectangleBorder(borderRadius: RadiusTokens.bMd),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: appColors.sidebarText,
        shape: RoundedRectangleBorder(borderRadius: RadiusTokens.bMd),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    );
  }

  static TimePickerThemeData _buildTimePickerTheme({
    required ColorScheme scheme,
    required AppColors appColors,
    required TextTheme textTheme,
    required Color pickerSurface,
    required bool isDark,
  }) {
    final hourMinuteIdleColor = isDark ? ColorTokens.surface3 : ColorTokens.lightInputFill;
    final dialTextIdleColor =
        isDark ? ColorTokens.inkMuted : ColorTokens.lightInkTertiary;

    return TimePickerThemeData(
      backgroundColor: pickerSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: RadiusTokens.bXl,
        side: BorderSide(
          color: appColors.borderColor.withValues(alpha: OpacityTokens.strong),
        ),
      ),
      hourMinuteShape: RoundedRectangleBorder(borderRadius: RadiusTokens.bLg),
      hourMinuteColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.primary.withValues(alpha: 0.14);
        }
        return hourMinuteIdleColor;
      }),
      hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return isDark ? ColorTokens.ink : ColorTokens.lightInk;
      }),
      dialBackgroundColor: hourMinuteIdleColor,
      dialHandColor: scheme.primary,
      dialTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.onPrimary;
        return dialTextIdleColor;
      }),
      entryModeIconColor: scheme.primary,
      dayPeriodBorderSide: BorderSide(color: appColors.borderColor),
      dayPeriodShape: RoundedRectangleBorder(borderRadius: RadiusTokens.bMd),
      helpTextStyle: textTheme.labelMedium?.copyWith(
        color: appColors.subtleText,
        fontWeight: FontWeight.w600,
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: scheme.onPrimary,
        backgroundColor: scheme.primary,
        shape: RoundedRectangleBorder(borderRadius: RadiusTokens.bMd),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: appColors.sidebarText,
        shape: RoundedRectangleBorder(borderRadius: RadiusTokens.bMd),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme(bool isDark) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? ColorTokens.surface1 : ColorTokens.lightInk,
      contentTextStyle: TextStyle(
        color: isDark ? ColorTokens.ink : ColorTokens.lightBackground,
      ),
    );
  }

  /// Convenience getters — use default seed color.
  /// Prefer [build] when the user can pick a custom seed.
  static ThemeData get lightTheme => build(brightness: Brightness.light);
  static ThemeData get darkTheme => build(brightness: Brightness.dark);
}
