import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';

class TaskPlaceholderPage extends StatelessWidget {
  const TaskPlaceholderPage({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  static const double _spacing = 12;
  static const double _sectionSpacing = 16;
  static const String _summaryHintText = '当前页面正在完善。';

  @override
  Widget build(BuildContext context) {
    return ListPageScaffold(
      spacing: _spacing,
      header: WorkbenchHeaderBar(
        breadcrumb: null,
        title: title,
        subtitle: _summaryHintText,
        titleMaxWidth: 420,
        stats: const [
          WorkbenchStatItem(label: '状态', value: '建设中'),
        ],
        hideBreadcrumbOnMobile: true,
        actions: PageActionButton.outlined(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, size: 16),
          label: '返回',
        ),
      ),
      body: ListView(
        children: [
          _SectionCard(title: title, subtitle: description),
          const SizedBox(height: _sectionSpacing),
          const _SectionCard(
            title: '说明',
            subtitle: '入口已接入统一布局，业务能力会继续补齐。',
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.sidebarText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.subtleText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
