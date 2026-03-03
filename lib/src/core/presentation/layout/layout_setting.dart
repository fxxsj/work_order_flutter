import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/controllers/theme_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class LayoutSetting extends StatelessWidget {
  LayoutSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    final tilePadding = EdgeInsets.symmetric(horizontal: isXs ? 12 : 16, vertical: isXs ? 4 : 6);
    final density = isXs || isSm ? VisualDensity.compact : VisualDensity.standard;
    final themeController = context.watch<ThemeController>();
    final theme = Theme.of(context);

    final headerColor = themeController.tempColor;
    final isDarkText = ThemeData.estimateBrightnessForColor(headerColor) == Brightness.dark;

    final seed = themeController.seedColor;
    final temp = themeController.tempColor;
    final dirty = seed.value != temp.value;
    final buttonIsDark = ThemeData.estimateBrightnessForColor(temp) == Brightness.dark;

    final scale = themeController.fontScale;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: headerColor),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: isXs ? 12 : 16),
            child: Text(
              '外观设置',
              style: TextStyle(color: isDarkText ? Colors.white : Colors.black),
            ),
          ),
          Padding(
            padding: tilePadding,
            child: Text('主题模式', style: theme.textTheme.titleSmall),
          ),
          Column(
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: themeController.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    themeController.setThemeMode(value);
                  }
                },
                title: const Text('跟随系统'),
                subtitle: const Text('根据系统自动切换'),
                dense: true,
                visualDensity: density,
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: themeController.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    themeController.setThemeMode(value);
                  }
                },
                title: const Text('浅色'),
                dense: true,
                visualDensity: density,
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: themeController.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    themeController.setThemeMode(value);
                  }
                },
                title: const Text('深色'),
                dense: true,
                visualDensity: density,
              ),
            ],
          ),
          const Divider(thickness: 1),
          Padding(
            padding: tilePadding,
            child: Text('主题色', style: theme.textTheme.titleSmall),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isXs ? 8 : 12, vertical: 6),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () => themeController.resetColor(),
                      child: const Text('恢复默认'),
                    ),
                    const SizedBox(width: 6),
                    FilledButton(
                      onPressed: dirty
                          ? () {
                              themeController.applyColor();
                              Navigator.of(context).pop();
                            }
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: temp,
                        foregroundColor: buttonIsDark ? Colors.white : Colors.black,
                      ),
                      child: const Text('应用'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                BlockPicker(
                  pickerColor: temp,
                  onColorChanged: themeController.setTempColor,
                  layoutBuilder: (context, colors, child) {
                    final compact = isXs || isSm;
                    final crossAxisCount = compact ? 6 : 4;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: compact ? 6 : 8,
                      mainAxisSpacing: compact ? 6 : 8,
                      children: [for (final color in colors) child(color)],
                    );
                  },
                  itemBuilder: (color, isCurrent, changeColor) {
                    final compact = isXs || isSm;
                    final size = compact ? 28.0 : 36.0;
                    final iconSize = compact ? 14.0 : 18.0;
                    return SizedBox(
                      width: size,
                      height: size,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: changeColor,
                          borderRadius: BorderRadius.circular(size),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.5),
                                  offset: const Offset(0, 2),
                                  blurRadius: compact ? 3 : 4,
                                ),
                              ],
                            ),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 160),
                              opacity: isCurrent ? 1 : 0,
                              child: Icon(
                                Icons.done,
                                size: iconSize,
                                color: ThemeData.estimateBrightnessForColor(color) == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          Padding(
            padding: tilePadding,
            child: Text('字号大小', style: theme.textTheme.titleSmall),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isXs ? 8 : 12, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('小'),
                    Expanded(
                      child: Slider(
                        value: scale,
                        min: 0.9,
                        max: 1.25,
                        divisions: 7,
                        label: scale.toStringAsFixed(2),
                        onChanged: themeController.setFontScale,
                      ),
                    ),
                    const Text('大'),
                  ],
                ),
                Text(
                  '当前倍率：${scale.toStringAsFixed(2)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
