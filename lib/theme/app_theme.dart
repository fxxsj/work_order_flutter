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

  static const Color defaultSeed = Color(0xFF14B8A6);

  /// Build a complete [ThemeData] for the given brightness and seed color.
  static ThemeData build({
    required Brightness brightness,
    Color seedColor = defaultSeed,
  }) {
    final isDark = brightness == Brightness.dark;
    final primary = seedColor;

    // ── Linear base palette ──────────────────────────────
    const linearCanvas = Color(0xFF010102);
    const linearSurface1 = Color(0xFF0f1011);
    const linearHairline = Color(0xFF23252a);
    const linearInk = Color(0xFFf7f8f8);
    const linearInkMuted = Color(0xFFd0d6e0);
    const linearInkSubtle = Color(0xFF8a8f98);
    const linearSuccess = Color(0xFF27a644);

    // ── ColorScheme (seed → primary family) ──────────────
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: Colors.white,
      surface: isDark ? linearSurface1 : Colors.white,
      surfaceTint: Colors.transparent,
    );

    // ── Semantic colors ──────────────────────────────────
    final semantic = AppSemanticColors(
      success: linearSuccess,
      warning: isDark ? linearInkSubtle : const Color(0xFF8a8f98),
      danger: const Color(0xFFef4444),
      info: primary,
      surfaceAlt: isDark ? const Color(0xFF141516) : const Color(0xFFF8FAFC),
      shadowStrong: const Color(0xFF000000),
      unreadBackground: isDark ? const Color(0xFF1a1a1a) : const Color(0xFFEDF2F7),
      successBg: linearSuccess.withValues(alpha: 0.12),
      warningBg: (isDark ? linearInkSubtle : const Color(0xFF8a8f98)).withValues(alpha: 0.12),
      dangerBg: const Color(0xFFef4444).withValues(alpha: 0.12),
      infoBg: primary.withValues(alpha: 0.12),
    );

    // ── App surface colors ───────────────────────────────
    final appColors = AppColors(
      background: isDark ? linearCanvas : const Color(0xFFF1F5F9),
      surface: isDark ? linearSurface1 : Colors.white,
      sidebar: isDark ? linearCanvas : Colors.white,
      subtleText: isDark ? linearInkSubtle : const Color(0xFF64748B),
      sidebarText: isDark ? linearInkMuted : const Color(0xFF475569),
      borderColor: isDark ? linearHairline : const Color(0xFFE2E8F0),
    );

    // ── Typography ───────────────────────────────────────
    final baseTextTheme = ThemeData(brightness: brightness).textTheme;
    const headingFont = 'AGENCYR';
    const bodyFont = 'Roboto';

    final textTheme = baseTextTheme.copyWith(
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

    // ── Assemble ThemeData ───────────────────────────────
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: textTheme,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: appColors.background,
      shadowColor: semantic.shadowStrong.withValues(alpha: OpacityTokens.mild),
      inputDecorationTheme: InputDecorationTheme(
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
        labelStyle: TextStyle(
          fontSize: TextTokens.fontSizeBodyMedium,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: TextTokens.fontSizeLabelMedium,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appColors.surface,
        foregroundColor: isDark ? linearInk : const Color(0xFF0F172A),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: TextTokens.fontSizeTitleMedium,
          fontWeight: FontWeight.w600,
          color: isDark ? linearInk : const Color(0xFF0F172A),
        ),
      ),
      iconTheme: IconThemeData(color: scheme.primary),
      dividerTheme: DividerThemeData(
        color: appColors.borderColor.withValues(alpha: OpacityTokens.intense),
        thickness: 0.8,
      ),
      cardTheme: CardThemeData(
        color: appColors.surface,
        elevation: 0,
        shadowColor: semantic.shadowStrong.withValues(alpha: OpacityTokens.subtle),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.bLg,
          side: BorderSide(color: appColors.borderColor.withValues(alpha: OpacityTokens.strong)),
        ),
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
          side: WidgetStateProperty.all(BorderSide(color: scheme.primary.withAlpha(128))),
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
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? linearSurface1 : const Color(0xFF0F172A),
        contentTextStyle: TextStyle(color: isDark ? linearInk : const Color(0xFFF1F5F9)),
      ),
      extensions: [semantic, appColors],
    );
  }

  /// Convenience getters — use default seed color.
  /// Prefer [build] when the user can pick a custom seed.
  static ThemeData get lightTheme => build(brightness: Brightness.light);
  static ThemeData get darkTheme => build(brightness: Brightness.dark);
}
