import 'package:flutter/material.dart';

class NavItem {
  final String id;
  final String label;
  final IconData icon;
  final String? path;
  final String? pathPattern;
  final List<String>? breadcrumb;
  final List<NavItem> children;
  final String? badge;
  final bool showInSidebar;
  final List<String> requiredPermissions;
  final List<String> requiredGroups;
  final bool superuserOnly;

  const NavItem({
    required this.id,
    required this.label,
    required this.icon,
    this.path,
    this.pathPattern,
    this.breadcrumb,
    this.children = const [],
    this.badge,
    this.showInSidebar = true,
    this.requiredPermissions = const [],
    this.requiredGroups = const [],
    this.superuserOnly = false,
  });

  NavItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    String? path,
    String? pathPattern,
    List<String>? breadcrumb,
    List<NavItem>? children,
    String? badge,
    bool? showInSidebar,
    List<String>? requiredPermissions,
    List<String>? requiredGroups,
    bool? superuserOnly,
  }) {
    return NavItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      path: path ?? this.path,
      pathPattern: pathPattern ?? this.pathPattern,
      breadcrumb: breadcrumb ?? this.breadcrumb,
      children: children ?? this.children,
      badge: badge ?? this.badge,
      showInSidebar: showInSidebar ?? this.showInSidebar,
      requiredPermissions: requiredPermissions ?? this.requiredPermissions,
      requiredGroups: requiredGroups ?? this.requiredGroups,
      superuserOnly: superuserOnly ?? this.superuserOnly,
    );
  }
}

class _NavAccessContext {
  const _NavAccessContext({
    required this.permissions,
    required this.groups,
    required this.isSuperuser,
    required this.unrestricted,
  });

  final Set<String> permissions;
  final Set<String> groups;
  final bool isSuperuser;
  final bool unrestricted;

  factory _NavAccessContext.fromUser(Map<String, dynamic>? user) {
    if (user == null || user.isEmpty) {
      return const _NavAccessContext(
        permissions: {},
        groups: {},
        isSuperuser: false,
        unrestricted: true,
      );
    }

    final rawPermissions = user['permissions'];
    final rawGroups = user['groups'];
    final permissions = <String>{};
    final groups = <String>{};

    if (rawPermissions is List) {
      permissions.addAll(rawPermissions.map((item) => item.toString()));
    }
    if (rawGroups is List) {
      groups.addAll(rawGroups.map((item) => item.toString()));
    }

    final isSuperuser = user['is_superuser'] == true;
    final unrestricted = permissions.isEmpty && groups.isEmpty && !isSuperuser;

    return _NavAccessContext(
      permissions: permissions,
      groups: groups,
      isSuperuser: isSuperuser,
      unrestricted: unrestricted,
    );
  }

  bool canAccess(NavItem item) {
    if (unrestricted) return true;
    if (isSuperuser || permissions.contains('*')) return true;
    if (item.superuserOnly) return false;
    if (item.requiredGroups.isNotEmpty &&
        !item.requiredGroups.any(groups.contains)) {
      return false;
    }
    if (item.requiredPermissions.isNotEmpty &&
        !item.requiredPermissions.any(permissions.contains)) {
      return false;
    }
    return true;
  }
}

// Keep this in sync with leaf routes. New menu items should be added here
// to preserve branch order across sidebar reorderings.
const List<String> branchOrder = [
  'dashboard',
  'workorders',
  'approval_center',
  'approval_workflows',
  'urgent_orders',
  'approval_reports',
  'tasks_list',
  'tasks_operator',
  'tasks_supervisor',
  'tasks_board',
  'tasks_stats',
  'tasks_history',
  'products',
  'materials',
  'product_groups',
  'artworks',
  'dies',
  'foiling',
  'embossing',
  'purchase_orders',
  'sales_orders',
  'stocks',
  'stock_ins',
  'stock_outs',
  'delivery',
  'quality',
  'invoices',
  'payments',
  'payment_plans',
  'cost_centers',
  'cost_items',
  'costs',
  'statements',
  'customers',
  'suppliers',
  'departments',
  'processes',
  'process_logs',
  'tasks_rules',
  'system_notifications',
  'user_notification_settings',
  'notification_templates',
  'notifications',
  'profile',
  'audit_logs',
];

