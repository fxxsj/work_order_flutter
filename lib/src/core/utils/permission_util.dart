import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';

class PermissionSnapshot {
  const PermissionSnapshot._({
    required this.permissions,
    required this.isSuperuser,
  });

  final Set<String> permissions;
  final bool isSuperuser;

  bool get isAdmin => isSuperuser || permissions.contains('*');

  bool has(String permission) => hasAny([permission]);

  bool hasAny(List<String> requiredPermissions) {
    if (isAdmin) {
      return true;
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

  static PermissionSnapshot snapshot(BuildContext context) {
    final user = currentUser(context);
    if (user == null || user.isEmpty) {
      return PermissionSnapshot._(permissions: const {}, isSuperuser: false);
    }

    return PermissionSnapshot._(
      permissions: _stringSet(user['permissions']),
      isSuperuser: user['is_superuser'] == true,
    );
  }

  static bool hasPermission(BuildContext context, String permission) {
    return snapshot(context).has(permission);
  }

  static bool hasAnyPermission(BuildContext context, List<String> permissions) {
    return snapshot(context).hasAny(permissions);
  }

  static Set<String> _stringSet(Object? raw) {
    if (raw is List) {
      return raw.map((item) => item.toString()).toSet();
    }
    return <String>{};
  }
}
