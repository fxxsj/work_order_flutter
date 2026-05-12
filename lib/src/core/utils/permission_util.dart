import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';

class PermissionSnapshot {
  const PermissionSnapshot._({
    required this.permissions,
    required this.isSuperuser,
    required this.fallbackToUnrestricted,
  });

  final Set<String> permissions;
  final bool isSuperuser;
  final bool fallbackToUnrestricted;

  bool has(String permission) => hasAny([permission]);

  bool hasAny(List<String> requiredPermissions) {
    if (isSuperuser || permissions.contains('*')) {
      return true;
    }
    if (permissions.isEmpty) {
      return fallbackToUnrestricted;
    }
    return requiredPermissions.any(permissions.contains);
  }
}

enum PermissionRole {
  admin,
  manager,
  sales,
  supervisor,
  operator,
  finance,
  inventory,
  quality,
  system,
  general,
}

class PermissionProfile {
  const PermissionProfile._({
    required this.user,
    required this.permissions,
    required this.groups,
    required this.departments,
    required this.isStaff,
    required this.isSuperuser,
    required this.fallbackToUnrestricted,
  });

  static const List<String> financePermissions = [
    'workorder.view_invoice',
    'workorder.add_invoice',
    'workorder.change_invoice',
    'workorder.view_payment',
    'workorder.add_payment',
    'workorder.change_payment',
    'workorder.view_paymentplan',
    'workorder.change_paymentplan',
    'workorder.view_statement',
    'workorder.add_statement',
    'workorder.change_statement',
    'workorder.view_productioncost',
    'workorder.change_productioncost',
  ];

  static const List<String> inventoryPermissions = [
    'workorder.view_productstock',
    'workorder.change_productstock',
    'workorder.view_stockin',
    'workorder.add_stockin',
    'workorder.change_stockin',
    'workorder.view_stockout',
    'workorder.add_stockout',
    'workorder.change_stockout',
    'workorder.view_deliveryorder',
    'workorder.add_deliveryorder',
    'workorder.change_deliveryorder',
  ];

  static const List<String> qualityPermissions = [
    'workorder.view_qualityinspection',
    'workorder.add_qualityinspection',
    'workorder.change_qualityinspection',
  ];

  static const List<String> salesPermissions = [
    'workorder.view_salesorder',
    'workorder.add_salesorder',
    'workorder.change_salesorder',
    'workorder.view_customer',
    'workorder.add_customer',
    'workorder.change_customer',
  ];

  static const List<String> productionPermissions = [
    'workorder.view_workorder',
    'workorder.add_workorder',
    'workorder.change_workorder',
    'workorder.view_workordertask',
    'workorder.change_workordertask',
    'workorder.view_workorderprocess',
    'workorder.change_workorderprocess',
  ];

  static const List<String> systemPermissions = [
    'workorder.view_department',
    'workorder.change_department',
    'workorder.view_process',
    'workorder.change_process',
    'workorder.view_taskassignmentrule',
    'workorder.change_taskassignmentrule',
    'workorder.view_systemnotificationsettings',
    'workorder.change_systemnotificationsettings',
    'workorder.view_notificationtemplate',
    'workorder.change_notificationtemplate',
    'workorder.view_auditlog',
  ];

  final Map<String, dynamic>? user;
  final Set<String> permissions;
  final Set<String> groups;
  final Set<String> departments;
  final bool isStaff;
  final bool isSuperuser;
  final bool fallbackToUnrestricted;

  bool get isAdmin => isSuperuser || permissions.contains('*');
  bool get isManager => isAdmin || hasGroup('经理');
  bool get isSales => hasGroup('业务员') || user?['is_salesperson'] == true;
  bool get isSupervisor =>
      isAdmin || isManager || hasAnyGroup(['主管', 'supervisor']);
  bool get isOperator => hasGroup('操作员');

  bool get canSeeSales => isSales || hasAnyPermission(salesPermissions);
  bool get canSeeProduction =>
      isAdmin ||
      isManager ||
      isSupervisor ||
      isOperator ||
      hasAnyPermission(productionPermissions);
  bool get canSeeTasks =>
      canSeeProduction ||
      hasAnyPermission([
        'workorder.view_workordertask',
        'workorder.change_workordertask',
      ]);
  bool get canManageTasks =>
      isAdmin ||
      isManager ||
      isSupervisor ||
      hasAnyPermission([
        'workorder.change_workorder',
        'workorder.change_workordertask',
      ]);
  bool get canSeeFinance =>
      hasGroup('财务') || hasAnyPermission(financePermissions);
  bool get canSeeInventory =>
      hasGroup('仓储') || hasAnyPermission(inventoryPermissions);
  bool get canSeeQuality =>
      hasGroup('质检') || hasAnyPermission(qualityPermissions);
  bool get canSeeSystem =>
      hasGroup('系统管理员') ||
      isStaff ||
      isAdmin ||
      hasAnyPermission(systemPermissions);