const List<NavItem> navItems = [
  NavItem(
    id: 'dashboard',
    label: '工作台',
    icon: Icons.dashboard_outlined,
    path: '/dashboard',
  ),
  NavItem(
    id: 'workorders',
    label: '施工单',
    icon: Icons.description_outlined,
    path: '/workorders',
    requiredPermissions: ['workorder.view_workorder'],
  ),
  NavItem(
    id: 'approvals',
    label: '审批管理',
    icon: Icons.fact_check_outlined,
    children: [
      NavItem(
        id: 'approval_center',
        label: '审批中心',
        icon: Icons.task_alt_outlined,
        path: '/approvals/center',
        requiredPermissions: ['workorder.view_workorder'],
      ),
      NavItem(
        id: 'approval_workflows',
        label: '审批工作流',
        icon: Icons.route_outlined,
        path: '/approvals/workflows',
      ),
      NavItem(
        id: 'urgent_orders',
        label: '紧急订单',
        icon: Icons.priority_high_outlined,
        path: '/approvals/urgent-orders',
      ),
      NavItem(
        id: 'approval_reports',
        label: '审批报表',
        icon: Icons.bar_chart_outlined,
        path: '/approvals/reports',
      ),
    ],
  ),
  NavItem(
    id: 'tasks',
    label: '任务管理',
    icon: Icons.task_alt_outlined,
    children: [
      NavItem(
        id: 'tasks_list',
        label: '任务列表',
        icon: Icons.view_list_outlined,
        path: '/tasks',
        requiredPermissions: [
          'workorder.view_workordertask',
          'workorder.view_workorder',
        ],
      ),
      NavItem(
        id: 'tasks_operator',
        label: '操作员任务中心',
        icon: Icons.person_outline,
        path: '/tasks/operator',
        requiredPermissions: [
          'workorder.view_workordertask',
          'workorder.view_workorder',
        ],
      ),
      NavItem(
        id: 'tasks_supervisor',
        label: '主管看板',
        icon: Icons.dashboard_customize_outlined,
        path: '/tasks/supervisor',
        requiredPermissions: [
          'workorder.view_workordertask',
          'workorder.view_workorder',
        ],
      ),
      NavItem(
        id: 'tasks_board',
        label: '部门任务看板',
        icon: Icons.view_kanban_outlined,
        path: '/tasks/board',
        requiredPermissions: [
          'workorder.view_workordertask',
          'workorder.view_workorder',
        ],
      ),
      NavItem(
        id: 'tasks_stats',
        label: '协作统计',
        icon: Icons.insights_outlined,
        path: '/tasks/stats',
        requiredPermissions: [
          'workorder.view_workordertask',
          'workorder.view_workorder',
        ],
      ),
      NavItem(
        id: 'tasks_history',
        label: '分派历史',
        icon: Icons.history_outlined,
        path: '/tasks/assignment-history',
        requiredPermissions: [
          'workorder.view_workordertask',
          'workorder.view_workorder',
        ],
      ),
    ],
  ),
  NavItem(
    id: 'product_material',
    label: '产品物料',
    icon: Icons.shopping_bag_outlined,
    children: [
      NavItem(
        id: 'products',
        label: '产品管理',
        icon: Icons.inventory_2_outlined,
        path: '/products',
        requiredPermissions: ['workorder.view_product'],
      ),
      NavItem(
        id: 'materials',
        label: '物料管理',
        icon: Icons.category_outlined,
        path: '/materials',
        requiredPermissions: ['workorder.view_material'],
      ),
      NavItem(
        id: 'product_groups',
        label: '产品组管理',
        icon: Icons.group_work_outlined,
        path: '/product-groups',
        requiredPermissions: ['workorder.view_productgroup'],
      ),
    ],
  ),
  NavItem(
    id: 'plate_making',
    label: '制版管理',
    icon: Icons.print_outlined,
    children: [
      NavItem(
        id: 'artworks',
        label: '图稿管理',
        icon: Icons.image_outlined,
        path: '/artworks',
        requiredPermissions: ['workorder.view_artwork'],
      ),
      NavItem(
        id: 'dies',
        label: '刀模管理',
        icon: Icons.cut_outlined,
        path: '/dies',
        requiredPermissions: ['workorder.view_die'],
      ),
      NavItem(
        id: 'foiling',
        label: '烫金版管理',
        icon: Icons.auto_fix_high_outlined,
        path: '/foiling-plates',
        requiredPermissions: ['workorder.view_foilingplate'],
      ),
      NavItem(
        id: 'embossing',
        label: '压凸版管理',
        icon: Icons.texture_outlined,
        path: '/embossing-plates',
        requiredPermissions: ['workorder.view_embossingplate'],
      ),
    ],
  ),
  NavItem(
    id: 'purchase_sales',
    label: '采购销售',
    icon: Icons.shopping_cart_outlined,
    children: [
      NavItem(
        id: 'purchase_orders',
        label: '采购单管理',
        icon: Icons.receipt_long_outlined,
        path: '/purchase-orders',
        requiredPermissions: ['workorder.view_purchaseorder'],
      ),
      NavItem(
        id: 'sales_orders',
        label: '客户订单',
        icon: Icons.point_of_sale_outlined,
        path: '/sales-orders',
        requiredPermissions: ['workorder.view_salesorder'],
      ),
    ],
  ),
  NavItem(
    id: 'inventory',
    label: '库存管理',
    icon: Icons.warehouse_outlined,
    children: [
      NavItem(
        id: 'stocks',
        label: '成品库存',
        icon: Icons.inventory_outlined,
        path: '/inventory/stocks',
        requiredPermissions: ['workorder.view_productstock'],
      ),
      NavItem(
        id: 'stock_ins',
        label: '入库单',
        icon: Icons.inventory_2_outlined,
        path: '/inventory/stock-ins',
        requiredPermissions: ['workorder.view_stockin'],
      ),
      NavItem(
        id: 'stock_outs',
        label: '出库单',
        icon: Icons.exit_to_app_outlined,
        path: '/inventory/stock-outs',
        requiredPermissions: ['workorder.view_stockout'],
      ),
      NavItem(
        id: 'delivery',
        label: '发货管理',
        icon: Icons.local_shipping_outlined,
        path: '/inventory/delivery',
        requiredPermissions: ['workorder.view_deliveryorder'],
      ),
      NavItem(
        id: 'quality',
        label: '质量检验',
        icon: Icons.verified_outlined,
        path: '/inventory/quality',
        requiredPermissions: ['workorder.view_qualityinspection'],
      ),
    ],
  ),
  NavItem(
    id: 'finance',
    label: '财务管理',
    icon: Icons.account_balance_wallet_outlined,
    children: [
      NavItem(
        id: 'invoices',
        label: '发票管理',
        icon: Icons.receipt_outlined,
        path: '/finance/invoices',
        requiredPermissions: ['workorder.view_invoice'],
      ),
      NavItem(
        id: 'payments',
        label: '收款管理',
        icon: Icons.payments_outlined,
        path: '/finance/payments',
        requiredPermissions: ['workorder.view_payment'],
      ),
      NavItem(
        id: 'payment_plans',
        label: '收款计划',
        icon: Icons.event_note_outlined,
        path: '/finance/payment-plans',
        requiredPermissions: ['workorder.view_paymentplan'],
      ),
      NavItem(
        id: 'cost_centers',
        label: '成本中心',
        icon: Icons.account_tree_outlined,
        path: '/finance/cost-centers',
        requiredPermissions: ['workorder.view_costcenter'],
      ),
      NavItem(
        id: 'cost_items',
        label: '成本项目',
        icon: Icons.receipt_long_outlined,
        path: '/finance/cost-items',
        requiredPermissions: ['workorder.view_costitem'],
      ),
      NavItem(
        id: 'costs',
        label: '成本核算',
        icon: Icons.pie_chart_outline,
        path: '/finance/costs',
        requiredPermissions: ['workorder.view_productioncost'],
      ),
      NavItem(
        id: 'statements',
        label: '对账管理',
        icon: Icons.summarize_outlined,
        path: '/finance/statements',
        requiredPermissions: ['workorder.view_statement'],
      ),
    ],
  ),
  NavItem(
    id: 'system',
    label: '系统设置',
    icon: Icons.settings_outlined,
    children: [
      NavItem(
        id: 'customers',
        label: '客户管理',
        icon: Icons.people_outline,
        path: '/customers',
        requiredPermissions: ['workorder.view_customer'],
      ),
      NavItem(
        id: 'suppliers',
        label: '供应商管理',
        icon: Icons.storefront_outlined,
        path: '/suppliers',
        requiredPermissions: ['workorder.view_supplier'],
      ),
      NavItem(
        id: 'departments',
        label: '部门管理',
        icon: Icons.apartment_outlined,
        path: '/departments',
        requiredPermissions: ['workorder.view_department'],
      ),
      NavItem(
        id: 'processes',
        label: '工序管理',
        icon: Icons.account_tree_outlined,
        path: '/processes',
        requiredPermissions: ['workorder.view_process'],
      ),
      NavItem(
        id: 'process_logs',
        label: '工序日志',
        icon: Icons.article_outlined,
        path: '/process-logs',
        showInSidebar: false,
        requiredPermissions: ['workorder.view_processlog'],
      ),
      NavItem(
        id: 'tasks_rules',
        label: '分派规则配置',
        icon: Icons.rule_outlined,
        path: '/tasks/assignment-rules',
        requiredPermissions: ['workorder.view_taskassignmentrule'],
      ),
      NavItem(
        id: 'system_notifications',
        label: '系统通知',
        icon: Icons.campaign_outlined,
        path: '/system-notifications',
        superuserOnly: true,
      ),
      NavItem(
        id: 'user_notification_settings',
        label: '通知设置',
        icon: Icons.tune_outlined,
        path: '/notification-settings',
        superuserOnly: true,
      ),
      NavItem(
        id: 'notification_templates',
        label: '通知模板',
        icon: Icons.view_list_outlined,
        path: '/notification-templates',
        superuserOnly: true,
      ),
      NavItem(
        id: 'audit_logs',
        label: '审计日志',
        icon: Icons.fact_check_outlined,
        path: '/audit-logs',
        requiredPermissions: ['workorder.view_auditlog'],
      ),
    ],
  ),
  NavItem(
    id: 'notifications',
    label: '通知中心',
    icon: Icons.notifications_outlined,
    path: '/notifications',
    showInSidebar: false,
  ),
  NavItem(
    id: 'profile',
    label: '个人信息',
    icon: Icons.person_outline,
    path: '/profile',
    showInSidebar: false,
  ),
];

