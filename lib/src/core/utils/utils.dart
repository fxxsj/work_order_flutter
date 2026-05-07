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
          ? ColorTokens.surfaceDark
          : ColorTokens.surfaceLight,
      surfaceTint: Colors.transparent,
      shadow: resolvedBrightness == Brightness.dark
          ? ColorTokens.shadowDark
          : ColorTokens.shadowLight,
    );
    final semantic = resolvedBrightness == Brightness.dark
        ? const AppSemanticColors(
            success: ColorTokens.success,
            warning: ColorTokens.warning,
            danger: ColorTokens.danger,
            info: ColorTokens.info,
            surfaceAlt: ColorTokens.surfaceAltDark,
            shadowStrong: ColorTokens.shadowDark,
            successBg: ColorTokens.successBg,
            warningBg: ColorTokens.warningBg,
            dangerBg: ColorTokens.dangerBg,
            infoBg: Color(0x1A38BDF8),
          )
        : const AppSemanticColors(
            success: ColorTokens.successDark,
            warning: ColorTokens.warningDark,
            danger: ColorTokens.dangerDark,
            info: ColorTokens.infoDark,
            surfaceAlt: ColorTokens.surfaceAltLight,
            shadowStrong: ColorTokens.shadowLight,
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
            background: mix(ColorTokens.backgroundBaseDark, seedDeep, 0.22),
            surface: mix(ColorTokens.surfaceDark, seedDeep, 0.18),
            sidebar: mix(ColorTokens.sidebarBaseDark, seedDeep, 0.2),
            subtleText: const Color(0xFF9AA4B2),
            sidebarText: const Color(0xFFE2E8F0),
            borderColor: mix(ColorTokens.borderDark, seedDeep, 0.24),
          )
        : AppColors(
            background: mix(ColorTokens.backgroundBaseLight, seedSoft2, 0.12),
            surface: mix(ColorTokens.surfaceLight, seedSoft, 0.04),
            sidebar: mix(ColorTokens.sidebarBaseLight, seedSoft, 0.08),
            subtleText: ColorTokens.textSecondary,
            sidebarText: ColorTokens.sidebarTextLight,
            borderColor: mix(ColorTokens.borderLight, seedSoft, 0.14),
          );
    final baseTextTheme = ThemeData(brightness: resolvedBrightness).textTheme;
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
    final base = ThemeData(
      useMaterial3: true,
      brightness: resolvedBrightness,
      colorScheme: scheme,
      textTheme: textTheme,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: appColors.background,
      shadowColor: semantic.shadowStrong.withValues(alpha: OpacityTokens.mild),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
          borderSide: BorderSide(
            color: appColors.borderColor.withValues(alpha: OpacityTokens.intense),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
          borderSide: BorderSide(
            color: appColors.borderColor.withValues(alpha: OpacityTokens.intense),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
          borderSide: BorderSide(
            color: semantic.danger.withValues(alpha: OpacityTokens.intense),
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
        foregroundColor: resolvedBrightness == Brightness.dark
            ? ColorTokens.textOnDark
            : ColorTokens.textDark,
        elevation: 0,
        scrolledUnderElevation: 1.5,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: TextTokens.fontSizeTitleMedium,
          fontWeight: FontWeight.w600,
          color: resolvedBrightness == Brightness.dark
              ? ColorTokens.textOnDark
              : ColorTokens.textDark,
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
          borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
          side:
              BorderSide(color: appColors.borderColor.withValues(alpha: OpacityTokens.strong)),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(scheme.primary.withAlpha(153)),
        radius: const Radius.circular(LayoutTokens.radiusXs),
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
              BorderSide(color: scheme.primary.withAlpha(128))),
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
            backgroundColor: WidgetStateProperty.all(scheme.primary)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: resolvedBrightness == Brightness.dark
            ? ColorTokens.surfaceDark
            : ColorTokens.sidebarBaseDark,
        contentTextStyle: TextStyle(color: ColorTokens.textOnDark),
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
