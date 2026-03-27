import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/edit_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';

typedef CrudSaveHandler<T, VM extends ChangeNotifier> = Future<void> Function(
    BuildContext context, VM viewModel, T? item);

class CrudFormSection {
  const CrudFormSection({
    required this.title,
    required this.fields,
    this.column = 0,
    this.visible = true,
  });

  final String title;
  final List<CrudFormField> fields;
  final int column;
  final bool visible;
}

class CrudEditConfig<T, VM extends ChangeNotifier> {
  const CrudEditConfig({
    required this.sectionsBuilder,
    required this.onSave,
    this.submitText = '保存',
    this.cancelText = '返回',
    this.submittingText = '保存中',
    this.errorMessagePrefix = '操作失败: ',
    this.canSave,
  });

  final List<CrudFormSection> Function(BuildContext context, bool isMobile)
      sectionsBuilder;
  final CrudSaveHandler<T, VM> onSave;
  final String submitText;
  final String cancelText;
  final String submittingText;
  final String errorMessagePrefix;
  final bool Function(BuildContext context, VM viewModel, T? item)? canSave;
}

class CrudEditPage<T, VM extends ChangeNotifier> extends StatefulWidget {
  const CrudEditPage({
    super.key,
    required this.config,
    this.item,
  });

  final CrudEditConfig<T, VM> config;
  final T? item;

  @override
  State<CrudEditPage<T, VM>> createState() => _CrudEditPageState<T, VM>();
}

class _CrudEditPageState<T, VM extends ChangeNotifier>
    extends State<CrudEditPage<T, VM>> {
  static const double _inlineSpacing = 8;

  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;

  CrudEditConfig<T, VM> get _config => widget.config;

  Future<void> _handleSubmit(VM viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);
    try {
      await _config.onSave(context, viewModel, widget.item);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('${_config.errorMessagePrefix}$err');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final contentPadding = LayoutTokens.pagePadding(context);
    final pageSpacing = LayoutTokens.formPageSpacing(context);

    return Consumer<VM>(
      builder: (context, viewModel, _) {
        final canSubmit = !_submitting &&
            (_config.canSave?.call(context, viewModel, widget.item) ?? true);

        return SafeArea(
          child: Form(
            key: _formKey,
            child: EditPageScaffold(
              spacing: pageSpacing,
              contentPadding: contentPadding,
              header: PageHeaderBar(
                breadcrumb: null,
                useSurface: false,
                showDivider: false,
                padding: EdgeInsets.zero,
                actions: Wrap(
                  spacing: _inlineSpacing,
                  runSpacing: 8,
                  children: [
                    PageActionButton.outlined(
                      onPressed: _submitting
                          ? null
                          : () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: _config.cancelText,
                    ),
                    PageActionButton.filled(
                      onPressed:
                          canSubmit ? () => _handleSubmit(viewModel) : null,
                      icon: const Icon(Icons.save, size: 16),
                      label: _submitting
                          ? _config.submittingText
                          : _config.submitText,
                    ),
                  ],
                ),
              ),
              body: _buildBody(context, isMobile),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, bool isMobile) {
    final sections = _config
        .sectionsBuilder(context, isMobile)
        .where((section) => section.visible)
        .toList();
    final columnSpacing = LayoutTokens.formColumnSpacing(context);
    final actionSpacing = LayoutTokens.formActionSpacing(context);

    if (isMobile || sections.every((section) => section.column == 0)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._buildSectionGroup(context, sections),
          SizedBox(height: actionSpacing),
        ],
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
    List<CrudFormSection> sections,
  ) {
    final theme = Theme.of(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final widgets = <Widget>[];

    for (var index = 0; index < sections.length; index++) {
      final section = sections[index];
      if (index > 0) {
        widgets.add(SizedBox(height: sectionSpacing));
      }
      if (section.title.isNotEmpty) {
        widgets.add(
          Text(
            section.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        );
        widgets.add(SizedBox(height: sectionSpacing));
      }
      for (var fieldIndex = 0;
          fieldIndex < section.fields.length;
          fieldIndex++) {
        if (fieldIndex > 0) {
          widgets.add(SizedBox(height: sectionSpacing));
        }
        widgets.add(section.fields[fieldIndex].build(context));
      }
    }

    return widgets;
  }
}
