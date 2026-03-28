import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/controllers/theme_controller.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static getThemeData({Color? themeColor, Brightness? brightness}) {
    final resolvedThemeColor = themeColor ?? ThemeController.defaultSeed;
    final resolvedBrightness = brightness ?? Brightness.light;
    final baseScheme = ColorScheme.fromSeed(
      seedColor: resolvedThemeColor,
      brightness: resolvedBrightness,
    );
    Color shiftLightness(Color color, double amount) {
      final hsl = HSLColor.fromColor(color);
      return hsl
          .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
          .toColor();
    }

    final seed = resolvedThemeColor;
    final seedLight = shiftLightness(seed, 0.28);
    final seedDark = shiftLightness(seed, -0.22);
    final scheme = baseScheme.copyWith(
      primary: seed,
      secondary: seed,
      primaryContainer:
          resolvedBrightness == Brightness.dark ? seedDark : seedLight,
      secondaryContainer:
          resolvedBrightness == Brightness.dark ? seedDark : seedLight,
      surface: resolvedBrightness == Brightness.dark
          ? const Color(0xFF111827)
          : const Color(0xFFFCFCFD),
      surfaceTint: Colors.transparent,
      shadow: resolvedBrightness == Brightness.dark
          ? const Color(0xFF000000)
          : const Color(0xFF0B1220),
    );
    final semantic = resolvedBrightness == Brightness.dark
        ? const AppSemanticColors(
            success: Color(0xFF22C55E),
            warning: Color(0xFFF59E0B),
            danger: Color(0xFFEF4444),
            info: Color(0xFF38BDF8),
            surfaceAlt: Color(0xFF0C1626),
            shadowStrong: Color(0xFF000000),
            successBg: Color(0x1A22C55E),
            warningBg: Color(0x1AF59E0B),
            dangerBg: Color(0x1AEF4444),
            infoBg: Color(0x1A38BDF8),
          )
        : const AppSemanticColors(
            success: Color(0xFF16A34A),
            warning: Color(0xFFD97706),
            danger: Color(0xFFDC2626),
            info: Color(0xFF0284C7),
            surfaceAlt: Color(0xFFEFF3F8),
            shadowStrong: Color(0xFF0B1220),
            successBg: Color(0x1A16A34A),
            warningBg: Color(0x1AD97706),
            dangerBg: Color(0x1ADC2626),
            infoBg: Color(0x1A0284C7),
          );
    Color mix(Color a, Color b, double t) => Color.lerp(a, b, t) ?? a;

    final seedBase = resolvedThemeColor;
    final seedHsl = HSLColor.fromColor(seedBase);
    final seedSoft = seedHsl
        .withLightness((seedHsl.lightness + 0.32).clamp(0.0, 1.0))
        .toColor();
    final seedSoft2 = seedHsl
        .withLightness((seedHsl.lightness + 0.42).clamp(0.0, 1.0))
        .toColor();
    final seedDeep = seedHsl
        .withLightness((seedHsl.lightness - 0.28).clamp(0.0, 1.0))
        .toColor();

    final appColors = resolvedBrightness == Brightness.dark
        ? AppColors(
            background: mix(const Color(0xFF0B1220), seedDeep, 0.22),
            surface: mix(const Color(0xFF111827), seedDeep, 0.18),
            sidebar: mix(const Color(0xFF0F172A), seedDeep, 0.2),
            subtleText: const Color(0xFF9AA4B2),
            sidebarText: const Color(0xFFE2E8F0),
            borderColor: mix(const Color(0xFF1F2937), seedDeep, 0.24),
          )
        : AppColors(
            background: mix(const Color(0xFFF2F4F8), seedSoft2, 0.12),
            surface: mix(const Color(0xFFFFFFFF), seedSoft, 0.04),
            sidebar: mix(const Color(0xFFF6F8FB), seedSoft, 0.08),
            subtleText: const Color(0xFF64748B),
            sidebarText: const Color(0xFF334155),
            borderColor: mix(const Color(0xFFD8DEE8), seedSoft, 0.14),
          );
    final baseTextTheme = ThemeData(brightness: resolvedBrightness).textTheme;
    const headingFont = 'AGENCYR';

    // 增强的字体大小配置
    const fontSizeDisplaySmall = 40.0;
    const fontSizeHeadlineSmall = 28.0;
    const fontSizeTitleLarge = 18.0;
    const fontSizeTitleMedium = 15.0;
    const fontSizeTitleSmall = 14.0;
    const fontSizeBodyLarge = 16.0;
    const fontSizeBodyMedium = 14.5;
    const fontSizeBodySmall = 13.0;
    const fontSizeLabelLarge = 15.0;
    const fontSizeLabelMedium = 13.0;
    const fontSizeLabelSmall = 12.0;

    final textTheme = baseTextTheme.copyWith(
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontFamily: headingFont,
        fontSize: fontSizeDisplaySmall,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        height: 1.2,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontFamily: headingFont,
        fontSize: fontSizeHeadlineSmall,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        height: 1.3,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontFamily: headingFont,
        fontSize: fontSizeTitleLarge,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.3,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: fontSizeTitleMedium,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: fontSizeTitleSmall,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: fontSizeBodyLarge,
        height: 1.5,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: fontSizeBodyMedium,
        height: 1.5,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: fontSizeBodySmall,
        height: 1.45,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: fontSizeLabelLarge,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: fontSizeLabelMedium,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: fontSizeLabelSmall,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: resolvedBrightness,
      colorScheme: scheme,
      textTheme: textTheme,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: appColors.background,
      shadowColor: semantic.shadowStrong.withValues(alpha: 0.12),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
          borderSide: BorderSide(
            color: appColors.borderColor.withValues(alpha: 0.7),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
          borderSide: BorderSide(
            color: appColors.borderColor.withValues(alpha: 0.7),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
          borderSide: BorderSide(
            color: semantic.danger.withValues(alpha: 0.8),
            width: 1.4,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
          borderSide: BorderSide(
            color: semantic.danger,
            width: 2,
          ),
        ),
        errorStyle: TextStyle(
          color: semantic.danger,
          fontSize: fontSizeLabelSmall,
          height: 1.4,
        ),
        hintStyle: TextStyle(
          fontSize: fontSizeBodyMedium,
          color: appColors.subtleText,
        ),
        labelStyle: TextStyle(
          fontSize: fontSizeBodyMedium,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: fontSizeLabelMedium,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appColors.surface,
        foregroundColor: resolvedBrightness == Brightness.dark
            ? const Color(0xFFE5E7EB)
            : const Color(0xFF111827),
        elevation: 0,
        scrolledUnderElevation: 1.5,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: fontSizeTitleMedium,
          fontWeight: FontWeight.w600,
          color: resolvedBrightness == Brightness.dark
              ? const Color(0xFFE5E7EB)
              : const Color(0xFF111827),
        ),
      ),
      iconTheme: IconThemeData(color: scheme.primary),
      dividerTheme: DividerThemeData(
        color: appColors.borderColor.withValues(alpha: 0.7),
        thickness: 0.8,
      ),
      cardTheme: CardThemeData(
        color: appColors.surface,
        elevation: 0,
        shadowColor: semantic.shadowStrong.withValues(alpha: 0.08),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
          side:
              BorderSide(color: appColors.borderColor.withValues(alpha: 0.45)),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(scheme.primary.withAlpha(153)),
        radius: const Radius.circular(8),
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
                fontSize: fontSizeLabelMedium, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStateProperty.all(
              BorderSide(color: scheme.primary.withAlpha(128))),
          foregroundColor: WidgetStateProperty.all(scheme.primary),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
          textStyle: WidgetStateProperty.all(
            TextStyle(
                fontSize: fontSizeLabelMedium, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(scheme.primary)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: resolvedBrightness == Brightness.dark
            ? const Color(0xFF111827)
            : const Color(0xFF0F172A),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
      extensions: [semantic, appColors],
    );

    return base;
  }

  static launchURL(url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
