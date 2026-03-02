import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/constants/breakpoints.dart';
import 'package:work_order_app/constants/constant.dart';
import 'package:work_order_app/common/theme_ext.dart';
import 'package:work_order_app/controllers/auth_controller.dart';
import 'package:work_order_app/controllers/notification_controller.dart';
import 'package:work_order_app/pages/layout/layout_setting.dart';
import 'package:work_order_app/pages/layout/nav_config.dart';
import 'package:work_order_app/pages/layout/widgets/app_header.dart';
import 'package:work_order_app/pages/layout/widgets/app_sidebar.dart';
import 'package:work_order_app/pages/layout/widgets/content_container.dart';
import 'package:work_order_app/router/app_router.dart';
import 'package:work_order_app/utils/breakpoints_util.dart';
import 'package:work_order_app/utils/store_util.dart';
import 'package:work_order_app/utils/utils.dart';

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
  final Set<String> _expandedIds = <String>{};
  late final Map<String, String> _pathToId;
  late final Map<String, int> _idToBranchIndex;

  @override
  void initState() {
    super.initState();
    _idToBranchIndex = buildIdToBranchIndex();
    _pathToId = buildPathToIdMap();
    final collapsed = StoreUtil.read(Constant.KEY_SIDEBAR_COLLAPSED);
    _sidebarCollapsed = collapsed == true;
    final savedExpanded = StoreUtil.read(Constant.KEY_SIDEBAR_EXPANDED);
    if (savedExpanded is List) {
      _expandedIds.addAll(savedExpanded.map((e) => e.toString()));
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
    final colors = theme.extension<AppColors>()!;
    final size = MediaQuery.sizeOf(context);
    final screenSize = _getScreenSize(size.width);

    final isMobile = screenSize == ScreenSize.mobile;
    final isXs = BreakpointsUtil.isXs(context);
    final isXl = BreakpointsUtil.isXl(context);
    final is2xl = BreakpointsUtil.is2xl(context);

    final background = colors.background;
    final surface = colors.surface;
    final primary = theme.primaryColor;
    final accent = colors.sidebarText;
    final sidebar = colors.sidebar;
    final subtleText = colors.subtleText;
    final sidebarText = colors.sidebarText;
    final sidebarItems = sidebarNavItems();
    final borderColor = colors.borderColor;
    final appBarHeight = isXs ? 52.0 : 56.0;
    final currentId = _currentId(context);
    final isActionCompact = size.width < Breakpoints.lg;

    final railExtended = (isXl || is2xl) && !_sidebarCollapsed;
    final railWidth = railExtended ? 214.0 : 59.0;
    final showDesktopSidebar = !isMobile;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: background,
      drawer: isMobile
          ? Drawer(
              backgroundColor: sidebar,
              child: SafeArea(
                child: AppSidebarDrawer(
                  navItems: sidebarItems,
                  expandedIds: _expandedIds,
                  currentId: currentId,
                  onToggleExpand: _setExpanded,
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
        onSidebarToggle: () {
          setState(() {
            _sidebarCollapsed = !_sidebarCollapsed;
          });
          StoreUtil.write(Constant.KEY_SIDEBAR_COLLAPSED, _sidebarCollapsed);
        },
        title: buildBreadcrumbForPathWith(GoRouterState.of(context).uri.path, _pathToId).join(' / '),
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
        isCompactActions: isActionCompact,
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
                navItems: sidebarItems,
                expandedIds: _expandedIds,
                currentId: currentId,
                onToggleExpand: _setExpanded,
                onSelectId: _handleSelectId,
                primary: primary,
                sidebarText: sidebarText,
                railExtended: railExtended,
                badgeTextForItem: _badgeTextForItem,
                controller: _railScrollController,
              ),
            ),
          Expanded(
            child: SafeArea(
              child: ContentContainer(
                child: widget.navigationShell,
              ),
            ),
          ),
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
    Utils.logout(context.read<AuthController>());
    appRouter.go('/login');
  }

  void _setExpanded(String id, bool expanded) {
    setState(() {
      if (expanded) {
        _expandedIds.add(id);
      } else {
        _expandedIds.remove(id);
      }
    });
    StoreUtil.write(Constant.KEY_SIDEBAR_EXPANDED, _expandedIds.toList());
  }

  ScreenSize _getScreenSize(double width) {
    if (width < Breakpoints.md) return ScreenSize.mobile;
    if (width < Breakpoints.lg) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  String _currentId(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return matchNavIdWith(path, _pathToId) ?? _pathToId[path] ?? 'dashboard';
  }

  String? _badgeTextForItem(NavItem item) {
    if (item.id == 'notifications') {
      final count = context.read<NotificationController>().unreadCount;
      if (count <= 0) {
        return null;
      }
      return count > 99 ? '99+' : '$count';
    }
    return item.badge;
  }
}
