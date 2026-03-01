import 'package:flutter/material.dart';
import 'package:work_order_app/constants/breakpoints.dart';
import 'package:work_order_app/controllers/notification_controller.dart';
import 'package:work_order_app/models/notification_model.dart';
import 'package:work_order_app/pages/layout/layout_setting.dart';
import 'package:work_order_app/utils/breakpoints_util.dart';
import 'package:work_order_app/utils/utils.dart';
import 'package:get/get.dart';

enum ScreenSize {
  mobile,
  tablet,
  desktop,
}

class NavItem {
  final String id;
  final String label;
  final IconData icon;
  final List<NavItem> children;
  final String? badge;

  const NavItem({
    required this.id,
    required this.label,
    required this.icon,
    this.children = const [],
    this.badge,
  });
}

class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key});

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedId = 'dashboard';
  final ScrollController _railScrollController = ScrollController();
  bool _sidebarCollapsed = false;
  late final NotificationController _notificationController;

  final List<NavItem> navItems = const [
    NavItem(
      id: 'dashboard',
      label: '工作台',
      icon: Icons.dashboard_outlined,
    ),
    NavItem(
      id: 'workorders',
      label: '施工单',
      icon: Icons.description_outlined,
      children: [
        NavItem(id: 'workorders_list', label: '施工单列表', icon: Icons.list_alt_outlined),
        NavItem(id: 'workorders_create', label: '新建施工单', icon: Icons.add_circle_outline),
      ],
    ),
    NavItem(
      id: 'tasks',
      label: '任务管理',
      icon: Icons.task_alt_outlined,
      children: [
        NavItem(id: 'tasks_list', label: '任务列表', icon: Icons.view_list_outlined),
        NavItem(id: 'tasks_board', label: '部门任务看板', icon: Icons.view_kanban_outlined),
        NavItem(id: 'tasks_stats', label: '协作统计', icon: Icons.insights_outlined),
        NavItem(id: 'tasks_history', label: '分派历史', icon: Icons.history_outlined),
        NavItem(id: 'tasks_rules', label: '分派规则配置', icon: Icons.rule_outlined),
      ],
    ),
    NavItem(
      id: 'basic_data',
      label: '基础数据',
      icon: Icons.storage_outlined,
      children: [
        NavItem(id: 'customers', label: '客户管理', icon: Icons.people_outline),
        NavItem(id: 'departments', label: '部门管理', icon: Icons.apartment_outlined),
        NavItem(id: 'processes', label: '工序管理', icon: Icons.account_tree_outlined),
        NavItem(id: 'products', label: '产品管理', icon: Icons.inventory_2_outlined),
        NavItem(id: 'materials', label: '物料管理', icon: Icons.category_outlined),
        NavItem(id: 'product_groups', label: '产品组管理', icon: Icons.group_work_outlined),
      ],
    ),
    NavItem(
      id: 'plate_making',
      label: '制版管理',
      icon: Icons.print_outlined,
      children: [
        NavItem(id: 'artworks', label: '图稿管理', icon: Icons.image_outlined),
        NavItem(id: 'dies', label: '刀模管理', icon: Icons.cut_outlined),
        NavItem(id: 'foiling', label: '烫金版管理', icon: Icons.auto_fix_high_outlined),
        NavItem(id: 'embossing', label: '压凸版管理', icon: Icons.texture_outlined),
      ],
    ),
    NavItem(
      id: 'purchase_sales',
      label: '采购销售',
      icon: Icons.shopping_bag_outlined,
      children: [
        NavItem(id: 'purchase_orders', label: '采购单管理', icon: Icons.receipt_long_outlined),
        NavItem(id: 'sales_orders', label: '销售订单', icon: Icons.point_of_sale_outlined),
      ],
    ),
    NavItem(
      id: 'inventory',
      label: '库存管理',
      icon: Icons.warehouse_outlined,
      children: [
        NavItem(id: 'stocks', label: '成品库存', icon: Icons.inventory_outlined),
        NavItem(id: 'delivery', label: '发货管理', icon: Icons.local_shipping_outlined),
        NavItem(id: 'quality', label: '质量检验', icon: Icons.verified_outlined),
      ],
    ),
    NavItem(
      id: 'finance',
      label: '财务管理',
      icon: Icons.account_balance_wallet_outlined,
      children: [
        NavItem(id: 'invoices', label: '发票管理', icon: Icons.receipt_outlined),
        NavItem(id: 'payments', label: '收款管理', icon: Icons.payments_outlined),
        NavItem(id: 'costs', label: '成本核算', icon: Icons.pie_chart_outline),
        NavItem(id: 'statements', label: '对账管理', icon: Icons.summarize_outlined),
      ],
    ),
    NavItem(
      id: 'notifications',
      label: '通知中心',
      icon: Icons.notifications_outlined,
    ),
    NavItem(
      id: 'profile',
      label: '个人信息',
      icon: Icons.person_outline,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<NotificationController>()) {
      _notificationController = Get.find<NotificationController>();
    } else {
      _notificationController = Get.put(NotificationController());
    }
  }

  @override
  void dispose() {
    _railScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final screenSize = _getScreenSize(size.width);
    final isDark = theme.brightness == Brightness.dark;

    final isMobile = screenSize == ScreenSize.mobile;
    final isCompact = screenSize == ScreenSize.tablet;
    final isDesktop = screenSize == ScreenSize.desktop;
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    final isMd = BreakpointsUtil.isMd(context);
    final isLg = BreakpointsUtil.isLg(context);
    final isXl = BreakpointsUtil.isXl(context);
    final is2xl = BreakpointsUtil.is2xl(context);

    final background = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final surface = isDark ? const Color(0xFF111827) : Colors.white;
    final primary = theme.primaryColor;
    final accent = isDark ? const Color(0xFFE5E7EB) : const Color(0xFF111827);
    final sidebar = isDark ? const Color(0xFF0B1320) : Colors.white;
    final subtleText = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final sidebarText = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final contentPadding = isXs
        ? const EdgeInsets.fromLTRB(16, 16, 16, 24)
        : isSm
            ? const EdgeInsets.fromLTRB(20, 20, 20, 28)
            : isMd
                ? const EdgeInsets.fromLTRB(24, 24, 24, 32)
                : isLg
                    ? const EdgeInsets.fromLTRB(24, 24, 24, 32)
                    : isXl
                        ? const EdgeInsets.fromLTRB(28, 28, 28, 36)
                        : const EdgeInsets.fromLTRB(32, 32, 32, 40);
    final appBarHeight = isXs ? 52.0 : 56.0;

    final content = _ContentArea(
      selectedId: selectedId,
      breadcrumb: _buildBreadcrumb(),
      primary: primary,
      accent: accent,
      surface: surface,
      background: background,
      subtleText: subtleText,
      borderColor: borderColor,
      padding: contentPadding,
      gridCount: is2xl
          ? 4
          : isXl
              ? 3
              : isMd
                  ? 2
                  : 1,
    );

    final railExtended = isXl || is2xl;
    final railWidth = railExtended ? 214.0 : 59.0;
    final showDesktopSidebar = !isMobile && (!isDesktop || !_sidebarCollapsed);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: background,
      drawer: isMobile
          ? Drawer(
              backgroundColor: sidebar,
              child: SafeArea(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _buildNavigationDrawer(primary, sidebarText),
                ),
              ),
            )
          : null,
      endDrawer: LayoutSetting(),
      appBar: _AdaptiveAppBar(
        isMobile: isMobile,
        showSidebarToggle: !isMobile,
        isSidebarCollapsed: _sidebarCollapsed,
        onSidebarToggle: () => setState(() => _sidebarCollapsed = !_sidebarCollapsed),
        title: _buildBreadcrumb().join(' / '),
        onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
        onSettingTap: () => scaffoldKey.currentState?.openEndDrawer(),
        onNotificationViewAll: () => _handleSelect('notifications'),
        onProfileTap: () => _handleSelect('profile'),
        onLogoutTap: _handleLogout,
        primary: primary,
        surface: surface,
        accent: accent,
        subtleText: subtleText,
        height: appBarHeight,
      ),
      body: Row(
        children: [
          if (showDesktopSidebar)
            Container(
              width: railWidth,
              decoration: BoxDecoration(
                color: sidebar,
                border: Border(
                  right: BorderSide(color: borderColor),
                ),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                controller: _railScrollController,
                child: ListView.builder(
                  controller: _railScrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  itemCount: _flatNavItems.length,
                  itemBuilder: (context, index) {
                    final item = _flatNavItems[index];
                    final isSelected = item.id == selectedId;
                    final background = isSelected ? primary.withOpacity(0.12) : Colors.transparent;
                    final iconColor = isSelected ? primary : sidebarText;
                    final textColor = isSelected ? primary : sidebarText;
                    final tile = InkWell(
                      onTap: () => _handleSelect(item.id),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: railExtended ? 12 : 0),
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: railExtended
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            Icon(item.icon, color: iconColor, size: 20),
                            if (railExtended) const SizedBox(width: 12),
                            if (railExtended)
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            if (railExtended)
                              _RailBadge(
                                item: item,
                                primary: primary,
                                badgeTextForItem: _badgeTextForItem,
                              ),
                          ],
                        ),
                      ),
                    );
                    if (railExtended) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: tile,
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Tooltip(message: item.label, child: tile),
                    );
                  },
                ),
              ),
            ),
          Expanded(child: SafeArea(child: content)),
        ],
      ),
    );
  }

  void _handleSelect(String id) {
    final isMobile = _getScreenSize(MediaQuery.sizeOf(context).width) == ScreenSize.mobile;
    setState(() {
      selectedId = id;
    });
    if (isMobile) {
      scaffoldKey.currentState?.closeDrawer();
    }
  }

  void _handleLogout() {
    Utils.logout();
    Get.offAllNamed('/login');
  }

  ScreenSize _getScreenSize(double width) {
    if (width < Breakpoints.md) return ScreenSize.mobile;
    if (width < Breakpoints.lg) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  List<String> _buildBreadcrumb() {
    for (final item in navItems) {
      if (item.id == selectedId) {
        return ['首页', item.label];
      }
      for (final child in item.children) {
        if (child.id == selectedId) {
          return ['首页', item.label, child.label];
        }
      }
    }
    return ['首页'];
  }

  List<NavigationDestination> _buildDestinations(Color primary, Color sidebarText) {
    return _flatNavItems.map((item) {
      return NavigationDestination(
        icon: Icon(item.icon, color: sidebarText),
        selectedIcon: Icon(item.icon, color: primary),
        label: item.label,
      );
    }).toList();
  }

  List<NavItem> get _flatNavItems {
    return navItems.expand((item) {
      if (item.children.isEmpty) return [item];
      return [item, ...item.children];
    }).toList();
  }

  int _selectedIndex() {
    final index = _flatNavItems.indexWhere((item) => item.id == selectedId);
    return index >= 0 ? index : 0;
  }

  List<String> get _destinationIds {
    return _flatNavItems.map((item) => item.id).toList();
  }

  List<Widget> _buildNavigationDrawer(Color primary, Color sidebarText) {
    List<Widget> children = [];
    for (final item in navItems) {
      children.add(_DrawerSectionHeader(title: item.label));
      if (item.children.isEmpty) {
        children.add(_buildDrawerTile(
          item,
          primary: primary,
          sidebarText: sidebarText,
        ));
      } else {
        for (final child in item.children) {
          children.add(_buildDrawerTile(
            child,
            primary: primary,
            sidebarText: sidebarText,
          ));
        }
      }
      children.add(const SizedBox(height: 8));
    }
    return children;
  }

  Widget _buildDrawerTile(
    NavItem item, {
    required Color primary,
    required Color sidebarText,
  }) {
    if (item.id == 'notifications') {
      return Obx(() {
        final badgeText = _badgeTextForItem(item);
        return _DrawerTile(
          item: item,
          badgeText: badgeText,
          isSelected: selectedId == item.id,
          primary: primary,
          sidebarText: sidebarText,
          onTap: () => _handleSelect(item.id),
        );
      });
    }
    return _DrawerTile(
      item: item,
      badgeText: _badgeTextForItem(item),
      isSelected: selectedId == item.id,
      primary: primary,
      sidebarText: sidebarText,
      onTap: () => _handleSelect(item.id),
    );
  }

  String? _badgeTextForItem(NavItem item) {
    if (item.id == 'notifications') {
      final count = _notificationController.unreadCount.value;
      if (count <= 0) {
        return null;
      }
      return count > 99 ? '99+' : '$count';
    }
    return item.badge;
  }
}

