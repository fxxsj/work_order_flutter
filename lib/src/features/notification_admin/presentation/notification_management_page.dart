import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_mode_toggle.dart';
import 'package:work_order_app/src/features/notification_admin/presentation/notification_template_page.dart';
import 'package:work_order_app/src/features/notification_admin/presentation/system_notification_page.dart';
import 'package:work_order_app/src/features/notification_admin/presentation/user_notification_settings_page.dart';

enum NotificationManagementTab {
  send,
  settings,
  templates,
}

class NotificationManagementPage extends StatefulWidget {
  const NotificationManagementPage({
    super.key,
    this.initialTab = NotificationManagementTab.send,
  });

  final NotificationManagementTab initialTab;

  @override
  State<NotificationManagementPage> createState() =>
      _NotificationManagementPageState();
}

class _NotificationManagementPageState
    extends State<NotificationManagementPage> {
  late NotificationManagementTab _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return ListPageScaffold(
      spacing: LayoutTokens.gapSm,
      header: PageHeaderBar(
        breadcrumb: null,
        useSurface: false,
        showDivider: false,
        padding: EdgeInsets.zero,
        actions: PageModeToggle<NotificationManagementTab>(
          value: _activeTab,
          minWidth: 96,
          options: const [
            PageModeOption(
              value: NotificationManagementTab.send,
              label: '发送通知',
            ),
            PageModeOption(
              value: NotificationManagementTab.settings,
              label: '接收设置',
            ),
            PageModeOption(
              value: NotificationManagementTab.templates,
              label: '通知模板',
            ),
          ],
          onChanged: (value) => setState(() => _activeTab = value),
        ),
      ),
      body: IndexedStack(
        index: NotificationManagementTab.values.indexOf(_activeTab),
        children: const [
          SystemNotificationPage(),
          UserNotificationSettingsPage(),
          NotificationTemplatePage(),
        ],
      ),
    );
  }
}