List<NavItem> sidebarNavItems({Map<String, dynamic>? currentUser}) {
  return _filterNavItems(
    navItems,
    access: _NavAccessContext.fromUser(currentUser),
    includeHidden: false,
  );
}

List<NavItem> _filterNavItems(
  List<NavItem> items, {
  required _NavAccessContext access,
  required bool includeHidden,
}) {
  final result = <NavItem>[];
  for (final item in items) {
    if (!includeHidden && !item.showInSidebar) {
      continue;
    }
    if (item.children.isEmpty && !access.canAccess(item)) {
      continue;
    }
    if (item.children.isEmpty) {
      result.add(item);
    } else {
      final children = _filterNavItems(
        item.children,
        access: access,
        includeHidden: includeHidden,
      );
      if (children.isEmpty) {
        continue;
      }
      result.add(item.copyWith(children: children));
    }
  }
  return result;
}

List<NavItem> flattenNavItems(List<NavItem> items) {
  final result = <NavItem>[];
  for (final item in items) {
    if (item.children.isNotEmpty) {
      result.addAll(flattenNavItems(item.children));
    } else {
      result.add(item);
    }
  }
  return result;
}

final List<NavItem> _flatNavItems = flattenNavItems(navItems);

List<NavItem> leafNavItemsByBranch({Map<String, dynamic>? currentUser}) {
  final filtered = _filterNavItems(
    navItems,
    access: _NavAccessContext.fromUser(currentUser),
    includeHidden: true,
  );
  final leaves = flattenNavItems(filtered);
  final byId = {for (final item in leaves) item.id: item};
  final ordered = <NavItem>[];
  for (final id in branchOrder) {
    final item = byId.remove(id);
    if (item != null) {
      ordered.add(item);
    }
  }
  if (byId.isNotEmpty) {
    final remaining = byId.values.toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    ordered.addAll(remaining);
  }
  return ordered;
}