class _DrawerSectionHeader extends StatelessWidget {
  const _DrawerSectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF94A3B8),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _RailBadge extends StatelessWidget {
  const _RailBadge({
    required this.item,
    required this.primary,
    required this.badgeTextForItem,
  });

  final NavItem item;
  final Color primary;
  final String? Function(NavItem) badgeTextForItem;

  @override
  Widget build(BuildContext context) {
    if (item.id == 'notifications') {
      return Obx(() => _buildBadge(badgeTextForItem(item)));
    }
    return _buildBadge(badgeTextForItem(item));
  }

  Widget _buildBadge(String? text) {
    if (text == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10.5),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.item,
    required this.badgeText,
    required this.isSelected,
    required this.primary,
    required this.sidebarText,
    required this.onTap,
  });

  final NavItem item;
  final String? badgeText;
  final bool isSelected;
  final Color primary;
  final Color sidebarText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = isSelected ? primary.withOpacity(0.2) : Colors.transparent;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? primary.withOpacity(0.35) : Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(item.icon, color: isSelected ? primary : sidebarText, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: isSelected ? primary : sidebarText,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AdaptiveAppBar({
    required this.isMobile,
    required this.showSidebarToggle,
    required this.isSidebarCollapsed,
    required this.onSidebarToggle,
    required this.title,
    required this.onMenuTap,
    required this.onSettingTap,
    required this.onNotificationViewAll,
    required this.onProfileTap,
    required this.onLogoutTap,
    required this.primary,
    required this.surface,
    required this.accent,
    required this.subtleText,
    required this.height,
  });

  final bool isMobile;
  final bool showSidebarToggle;
  final bool isSidebarCollapsed;
  final VoidCallback onSidebarToggle;
  final String title;
  final VoidCallback onMenuTap;
  final VoidCallback onSettingTap;
  final VoidCallback onNotificationViewAll;
  final VoidCallback onProfileTap;
  final VoidCallback onLogoutTap;
  final Color primary;
  final Color surface;
  final Color accent;
  final Color subtleText;
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: surface,
      elevation: 0,
      iconTheme: IconThemeData(color: subtleText),
      titleSpacing: isMobile ? 0 : 16,
      leading: isMobile
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuTap,
            )
          : null,
      title: Row(
        children: [
          if (!isMobile)
            Container(
              width: 8,
              height: 28,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          if (!isMobile) const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 15 : 17,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        if (showSidebarToggle)
          IconButton(
            tooltip: isSidebarCollapsed ? '展开侧边栏' : '收起侧边栏',
            icon: Icon(isSidebarCollapsed ? Icons.chevron_right : Icons.chevron_left),
            onPressed: onSidebarToggle,
          ),
        _AppBarChip(
          label: '今日待办 8',
          color: primary,
        ),
        const SizedBox(width: 8),
        Obx(() {
          final notifyCtrl = Get.find<NotificationController>();
          final unread = notifyCtrl.unreadCount.value;
          final label = unread > 99 ? '99+' : '$unread';
          return PopupMenuButton<String>(
            tooltip: '通知',
            offset: const Offset(0, 46),
            constraints: const BoxConstraints(minWidth: 280, maxWidth: 320),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onSelected: (value) {
              notifyCtrl.markRead(value);
            },
            itemBuilder: (context) => _buildNotificationMenuItems(
              context,
              notifyCtrl,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Badge(
                isLabelVisible: unread > 0,
                label: Text(label),
                backgroundColor: Colors.redAccent,
                offset: const Offset(6, -6),
                child: const Icon(Icons.notifications_none_outlined),
              ),
            ),
          );
        }),
        IconButton(
          tooltip: '搜索',
          icon: const Icon(Icons.search_outlined),
          onPressed: () {},
        ),
        IconButton(
          tooltip: '外观设置',
          icon: const Icon(Icons.tune_outlined),
          onPressed: onSettingTap,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _AvatarMenu(
            primary: primary,
            onProfileTap: onProfileTap,
            onLogoutTap: onLogoutTap,
          ),
        ),
      ],
    );
  }

  List<PopupMenuEntry<String>> _buildNotificationMenuItems(
    BuildContext context,
    NotificationController controller,
  ) {
    final items = <PopupMenuEntry<String>>[];
    items.add(
      PopupMenuItem<String>(
        enabled: false,
          padding: const EdgeInsets.fromLTRB(14, 10, 10, 4),
          child: Row(
            children: [
              Text(
                '通知',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              TextButton(
              onPressed: () {
                controller.markAllRead();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('全部已读', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
    items.add(const PopupMenuDivider(height: 1));
    if (controller.recentList.isEmpty) {
      items.add(
        PopupMenuItem<String>(
          enabled: false,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Text(
            '暂无通知',
            style: TextStyle(color: subtleText, fontSize: 12),
          ),
        ),
      );
      return items;
    }

    final sortedList = controller.recentList.toList()
      ..sort((a, b) {
        if (a.isRead == b.isRead) {
          return b.createdAt.compareTo(a.createdAt);
        }
        return a.isRead ? 1 : -1;
      });

    for (int i = 0; i < sortedList.length; i += 1) {
      final item = sortedList[i];
      final showDivider = i != sortedList.length - 1;
      items.add(
        PopupMenuItem<String>(
          value: item.id,
          padding: EdgeInsets.zero,
          child: _NotificationListItem(
            item: item,
            accent: accent,
            subtleText: subtleText,
            primary: primary,
            showDivider: showDivider,
            timeLabel: _formatTime(item.createdAt),
            onMarkRead: () {
              controller.markRead(item.id);
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
    items.add(const PopupMenuDivider(height: 1));
    items.add(
      PopupMenuItem<String>(
        enabled: false,
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
        child: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
              onNotificationViewAll();
            },
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('查看全部', style: TextStyle(fontSize: 12)),
          ),
        ),
      ),
    );
    return items;
  }

  String _formatTime(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) {
      return '刚刚';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    }
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '${createdAt.month}月${createdAt.day}日 $hour:$minute';
  }
}

class _NotificationListItem extends StatelessWidget {
  const _NotificationListItem({
    required this.item,
    required this.accent,
    required this.subtleText,
    required this.primary,
    required this.showDivider,
    required this.timeLabel,
    required this.onMarkRead,
  });

  final NotificationModel item;
  final Color accent;
  final Color subtleText;
  final Color primary;
  final bool showDivider;
  final String timeLabel;
  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    final levelColor = _levelColor(item.level, primary);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: item.isRead ? Colors.transparent : primary.withOpacity(0.14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: levelColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: accent,
                    fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w700,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                timeLabel,
                style: TextStyle(color: subtleText, fontSize: 11),
              ),
              const SizedBox(width: 6),
              IconButton(
                tooltip: '标为已读',
                icon: const Icon(Icons.done_all, size: 16),
                color: item.isRead ? subtleText : primary,
                onPressed: onMarkRead,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.body,
            style: TextStyle(color: subtleText, fontSize: 12, height: 1.35),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (showDivider) ...[
            const SizedBox(height: 10),
            Divider(height: 1, color: subtleText.withOpacity(0.15)),
          ],
        ],
      ),
    );
  }

  Color _levelColor(NotificationLevel level, Color primary) {
    switch (level) {
      case NotificationLevel.warning:
        return const Color(0xFFF59E0B);
      case NotificationLevel.urgent:
        return const Color(0xFFEF4444);
      case NotificationLevel.info:
      default:
        return primary;
    }
  }
}

class _AvatarMenu extends StatelessWidget {
  const _AvatarMenu({
    required this.primary,
    required this.onProfileTap,
    required this.onLogoutTap,
  });

  final Color primary;
  final VoidCallback onProfileTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_AvatarAction>(
      tooltip: '账户',
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (action) {
        switch (action) {
          case _AvatarAction.profile:
            onProfileTap();
            return;
          case _AvatarAction.logout:
            onLogoutTap();
            return;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: _AvatarAction.profile,
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('个人信息'),
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: _AvatarAction.logout,
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('退出登录'),
            dense: true,
          ),
        ),
      ],
      child: CircleAvatar(
        radius: 16,
        backgroundColor: primary.withOpacity(0.12),
        backgroundImage: const AssetImage('assets/images/avatar.jpg'),
      ),
    );
  }
}

enum _AvatarAction { profile, logout }

class _AppBarChip extends StatelessWidget {
  const _AppBarChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11.5,
        ),
      ),
    );
  }
}


