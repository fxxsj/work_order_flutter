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
import 'package:work_order_app/src/features/sales_orders/presentation/sales_order_detail_page.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/sales_order_form_page.dart';

GoRouter createAppRouter(AuthController authController) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/dashboard',
    refreshListenable: authController,
    redirect: (context, state) {
      final goingToLogin = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final loggedIn = authController.isLoggedIn;

      if (loggedIn) {
        // Validate in background so we don't block initial render.
        authController.ensureValidSession();
      }

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
              navigatorKey: _branchNavigatorKeys[item.id],
              routes: _buildBranchRoutes(item),
            ),
        ],
      ),
    ],
  );
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final List<NavItem> _leafItems = allLeafNavItemsByBranch();
final Map<String, GlobalKey<NavigatorState>> _branchNavigatorKeys = {
  for (final item in _leafItems) item.id: GlobalKey<NavigatorState>(),
};

const Set<String> _resourceEditRouteIds = {
  'customers',
  'products',
  'materials',
  'product_groups',
  'suppliers',
  'departments',
  'processes',
  'artworks',
  'dies',
  'foiling',
  'embossing',
};

const Set<String> _resourceDetailRouteIds = {
  'customers',
  'products',
  'suppliers',
};

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
            pageBuilder: (context, state) {
              final salesOrderId =
                  int.tryParse(state.uri.queryParameters['sales_order_id'] ?? '');
              return NoTransitionPage(
                child: WorkOrderFormEntry(
                  mode: WorkOrderFormMode.create,
                  initialSalesOrderId: salesOrderId,
                ),
              );
            },
          ),
          GoRoute(
            path: ':id',
            name: 'workorder_detail',
            pageBuilder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              return NoTransitionPage(
                child: WorkOrderDetailEntry(workOrderId: id ?? 0),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'workorder_edit',
                pageBuilder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  return NoTransitionPage(
                    child: WorkOrderFormEntry(
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

  if (item.id == 'sales_orders') {
    return [
      GoRoute(
        path: item.path ?? '/sales-orders',
        name: item.id,
        pageBuilder: (context, state) => NoTransitionPage(
          child: ContentPage(selectedId: item.id),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: 'sales_order_create',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SalesOrderFormEntry(mode: SalesOrderFormMode.create),
            ),
          ),
          GoRoute(
            path: ':id',
            name: 'sales_order_detail',
            pageBuilder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              return NoTransitionPage(
                child: SalesOrderDetailEntry(orderId: id ?? 0),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'sales_order_edit',
                pageBuilder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  return NoTransitionPage(
                    child: SalesOrderFormEntry(
                      mode: SalesOrderFormMode.edit,
                      orderId: id,
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
      routes: [
        if (_resourceEditRouteIds.contains(item.id))
          GoRoute(
            path: 'create',
            name: '${item.id}_create',
            pageBuilder: (context, state) => _buildExtraPage(state, item.id),
          ),
        if (_resourceEditRouteIds.contains(item.id))
          GoRoute(
            path: ':id/edit',
            name: '${item.id}_edit',
            pageBuilder: (context, state) => _buildExtraPage(state, item.id),
          ),
        if (_resourceDetailRouteIds.contains(item.id))
          GoRoute(
            path: ':id',
            name: '${item.id}_detail',
            pageBuilder: (context, state) => _buildExtraPage(state, item.id),
          ),
      ],
    ),
  ];
}

NoTransitionPage _buildExtraPage(GoRouterState state, String fallbackId) {
  final extra = state.extra;
  return NoTransitionPage(
    child: extra is Widget ? extra : ContentPage(selectedId: fallbackId),
  );
}
