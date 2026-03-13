import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/edit_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/application/customer_view_model.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';

/// 客户编辑页，支持新增与编辑。
class CustomerEditPage extends StatefulWidget {
  const CustomerEditPage({super.key, this.customer});

  final Customer? customer;

  @override
  State<CustomerEditPage> createState() => _CustomerEditPageState();
}

class _CustomerEditPageState extends State<CustomerEditPage> {
  final _formKey = GlobalKey<FormState>();
  static const double _loadingIndicatorSize = 14;
  static const double _submitIndicatorSize = 20;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;

  static const String _nameLabel = '客户名称';
  static const String _contactLabel = '联系人';
  static const String _phoneLabel = '联系电话';
  static const String _emailLabel = '邮箱';
  static const String _salespersonLabel = '业务员';
  static const String _addressLabel = '地址';
  static const String _notesLabel = '备注';
  static const String _noSalespersonText = '不指定';
  static const String _loadingSalespersonsText = '正在加载业务员列表...';
  static const String _submitCreateText = '保存';
  static const String _submitUpdateText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _nameRequiredText = '请输入客户名称';
  static const String _nameLengthText = '客户名称至少需要2个字符';
  static const String _phoneInvalidText = '电话号码格式不正确';
  static const String _emailInvalidText = '请输入正确的邮箱地址';
  static const String _cancelText = '返回';
  static const String _basicSectionTitle = '基本信息';
  static const String _contactSectionTitle = '联系信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _systemSectionTitle = '系统信息';
  static const String _createdAtLabel = '创建时间';
  static const String _updatedAtLabel = '更新时间';
  static const String _emptyText = '-';

  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  int? _salespersonId;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _nameController = TextEditingController(text: customer?.name ?? '');
    _contactController = TextEditingController(text: customer?.contactPerson ?? '');
    _phoneController = TextEditingController(text: customer?.phone ?? '');
    _emailController = TextEditingController(text: customer?.email ?? '');
    _addressController = TextEditingController(text: customer?.address ?? '');
    _notesController = TextEditingController(text: customer?.notes ?? '');
    _salespersonId = customer?.salespersonId;
  }

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

  Future<void> _handleSubmit(CustomerViewModel viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

    String? salespersonName;
    if (_salespersonId != null) {
      for (final item in viewModel.salespersons) {
        if (item.id == _salespersonId) {
          salespersonName = item.name;
          break;
        }
      }
    }

    final payload = Customer(
      id: widget.customer?.id ?? 0,
      name: _nameController.text.trim(),
      contactPerson: _contactController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      notes: _notesController.text.trim(),
      salespersonId: _salespersonId,
      salespersonName: salespersonName,
      createdAt: widget.customer?.createdAt,
      updatedAt: widget.customer?.updatedAt,
    );

    try {
      if (widget.customer == null) {
        await viewModel.createCustomer(payload);
      } else {
        await viewModel.updateCustomer(payload);
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

  String _formatDateTime(DateTime? value) {
    if (value == null) return _emptyText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
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

  Widget _readonlyField(ThemeData theme, String label, String value) {
    final colors = theme.extension<AppColors>();
    final subtleText = colors?.subtleText ?? theme.hintColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: subtleText)),
        const SizedBox(height: LayoutTokens.gapSm),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CustomerViewModel>();
    final salespersons = viewModel.salespersons;
    final salespersonsError = viewModel.salespersonsError;
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final customer = widget.customer;
    final contentPadding = LayoutTokens.pagePadding(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final actionSpacing = LayoutTokens.formActionSpacing(context);
    final pageSpacing = LayoutTokens.formPageSpacing(context);
    final columnSpacing = LayoutTokens.formColumnSpacing(context);

    return SafeArea(
      child: Form(
        key: _formKey,
        child: EditPageScaffold(
          spacing: pageSpacing,
          contentPadding: contentPadding,
          header: PageHeaderBar(
            breadcrumb: null,
            useSurface: false,
            showDivider: false,
            padding: EdgeInsets.zero,
            actions: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PageActionButton.outlined(
                  onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: _cancelText,
                ),
                const SizedBox(width: _inlineSpacing),
                PageActionButton.filled(
                  onPressed: _submitting ? null : () => _handleSubmit(viewModel),
                  label: customer == null ? _submitCreateText : _submitUpdateText,
                  icon: _submitting
                      ? const SizedBox(
                          height: _submitIndicatorSize,
                          width: _submitIndicatorSize,
                          child: CircularProgressIndicator(strokeWidth: _indicatorStrokeWidth),
                        )
                      : const Icon(Icons.save, size: 16),
                ),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isMobile) ...[
                _sectionTitle(theme, _basicSectionTitle),
                SizedBox(height: sectionSpacing),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: _nameLabel),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return _nameRequiredText;
                    }
                    if (text.length < 2) {
                      return _nameLengthText;
                    }
                    return null;
                  },
                ),
                SizedBox(height: sectionSpacing),
                DropdownButtonFormField<int?>(
                  initialValue: _salespersonId,
                  decoration: const InputDecoration(labelText: _salespersonLabel),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text(_noSalespersonText),
                    ),
                    ...salespersons.map(
                      (item) => DropdownMenuItem<int?>(
                        value: item.id,
                        child: Text(item.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _salespersonId = value;
                    });
                  },
                  validator: (_) => null,
                ),
                if (viewModel.loadingSalespersons)
                  Padding(
                    padding: EdgeInsets.only(top: sectionSpacing),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: _loadingIndicatorSize,
                          height: _loadingIndicatorSize,
                          child: CircularProgressIndicator(strokeWidth: _indicatorStrokeWidth),
                        ),
                        const SizedBox(width: _inlineSpacing),
                        const Text(_loadingSalespersonsText),
                      ],
                    ),
                  )
                else if (salespersonsError != null && salespersonsError.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: sectionSpacing),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            salespersonsError,
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                          ),
                        ),
                        TextButton(
                          onPressed: viewModel.loadSalespersons,
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: sectionSpacing),
                _sectionTitle(theme, _contactSectionTitle),
                SizedBox(height: sectionSpacing),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: _contactLabel),
                  validator: (_) => null,
                ),
                SizedBox(height: sectionSpacing),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: _phoneLabel),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return null;
                    }
                    final phoneRegex = RegExp(r'^[\d\-+() ]+$');
                    if (!phoneRegex.hasMatch(text)) {
                      return _phoneInvalidText;
                    }
                    return null;
                  },
                ),
                SizedBox(height: sectionSpacing),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: _emailLabel),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return null;
                    }
                    final emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                    if (!emailRegex.hasMatch(text)) {
                      return _emailInvalidText;
                    }
                    return null;
                  },
                ),
                SizedBox(height: sectionSpacing),
                _sectionTitle(theme, _extraSectionTitle),
                SizedBox(height: sectionSpacing),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: _addressLabel),
                  maxLines: 2,
                  validator: (_) => null,
                ),
                SizedBox(height: sectionSpacing),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: _notesLabel),
                  maxLines: 3,
                  validator: (_) => null,
                ),
                if (customer != null) ...[
                  SizedBox(height: sectionSpacing),
                  _sectionTitle(theme, _systemSectionTitle),
                  SizedBox(height: sectionSpacing),
                  _readonlyField(theme, _createdAtLabel, _formatDateTime(customer.createdAt)),
                  SizedBox(height: sectionSpacing),
                  _readonlyField(theme, _updatedAtLabel, _formatDateTime(customer.updatedAt)),
                ],
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
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: _nameLabel),
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (text.isEmpty) {
                                return _nameRequiredText;
                              }
                              if (text.length < 2) {
                                return _nameLengthText;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: sectionSpacing),
                          DropdownButtonFormField<int?>(
                            initialValue: _salespersonId,
                            decoration: const InputDecoration(labelText: _salespersonLabel),
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text(_noSalespersonText),
                              ),
                              ...salespersons.map(
                                (item) => DropdownMenuItem<int?>(
                                  value: item.id,
                                  child: Text(item.name),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _salespersonId = value;
                              });
                            },
                            validator: (_) => null,
                          ),
                          if (viewModel.loadingSalespersons)
                            Padding(
                              padding: EdgeInsets.only(top: sectionSpacing),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: _loadingIndicatorSize,
                                    height: _loadingIndicatorSize,
                                    child: CircularProgressIndicator(strokeWidth: _indicatorStrokeWidth),
                                  ),
                                  const SizedBox(width: _inlineSpacing),
                                  const Text(_loadingSalespersonsText),
                                ],
                              ),
                            )
                          else if (salespersonsError != null && salespersonsError.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: sectionSpacing),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      salespersonsError,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: theme.colorScheme.error),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: viewModel.loadSalespersons,
                                    child: const Text('重试'),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: sectionSpacing),
                          _sectionTitle(theme, _contactSectionTitle),
                          SizedBox(height: sectionSpacing),
                          TextFormField(
                            controller: _contactController,
                            decoration: const InputDecoration(labelText: _contactLabel),
                            validator: (_) => null,
                          ),
                          SizedBox(height: sectionSpacing),
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(labelText: _phoneLabel),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (text.isEmpty) {
                                return null;
                              }
                              final phoneRegex = RegExp(r'^[\d\-+() ]+$');
                              if (!phoneRegex.hasMatch(text)) {
                                return _phoneInvalidText;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: sectionSpacing),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: _emailLabel),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (text.isEmpty) {
                                return null;
                              }
                              final emailRegex =
                                  RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                              if (!emailRegex.hasMatch(text)) {
                                return _emailInvalidText;
                              }
                              return null;
                            },
                          ),
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
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(labelText: _addressLabel),
                            maxLines: 2,
                            validator: (_) => null,
                          ),
                          SizedBox(height: sectionSpacing),
                          TextFormField(
                            controller: _notesController,
                            decoration: const InputDecoration(labelText: _notesLabel),
                            maxLines: 3,
                            validator: (_) => null,
                          ),
                          if (customer != null) ...[
                            SizedBox(height: sectionSpacing),
                            _sectionTitle(theme, _systemSectionTitle),
                            SizedBox(height: sectionSpacing),
                            _readonlyField(
                              theme,
                              _createdAtLabel,
                              _formatDateTime(customer.createdAt),
                            ),
                            SizedBox(height: sectionSpacing),
                            _readonlyField(
                              theme,
                              _updatedAtLabel,
                              _formatDateTime(customer.updatedAt),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: actionSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
