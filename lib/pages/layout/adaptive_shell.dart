import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/constants/breakpoints.dart';
import 'package:work_order_app/controllers/notification_controller.dart';
import 'package:work_order_app/pages/layout/layout_setting.dart';
import 'package:work_order_app/pages/layout/nav_config.dart';
import 'package:work_order_app/pages/layout/widgets/app_header.dart';
import 'package:work_order_app/pages/layout/widgets/app_sidebar.dart';
import 'package:work_order_app/router/app_router.dart';
import 'package:work_order_app/utils/breakpoints_util.dart';
import 'package:work_order_app/utils/utils.dart';
import 'package:get/get.dart';

enum ScreenSize {
  mobile,
  tablet,
  desktop,
}

class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _railScrollController = ScrollController();
  bool _sidebarCollapsed = false;
  late final NotificationController _notificationController;
  final Set<String> _expandedIds = <String>{};
  late final Map<String, int> _idToBranchIndex;
  late final Map<String, String> _pathToId;
  late final List<NavItem> _leafItems;

  @override
  void initState() {
    super.initState();
    _leafItems = flattenNavItems(navItems);
    _idToBranchIndex = {
      for (var i = 0; i < _leafItems.length; i++) _leafItems[i].id: i,
    };
    _pathToId = buildPathToIdMap();
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
    final isDesktop = screenSize == ScreenSize.desktop;
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    final isMd = BreakpointsUtil.isMd(context);
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
    final appBarHeight = isXs ? 52.0 : 56.0;
    final currentId = _currentId(context);

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
                child: AppSidebarDrawer(
                  navItems: navItems,
                  expandedIds: _expandedIds,
                  currentId: currentId,
                  onToggleExpand: _toggleExpand,
                  onSelectId: _handleSelectId,
                  primary: primary,
                  sidebarText: sidebarText,
                  badgeTextForItem: _badgeTextForItem,
                ),
              ),
            )
          : null,
      endDrawer: LayoutSetting(),
      appBar: AppHeader(
        isMobile: isMobile,
        showSidebarToggle: !isMobile,
        isSidebarCollapsed: _sidebarCollapsed,
        onSidebarToggle: () => setState(() => _sidebarCollapsed = !_sidebarCollapsed),
        title: buildBreadcrumb(currentId).join(' / '),
        onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
        onSettingTap: () => scaffoldKey.currentState?.openEndDrawer(),
        onNotificationViewAll: () => _handleSelectId('notifications'),
        onProfileTap: () => _handleSelectId('profile'),
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
              child: AppSidebarRail(
                navItems: navItems,
                expandedIds: _expandedIds,
                currentId: currentId,
                onToggleExpand: _toggleExpand,
                onSelectId: _handleSelectId,
                primary: primary,
                sidebarText: sidebarText,
                railExtended: railExtended,
                badgeTextForItem: _badgeTextForItem,
                controller: _railScrollController,
              ),
            ),
          Expanded(child: SafeArea(child: widget.navigationShell)),
        ],
      ),
    );
  }

  void _handleSelectId(String id) {
    final index = _idToBranchIndex[id];
    if (index == null) {
      return;
    }
    final isMobile = _getScreenSize(MediaQuery.sizeOf(context).width) == ScreenSize.mobile;
    widget.navigationShell.goBranch(index, initialLocation: false);
    if (isMobile) {
      scaffoldKey.currentState?.closeDrawer();
    }
  }

  void _handleLogout() {
    Utils.logout();
    appRouter.go('/login');
  }

  void _toggleExpand(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  ScreenSize _getScreenSize(double width) {
    if (width < Breakpoints.md) return ScreenSize.mobile;
    if (width < Breakpoints.lg) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  String _currentId(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return _pathToId[path] ?? 'dashboard';
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

