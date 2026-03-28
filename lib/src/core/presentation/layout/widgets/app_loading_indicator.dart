import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size,
    this.color,
    this.strokeWidth,
    this.centered = true,
  });

  final double? size;
  final Color? color;
  final double? strokeWidth;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? LayoutTokens.iconXxl;
    final indicator = SizedBox(
      width: resolvedSize,
      height: resolvedSize,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? LayoutTokens.progressStrokeWidth,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );

    if (centered) {
      return Center(child: indicator);
    }
    return indicator;
  }
}
