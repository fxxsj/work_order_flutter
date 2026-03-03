import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static getThemeData({Color? themeColor, Brightness? brightness}) {
    final resolvedThemeColor = themeColor ?? const Color(0xFF14B8A6);
    final resolvedBrightness = brightness ?? Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: resolvedThemeColor,
      brightness: resolvedBrightness,
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
    final seedSoft = seedHsl.withLightness((seedHsl.lightness + 0.35).clamp(0.0, 1.0)).toColor();
    final seedSoft2 = seedHsl.withLightness((seedHsl.lightness + 0.45).clamp(0.0, 1.0)).toColor();
    final seedDark = seedHsl.withLightness((seedHsl.lightness - 0.25).clamp(0.0, 1.0)).toColor();

    final appColors = resolvedBrightness == Brightness.dark
        ? AppColors(
            background: mix(const Color(0xFF0F172A), seedDark, 0.18),
            surface: mix(const Color(0xFF111827), seedDark, 0.14),
            sidebar: mix(const Color(0xFF0B1320), seedDark, 0.14),
            subtleText: const Color(0xFF94A3B8),
            sidebarText: const Color(0xFFCBD5E1),
            borderColor: mix(const Color(0xFF334155), seedDark, 0.12),
          )
        : AppColors(
            background: mix(const Color(0xFFF8FAFC), seedSoft2, 0.18),
            surface: mix(Colors.white, seedSoft, 0.12),
            sidebar: mix(Colors.white, seedSoft, 0.08),
            subtleText: const Color(0xFF6B7280),
            sidebarText: const Color(0xFF334155),
            borderColor: mix(const Color(0xFFE2E8F0), seedSoft, 0.2),
          );
    final base = ThemeData(
      useMaterial3: true,
      brightness: resolvedBrightness,
      colorScheme: scheme,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: appColors.background,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appColors.surface,
        foregroundColor: resolvedBrightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF111827),
        elevation: 0,
      ),
      iconTheme: IconThemeData(color: scheme.primary),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(scheme.primary.withOpacity(0.6)),
        radius: const Radius.circular(8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(scheme.primary),
          mouseCursor: MaterialStateProperty.all(SystemMouseCursors.click),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(color: scheme.primary.withOpacity(0.5))),
          foregroundColor: MaterialStateProperty.all(scheme.primary),
          mouseCursor: MaterialStateProperty.all(SystemMouseCursors.click),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(scheme.primary)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: resolvedBrightness == Brightness.dark ? const Color(0xFF111827) : const Color(0xFF0F172A),
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
