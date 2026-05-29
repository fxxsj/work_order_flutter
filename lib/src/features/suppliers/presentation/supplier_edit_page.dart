import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_drawer_edit_panel.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/validators.dart';
import 'package:work_order_app/src/features/suppliers/application/supplier_view_model.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';

Future<bool> showSupplierEditDrawer(
  BuildContext context, {
  required SupplierViewModel viewModel,
  Supplier? supplier,
}) async {
  var saved = false;
  await showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: supplier == null ? '新建供应商' : '编辑供应商',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: ChangeNotifierProvider<SupplierViewModel>.value(
      value: viewModel,
      child: SupplierEditPage(supplier: supplier, onSaved: () => saved = true),
    ),
  );
  return saved;
}

/// 供应商编辑页，支持新增与编辑。
class SupplierEditPage extends StatefulWidget {
  const SupplierEditPage({super.key, this.supplier, this.onSaved});

  final Supplier? supplier;
  final VoidCallback? onSaved;

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
  static const String _codeLengthText = '编码长度在2-50个字符之间';
  static const String _codeInvalidText = '编码只能包含中文、字母、数字和连字符';
  static const String _nameRequiredText = '请输入供应商名称';
  static const String _nameLengthText = '供应商名称不能超过200个字符';
  static const String _phoneInvalidText = '请输入正确的联系电话（手机号或座机号）';
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
    _contactController = TextEditingController(
      text: supplier?.contactPerson ?? '',
    );
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
      createdAt: widget.supplier?.createdAt,
      updatedAt: widget.supplier?.updatedAt,
    );

    if (widget.supplier == null) {
      await viewModel.createSupplier(payload);
    } else {
      await viewModel.updateSupplier(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CrudDrawerEditPanel<Supplier, SupplierViewModel>(
      item: widget.supplier,
      onSaved: widget.onSaved,
      config: CrudEditConfig<Supplier, SupplierViewModel>(
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
                enabled: widget.supplier == null,
                hintText: '请输入编码（留空自动生成）',
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return null;
                  if (text.length < 2 || text.length > 50) {
                    return _codeLengthText;
                  }
                  final regex = RegExp(r'^[\u4e00-\u9fa5A-Za-z0-9-]+$');
                  if (!regex.hasMatch(text)) return _codeInvalidText;
                  return null;
                },
              ),
              CrudFieldConfig.text(
                label: _nameLabel,
                controller: _nameController,
                validator: FormValidators.compose<String>([
                  FormValidators.required(_nameRequiredText),
                  FormValidators.maxLength(200, _nameLengthText),
                ]),
              ),
            ],
          ),
          CrudFormSection(
            title: _contactSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFieldConfig.text(
                label: _contactLabel,
                controller: _contactController,
              ),
              CrudFieldConfig.phone(
                label: _phoneLabel,
                controller: _phoneController,
                validator: FormValidators.pattern(
                  RegExp(r'^(1[3-9]\d{9}|0\d{2,3}-?\d{7,8})$'),
                  _phoneInvalidText,
                ),
              ),
              CrudFieldConfig.email(
                label: _emailLabel,
                controller: _emailController,
                validator: FormValidators.email(_emailInvalidText),
              ),
            ],
          ),
          CrudFormSection(
            title: _extraSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFieldConfig.dropdown(
                label: _statusLabel,
                value: _status,
                options: const [
                  AppDropdownOption(value: _statusActive, label: '启用'),
                  AppDropdownOption(value: _statusInactive, label: '停用'),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _status = value as String);
                },
              ),
              CrudFieldConfig.textarea(
                label: _addressLabel,
                controller: _addressController,
              ),
              CrudFieldConfig.textarea(
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
