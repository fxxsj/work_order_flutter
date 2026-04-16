import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/utils/validators.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_dto.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

Future<Product?> showQuickProductCreateDialog({
  required BuildContext context,
  required ProductApiService productApi,
}) {
  return showDialog<Product>(
    context: context,
    builder: (dialogContext) {
      return _QuickProductCreateDialog(productApi: productApi);
    },
  );
}

class _QuickProductCreateDialog extends StatefulWidget {
  const _QuickProductCreateDialog({required this.productApi});

  final ProductApiService productApi;

  @override
  State<_QuickProductCreateDialog> createState() =>
      _QuickProductCreateDialogState();
}

class _QuickProductCreateDialogState extends State<_QuickProductCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _specController = TextEditingController();
  final _unitController = TextEditingController(text: '件');
  final _unitPriceController = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _specController.dispose();
    _unitController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _submitting = true);
    try {
      final created = await widget.productApi.createProduct(
        ProductDto(
          id: 0,
          code: _codeController.text.trim(),
          name: _nameController.text.trim(),
          productType: 'single',
          specification: _textOrNull(_specController.text),
          unit: _textOrNull(_unitController.text),
          unitPrice: _parseDouble(_unitPriceController.text),
          isActive: true,
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop(created.toEntity());
    } catch (err) {
      ToastUtil.showError('创建产品失败: $err');
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
      title: '新增产品',
      formKey: _formKey,
      submitText: '保存',
      submitting: _submitting,
      maxWidth: 480,
      onSubmit: _submit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CrudFormField.text(
            label: '产品编码',
            controller: _codeController,
            validator: FormValidators.compose<String>([
              FormValidators.required('请输入产品编码'),
              FormValidators.lengthRange(2, 50, '编码长度在2-50个字符之间'),
              FormValidators.pattern(
                RegExp(r'^[A-Za-z0-9-]+$'),
                '编码只能包含字母、数字和连字符',
              ),
            ]),
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.text(
            label: '产品名称',
            controller: _nameController,
            validator: FormValidators.required('请输入产品名称'),
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.text(
            label: '规格',
            controller: _specController,
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.text(
            label: '单位',
            controller: _unitController,
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.number(
            label: '单价',
            controller: _unitPriceController,
            decimal: true,
          ).build(context),
        ],
      ),
    );
  }
}