  bool get isFinanceFocused =>
      !isAdmin && !isManager && !isSales && !isSupervisor && canSeeFinance;
  bool get isInventoryFocused =>
      !isAdmin &&
      !isManager &&
      !isSales &&
      !isSupervisor &&
      !canSeeFinance &&
      canSeeInventory;
  bool get isQualityFocused =>
      !isAdmin &&
      !isManager &&
      !isSales &&
      !isSupervisor &&
      !canSeeFinance &&
      !canSeeInventory &&
      canSeeQuality;

  PermissionRole get primaryRole {
    if (isAdmin) return PermissionRole.admin;
    if (isManager) return PermissionRole.manager;
    if (isSales) return PermissionRole.sales;
    if (isSupervisor) return PermissionRole.supervisor;
    if (isOperator) return PermissionRole.operator;
    if (canSeeFinance) return PermissionRole.finance;
    if (canSeeInventory) return PermissionRole.inventory;
    if (canSeeQuality) return PermissionRole.quality;
    if (canSeeSystem) return PermissionRole.system;
    return PermissionRole.general;
  }

  String get primaryRoleId => primaryRole.name;

  String get primaryRoleLabel {
    switch (primaryRole) {
      case PermissionRole.admin:
        return '管理员';
      case PermissionRole.manager:
        return '经理';
      case PermissionRole.sales:
        return '业务员';
      case PermissionRole.supervisor:
        return '主管';
      case PermissionRole.operator:
        return '操作员';
      case PermissionRole.finance:
        return '财务';
      case PermissionRole.inventory:
        return '仓储';
      case PermissionRole.quality:
        return '质检';
      case PermissionRole.system:
        return '系统维护';
      case PermissionRole.general:
        return '通用';
    }
  }

  List<String> get capabilityIds {
    return [
      if (canSeeSales) 'sales',
      if (canSeeProduction) 'production',
      if (canSeeTasks) 'tasks',
      if (canSeeFinance) 'finance',
      if (canSeeInventory) 'inventory',
      if (canSeeQuality) 'quality',
      if (canSeeSystem) 'system',
    ];
  }

  bool hasGroup(String group) => groups.contains(group);

  bool hasAnyGroup(List<String> requiredGroups) {
    return requiredGroups.any(groups.contains);
  }

  bool hasPermission(String permission) => hasAnyPermission([permission]);

  bool hasAnyPermission(List<String> requiredPermissions) {
    if (isAdmin) return true;
    if (permissions.isEmpty) return fallbackToUnrestricted;
    return requiredPermissions.any(permissions.contains);
  }

  bool canUseAny(List<String> requiredPermissions) {
    return hasAnyPermission(requiredPermissions);
  }
}

class PermissionUtil {
  const PermissionUtil._();

  static Map<String, dynamic>? currentUser(BuildContext context) {
    final raw = context.read<AppStorage>().read(Constant.KEY_CURRENT_USER_INFO);
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  static bool isSuperuser(BuildContext context) {
    final user = currentUser(context);
    return user?['is_superuser'] == true;
  }

  static PermissionProfile profile(
    BuildContext context, {
    bool fallbackToUnrestricted = true,
  }) {
    return profileFromUser(
      currentUser(context),
      fallbackToUnrestricted: fallbackToUnrestricted,
    );
  }

  static PermissionProfile profileFromUser(
    Map<String, dynamic>? user, {
    bool fallbackToUnrestricted = true,
  }) {
    if (user == null || user.isEmpty) {
      return PermissionProfile._(
        user: user,
        permissions: const {},
        groups: const {},
        departments: const {},
        isStaff: false,
        isSuperuser: false,
        fallbackToUnrestricted: fallbackToUnrestricted,
      );
    }

    return PermissionProfile._(
      user: user,
      permissions: _stringSet(user['permissions']),
      groups: _stringSet(user['groups']),
      departments: _stringSet(user['departments']),
      isStaff: user['is_staff'] == true,
      isSuperuser: user['is_superuser'] == true,
      fallbackToUnrestricted: fallbackToUnrestricted,
    );
  }

  static PermissionSnapshot snapshot(
    BuildContext context, {
    bool fallbackToUnrestricted = true,
  }) {
    final user = currentUser(context);
    if (user == null || user.isEmpty) {
      return PermissionSnapshot._(
        permissions: const {},
        isSuperuser: false,
        fallbackToUnrestricted: fallbackToUnrestricted,
      );
    }

    return PermissionSnapshot._(
      permissions: _stringSet(user['permissions']),
      isSuperuser: user['is_superuser'] == true,
      fallbackToUnrestricted: fallbackToUnrestricted,
    );
  }

  static bool hasPermission(
    BuildContext context,
    String permission, {
    bool fallbackToUnrestricted = true,
  }) {
    return snapshot(
      context,
      fallbackToUnrestricted: fallbackToUnrestricted,
    ).has(permission);
  }

  static bool hasAnyPermission(
    BuildContext context,
    List<String> permissions, {
    bool fallbackToUnrestricted = true,
  }) {
    return snapshot(
      context,
      fallbackToUnrestricted: fallbackToUnrestricted,
    ).hasAny(permissions);
  }

  static Set<String> _stringSet(Object? raw) {
    if (raw is List) {
      return raw.map((item) => item.toString()).toSet();
    }
    return <String>{};
  }
}
