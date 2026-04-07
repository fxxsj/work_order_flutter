import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';

class AuditLogNavigation {
  const AuditLogNavigation._();

  static bool canView(BuildContext context) {
    return PermissionUtil.snapshot(context).has('workorder.view_auditlog');
  }

  static void open(
    BuildContext context, {
    String? keyword,
  }) {
    final trimmed = keyword?.trim() ?? '';
    if (trimmed.isEmpty) {
      context.go('/audit-logs');
      return;
    }
    final uri = Uri(
      path: '/audit-logs',
      queryParameters: <String, String>{'search': trimmed},
    );
    context.go(uri.toString());
  }
}
