import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';

/// 客户列表项组件。
class CustomerListTile extends StatelessWidget {
  const CustomerListTile({
    super.key,
    required this.customer,
    required this.onTap,
    required this.onDelete,
  });

  static const double _verticalMargin = 8;
  static const String _contactLabel = '联系人';
  static const String _phoneLabel = '电话';
  static const String _emailLabel = '邮箱';
  static const String _salespersonLabel = '业务员';
  static const String _emptySubtitle = '暂无更多信息';
  static const String _subtitleSeparator = ' · ';

  final Customer customer;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleLines = <String>[];

    if (customer.contactPerson != null && customer.contactPerson!.trim().isNotEmpty) {
      subtitleLines.add('$_contactLabel：${customer.contactPerson}');
    }
    if (customer.phone != null && customer.phone!.trim().isNotEmpty) {
      subtitleLines.add('$_phoneLabel：${customer.phone}');
    }
    if (customer.email != null && customer.email!.trim().isNotEmpty) {
      subtitleLines.add('$_emailLabel：${customer.email}');
    }
    if (customer.salespersonName != null && customer.salespersonName!.trim().isNotEmpty) {
      subtitleLines.add('$_salespersonLabel：${customer.salespersonName}');
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: _verticalMargin),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?'),
        ),
        title: Text(customer.name),
        subtitle: subtitleLines.isEmpty
            ? const Text(_emptySubtitle)
            : Text(subtitleLines.join(_subtitleSeparator)),
        isThreeLine: subtitleLines.length > 2,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: theme.colorScheme.primary),
              onPressed: onTap,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: theme.colorScheme.error),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
