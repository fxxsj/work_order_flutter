import 'package:flutter/material.dart';
import 'package:work_order_app/constants/constant.dart';
import 'package:work_order_app/utils/store_util.dart';

class ThemeController extends ChangeNotifier {
  static const Color defaultSeed = Color(0xFF14B8A6);

  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = defaultSeed;
  Color _tempColor = defaultSeed;
  double _fontScale = 1.0;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;
  Color get tempColor => _tempColor;
  double get fontScale => _fontScale;

  void load() {
    final colorValue = StoreUtil.read(Constant.KEY_THEME_COLOR);
    if (colorValue is int) {
      _seedColor = Color(colorValue);
    }
    _tempColor = _seedColor;

    final modeValue = StoreUtil.read(Constant.KEY_THEME_MODE);
    _themeMode = _parseMode(modeValue?.toString());

    final scaleValue = StoreUtil.read(Constant.KEY_FONT_SCALE);
    if (scaleValue is num) {
      _fontScale = scaleValue.toDouble();
    }

    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    StoreUtil.write(Constant.KEY_THEME_MODE, _serializeMode(mode));
    notifyListeners();
  }

  void setTempColor(Color color) {
    _tempColor = color;
    notifyListeners();
  }

  void setFontScale(double value) {
    _fontScale = value;
    StoreUtil.write(Constant.KEY_FONT_SCALE, value);
    notifyListeners();
  }

  void applyColor() {
    _seedColor = _tempColor;
    StoreUtil.write(Constant.KEY_THEME_COLOR, _seedColor.value);
    notifyListeners();
  }

  void resetColor() {
    _tempColor = defaultSeed;
    notifyListeners();
  }

  ThemeMode _parseMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _serializeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }
}
