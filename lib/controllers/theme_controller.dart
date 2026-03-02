import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:work_order_app/constants/constant.dart';

class ThemeController extends GetxController {
  static const Color defaultSeed = Color(0xFF14B8A6);

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<Color> seedColor = defaultSeed.obs;
  final Rx<Color> tempColor = defaultSeed.obs;
  final RxDouble fontScale = 1.0.obs;

  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    final colorValue = _storage.read(Constant.KEY_THEME_COLOR);
    if (colorValue is int) {
      seedColor.value = Color(colorValue);
    }
    tempColor.value = seedColor.value;

    final modeValue = _storage.read(Constant.KEY_THEME_MODE);
    themeMode.value = _parseMode(modeValue?.toString());

    final scaleValue = _storage.read(Constant.KEY_FONT_SCALE);
    if (scaleValue is num) {
      fontScale.value = scaleValue.toDouble();
    }
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _storage.write(Constant.KEY_THEME_MODE, _serializeMode(mode));
  }

  void setTempColor(Color color) {
    tempColor.value = color;
  }

  void setFontScale(double value) {
    fontScale.value = value;
    _storage.write(Constant.KEY_FONT_SCALE, value);
  }

  void applyColor() {
    seedColor.value = tempColor.value;
    _storage.write(Constant.KEY_THEME_COLOR, seedColor.value.value);
  }

  void resetColor() {
    tempColor.value = defaultSeed;
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
