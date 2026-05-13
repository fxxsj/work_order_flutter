import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';
import 'package:work_order_app/src/core/utils/role_labels.dart';

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
    required this.roleCodes,
    required this.departments,
    required this.isStaff,
    required this.isSuperuser,
    required this.fallbackToUnrestricted,
  });

  final Map<String, dynamic>? user;
  final Set<String> permissions;
  final Set<String> roleCodes;
  final Set<String> departments;
  final bool isStaff;
  final bool isSuperuser;
  final bool fallbackToUnrestricted;

  bool get isAdmin => isSuperuser || permissions.contains('*');
  bool get isManager => isAdmin || hasRole('manager');
  bool get isSales => hasRole('sales') || user?['is_salesperson'] == true;
  bool get isSupervisor =>
      isAdmin || isManager || hasRole('supervisor');
  bool get isOperator => hasRole('operator');

  bool get canSeeSales =>
      isSales || hasRole('sales');
  bool get canSeeProduction =>
      isAdmin ||
      isManager ||
      isSupervisor ||
      isOperator ||
      hasRole('supervisor') ||
      hasRole('manager') ||
      hasRole('operator');
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
      hasRole('finance') || hasRole('manager');
  bool get canSeeInventory =>
      hasRole('inventory') ||
      hasRole('supervisor') ||
      hasRole('manager');
  bool get canSeeQuality =>
      hasRole('quality') ||
      hasRole('supervisor') ||
      hasRole('manager');
  bool get canSeeSystem =>
      hasRole('admin') ||
      isStaff ||
      isAdmin ||
      hasRole('manager');

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

  String get primaryRoleLabel => RoleLabels.label(primaryRoleId);

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

  bool hasRole(String role) => roleCodes.contains(role);

  bool hasAnyRole(List<String> requiredRoles) {
    return requiredRoles.any(roleCodes.contains);
  }

  bool hasPermission(String permission) => hasAnyPermission([permission]);

  bool hasAnyPermission(Iterable<String> requiredPermissions) {
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
        roleCodes: const {},
        departments: const {},
        isStaff: false,
        isSuperuser: false,
        fallbackToUnrestricted: fallbackToUnrestricted,
      );
    }

    return PermissionProfile._(
      user: user,
      permissions: _stringSet(user['permissions']),
      roleCodes: _stringSet(user['role_codes']),
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