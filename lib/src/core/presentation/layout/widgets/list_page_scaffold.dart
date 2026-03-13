import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class ListPageScaffold extends StatelessWidget {
  const ListPageScaffold({
    super.key,
    required this.header,
    required this.body,
    this.footer,
    this.spacing,
  });

  final Widget header;
  final Widget body;
  final Widget? footer;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final resolvedSpacing = spacing ?? LayoutTokens.sectionSpacing(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        SizedBox(height: resolvedSpacing),
        Expanded(child: body),
        if (footer != null) footer!,
      ],
    );
  }
}
