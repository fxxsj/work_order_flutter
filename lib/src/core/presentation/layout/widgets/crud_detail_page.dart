import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/edit_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';

class CrudDetailAction {
  const CrudDetailAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = PageActionVariant.outlined,
    this.visible = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final PageActionVariant variant;
  final bool visible;
}

enum CrudDetailItemLayout {
  vertical,
  horizontal,
}

class CrudDetailItem {
  const CrudDetailItem({
    required this.label,
    this.value,
    this.child,
    this.emptyText = '-',
    this.visible = true,
    this.layout = CrudDetailItemLayout.vertical,
  });

  final String label;
  final String? value;
  final Widget? child;
  final String emptyText;
  final bool visible;
  final CrudDetailItemLayout layout;
}

class CrudDetailSection {
  const CrudDetailSection({
    required this.title,
    required this.items,
    this.column = 0,
    this.visible = true,
    this.trailing,
  });

  final String title;
  final List<CrudDetailItem> items;
  final int column;
  final bool visible;
  final Widget? trailing;
}

class CrudDetailConfig<T> {
  const CrudDetailConfig({
    required this.title,
    required this.item,
    required this.sectionsBuilder,
    this.subtitle,
    this.backText = '返回',
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final T item;
  final List<CrudDetailSection> Function(
    BuildContext context,
    bool isMobile,
    T item,
  ) sectionsBuilder;
  final String backText;
  final List<CrudDetailAction> actions;
}

class CrudDetailPage<T> extends StatelessWidget {
  const CrudDetailPage({
    super.key,
    required this.config,
  });

  final CrudDetailConfig<T> config;

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final contentPadding = LayoutTokens.pagePadding(context);
    final pageSpacing = LayoutTokens.formPageSpacing(context);

    return SafeArea(
      child: EditPageScaffold(
        spacing: pageSpacing,
        contentPadding: contentPadding,
        header: PageHeaderBar(
          breadcrumb: config.subtitle == null
              ? config.title
              : '${config.title} / ${config.subtitle}',
          useSurface: false,
          showDivider: false,
          padding: EdgeInsets.zero,
          actions: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PageActionButton.outlined(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: config.backText,
              ),
              ...config.actions
                  .where((action) => action.visible)
                  .map((action) => _buildActionButton(action)),
            ],
          ),
        ),
        body: _buildBody(context, isMobile),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isMobile) {
    final sections = config
        .sectionsBuilder(context, isMobile, config.item)
        .where((section) => section.visible)
        .toList();
    final columnSpacing = LayoutTokens.formColumnSpacing(context);

    if (isMobile || sections.every((section) => section.column == 0)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildSectionGroup(context, sections),
      );
    }

    final columns = sections.map((section) => section.column).toSet().toList()
      ..sort();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < columns.length; index++) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildSectionGroup(
                context,
                sections
                    .where((section) => section.column == columns[index])
                    .toList(),
              ),
            ),
          ),
          if (index < columns.length - 1) SizedBox(width: columnSpacing),
        ],
      ],
    );
  }

  List<Widget> _buildSectionGroup(
    BuildContext context,
    List<CrudDetailSection> sections,
  ) {
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final widgets = <Widget>[];

    for (var index = 0; index < sections.length; index++) {
      final section = sections[index];
      if (index > 0) {
        widgets.add(SizedBox(height: sectionSpacing));
      }
      widgets.add(
        DetailSectionCard(
          title: section.title,
          trailing: section.trailing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildItems(context, section.items),
          ),
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildItems(BuildContext context, List<CrudDetailItem> items) {
    final visibleItems = items.where((item) => item.visible).toList();
    final itemSpacing = LayoutTokens.sectionSpacing(context);
    final widgets = <Widget>[];

    for (var index = 0; index < visibleItems.length; index++) {
      if (index > 0) {
        widgets.add(SizedBox(height: itemSpacing));
      }
      widgets.add(_CrudDetailItemView(item: visibleItems[index]));
    }

    return widgets;
  }

  Widget _buildActionButton(CrudDetailAction action) {
    switch (action.variant) {
      case PageActionVariant.filled:
        return PageActionButton.filled(
          onPressed: action.onPressed,
          icon: action.icon,
          label: action.label,
        );
      case PageActionVariant.outlined:
        return PageActionButton.outlined(
          onPressed: action.onPressed,
          icon: action.icon,
          label: action.label,
        );
    }
  }
}

class _CrudDetailItemView extends StatelessWidget {
  const _CrudDetailItemView({required this.item});

  final CrudDetailItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: colors?.subtleText ?? theme.hintColor,
    );
    final valueWidget = item.child ??
        Text(
          (item.value == null || item.value!.trim().isEmpty)
              ? item.emptyText
              : item.value!,
          style: theme.textTheme.bodyMedium,
        );

    if (item.layout == CrudDetailItemLayout.horizontal) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final stack = constraints.maxWidth < 420;
          if (stack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label, style: labelStyle),
                const SizedBox(height: LayoutTokens.gapSm),
                valueWidget,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 128,
                child: Text(item.label, style: labelStyle),
              ),
              const SizedBox(width: LayoutTokens.gapLg),
              Expanded(child: valueWidget),
            ],
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.label, style: labelStyle),
        const SizedBox(height: LayoutTokens.gapSm),
        valueWidget,
      ],
    );
  }
}
