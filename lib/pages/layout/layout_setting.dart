import 'package:flutter/material.dart';
import 'package:work_order_app/utils/breakpoints_util.dart';
import 'package:work_order_app/controllers/theme_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class LayoutSetting extends StatelessWidget {
  LayoutSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    final tilePadding = EdgeInsets.symmetric(horizontal: isXs ? 12 : 16, vertical: isXs ? 4 : 6);
    final density = isXs || isSm ? VisualDensity.compact : VisualDensity.standard;
    final themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Obx(() => DrawerHeader(
                child: const Text('外观设置'),
                decoration: BoxDecoration(
                  color: themeController.tempColor.value,
                ),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: isXs ? 12 : 16),
              )),
          Padding(
            padding: tilePadding,
            child: Text('主题模式', style: theme.textTheme.titleSmall),
          ),
          Obx(() => Column(
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: themeController.themeMode.value,
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
                    groupValue: themeController.themeMode.value,
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
                    groupValue: themeController.themeMode.value,
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
              )),
          const Divider(thickness: 1),
          Padding(
            padding: tilePadding,
            child: Text('主题色', style: theme.textTheme.titleSmall),
          ),
          Obx(() {
            final seed = themeController.seedColor.value;
            final temp = themeController.tempColor.value;
            final dirty = seed.value != temp.value;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isXs ? 8 : 12, vertical: 6),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius: 10, backgroundColor: temp),
                      const SizedBox(width: 8),
                      Text('当前颜色', style: theme.textTheme.bodySmall),
                      const Spacer(),
                      TextButton(
                        onPressed: () => themeController.resetColor(),
                        child: const Text('恢复默认'),
                      ),
                      const SizedBox(width: 6),
                      FilledButton(
                        onPressed: dirty ? themeController.applyColor : null,
                        child: const Text('应用'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlockPicker(
                    pickerColor: temp,
                    onColorChanged: themeController.setTempColor,
                  ),
                ],
              ),
            );
          }),
          const Divider(thickness: 1),
          Padding(
            padding: tilePadding,
            child: Text('字号大小', style: theme.textTheme.titleSmall),
          ),
          Obx(() {
            final scale = themeController.fontScale.value;
            return Padding(
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
            );
          }),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
