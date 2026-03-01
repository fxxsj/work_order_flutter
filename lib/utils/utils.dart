import 'package:flutter/material.dart';
import 'package:work_order_app/constants/constant.dart';
import 'package:work_order_app/common/theme_ext.dart';
import 'package:work_order_app/utils/store_util.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static Future<T?> fullscreenDialog<T>(Widget widget) {
    final context = Get.context;
    if (context == null) {
      return Future.value(null);
    }
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (_) => widget,
        fullscreenDialog: true,
      ),
    );
  }

  static getThemeData({Color? themeColor, Brightness? brightness}) {
    if (themeColor != null) {
      currentThemeColor = themeColor;
    }
    if (brightness != null) {
      currentBrightness = brightness;
    }

    final scheme = ColorScheme.fromSeed(
      seedColor: currentThemeColor,
      brightness: currentBrightness,
    );
    final semantic = currentBrightness == Brightness.dark
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
    final appColors = currentBrightness == Brightness.dark
        ? const AppColors(
            background: Color(0xFF0F172A),
            surface: Color(0xFF111827),
            sidebar: Color(0xFF0B1320),
            subtleText: Color(0xFF94A3B8),
            sidebarText: Color(0xFFCBD5E1),
            borderColor: Color(0xFF334155),
          )
        : const AppColors(
            background: Color(0xFFF8FAFC),
            surface: Colors.white,
            sidebar: Colors.white,
            subtleText: Color(0xFF6B7280),
            sidebarText: Color(0xFF334155),
            borderColor: Color(0xFFE2E8F0),
          );
    return ThemeData(
      useMaterial3: true,
      brightness: currentBrightness,
      colorScheme: scheme,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: currentBrightness == Brightness.dark ? const Color(0xFF0B1020) : const Color(0xFFF4F6FA),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: currentBrightness == Brightness.dark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: currentBrightness == Brightness.dark ? const Color(0xFF0F172A) : Colors.white,
        foregroundColor: currentBrightness == Brightness.dark ? const Color(0xFFE5E7EB) : const Color(0xFF111827),
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
        backgroundColor: currentBrightness == Brightness.dark ? const Color(0xFF111827) : const Color(0xFF0F172A),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
      extensions: [semantic, appColors],
    );
  }

  static Color currentThemeColor = const Color(0xFF14B8A6);
  static Brightness currentBrightness = Brightness.light;

  static isLogin() {
    return StoreUtil.hasData(Constant.KEY_TOKEN);
  }

  static logout() {
    StoreUtil.remove(Constant.KEY_TOKEN);
    StoreUtil.remove(Constant.KEY_CURRENT_USER_INFO);
  }

  static launchURL(url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
