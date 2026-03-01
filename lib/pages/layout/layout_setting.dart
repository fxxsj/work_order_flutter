import 'package:flutter/material.dart';
import 'package:work_order_app/utils/breakpoints_util.dart';
import 'package:work_order_app/utils/utils.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final picker = BlockPicker(
      pickerColor: Theme.of(context).colorScheme.primary,
      onColorChanged: (v) {
        Get.changeTheme(Utils.getThemeData(themeColor: v));
      },
    );

    final themeMode = Switch.adaptive(
      onChanged: (value) {
        Get.changeTheme(Utils.getThemeData(brightness: value ? Brightness.dark : Brightness.light));
      },
      value: isDark,
    );

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: const Text('外观设置'),
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: isXs ? 12 : 16),
          ),
          ListTile(
            title: const Text('暗黑模式'),
            trailing: themeMode,
            contentPadding: tilePadding,
            visualDensity: density,
          ),
          const Divider(thickness: 1),
          Padding(
            padding: EdgeInsets.all(isXs ? 6.0 : 8.0),
            child: picker,
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
