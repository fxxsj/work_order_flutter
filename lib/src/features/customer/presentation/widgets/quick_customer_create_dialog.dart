import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/utils/validators.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';

Future<Customer?> showQuickCustomerCreateDialog({
  required BuildContext context,
  required CustomerApiService customerApi,
}) {
  return showDialog<Customer>(
    context: context,
    builder: (dialogContext) {
      return _QuickCustomerCreateDialog(customerApi: customerApi);
    },
  );
}

class _QuickCustomerCreateDialog extends StatefulWidget {
  const _QuickCustomerCreateDialog({required this.customerApi});

  final CustomerApiService customerApi;

  @override
  State<_QuickCustomerCreateDialog> createState() =>
      _QuickCustomerCreateDialogState();
}

class _QuickCustomerCreateDialogState
    extends State<_QuickCustomerCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _submitting = true);
    try {
      final created = await widget.customerApi.createCustomer(
        CustomerDto(
          id: 0,
          name: _nameController.text.trim(),
          contactPerson: _contactController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          address: _addressController.text.trim(),
          notes: _notesController.text.trim(),
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop(created.toEntity());
    } catch (err) {
      ToastUtil.showError('创建客户失败: $err');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      title: '新增客户',
      formKey: _formKey,
      submitText: '保存',
      submitting: _submitting,
      maxWidth: 480,
      onSubmit: _submit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CrudFormField.text(
            label: '客户名称',
            controller: _nameController,
            validator: FormValidators.compose<String>([
              FormValidators.required('请输入客户名称'),
              FormValidators.minLength(2, '客户名称至少需要2个字符'),
            ]),
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.text(
            label: '联系人',
            controller: _contactController,
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.phone(
            label: '联系电话',
            controller: _phoneController,
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.email(
            label: '邮箱',
            controller: _emailController,
            validator: FormValidators.email('请输入正确的邮箱地址'),
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.text(
            label: '地址',
            controller: _addressController,
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.textarea(
            label: '备注',
            controller: _notesController,
            maxLines: 3,
          ).build(context),
        ],
      ),
    );
  }
}
