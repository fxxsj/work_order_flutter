import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/edit_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
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
  final _formKey = GlobalKey<FormState>();

  static const double _submitIndicatorSize = 20;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;

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
  static const String _backText = '返回';
  static const String _cancelText = '取消';
  static const String _basicSectionTitle = '基本信息';
  static const String _contactSectionTitle = '联系信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _breadcrumbSeparator = ' / ';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  String _status = _statusActive;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final supplier = widget.supplier;
    _codeController = TextEditingController(text: supplier?.code ?? '');
    _nameController = TextEditingController(text: supplier?.name ?? '');
    _contactController = TextEditingController(text: supplier?.contactPerson ?? '');
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
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

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

    try {
      if (widget.supplier == null) {
        await viewModel.createSupplier(payload);
      } else {
        await viewModel.updateSupplier(payload);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_submitErrorText$err');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Widget _sectionTitle(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SupplierViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPath('/suppliers');
    final contentPadding = LayoutTokens.pagePadding(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final actionSpacing = LayoutTokens.formActionSpacing(context);
    final pageSpacing = LayoutTokens.formPageSpacing(context);
    final columnSpacing = LayoutTokens.formColumnSpacing(context);

    final codeField = TextFormField(
      controller: _codeController,
      decoration: const InputDecoration(labelText: _codeLabel),
      enabled: widget.supplier == null,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) {
          return _codeRequiredText;
        }
        if (text.length < 2 || text.length > 50) {
          return _codeLengthText;
        }
        if (!RegExp(r'^[A-Za-z0-9-]+$').hasMatch(text)) {
          return _codeInvalidText;
        }
        return null;
      },
    );

    final nameField = TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: _nameLabel),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) {
          return _nameRequiredText;
        }
        return null;
      },
    );

    final contactField = TextFormField(
      controller: _contactController,
      decoration: const InputDecoration(labelText: _contactLabel),
    );

    final phoneField = TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(labelText: _phoneLabel),
      keyboardType: TextInputType.phone,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return null;
        if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(text)) {
          return _phoneInvalidText;
        }
        return null;
      },
    );

    final emailField = TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: _emailLabel),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return null;
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(text)) {
          return _emailInvalidText;
        }
        return null;
      },
    );

    final statusField = DropdownButtonFormField<String>(
      initialValue: _status,
      decoration: const InputDecoration(labelText: _statusLabel),
      items: const [
        DropdownMenuItem(value: _statusActive, child: Text('启用')),
        DropdownMenuItem(value: _statusInactive, child: Text('停用')),
      ],
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _status = value;
        });
      },
    );

    final addressField = TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(labelText: _addressLabel),
      minLines: 2,
      maxLines: 3,
    );

    final notesField = TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(labelText: _notesLabel),
      minLines: 2,
      maxLines: 3,
    );

    final mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile) ...[
          _sectionTitle(theme, _basicSectionTitle),
          SizedBox(height: sectionSpacing),
          codeField,
          SizedBox(height: sectionSpacing),
          nameField,
          SizedBox(height: sectionSpacing),
          _sectionTitle(theme, _contactSectionTitle),
          SizedBox(height: sectionSpacing),
          contactField,
          SizedBox(height: sectionSpacing),
          phoneField,
          SizedBox(height: sectionSpacing),
          emailField,
          SizedBox(height: sectionSpacing),
          _sectionTitle(theme, _extraSectionTitle),
          SizedBox(height: sectionSpacing),
          statusField,
          SizedBox(height: sectionSpacing),
          addressField,
          SizedBox(height: sectionSpacing),
          notesField,
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionTitle(theme, _basicSectionTitle),
                    SizedBox(height: sectionSpacing),
                    codeField,
                    SizedBox(height: sectionSpacing),
                    nameField,
                    SizedBox(height: sectionSpacing),
                    _sectionTitle(theme, _contactSectionTitle),
                    SizedBox(height: sectionSpacing),
                    contactField,
                    SizedBox(height: sectionSpacing),
                    phoneField,
                    SizedBox(height: sectionSpacing),
                    emailField,
                  ],
                ),
              ),
              SizedBox(width: columnSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionTitle(theme, _extraSectionTitle),
                    SizedBox(height: sectionSpacing),
                    statusField,
                    SizedBox(height: sectionSpacing),
                    addressField,
                    SizedBox(height: sectionSpacing),
                    notesField,
                  ],
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: actionSpacing),
      ],
    );

    return SafeArea(
      child: Form(
        key: _formKey,
        child: EditPageScaffold(
          spacing: pageSpacing,
          contentPadding: contentPadding,
          header: PageHeaderBar(
            breadcrumb: breadcrumb.join(_breadcrumbSeparator),
            useSurface: false,
            showDivider: false,
            padding: EdgeInsets.zero,
            actions: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PageActionButton.outlined(
                  onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: _backText,
                ),
              ],
            ),
          ),
          body: mainContent,
          footer: EditPageFooterBar(
            child: Row(
              children: [
                PageActionButton.outlined(
                  onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
                  label: _cancelText,
                ),
                const SizedBox(width: _inlineSpacing),
                PageActionButton.filled(
                  onPressed: _submitting ? null : () => _handleSubmit(viewModel),
                  label: _submitText,
                  icon: _submitting
                      ? const SizedBox(
                          height: _submitIndicatorSize,
                          width: _submitIndicatorSize,
                          child: CircularProgressIndicator(strokeWidth: _indicatorStrokeWidth),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
