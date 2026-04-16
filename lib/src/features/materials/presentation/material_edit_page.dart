import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_drawer_edit_panel.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/materials/application/material_view_model.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';

Future<bool> showMaterialEditDrawer(
  BuildContext context, {
  required MaterialViewModel viewModel,
  MaterialItem? material,
}) async {
  var saved = false;
  await showAdaptiveFilterDrawer(
    context,
    isMobile: BreakpointsUtil.isMobile(context),
    title: material == null ? '新建物料' : '编辑物料',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: ChangeNotifierProvider<MaterialViewModel>.value(
      value: viewModel,
      child: MaterialEditPage(
        material: material,
        onSaved: () => saved = true,
      ),
    ),
  );
  return saved;
}

class MaterialEditPage extends StatefulWidget {
  const MaterialEditPage({super.key, this.material, this.onSaved});

  final MaterialItem? material;
  final VoidCallback? onSaved;

  @override
  State<MaterialEditPage> createState() => _MaterialEditPageState();
}

class _MaterialEditPageState extends State<MaterialEditPage> {
  static const String _codeLabel = '物料编码';
  static const String _nameLabel = '物料名称';
  static const String _unitLabel = '单位';
  static const String _unitPriceLabel = '单价';
  static const String _stockLabel = '库存数量';
  static const String _minStockLabel = '最小库存';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _codeRequiredText = '请输入物料编码';
  static const String _codeLengthText = '编码长度在2-50个字符之间';
  static const String _codeInvalidText = '编码只能包含字母、数字和连字符';
  static const String _nameRequiredText = '请输入物料名称';
  static const String _unitRequiredText = '请输入单位';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '库存信息';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _unitController;
  late final TextEditingController _unitPriceController;
  late final TextEditingController _stockController;
  late final TextEditingController _minStockController;

  @override
  void initState() {
    super.initState();
    final material = widget.material;
    _codeController = TextEditingController(text: material?.code ?? '');
    _nameController = TextEditingController(text: material?.name ?? '');
    _unitController = TextEditingController(text: material?.unit ?? '个');
    _unitPriceController = TextEditingController(
      text: material?.unitPrice?.toStringAsFixed(2) ?? '',
    );
    _stockController = TextEditingController(
      text: material?.stockQuantity?.toStringAsFixed(3) ?? '',
    );
    _minStockController = TextEditingController(
      text: material?.minStockQuantity?.toStringAsFixed(3) ?? '',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _unitController.dispose();
    _unitPriceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(MaterialViewModel viewModel) async {
    final payload = MaterialItem(
      id: widget.material?.id ?? 0,
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      unit: _unitController.text.trim().isEmpty
          ? null
          : _unitController.text.trim(),
      unitPrice: _parseDouble(_unitPriceController.text),
      stockQuantity: _parseDouble(_stockController.text),
      minStockQuantity: _parseDouble(_minStockController.text),
      isActive: widget.material?.isActive,
    );

    if (widget.material == null) {
      await viewModel.createMaterial(payload);
    } else {
      await viewModel.updateMaterial(payload);
    }
  }

  double? _parseDouble(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  @override
  Widget build(BuildContext context) {
    return CrudDrawerEditPanel<MaterialItem, MaterialViewModel>(
      item: widget.material,
      onSaved: widget.onSaved,
      config: CrudEditConfig<MaterialItem, MaterialViewModel>(
        submitText: _submitText,
        submittingText: '保存中',
        errorMessagePrefix: _submitErrorText,
        sectionsBuilder: (context, isMobile) => [
          CrudFormSection(
            title: _basicSectionTitle,
            column: 0,
            fields: [
              CrudFormField.text(
                label: _codeLabel,
                controller: _codeController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _codeRequiredText;
                  if (text.length < 2 || text.length > 50) {
                    return _codeLengthText;
                  }
                  final regex = RegExp(r'^[A-Za-z0-9-]+$');
                  if (!regex.hasMatch(text)) return _codeInvalidText;
                  return null;
                },
              ),
              CrudFormField.text(
                label: _nameLabel,
                controller: _nameController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _nameRequiredText;
                  return null;
                },
              ),
              CrudFormField.text(
                label: _unitLabel,
                controller: _unitController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _unitRequiredText;
                  return null;
                },
              ),
            ],
          ),
          CrudFormSection(
            title: _extraSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFormField.number(
                label: _unitPriceLabel,
                controller: _unitPriceController,
                decimal: true,
              ),
              CrudFormField.number(
                label: _stockLabel,
                controller: _stockController,
                decimal: true,
              ),
              CrudFormField.number(
                label: _minStockLabel,
                controller: _minStockController,
                decimal: true,
              ),
            ],
          ),
        ],
        onSave: (context, viewModel, item) => _handleSubmit(viewModel),
      ),
    );
  }
}