Map<String, int> buildIdToBranchIndex() {
  final map = <String, int>{};
  final ordered = leafNavItemsByBranch();
  for (var i = 0; i < ordered.length; i++) {
    map[ordered[i].id] = i;
  }
  return map;
}

Map<String, String> buildPathToIdMap() {
  final map = <String, String>{};
  for (final item in _flatNavItems) {
    final path = item.path;
    if (path != null) {
      map[path] = item.id;
    }
  }
  return map;
}

String? matchNavId(String path) {
  final direct = buildPathToIdMap()[path];
  if (direct != null) {
    return direct;
  }
  for (final item in _flatNavItems) {
    final pattern = item.pathPattern ?? item.path;
    if (pattern == null) {
      continue;
    }
    final regex = _pathPatternToRegex(pattern);
    if (regex.hasMatch(path)) {
      return item.id;
    }
  }
  for (final item in _flatNavItems) {
    final base = item.path;
    if (base != null && path.startsWith('$base/')) {
      return item.id;
    }
  }
  return null;
}

String? matchNavIdWith(String path, Map<String, String> pathToId) {
  final direct = pathToId[path];
  if (direct != null) {
    return direct;
  }
  for (final item in _flatNavItems) {
    final pattern = item.pathPattern ?? item.path;
    if (pattern == null) {
      continue;
    }
    final regex = _pathPatternToRegex(pattern);
    if (regex.hasMatch(path)) {
      return item.id;
    }
  }
  for (final item in _flatNavItems) {
    final base = item.path;
    if (base != null && path.startsWith('$base/')) {
      return item.id;
    }
  }
  return null;
}

