import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';

class MaterialPlanDialog extends StatefulWidget {
  const MaterialPlanDialog({
    super.key,
    required this.material,
    required this.stockMaterials,
    required this.suppliers,
    required this.onCalculate,
    required this.onConfirm,
    required this.onInvalidate,
  });

  final WorkOrderMaterialItem material;
  final List<Map<String, dynamic>> stockMaterials;
  final List<Map<String, dynamic>> suppliers;
  final Future<Map<String, dynamic>> Function(Map<String, dynamic> payload)
  onCalculate;
  final Future<Map<String, dynamic>> Function() onConfirm;
  final Future<bool> Function() onInvalidate;

  @override
  State<MaterialPlanDialog> createState() => _MaterialPlanDialogState();
}

class _MaterialPlanDialogState extends State<MaterialPlanDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _widthController;
  late final TextEditingController _heightController;
  late final TextEditingController _quantityController;
  late final TextEditingController _wastageController;
  late final TextEditingController _customWidthController;
  late final TextEditingController _customHeightController;
  late final TextEditingController _customUnitPriceController;
  int? _purchaseMaterialId;
  int? _customSupplierId;
  late bool _useCustomSpecification;
  late String _preparationMode;
  Map<String, dynamic>? _plan;
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final item = widget.material;
    _preparationMode = item.preparationMode == 'internal_cutting'
        ? 'internal_cutting'
        : 'supplier_cutting';
    _useCustomSpecification = item.purchaseMaterialIsTemporary;
    _purchaseMaterialId = item.purchaseMaterialId;
    _customSupplierId = item.purchaseMaterialSupplier;
    _customWidthController = TextEditingController(
      text: _number(item.parentSheetWidthMm),
    );
    _customHeightController = TextEditingController(
      text: _number(item.parentSheetHeightMm),
    );
    _customUnitPriceController = TextEditingController(
      text: _number(item.purchaseMaterialUnitPrice),
    );
    _widthController = TextEditingController(text: _number(item.cutWidthMm));
    _heightController = TextEditingController(text: _number(item.cutHeightMm));
    _quantityController = TextEditingController(
      text: _number(
        item.calculationMode == 'specification_selection'
            ? item.plannedMaterialQuantity
            : item.requiredCutQuantity,
      ),
    );
    _wastageController = TextEditingController(
      text: _number(item.wastageRate ?? 5),
    );
    if (item.planningStatus == 'calculated' ||
        item.planningStatus == 'confirmed') {
      _plan = {
        'planning_status': item.planningStatus,
        'pieces_per_parent_sheet': item.piecesPerParentSheet,
        'planned_parent_quantity': item.plannedParentQuantity,
        'planned_material_quantity': item.plannedMaterialQuantity,
        'reserved_quantity': item.reservedQuantity,
        'purchase_quantity': item.purchaseQuantity,
      };
    }
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    _quantityController.dispose();
    _wastageController.dispose();
    _customWidthController.dispose();
    _customHeightController.dispose();
    _customUnitPriceController.dispose();
    super.dispose();
  }

  String _number(double? value) {
    if (value == null) return '';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  String _stockLabel(Map<String, dynamic> item) {
    final name = item['name']?.toString() ?? '物料';
    final code = item['code']?.toString() ?? '';
    final width = item['sheet_width_mm'];
    final height = item['sheet_height_mm'];
    final size = width != null && height != null
        ? ' · ${width}×$height mm'
        : '';
    return '$name ($code)$size';
  }

  String? _positiveNumber(String? value) {
    final parsed = double.tryParse(value?.trim() ?? '');
    return parsed == null || parsed <= 0 ? '请输入大于 0 的数值' : null;
  }

  String? _wastageNumber(String? value) {
    final parsed = double.tryParse(value?.trim() ?? '');
    return parsed == null || parsed < 0 || parsed > 100 ? '请输入 0 到 100' : null;
  }

  Future<void> _calculate() async {
    final isSpecificationSelection =
        widget.material.calculationMode == 'specification_selection';
    final sourceValid = !isSpecificationSelection && _useCustomSpecification
        ? _customSupplierId != null &&
              _positiveNumber(_customWidthController.text) == null &&
              _positiveNumber(_customHeightController.text) == null
        : _purchaseMaterialId != null;
    if (!_formKey.currentState!.validate() || !sourceValid) {
      if (!sourceValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSpecificationSelection ? '请选择实际使用的物料规格' : '请完整填写本次原纸规格和供应商',
            ),
          ),
        );
      }
      return;
    }
    setState(() => _loading = true);
    try {
      final result = await widget.onCalculate({
        if (isSpecificationSelection) ...{
          'purchase_material': _purchaseMaterialId,
          'required_quantity': double.parse(_quantityController.text.trim()),
        } else if (_useCustomSpecification) ...{
          'custom_parent_width_mm': double.parse(
            _customWidthController.text.trim(),
          ),
          'custom_parent_height_mm': double.parse(
            _customHeightController.text.trim(),
          ),
          'custom_supplier': _customSupplierId,
          'custom_unit_price':
              double.tryParse(_customUnitPriceController.text.trim()) ?? 0,
        } else
          'purchase_material': _purchaseMaterialId,
        if (!isSpecificationSelection) ...{
          'preparation_mode': _preparationMode,
          'cut_width_mm': double.parse(_widthController.text.trim()),
          'cut_height_mm': double.parse(_heightController.text.trim()),
          'required_cut_quantity': double.parse(
            _quantityController.text.trim(),
          ),
          'wastage_rate': double.parse(_wastageController.text.trim()),
        },
      });
      if (mounted) setState(() => _plan = result);
    } catch (error) {
      if (mounted) setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirm() async {
    setState(() => _loading = true);
    try {
      final result = await widget.onConfirm();
      if (!mounted) return;
      setState(() => _plan = result);
      Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status =
        _plan?['planning_status']?.toString() ?? widget.material.planningStatus;
    final confirmed = status == 'confirmed';
    final isSpecificationSelection =
        widget.material.calculationMode == 'specification_selection';
    return AlertDialog(
      title: Text('物料规格规划 · ${widget.material.materialName ?? ''}'),
      content: SizedBox(
        width: 620,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isSpecificationSelection)
                  DropdownButtonFormField<String>(
                    initialValue: _useCustomSpecification ? 'custom' : 'stock',
                    decoration: const InputDecoration(labelText: '本次原纸来源'),
                    items: const [
                      DropdownMenuItem(value: 'stock', child: Text('选择已有常用规格')),
                      DropdownMenuItem(value: 'custom', child: Text('本单一次性特规')),
                    ],
                    onChanged: confirmed
                        ? null
                        : (value) => setState(
                            () => _useCustomSpecification = value == 'custom',
                          ),
                  ),
                const SizedBox(height: SpacingTokens.md),
                if (!isSpecificationSelection && _useCustomSpecification) ...[
                  Wrap(
                    spacing: SpacingTokens.md,
                    runSpacing: SpacingTokens.md,
                    children: [
                      _numberField(
                        '特规原纸宽度(mm)',
                        _customWidthController,
                        confirmed,
                      ),
                      _numberField(
                        '特规原纸高度(mm)',
                        _customHeightController,
                        confirmed,
                      ),
                      _numberField(
                        '预计单价（可选）',
                        _customUnitPriceController,
                        confirmed,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return null;
                          final parsed = double.tryParse(value.trim());
                          return parsed == null || parsed < 0
                              ? '请输入不小于0的数值'
                              : null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: SpacingTokens.md),
                  DropdownButtonFormField<int>(
                    initialValue: _customSupplierId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: '特规供应商'),
                    items: widget.suppliers
                        .map(
                          (item) => DropdownMenuItem<int>(
                            value: toInt(item['id']),
                            child: Text(
                              '${item['code'] ?? ''} ${item['name'] ?? ''}'
                                  .trim(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: confirmed
                        ? null
                        : (value) => setState(() => _customSupplierId = value),
                  ),
                ] else
                  DropdownButtonFormField<int>(
                    initialValue: _purchaseMaterialId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: isSpecificationSelection ? '实际物料规格' : '采购原纸规格',
                    ),
                    items: widget.stockMaterials
                        .where(
                          (item) =>
                              toInt(item['base_material']) ==
                              widget.material.materialId,
                        )
                        .map(
                          (item) => DropdownMenuItem<int>(
                            value: toInt(item['id']),
                            child: Text(
                              _stockLabel(item),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: confirmed
                        ? null
                        : (value) =>
                              setState(() => _purchaseMaterialId = value),
                  ),
                const SizedBox(height: SpacingTokens.md),
                if (!isSpecificationSelection)
                  DropdownButtonFormField<String>(
                    initialValue: _preparationMode,
                    decoration: const InputDecoration(labelText: '备料方式'),
                    items: const [
                      DropdownMenuItem(
                        value: 'internal_cutting',
                        child: Text('厂内开料'),
                      ),
                      DropdownMenuItem(
                        value: 'supplier_cutting',
                        child: Text('供应商按尺寸供货'),
                      ),
                    ],
                    onChanged: confirmed
                        ? null
                        : (value) => setState(
                            () =>
                                _preparationMode = value ?? 'supplier_cutting',
                          ),
                  ),
                if (!isSpecificationSelection)
                  const SizedBox(height: SpacingTokens.md),
                Wrap(
                  spacing: SpacingTokens.md,
                  runSpacing: SpacingTokens.md,
                  children: [
                    if (!isSpecificationSelection) ...[
                      _numberField('开料宽度(mm)', _widthController, confirmed),
                      _numberField('开料高度(mm)', _heightController, confirmed),
                    ],
                    _numberField(
                      isSpecificationSelection ? '计划需求数量' : '成品张数',
                      _quantityController,
                      confirmed,
                    ),
                    if (!isSpecificationSelection)
                      _numberField(
                        '损耗率(%)',
                        _wastageController,
                        confirmed,
                        validator: _wastageNumber,
                      ),
                  ],
                ),
                if (_plan != null) ...[
                  const SizedBox(height: SpacingTokens.lg),
                  Text(
                    '${isSpecificationSelection ? '' : '每张原纸出 ${_plan!['pieces_per_parent_sheet'] ?? '-'} 张；'}'
                    '计划 ${isSpecificationSelection ? _plan!['planned_material_quantity'] : _plan!['planned_parent_quantity']}；'
                    '库存预留 ${_plan!['reserved_quantity'] ?? 0}；'
                    '需采购 ${_plan!['purchase_quantity'] ?? 0}',
                  ),
                ],
                if (_errorMessage != null) ...[
                  const SizedBox(height: SpacingTokens.md),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('关闭'),
        ),
        if (confirmed)
          TextButton(
            onPressed: _loading
                ? null
                : () async {
                    try {
                      final invalidated = await widget.onInvalidate();
                      if (invalidated && context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    } catch (error) {
                      if (mounted) {
                        setState(() => _errorMessage = error.toString());
                      }
                    }
                  },
            child: const Text('作废计划'),
          )
        else ...[
          OutlinedButton(
            onPressed: _loading ? null : _calculate,
            child: Text(isSpecificationSelection ? '生成计划' : '计算'),
          ),
          FilledButton(
            onPressed: _loading || status != 'calculated' ? null : _confirm,
            child: const Text('确认并预留'),
          ),
        ],
      ],
    );
  }

  Widget _numberField(
    String label,
    TextEditingController controller,
    bool disabled, {
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: 135,
      child: TextFormField(
        controller: controller,
        enabled: !disabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label),
        validator: validator ?? _positiveNumber,
      ),
    );
  }
}
