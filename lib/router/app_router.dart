import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/pages/layout/adaptive_shell.dart';
import 'package:work_order_app/pages/layout/content_page.dart';
import 'package:work_order_app/pages/layout/nav_config.dart';
import 'package:work_order_app/pages/login.dart';
import 'package:work_order_app/pages/register.dart';
import 'package:work_order_app/controllers/auth_controller.dart';

GoRouter createAppRouter(AuthController authController) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/dashboard',
    refreshListenable: authController,
    redirect: (context, state) {
      final loggedIn = authController.isLoggedIn;
      final goingToLogin = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      if (!loggedIn && !goingToLogin) {
        return '/login';
      }
      if (loggedIn && state.matchedLocation == '/login') {
        return '/dashboard';
      }
      if (state.matchedLocation == '/') {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => NoTransitionPage(child: Login()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => NoTransitionPage(child: Register()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdaptiveShell(navigationShell: navigationShell);
        },
        branches: [
          for (final item in _leafItems)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: item.pathPattern ?? item.path ?? '/',
                  name: item.id,
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: ContentPage(selectedId: item.id),
                  ),
                ),
              ],
            ),
        ],
      ),
    ],
  );
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final List<NavItem> _leafItems = leafNavItemsByBranch();
