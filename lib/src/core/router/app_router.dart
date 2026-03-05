import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/presentation/layout/adaptive_shell.dart';
import 'package:work_order_app/src/core/presentation/layout/content_page.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/auth/presentation/login_page.dart';
import 'package:work_order_app/src/features/auth/presentation/register_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_detail_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_form_page.dart';

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
              routes: _buildBranchRoutes(item),
            ),
        ],
      ),
    ],
  );
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final List<NavItem> _leafItems = leafNavItemsByBranch();

List<GoRoute> _buildBranchRoutes(NavItem item) {
  if (item.id == 'workorders') {
    return [
      GoRoute(
        path: item.path ?? '/workorders',
        name: item.id,
        pageBuilder: (context, state) => NoTransitionPage(
          child: ContentPage(selectedId: item.id),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: 'workorder_create',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WorkOrderFormPage(mode: WorkOrderFormMode.create),
            ),
          ),
          GoRoute(
            path: ':id',
            name: 'workorder_detail',
            pageBuilder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              return NoTransitionPage(
                child: WorkOrderDetailPage(workOrderId: id ?? 0),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'workorder_edit',
                pageBuilder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  return NoTransitionPage(
                    child: WorkOrderFormPage(
                      mode: WorkOrderFormMode.edit,
                      workOrderId: id,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ];
  }

  return [
    GoRoute(
      path: item.path ?? '/',
      name: item.id,
      pageBuilder: (context, state) => NoTransitionPage(
        child: ContentPage(selectedId: item.id),
      ),
    ),
  ];
}
