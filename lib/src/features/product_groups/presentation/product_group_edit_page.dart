import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_drawer_edit_panel.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/features/product_groups/application/product_group_view_model.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';

Future<bool> showProductGroupEditDrawer(
  BuildContext context, {
  required ProductGroupViewModel viewModel,
  ProductGroup? group,
}) async {
  var saved = false;
  await showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: group == null ? '新建产品组' : '编辑产品组',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: ChangeNotifierProvider<ProductGroupViewModel>.value(
      value: viewModel,
      child: ProductGroupEditPage(group: group, onSaved: () => saved = true),
    ),
  );
  return saved;
}

class ProductGroupEditPage extends StatefulWidget {
  const ProductGroupEditPage({super.key, this.group, this.onSaved});

  final ProductGroup? group;
  final VoidCallback? onSaved;

  @override
  State<ProductGroupEditPage> createState() => _ProductGroupEditPageState();
}

class _ProductGroupEditPageState extends State<ProductGroupEditPage> {
  static const String _codeLabel = '产品组编码';
  static const String _nameLabel = '产品组名称';
  static const String _descLabel = '描述';
  static const String _statusLabel = '启用状态';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _codeRequiredText = '请输入产品组编码';
  static const String _codeLengthText = '产品组编码不能超过50个字符';
  static const String _codeInvalidText = '编码只能包含字母、数字和连字符';
  static const String _nameRequiredText = '请输入产品组名称';
  static const String _nameLengthText = '产品组名称不能超过200个字符';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  bool _isActive = true;

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
    final description = _descController.text.trim();
    final payload = ProductGroup(
      id: widget.group?.id ?? 0,
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      description: description.isEmpty ? null : description,
      isActive: _isActive,
      itemsCount: widget.group?.itemsCount,
      createdAt: widget.group?.createdAt,
      updatedAt: widget.group?.updatedAt,
    );

    if (widget.group == null) {
      await viewModel.createProductGroup(payload);
    } else {
      await viewModel.updateProductGroup(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CrudDrawerEditPanel<ProductGroup, ProductGroupViewModel>(
      item: widget.group,
      onSaved: widget.onSaved,
      config: CrudEditConfig<ProductGroup, ProductGroupViewModel>(
        submitText: _submitText,
        submittingText: '保存中',
        errorMessagePrefix: _submitErrorText,
        sectionsBuilder: (context, isMobile) => [
          CrudFormSection(
            title: _basicSectionTitle,
            column: 0,
            fields: [
              CrudFieldConfig.text(
                label: _codeLabel,
                controller: _codeController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _codeRequiredText;
                  if (text.length > 50) {
                    return _codeLengthText;
                  }
                  if (!RegExp(r'^[A-Za-z0-9-]+$').hasMatch(text)) {
                    return _codeInvalidText;
                  }
                  return null;
                },
              ),
              CrudFieldConfig.text(
                label: _nameLabel,
                controller: _nameController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _nameRequiredText;
                  if (text.length > 200) return _nameLengthText;
                  return null;
                },
              ),
            ],
          ),
          CrudFormSection(
            title: _extraSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFieldConfig.textarea(
                label: _descLabel,
                controller: _descController,
                maxLines: 3,
              ),
              CrudFieldConfig.toggle(
                label: _statusLabel,
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
          ),
        ],
        onSave: (context, viewModel, item) => _handleSubmit(viewModel),
      ),
    );
  }
}
