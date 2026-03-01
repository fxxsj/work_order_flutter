import 'package:flutter/material.dart';
import 'package:work_order_app/common/theme_ext.dart';
import 'package:work_order_app/utils/breakpoints_util.dart';

class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.scrollable = true,
  });

  final Widget child;
  final double maxWidth;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final isXs = BreakpointsUtil.isXs(context);
    final isSm = BreakpointsUtil.isSm(context);
    final isMd = BreakpointsUtil.isMd(context);
    final isXl = BreakpointsUtil.isXl(context);
    final padding = isXs
        ? const EdgeInsets.fromLTRB(16, 16, 16, 24)
        : isSm
            ? const EdgeInsets.fromLTRB(20, 20, 20, 28)
            : isMd
                ? const EdgeInsets.fromLTRB(24, 24, 24, 32)
                : isXl
                    ? const EdgeInsets.fromLTRB(28, 28, 28, 36)
                    : const EdgeInsets.fromLTRB(32, 32, 32, 40);

    final container = Container(
      color: colors?.background ?? theme.scaffoldBackgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    if (!scrollable) {
      return container;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: container,
          ),
        );
      },
    );
  }
}
