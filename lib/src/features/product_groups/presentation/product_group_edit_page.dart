import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/edit_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/product_groups/application/product_group_view_model.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';

class ProductGroupEditPage extends StatefulWidget {
  const ProductGroupEditPage({super.key, this.group});

  final ProductGroup? group;

  @override
  State<ProductGroupEditPage> createState() => _ProductGroupEditPageState();
}

class _ProductGroupEditPageState extends State<ProductGroupEditPage> {
  final _formKey = GlobalKey<FormState>();

  static const double _inlineSpacing = 8;

  static const String _codeLabel = '产品组编码';
  static const String _nameLabel = '产品组名称';
  static const String _descLabel = '描述';
  static const String _statusLabel = '启用状态';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _codeRequiredText = '请输入产品组编码';
  static const String _codeLengthText = '编码长度在2-50个字符之间';
  static const String _codeInvalidText = '编码只能包含字母、数字和连字符';
  static const String _nameRequiredText = '请输入产品组名称';
  static const String _cancelText = '返回';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  bool _isActive = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final group = widget.group;
    _codeController = TextEditingController(text: group?.code ?? '');
    _nameController = TextEditingController(text: group?.name ?? '');
    _descController = TextEditingController(text: group?.description ?? '');
    _isActive = group?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(ProductGroupViewModel viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

    final payload = ProductGroup(
      id: widget.group?.id ?? 0,
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      isActive: _isActive,
      itemsCount: widget.group?.itemsCount,
    );

    try {
      if (widget.group == null) {
        await viewModel.createProductGroup(payload);
      } else {
        await viewModel.updateProductGroup(payload);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_submitErrorText$err');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _sectionTitle(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductGroupViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final contentPadding = LayoutTokens.pagePadding(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final actionSpacing = LayoutTokens.formActionSpacing(context);
    final pageSpacing = LayoutTokens.formPageSpacing(context);
    final columnSpacing = LayoutTokens.formColumnSpacing(context);

    final basicFields = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, _basicSectionTitle),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _codeController,
          decoration: const InputDecoration(labelText: _codeLabel),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return _codeRequiredText;
            if (text.length < 2 || text.length > 50) return _codeLengthText;
            final regex = RegExp(r'^[A-Za-z0-9-]+$');
            if (!regex.hasMatch(text)) return _codeInvalidText;
            return null;
          },
        ),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: _nameLabel),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return _nameRequiredText;
            return null;
          },
        ),
      ],
    );

    final extraFields = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, _extraSectionTitle),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _descController,
          decoration: const InputDecoration(labelText: _descLabel),
          maxLines: 3,
        ),
        SizedBox(height: sectionSpacing),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text(_statusLabel),
          value: _isActive,
          onChanged: (value) => setState(() => _isActive = value),
        ),
      ],
    );

    final body = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              basicFields,
              SizedBox(height: sectionSpacing),
              extraFields,
              SizedBox(height: actionSpacing),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: basicFields),
              SizedBox(width: columnSpacing),
              Expanded(child: extraFields),
            ],
          );

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
                  onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: _cancelText,
                ),
                PageActionButton.filled(
                  onPressed: _submitting ? null : () => _handleSubmit(viewModel),
                  icon: const Icon(Icons.save, size: 16),
                  label: _submitting ? '保存中' : _submitText,
                ),
              ],
            ),
          ),
          body: body,
        ),
      ),
    );
  }
}
