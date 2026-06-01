import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';

/// Card wrapper for form sections.
class WorkOrderFormSectionCard extends StatelessWidget {
  const WorkOrderFormSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DetailSectionCard(title: title, child: child);
  }
}

/// Subsection title within a form section.
class WorkOrderFormSubsectionTitle extends StatelessWidget {
  const WorkOrderFormSubsectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(color: colors?.sidebarText),
    );
  }
}
