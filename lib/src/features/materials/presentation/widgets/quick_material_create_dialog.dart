import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/utils/validators.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';

Future<MaterialItem?> showQuickMaterialCreateDialog({
  required BuildContext context,
  required MaterialApiService materialApi,
}) {
  return showDialog<MaterialItem>(
    context: context,
    builder: (dialogContext) {
      return _QuickMaterialCreateDialog(materialApi: materialApi);
    },
  );
}

class _QuickMaterialCreateDialog extends StatefulWidget {
  const _QuickMaterialCreateDialog({required this.materialApi});

  final MaterialApiService materialApi;

  @override
  State<_QuickMaterialCreateDialog> createState() =>
      _QuickMaterialCreateDialogState();
}

class _QuickMaterialCreateDialogState
    extends State<_QuickMaterialCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _unitController = TextEditingController(text: '个');
  final _unitPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _minStockController = TextEditingController();

  bool _submitting = false;

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

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _submitting = true);
    try {
      final created = await widget.materialApi.createMaterial(
        MaterialDto(
          id: 0,
          code: _codeController.text.trim(),
          name: _nameController.text.trim(),
          unit: _textOrNull(_unitController.text),
          unitPrice: _parseDouble(_unitPriceController.text),
          stockQuantity: _parseDouble(_stockController.text),
          minStockQuantity: _parseDouble(_minStockController.text),
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop(created.toEntity());
    } catch (err) {
      ToastUtil.showError('创建物料失败: $err');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  String? _textOrNull(String value) {
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  double? _parseDouble(String value) {
    final text = value.trim();
    return text.isEmpty ? null : double.tryParse(text);
  }

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      title: '新增物料',
      formKey: _formKey,
      submitText: '保存',
      submitting: _submitting,
      maxWidth: 480,
      onSubmit: _submit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CrudFormField.text(
            label: '物料编码',
            controller: _codeController,
            validator: FormValidators.compose<String>([
              FormValidators.required('请输入物料编码'),
              FormValidators.lengthRange(2, 50, '编码长度在2-50个字符之间'),
              FormValidators.pattern(
                RegExp(r'^[A-Za-z0-9-]+$'),
                '编码只能包含字母、数字和连字符',
              ),
            ]),
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.text(
            label: '物料名称',
            controller: _nameController,
            validator: FormValidators.required('请输入物料名称'),
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.text(
            label: '单位',
            controller: _unitController,
            validator: FormValidators.required('请输入单位'),
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.number(
            label: '单价',
            controller: _unitPriceController,
            decimal: true,
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.number(
            label: '库存数量',
            controller: _stockController,
            decimal: true,
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.number(
            label: '最小库存',
            controller: _minStockController,
            decimal: true,
          ).build(context),
        ],
      ),
    );
  }
}
