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

  const NavItem({
    required this.id,
    required this.label,
    required this.icon,
    this.path,
    this.pathPattern,
    this.breadcrumb,
    this.children = const [],
    this.badge,
  });
}

// Keep this in sync with leaf routes. New menu items should be added here
// to preserve branch order across sidebar reorderings.
const List<String> branchOrder = [
  'dashboard',
  'workorders_list',
  'workorders_create',
  'tasks_list',
  'tasks_board',
  'tasks_stats',
  'tasks_history',
  'tasks_rules',
  'customers',
  'departments',
  'processes',
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
  'delivery',
  'quality',
  'invoices',
  'payments',
  'costs',
  'statements',
  'notifications',
  'profile',
];

const List<NavItem> navItems = [
  NavItem(
    id: 'dashboard',
    label: '工作台',
    icon: Icons.dashboard_outlined,
    path: '/',
  ),
  NavItem(
    id: 'workorders',
    label: '施工单',
    icon: Icons.description_outlined,
    children: [
      NavItem(id: 'workorders_list', label: '施工单列表', icon: Icons.list_alt_outlined, path: '/workorders/list'),
      NavItem(id: 'workorders_create', label: '新建施工单', icon: Icons.add_circle_outline, path: '/workorders/create'),
    ],
  ),
  NavItem(
    id: 'tasks',
    label: '任务管理',
    icon: Icons.task_alt_outlined,
    children: [
      NavItem(id: 'tasks_list', label: '任务列表', icon: Icons.view_list_outlined, path: '/tasks/list'),
      NavItem(id: 'tasks_board', label: '部门任务看板', icon: Icons.view_kanban_outlined, path: '/tasks/board'),
      NavItem(id: 'tasks_stats', label: '协作统计', icon: Icons.insights_outlined, path: '/tasks/stats'),
      NavItem(id: 'tasks_history', label: '分派历史', icon: Icons.history_outlined, path: '/tasks/history'),
      NavItem(id: 'tasks_rules', label: '分派规则配置', icon: Icons.rule_outlined, path: '/tasks/rules'),
    ],
  ),
  NavItem(
    id: 'basic_data',
    label: '基础数据',
    icon: Icons.storage_outlined,
    children: [
      NavItem(id: 'customers', label: '客户管理', icon: Icons.people_outline, path: '/basic/customers'),
      NavItem(id: 'departments', label: '部门管理', icon: Icons.apartment_outlined, path: '/basic/departments'),
      NavItem(id: 'processes', label: '工序管理', icon: Icons.account_tree_outlined, path: '/basic/processes'),
      NavItem(id: 'products', label: '产品管理', icon: Icons.inventory_2_outlined, path: '/basic/products'),
      NavItem(id: 'materials', label: '物料管理', icon: Icons.category_outlined, path: '/basic/materials'),
      NavItem(id: 'product_groups', label: '产品组管理', icon: Icons.group_work_outlined, path: '/basic/product-groups'),
    ],
  ),
  NavItem(
    id: 'plate_making',
    label: '制版管理',
    icon: Icons.print_outlined,
    children: [
      NavItem(id: 'artworks', label: '图稿管理', icon: Icons.image_outlined, path: '/plate/artworks'),
      NavItem(id: 'dies', label: '刀模管理', icon: Icons.cut_outlined, path: '/plate/dies'),
      NavItem(id: 'foiling', label: '烫金版管理', icon: Icons.auto_fix_high_outlined, path: '/plate/foiling'),
      NavItem(id: 'embossing', label: '压凸版管理', icon: Icons.texture_outlined, path: '/plate/embossing'),
    ],
  ),
  NavItem(
    id: 'purchase_sales',
    label: '采购销售',
    icon: Icons.shopping_bag_outlined,
    children: [
      NavItem(id: 'purchase_orders', label: '采购单管理', icon: Icons.receipt_long_outlined, path: '/purchase/orders'),
      NavItem(id: 'sales_orders', label: '销售订单', icon: Icons.point_of_sale_outlined, path: '/purchase/sales'),
    ],
  ),
  NavItem(
    id: 'inventory',
    label: '库存管理',
    icon: Icons.warehouse_outlined,
    children: [
      NavItem(id: 'stocks', label: '成品库存', icon: Icons.inventory_outlined, path: '/inventory/stocks'),
      NavItem(id: 'delivery', label: '发货管理', icon: Icons.local_shipping_outlined, path: '/inventory/delivery'),
      NavItem(id: 'quality', label: '质量检验', icon: Icons.verified_outlined, path: '/inventory/quality'),
    ],
  ),
  NavItem(
    id: 'finance',
    label: '财务管理',
    icon: Icons.account_balance_wallet_outlined,
    children: [
      NavItem(id: 'invoices', label: '发票管理', icon: Icons.receipt_outlined, path: '/finance/invoices'),
      NavItem(id: 'payments', label: '收款管理', icon: Icons.payments_outlined, path: '/finance/payments'),
      NavItem(id: 'costs', label: '成本核算', icon: Icons.pie_chart_outline, path: '/finance/costs'),
      NavItem(id: 'statements', label: '对账管理', icon: Icons.summarize_outlined, path: '/finance/statements'),
    ],
  ),
  NavItem(
    id: 'notifications',
    label: '通知中心',
    icon: Icons.notifications_outlined,
    path: '/notifications',
    badge: '3',
  ),
  NavItem(
    id: 'profile',
    label: '个人信息',
    icon: Icons.person_outline,
    path: '/profile',
  ),
];

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

List<NavItem> leafNavItemsByBranch() {
  final leaves = _flatNavItems;
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

List<String> buildBreadcrumbForPathWith(String path, Map<String, String> pathToId) {
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
  final escaped = pattern.replaceAllMapped(RegExp(r'([.+^${}()|\\])'), (m) => '\\${m[0]}');
  final replaced = escaped.replaceAllMapped(RegExp(r':([a-zA-Z_][a-zA-Z0-9_]*)'), (_) => r'[^/]+');
  return RegExp('^${replaced}\$');
}
