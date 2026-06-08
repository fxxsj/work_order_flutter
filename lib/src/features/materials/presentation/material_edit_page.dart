import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_drawer_edit_panel.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
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
    isMobile: ResponsiveLayout.isMobile(context),
    title: material == null ? '新建物料' : '编辑物料',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: ChangeNotifierProvider<MaterialViewModel>.value(
      value: viewModel,
      child: MaterialEditPage(material: material, onSaved: () => saved = true),
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
  static const String _specificationLabel = '规格';
  static const String _unitLabel = '单位';
  static const String _unitPriceLabel = '单价';
  static const String _stockLabel = '库存数量';
  static const String _minStockLabel = '最小库存';
  static const String _supplierLabel = '默认供应商';
  static const String _leadTimeLabel = '采购周期（天）';
  static const String _needCuttingLabel = '需要开料';
  static const String _isActiveLabel = '启用';
  static const String _notesLabel = '备注';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _codeLengthText = '编码长度在2-50个字符之间';
  static const String _codeInvalidText = '编码只能包含字母、数字和连字符';
  static const String _nameRequiredText = '请输入物料名称';
  static const String _unitRequiredText = '请输入单位';
  static const String _stockInvalidText = '库存数量不能为负数';
  static const String _minStockInvalidText = '最小库存不能为负数';
  static const String _minStockTooLargeText = '最小库存不能大于当前库存';
  static const String _leadTimeInvalidText = '采购周期需在0-365天之间';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '库存信息';
  static const String _purchaseSectionTitle = '采购信息';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _specificationController;
  late final TextEditingController _unitController;
  late final TextEditingController _unitPriceController;
  late final TextEditingController _stockController;
  late final TextEditingController _minStockController;
  late final TextEditingController _leadTimeController;
  late final TextEditingController _notesController;

  int? _defaultSupplier;
  bool _needCutting = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final material = widget.material;
    _codeController = TextEditingController(text: material?.code ?? '');
    _nameController = TextEditingController(text: material?.name ?? '');
    _specificationController = TextEditingController(
      text: material?.specification ?? '',
    );
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
    _leadTimeController = TextEditingController(
      text: (material?.leadTimeDays ?? 7).toString(),
    );
    _notesController = TextEditingController(text: material?.notes ?? '');
    _defaultSupplier = material?.defaultSupplier;
    _needCutting = material?.needCutting ?? false;
    _isActive = material?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _specificationController.dispose();
    _unitController.dispose();
    _unitPriceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _leadTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(MaterialViewModel viewModel) async {
    if (!_validateStockRelationship()) {
      throw Exception(_minStockTooLargeText);
    }
    final payload = MaterialItem(
      id: widget.material?.id ?? 0,
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      specification: _emptyToNull(_specificationController.text),
      unit: _unitController.text.trim().isEmpty
          ? null
          : _unitController.text.trim(),
      unitPrice: _parseDouble(_unitPriceController.text),
      stockQuantity: _parseDouble(_stockController.text),
      minStockQuantity: _parseDouble(_minStockController.text),
      defaultSupplier: _defaultSupplier,
      leadTimeDays: _parseInt(_leadTimeController.text) ?? 7,
      needCutting: _needCutting,
      isActive: _isActive,
      notes: _emptyToNull(_notesController.text),
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

  int? _parseInt(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  String? _emptyToNull(String raw) {
    final text = raw.trim();
    return text.isEmpty ? null : text;
  }

  bool _validateStockRelationship() {
    final stock = _parseDouble(_stockController.text);
    final minStock = _parseDouble(_minStockController.text);
    if (stock != null && minStock != null && minStock > stock) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(_minStockTooLargeText)));
      return false;
    }
    return true;
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
              CrudFieldConfig.text(
                label: _codeLabel,
                controller: _codeController,
                enabled: widget.material == null,
                hintText: '请输入编码（留空自动生成）',
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return null;
                  if (text.length < 2 || text.length > 50) {
                    return _codeLengthText;
                  }
                  final regex = RegExp(r'^[A-Za-z0-9-]+$');
                  if (!regex.hasMatch(text)) return _codeInvalidText;
                  return null;
                },
              ),
              CrudFieldConfig.text(
                label: _nameLabel,
                controller: _nameController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _nameRequiredText;
                  return null;
                },
              ),
              CrudFieldConfig.text(
                label: _specificationLabel,
                controller: _specificationController,
              ),
              CrudFieldConfig.text(
                label: _unitLabel,
                controller: _unitController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _unitRequiredText;
                  return null;
                },
              ),
              CrudFieldConfig.toggle(
                label: _isActiveLabel,
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
          ),
          CrudFormSection(
            title: _extraSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFieldConfig.number(
                label: _unitPriceLabel,
                controller: _unitPriceController,
                decimal: true,
              ),
              CrudFieldConfig.number(
                label: _stockLabel,
                controller: _stockController,
                decimal: true,
                validator: (value) {
                  final stock = _parseDouble(value ?? '');
                  if (stock != null && stock < 0) return _stockInvalidText;
                  return null;
                },
              ),
              CrudFieldConfig.number(
                label: _minStockLabel,
                controller: _minStockController,
                decimal: true,
                validator: (value) {
                  final minStock = _parseDouble(value ?? '');
                  if (minStock != null && minStock < 0) {
                    return _minStockInvalidText;
                  }
                  final stock = _parseDouble(_stockController.text);
                  if (widget.material != null &&
                      stock != null &&
                      minStock != null &&
                      minStock > stock) {
                    return _minStockTooLargeText;
                  }
                  return null;
                },
              ),
            ],
          ),
          CrudFormSection(
            title: _purchaseSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFieldConfig.dropdown(
                label: _supplierLabel,
                value: _defaultSupplier,
                options: [
                  const AppDropdownOption<dynamic>(value: null, label: '无'),
                  ...context.read<MaterialViewModel>().supplierOptions.map(
                    (supplier) => AppDropdownOption<dynamic>(
                      value: supplier.id,
                      label: supplier.label,
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _defaultSupplier = value as int?);
                },
              ),
              CrudFieldConfig.number(
                label: _leadTimeLabel,
                controller: _leadTimeController,
                validator: (value) {
                  final days = _parseInt(value ?? '');
                  if (days == null || days < 0 || days > 365) {
                    return _leadTimeInvalidText;
                  }
                  return null;
                },
              ),
              CrudFieldConfig.toggle(
                label: _needCuttingLabel,
                value: _needCutting,
                onChanged: (value) => setState(() => _needCutting = value),
              ),
              CrudFieldConfig.textarea(
                label: _notesLabel,
                controller: _notesController,
                maxLines: 3,
              ),
            ],
          ),
        ],
        onSave: (context, viewModel, item) => _handleSubmit(viewModel),
      ),
    );
  }
}