List<String> buildBreadcrumb(String id) {
  for (final item in navItems) {
    if (item.id == id) {
      return item.breadcrumb ?? ['首页', item.label];
    }
    for (final child in item.children) {
      if (child.id == id) {
        return child.breadcrumb ?? ['首页', item.label, child.label];
      }
    }
  }
  return ['首页'];
}

List<String> buildBreadcrumbForPath(String path) {
  final id = matchNavId(path);
  if (id == null) {
    return ['首页'];
  }
  return buildBreadcrumb(id);
}

List<String> buildBreadcrumbForPathWith(
    String path, Map<String, String> pathToId) {
  final id = matchNavIdWith(path, pathToId);
  if (id == null) {
    return ['首页'];
  }
  return buildBreadcrumb(id);
}

String labelFor(String id) {
  for (final item in navItems) {
    if (item.id == id) return item.label;
    for (final child in item.children) {
      if (child.id == id) return child.label;
    }
  }
  return id;
}

RegExp _pathPatternToRegex(String pattern) {
  final escaped =
      pattern.replaceAllMapped(RegExp(r'([.+^${}()|\\])'), (m) => '\\${m[0]}');
  final replaced = escaped.replaceAllMapped(
      RegExp(r':([a-zA-Z_][a-zA-Z0-9_]*)'), (_) => r'[^/]+');
  return RegExp('^${replaced}\$');
}
