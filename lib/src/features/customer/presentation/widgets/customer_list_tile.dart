import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';

/// 客户列表项组件。
class CustomerListTile extends StatelessWidget {
  const CustomerListTile({
    super.key,
    required this.customer,
    required this.onTap,
    required this.onDelete,
    this.useCard = true,
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
  final bool useCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final subtleText = theme.textTheme.bodySmall?.copyWith(color: theme.hintColor);
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

    final tile = ListTile(
      leading: CircleAvatar(
        backgroundColor: primary.withOpacity(0.12),
        foregroundColor: primary,
        child: Text(customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?'),
      ),
      title: Text(
        customer.name,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitleLines.isEmpty
          ? Text(_emptySubtitle, style: subtleText)
          : Text(subtitleLines.join(_subtitleSeparator), style: subtleText),
      isThreeLine: subtitleLines.length > 2,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: '编辑',
            icon: Icon(Icons.edit, color: primary),
            onPressed: onTap,
          ),
          PopupMenuButton<String>(
            tooltip: '更多',
            onSelected: (value) {
              if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'delete',
                child: Text('删除'),
              ),
            ],
            icon: const Icon(Icons.more_horiz),
          )
        ],
      ),
      onTap: onTap,
    );

    if (useCard) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: _verticalMargin),
        child: tile,
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.6)),
        ),
      ),
      child: tile,
    );
  }
}
