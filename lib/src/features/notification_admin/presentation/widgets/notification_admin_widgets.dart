import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';

class NotificationAdminSection extends StatelessWidget {
  const NotificationAdminSection({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: LayoutTokens.gapMd),
          child,
        ],
      ),
    );
  }
}

class NotificationFieldList extends StatelessWidget {
  const NotificationFieldList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: LayoutTokens.gapMd),
          children[index],
        ],
      ],
    );
  }
}

class NotificationLoadingIcon extends StatelessWidget {
  const NotificationLoadingIcon({
    super.key,
    required this.loading,
    required this.icon,
  });

  final bool loading;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Icon(icon, size: 18);
  }
}

class NotificationResultPanel extends StatelessWidget {
  const NotificationResultPanel({
    super.key,
    required this.result,
  });

  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    final pretty = const JsonEncoder.withIndent('  ').convert(result);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(LayoutTokens.gapSm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
      ),
      child: SelectableText(
        pretty,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
