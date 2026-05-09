import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';

class CrudDrawerEditPanel<T, VM extends ChangeNotifier> extends StatefulWidget {
  const CrudDrawerEditPanel({
    super.key,
    required this.config,
    this.item,
    this.onSaved,
  });

  final CrudEditConfig<T, VM> config;
  final T? item;
  final VoidCallback? onSaved;

  @override
  State<CrudDrawerEditPanel<T, VM>> createState() =>
      _CrudDrawerEditPanelState<T, VM>();
}

class _CrudDrawerEditPanelState<T, VM extends ChangeNotifier>
    extends State<CrudDrawerEditPanel<T, VM>> {
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;

  CrudEditConfig<T, VM> get _config => widget.config;

  Future<void> _handleSubmit(VM viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate() || _submitting) {
      return;
    }

    setState(() => _submitting = true);
    try {
      await _config.onSave(context, viewModel, widget.item);
      if (!mounted) return;
      widget.onSaved?.call();
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
    final isMobile = ResponsiveLayout.isMobile(context);

    return Consumer<VM>(
      builder: (context, viewModel, _) {
        final canSubmit = !_submitting &&
            (_config.canSave?.call(context, viewModel, widget.item) ?? true);
        return AdaptiveFormPanel(
          formKey: _formKey,
          submitText: _config.submitText,
          cancelText: _config.cancelText,
          submitting: _submitting,
          submitEnabled: canSubmit,
          onSubmit: () => _handleSubmit(viewModel),
          child: _CrudDrawerSectionList(
            sections: _config
                .sectionsBuilder(context, isMobile)
                .where((section) => section.visible)
                .toList(),
          ),
        );
      },
    );
  }
}

class _CrudDrawerSectionList extends StatelessWidget {
  const _CrudDrawerSectionList({required this.sections});

  final List<CrudFormSection> sections;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < sections.length; index++) ...[
          if (index > 0) const SizedBox(height: LayoutTokens.gapLg),
          _CrudDrawerSection(section: sections[index]),
        ],
      ],
    );
  }
}

class _CrudDrawerSection extends StatelessWidget {
  const _CrudDrawerSection({required this.section});

  final CrudFormSection section;

  @override
  Widget build(BuildContext context) {
    final spacing = LayoutTokens.gapMd;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (section.title.isNotEmpty) ...[
            Text(section.title, style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: spacing),
          ],
          for (var index = 0; index < section.fields.length; index++) ...[
            if (index > 0) SizedBox(height: spacing),
            section.fields[index].build(context),
          ],
        ],
      ),
    );
  }
}
