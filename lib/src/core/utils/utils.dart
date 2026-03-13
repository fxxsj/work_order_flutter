import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static getThemeData({Color? themeColor, Brightness? brightness}) {
    final resolvedThemeColor = themeColor ?? const Color(0xFF14B8A6);
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
    );
    final semantic = resolvedBrightness == Brightness.dark
        ? const AppSemanticColors(
            success: Color(0xFF22C55E),
            warning: Color(0xFFF59E0B),
            danger: Color(0xFFEF4444),
            info: Color(0xFF38BDF8),
            surfaceAlt: Color(0xFF0F172A),
            shadowStrong: Color(0xAA000000),
          )
        : const AppSemanticColors(
            success: Color(0xFF16A34A),
            warning: Color(0xFFD97706),
            danger: Color(0xFFDC2626),
            info: Color(0xFF0284C7),
            surfaceAlt: Color(0xFFF8FAFC),
            shadowStrong: Color(0x22000000),
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
            background: mix(const Color(0xFF0B1220), seedDeep, 0.16),
            surface: mix(const Color(0xFF111827), seedDeep, 0.12),
            sidebar: mix(const Color(0xFF0F172A), seedDeep, 0.1),
            subtleText: const Color(0xFF9AA4B2),
            sidebarText: const Color(0xFFE2E8F0),
            borderColor: mix(const Color(0xFF1F2937), seedDeep, 0.18),
          )
        : AppColors(
            background: mix(const Color(0xFFF5F7FB), seedSoft2, 0.1),
            surface: mix(const Color(0xFFFFFFFF), seedSoft, 0.08),
            sidebar: mix(const Color(0xFFF8FAFC), seedSoft, 0.06),
            subtleText: const Color(0xFF64748B),
            sidebarText: const Color(0xFF334155),
            borderColor: mix(const Color(0xFFE2E8F0), seedSoft, 0.16),
          );
    final baseTextTheme = ThemeData(brightness: resolvedBrightness).textTheme;
    const headingFont = 'AGENCYR';
    final textTheme = baseTextTheme.copyWith(
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontFamily: headingFont,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontFamily: headingFont,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontFamily: headingFont,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(height: 1.4),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(height: 1.4),
      bodySmall: baseTextTheme.bodySmall?.copyWith(height: 1.35),
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: resolvedBrightness,
      colorScheme: scheme,
      textTheme: textTheme,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: appColors.background,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appColors.surface,
        foregroundColor: resolvedBrightness == Brightness.dark
            ? const Color(0xFFE5E7EB)
            : const Color(0xFF111827),
        elevation: 0,
      ),
      iconTheme: IconThemeData(color: scheme.primary),
      dividerTheme: DividerThemeData(
        color: appColors.borderColor.withValues(alpha: 0.7),
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: appColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
          side: BorderSide(color: appColors.borderColor.withValues(alpha: 0.6)),
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
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStateProperty.all(
              BorderSide(color: scheme.primary.withAlpha(128))),
          foregroundColor: WidgetStateProperty.all(scheme.primary),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
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
