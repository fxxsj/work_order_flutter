import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';

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

  static bool hasPermission(
    BuildContext context,
    String permission, {
    bool fallbackToUnrestricted = true,
  }) {
    return hasAnyPermission(
      context,
      [permission],
      fallbackToUnrestricted: fallbackToUnrestricted,
    );
  }

  static bool hasAnyPermission(
    BuildContext context,
    List<String> permissions, {
    bool fallbackToUnrestricted = true,
  }) {
    final user = currentUser(context);
    if (user == null || user.isEmpty) {
      return fallbackToUnrestricted;
    }

    if (user['is_superuser'] == true) {
      return true;
    }

    final raw = user['permissions'];
    if (raw is! List) {
      return fallbackToUnrestricted;
    }

    final granted = raw.map((item) => item.toString()).toSet();
    if (granted.contains('*')) {
      return true;
    }
    if (granted.isEmpty) {
      return fallbackToUnrestricted;
    }

    return permissions.any(granted.contains);
  }
}
