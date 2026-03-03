import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/notification/application/notification_view_model.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_setting.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_header.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_sidebar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/content_container.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';

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
  static const String _appTitle = '新西彩订单管理';
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
    final storage = context.read<AppStorage>();
    final collapsed = storage.read(Constant.KEY_SIDEBAR_COLLAPSED);
    _sidebarCollapsed = collapsed == true;
    final savedExpanded = storage.read(Constant.KEY_SIDEBAR_EXPANDED);
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
    final path = GoRouterState.of(context).uri.path;
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
          context.read<AppStorage>().write(Constant.KEY_SIDEBAR_COLLAPSED, _sidebarCollapsed);
        },
        title: _appTitle,
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
                scrollable: false,
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
    context.read<AuthController>().handleLogout();
    context.go('/login');
  }

  void _setExpanded(String id, bool expanded) {
    setState(() {
      if (expanded) {
        _expandedIds.add(id);
      } else {
        _expandedIds.remove(id);
      }
    });
    context.read<AppStorage>().write(Constant.KEY_SIDEBAR_EXPANDED, _expandedIds.toList());
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
      final count = context.read<NotificationViewModel>().unreadCount;
      if (count <= 0) {
        return null;
      }
      return count > 99 ? '99+' : '$count';
    }
    return item.badge;
  }
}