class _ContentArea extends StatelessWidget {
  const _ContentArea({
    required this.selectedId,
    required this.breadcrumb,
    required this.primary,
    required this.accent,
    required this.surface,
    required this.background,
    required this.subtleText,
    required this.borderColor,
    required this.padding,
    required this.gridCount,
  });

  final String selectedId;
  final List<String> breadcrumb;
  final Color primary;
  final Color accent;
  final Color surface;
  final Color background;
  final Color subtleText;
  final Color borderColor;
  final EdgeInsets padding;
  final int gridCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return SingleChildScrollView(
            padding: padding,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderCard(
                      breadcrumb: breadcrumb,
                      title: _labelFor(selectedId),
                      primary: primary,
                      accent: accent,
                      surface: surface,
                      subtleText: subtleText,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(gridCount * 2, (index) {
                        return _StatCard(
                          width: (width - (gridCount - 1) * 16) / gridCount,
                          title: '指标 ${index + 1}',
                          value: '${(index + 1) * 12}',
                          trend: index.isEven ? '+${index + 2}%' : '-${index + 1}%',
                          primary: primary,
                          surface: surface,
                          subtleText: subtleText,
                          borderColor: borderColor,
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    _ListPlaceholder(
                      title: '核心列表区域',
                      subtitle: '这里是 $selectedId 的列表或表格布局，占位用于后续业务接入。',
                      primary: primary,
                      surface: surface,
                      subtleText: subtleText,
                      borderColor: borderColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _labelFor(String id) {
    switch (id) {
      case 'dashboard':
        return '工作台';
      case 'workorders':
      case 'workorders_list':
        return '施工单列表';
      case 'workorders_create':
        return '新建施工单';
      case 'tasks':
      case 'tasks_list':
        return '任务列表';
      case 'tasks_board':
        return '部门任务看板';
      case 'tasks_stats':
        return '协作统计';
      case 'tasks_history':
        return '分派历史';
      case 'tasks_rules':
        return '分派规则配置';
      case 'basic_data':
        return '基础数据';
      case 'customers':
        return '客户管理';
      case 'departments':
        return '部门管理';
      case 'processes':
        return '工序管理';
      case 'products':
        return '产品管理';
      case 'materials':
        return '物料管理';
      case 'product_groups':
        return '产品组管理';
      case 'plate_making':
        return '制版管理';
      case 'artworks':
        return '图稿管理';
      case 'dies':
        return '刀模管理';
      case 'foiling':
        return '烫金版管理';
      case 'embossing':
        return '压凸版管理';
      case 'purchase_sales':
        return '采购销售';
      case 'purchase_orders':
        return '采购单管理';
      case 'sales_orders':
        return '销售订单';
      case 'inventory':
        return '库存管理';
      case 'stocks':
        return '成品库存';
      case 'delivery':
        return '发货管理';
      case 'quality':
        return '质量检验';
      case 'finance':
        return '财务管理';
      case 'invoices':
        return '发票管理';
      case 'payments':
        return '收款管理';
      case 'costs':
        return '成本核算';
      case 'statements':
        return '对账管理';
      case 'notifications':
        return '通知中心';
      case 'profile':
        return '个人信息';
      default:
        return id;
    }
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.breadcrumb,
    required this.title,
    required this.primary,
    required this.accent,
    required this.surface,
    required this.subtleText,
    required this.borderColor,
  });

  final List<String> breadcrumb;
  final String title;
  final Color primary;
  final Color accent;
  final Color surface;
  final Color subtleText;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.auto_graph_outlined, color: primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  breadcrumb.join(' / '),
                  style: TextStyle(color: subtleText, fontSize: 11.5),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primary.withOpacity(0.2)),
            ),
            child: Text(
              '本周产能 82%',
              style: TextStyle(color: primary, fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.width,
    required this.title,
    required this.value,
    required this.trend,
    required this.primary,
    required this.surface,
    required this.subtleText,
    required this.borderColor,
  });

  final double width;
  final String title;
  final String value;
  final String trend;
  final Color primary;
  final Color surface;
  final Color subtleText;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final isPositive = trend.startsWith('+');
    final trendColor = isPositive ? primary : Colors.redAccent;
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: subtleText, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Text(
                trend,
                style: TextStyle(color: trendColor, fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.6,
            minHeight: 4,
            backgroundColor: primary.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(primary),
          ),
        ],
      ),
    );
  }
}

class _ListPlaceholder extends StatelessWidget {
  const _ListPlaceholder({
    required this.title,
    required this.subtitle,
    required this.primary,
    required this.surface,
    required this.subtleText,
    required this.borderColor,
  });

  final String title;
  final String subtitle;
  final Color primary;
  final Color surface;
  final Color subtleText;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: subtleText, fontSize: 12.5)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.filter_alt_outlined, color: primary),
                  label: Text('筛选', style: TextStyle(color: primary)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primary.withOpacity(0.35)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('新建'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
