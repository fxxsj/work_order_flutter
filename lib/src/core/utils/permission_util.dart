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

  bool get isAdmin => isSuperuser || permissions.contains('*');

  bool has(String permission) => hasAny([permission]);

  bool hasAny(List<String> requiredPermissions) {
    if (isAdmin) {
      return true;
    }
    if (permissions.isEmpty) {
      return fallbackToUnrestricted;
    }
    return requiredPermissions.any(permissions.contains);
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