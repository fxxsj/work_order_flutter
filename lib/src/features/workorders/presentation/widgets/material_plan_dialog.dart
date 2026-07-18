import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';

class MaterialPlanDialog extends StatefulWidget {
  const MaterialPlanDialog({
    super.key,
    required this.material,
    required this.stockMaterials,
    required this.onCalculate,
    required this.onConfirm,
    required this.onInvalidate,
  });

  final WorkOrderMaterialItem material;
  final List<Map<String, dynamic>> stockMaterials;
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
  int? _purchaseMaterialId;
  Map<String, dynamic>? _plan;
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final item = widget.material;
    _purchaseMaterialId = item.purchaseMaterialId;
    _widthController = TextEditingController(text: _number(item.cutWidthMm));
    _heightController = TextEditingController(text: _number(item.cutHeightMm));
    _quantityController = TextEditingController(
      text: _number(item.requiredCutQuantity),
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
    if (!_formKey.currentState!.validate() || _purchaseMaterialId == null) {
      if (_purchaseMaterialId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('请选择采购原纸规格')));
      }
      return;
    }
    setState(() => _loading = true);
    try {
      final result = await widget.onCalculate({
        'purchase_material': _purchaseMaterialId,
        'cut_width_mm': double.parse(_widthController.text.trim()),
        'cut_height_mm': double.parse(_heightController.text.trim()),
        'required_cut_quantity': double.parse(_quantityController.text.trim()),
        'wastage_rate': double.parse(_wastageController.text.trim()),
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
                DropdownButtonFormField<int>(
                  initialValue: _purchaseMaterialId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: '采购原纸规格'),
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
                      : (value) => setState(() => _purchaseMaterialId = value),
                ),
                const SizedBox(height: SpacingTokens.md),
                Wrap(
                  spacing: SpacingTokens.md,
                  runSpacing: SpacingTokens.md,
                  children: [
                    _numberField('开料宽度(mm)', _widthController, confirmed),
                    _numberField('开料高度(mm)', _heightController, confirmed),
                    _numberField('成品张数', _quantityController, confirmed),
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
                    '每张原纸出 ${_plan!['pieces_per_parent_sheet'] ?? '-'} 张；'
                    '计划 ${_plan!['planned_parent_quantity'] ?? '-'} 张；'
                    '库存预留 ${_plan!['reserved_quantity'] ?? 0} 张；'
                    '需采购 ${_plan!['purchase_quantity'] ?? 0} 张',
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
            child: const Text('计算'),
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
