import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/notification/application/notification_view_model.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_setting.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_header.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_sidebar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/content_container.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';
import 'package:work_order_app/src/core/common/app_metadata.dart';
import 'package:work_order_app/src/features/notification/domain/notification_model.dart';

class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  static const String _appTitle = AppMetadata.displayName;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _railScrollController = ScrollController();
  bool _sidebarCollapsed = false;
  MenuMode _menuMode = MenuMode.production;
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
    final savedMenuMode = storage.read(Constant.KEY_MENU_MODE);
    _menuMode = savedMenuMode == 'full' ? MenuMode.full : MenuMode.production;
  }

  @override
  void dispose() {
    _railScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.read<AppStorage>();
    final currentUser = _readCurrentUser(storage);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final size = MediaQuery.sizeOf(context);
    final screenSize = _getScreenSize(size.width);

    final isMobile = screenSize == ScreenSize.mobile;
    final isXs = ResponsiveLayout.isXs(context);
    final isXl = ResponsiveLayout.isXl(context);
    final is2xl = ResponsiveLayout.is2xl(context);

    final background = colors.background;
    final primary = theme.primaryColor;
    final headerForeground = theme.colorScheme.onPrimary;
    final headerMuted = headerForeground.withValues(
      alpha: OpacityTokens.textMuted,
    );
    final sidebar = colors.sidebar;
    final sidebarText = colors.sidebarText;
    final sidebarItems = sidebarNavItems(
      currentUser: currentUser,
      menuMode: _menuMode,
    );
    final isFullMode = _menuMode == MenuMode.full;
    final borderColor = colors.borderColor;
    final headerBorderColor = Colors.transparent;
    final appBarHeight = isXs ? 52.0 : 54.0;
    final currentId = _currentId(context);
    final isActionCompact = size.width < Breakpoints.lg;

    final railExtended = (isXl || is2xl) && !_sidebarCollapsed;
    final railWidth = railExtended ? 198.0 : 56.0;
    final showDesktopSidebar = !isMobile;

    final appHeader = AppHeader(
      isMobile: isMobile,
      showSidebarToggle: !isMobile,
      isSidebarCollapsed: _sidebarCollapsed,
      onSidebarToggle: () {
        setState(() {
          _sidebarCollapsed = !_sidebarCollapsed;
        });
        context.read<AppStorage>().write(
          Constant.KEY_SIDEBAR_COLLAPSED,
          _sidebarCollapsed,
        );
      },
      appTitle: _appTitle,
      sectionTitle: labelFor(currentId),
      onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
      onSettingTap: () => scaffoldKey.currentState?.openEndDrawer(),
      onNotificationViewAll: () => _handleSelectId('notifications'),
      onNotificationOpen: _handleOpenNotification,
      onProfileTap: () => _handleSelectId('profile'),
      onLogoutTap: _handleLogout,
      primary: headerForeground,
      surface: primary,
      accent: headerForeground,
      subtleText: headerMuted,
      borderColor: headerBorderColor,
      height: appBarHeight,
      isCompactActions: isActionCompact,
      showAppTitle: false,
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: background,
      drawer: isMobile
          ? Drawer(
              backgroundColor: sidebar,
              child: SafeArea(
                child: AppSidebarDrawer(
                  appTitle: _appTitle,
                  navItems: sidebarItems,
                  expandedIds: _expandedIds,
                  currentId: currentId,
                  onToggleExpand: _setExpanded,
                  onSelectId: _handleSelectId,
                  onToggleMenuMode: _toggleMenuMode,
                  isFullMode: isFullMode,
                  primary: primary,
                  sidebarText: sidebarText,
                  badgeTextForItem: _badgeTextForItem,
                  headerHeight: appBarHeight,
                ),
              ),
            )
          : null,
      endDrawer: LayoutSetting(),
      appBar: isMobile ? appHeader : null,
      body: Row(
        children: [
          if (showDesktopSidebar)
            Container(
              width: railWidth,
              decoration: BoxDecoration(
                color: sidebar,
                border: Border(
                  right: BorderSide(
                    color: borderColor.withValues(
                      alpha: OpacityTokens.borderStrong,
                    ),
                  ),
                ),
              ),
              child: AppSidebarRail(
                appTitle: _appTitle,
                navItems: sidebarItems,
                expandedIds: _expandedIds,
                currentId: currentId,
                onToggleExpand: _setExpanded,
                onSelectId: _handleSelectId,
                onToggleMenuMode: _toggleMenuMode,
                isFullMode: isFullMode,
                primary: primary,
                sidebarText: sidebarText,
                railExtended: railExtended,
                badgeTextForItem: _badgeTextForItem,
                controller: _railScrollController,
                headerHeight: appBarHeight,
              ),
            ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  if (!isMobile) appHeader,
                  Expanded(
                    child: ContentContainer(
                      scrollable: false,
                      maxWidth: LayoutTokens.maxContentWidth,
                      child: widget.navigationShell,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic>? _readCurrentUser(AppStorage storage) {
    final raw = storage.read(Constant.KEY_CURRENT_USER_INFO);
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  void _handleSelectId(String id) {
    final index = _idToBranchIndex[id];
    if (index == null) {
      return;
    }
    final isMobile =
        _getScreenSize(MediaQuery.sizeOf(context).width) == ScreenSize.mobile;
    widget.navigationShell.goBranch(index, initialLocation: false);
    if (isMobile) {
      scaffoldKey.currentState?.closeDrawer();
    }
  }

  void _handleOpenNotification(NotificationModel notification) {
    if (notification.workOrderId != null) {
      context.go('/workorders/${notification.workOrderId}');
      return;
    }
    if (notification.taskId != null) {
      context.go('/tasks');
      return;
    }
    _handleSelectId('notifications');
  }

  Future<void> _handleLogout() async {
    await context.read<AuthController>().handleLogout();
    if (!mounted) return;
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
    context.read<AppStorage>().write(
      Constant.KEY_SIDEBAR_EXPANDED,
      _expandedIds.toList(),
    );
  }

  void _toggleMenuMode() {
    setState(() {
      _menuMode =
          _menuMode == MenuMode.production ? MenuMode.full : MenuMode.production;
    });
    context.read<AppStorage>().write(
      Constant.KEY_MENU_MODE,
      _menuMode == MenuMode.full ? 'full' : 'production',
    );
  }

  ScreenSize _getScreenSize(double width) {
    return ResponsiveLayout.getScreenSize(width);
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
