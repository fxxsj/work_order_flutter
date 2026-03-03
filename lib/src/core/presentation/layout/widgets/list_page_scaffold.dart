import 'package:flutter/material.dart';

class ListPageScaffold extends StatelessWidget {
  const ListPageScaffold({
    super.key,
    required this.header,
    required this.body,
    this.footer,
    this.spacing = 8,
  });

  final Widget header;
  final Widget body;
  final Widget? footer;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        SizedBox(height: spacing),
        Expanded(child: body),
        if (footer != null) ...[
          SizedBox(height: spacing),
          footer!,
        ],
      ],
    );
  }
}
