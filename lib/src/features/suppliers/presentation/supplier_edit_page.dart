import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/features/suppliers/application/supplier_view_model.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';

/// 供应商编辑页，支持新增与编辑。
class SupplierEditPage extends StatefulWidget {
  const SupplierEditPage({super.key, this.supplier});

  final Supplier? supplier;

  @override
  State<SupplierEditPage> createState() => _SupplierEditPageState();
}

class _SupplierEditPageState extends State<SupplierEditPage> {
  static const String _codeLabel = '供应商编码';
  static const String _nameLabel = '供应商名称';
  static const String _contactLabel = '联系人';
  static const String _phoneLabel = '联系电话';
  static const String _emailLabel = '邮箱';
  static const String _addressLabel = '地址';
  static const String _statusLabel = '状态';
  static const String _notesLabel = '备注';

  static const String _statusActive = 'active';
  static const String _statusInactive = 'inactive';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _codeRequiredText = '请输入供应商编码';
  static const String _codeLengthText = '编码长度在2-50个字符之间';
  static const String _codeInvalidText = '编码只能包含字母、数字和连字符';
  static const String _nameRequiredText = '请输入供应商名称';
  static const String _phoneInvalidText = '请输入正确的联系电话';
  static const String _emailInvalidText = '请输入正确的邮箱地址';
  static const String _basicSectionTitle = '基本信息';
  static const String _contactSectionTitle = '联系信息';
  static const String _extraSectionTitle = '补充信息';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  String _status = _statusActive;

  @override
  void initState() {
    super.initState();
    final supplier = widget.supplier;
    _codeController = TextEditingController(text: supplier?.code ?? '');
    _nameController = TextEditingController(text: supplier?.name ?? '');
    _contactController =
        TextEditingController(text: supplier?.contactPerson ?? '');
    _phoneController = TextEditingController(text: supplier?.phone ?? '');
    _emailController = TextEditingController(text: supplier?.email ?? '');
    _addressController = TextEditingController(text: supplier?.address ?? '');
    _notesController = TextEditingController(text: supplier?.notes ?? '');
    _status = supplier?.status ?? _statusActive;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(SupplierViewModel viewModel) async {
    final payload = Supplier(
      id: widget.supplier?.id ?? 0,
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      contactPerson: _contactController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      status: _status,
      notes: _notesController.text.trim(),
      statusDisplay: widget.supplier?.statusDisplay,
      materialCount: widget.supplier?.materialCount,
    );

    if (widget.supplier == null) {
      await viewModel.createSupplier(payload);
    } else {
      await viewModel.updateSupplier(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CrudEditPage<Supplier, SupplierViewModel>(
      item: widget.supplier,
      config: CrudEditConfig<Supplier, SupplierViewModel>(
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
                enabled: widget.supplier == null,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _codeRequiredText;
                  if (text.length < 2 || text.length > 50) {
                    return _codeLengthText;
                  }
                  if (!RegExp(r'^[A-Za-z0-9-]+$').hasMatch(text)) {
                    return _codeInvalidText;
                  }
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
            ],
          ),
          CrudFormSection(
            title: _contactSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFormField.text(
                label: _contactLabel,
                controller: _contactController,
              ),
              CrudFormField.phone(
                label: _phoneLabel,
                controller: _phoneController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return null;
                  if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(text)) {
                    return _phoneInvalidText;
                  }
                  return null;
                },
              ),
              CrudFormField.email(
                label: _emailLabel,
                controller: _emailController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return null;
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(text)) {
                    return _emailInvalidText;
                  }
                  return null;
                },
              ),
            ],
          ),
          CrudFormSection(
            title: _extraSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFormField.dropdown(
                label: _statusLabel,
                value: _status,
                options: const [
                  CrudFieldOption(value: _statusActive, label: '启用'),
                  CrudFieldOption(value: _statusInactive, label: '停用'),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _status = value as String);
                },
              ),
              CrudFormField.textarea(
                label: _addressLabel,
                controller: _addressController,
              ),
              CrudFormField.textarea(
                label: _notesLabel,
                controller: _notesController,
              ),
            ],
          ),
        ],
        onSave: (context, viewModel, item) => _handleSubmit(viewModel),
      ),
    );
  }
}
