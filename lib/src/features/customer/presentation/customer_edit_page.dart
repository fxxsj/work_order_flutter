import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/extensions/datetime_extensions.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/utils/validators.dart';
import 'package:work_order_app/src/features/customer/application/customer_view_model.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';

Future<bool> showCustomerEditDrawer(
  BuildContext context, {
  required CustomerViewModel viewModel,
  Customer? customer,
}) async {
  var saved = false;
  await showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: customer == null ? '新建客户' : '编辑客户',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: ChangeNotifierProvider<CustomerViewModel>.value(
      value: viewModel,
      child: CustomerEditPage(
        customer: customer,
        onSaved: () => saved = true,
      ),
    ),
  );
  return saved;
}

/// 客户编辑页，支持新增与编辑。
class CustomerEditPage extends StatefulWidget {
  const CustomerEditPage({
    super.key,
    this.customer,
    this.onSaved,
  });

  final Customer? customer;
  final VoidCallback? onSaved;

  @override
  State<CustomerEditPage> createState() => _CustomerEditPageState();
}

class _CustomerEditPageState extends State<CustomerEditPage> {
  static const double _loadingIndicatorSize = 14;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;

  static const String _loadingSalespersonsText = '正在加载业务员列表...';
  static const String _submitErrorText = '操作失败: ';
  static const String _duplicateNameError = '该客户名称已存在';

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  int? _salespersonId;
  bool _submitting = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _nameController = TextEditingController(text: customer?.name ?? '');
    _contactController =
        TextEditingController(text: customer?.contactPerson ?? '');
    _phoneController = TextEditingController(text: customer?.phone ?? '');
    _emailController = TextEditingController(text: customer?.email ?? '');
    _addressController = TextEditingController(text: customer?.address ?? '');
    _notesController = TextEditingController(text: customer?.notes ?? '');
    _salespersonId = customer?.salespersonId;

    // 监听名称变化，清除错误提示
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    if (_nameError != null) {
      setState(() => _nameError = null);
    }
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

  bool _canSave(BuildContext context) {
    final requiredPermission = widget.customer == null
        ? 'workorder.add_customer'
        : 'workorder.change_customer';
    return PermissionUtil.snapshot(context).has(requiredPermission);
  }

  Future<bool> _handleSubmit(CustomerViewModel viewModel) async {
    try {
      final requiredPermission = widget.customer == null
          ? 'workorder.add_customer'
          : 'workorder.change_customer';
      final permissions = PermissionUtil.snapshot(context);
      if (!permissions.has(requiredPermission)) {
        ToastUtil.showError('当前账号无权执行该操作');
        return false;
      }

      // 检查客户名称是否重复
      final name = _nameController.text.trim();
      if (name.length >= 2) {
        final excludeId = widget.customer?.id;
        final exists = await viewModel.checkCustomerNameExists(
          name,
          excludeId: excludeId,
        );
        if (exists) {
          setState(() => _nameError = _duplicateNameError);
          return false;
        }
      }

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
        name: name,
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

      if (widget.customer == null) {
        await viewModel.createCustomer(payload);
      } else {
        await viewModel.updateCustomer(payload);
      }
      return true;
    } on ApiException catch (e) {
      // 解析后端返回的字段验证错误
      final nameError = e.getFieldError('name');
      if (nameError != null) {
        setState(() => _nameError = nameError);
        return false;
      }
      // 如果没有字段级错误，显示通用错误
      if (mounted) {
        ToastUtil.showError('${_submitErrorText}${e.message}');
      }
      return false;
    }
  }

  Future<void> _submit(CustomerViewModel viewModel) async {
    // 先检查重复名称（如果已发现重复，直接显示错误）
    if (_nameError != null) {
      ToastUtil.showError(_nameError!);
      return;
    }

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    if (_submitting) return;

    setState(() => _submitting = true);
    try {
      final saved = await _handleSubmit(viewModel);
      if (!mounted || !saved) {
        // 如果保存失败且有错误提示，显示错误
        if (_nameError != null) {
          ToastUtil.showError(_nameError!);
        }
        return;
      }
      widget.onSaved?.call();
      Navigator.of(context).pop(true);
    } catch (err) {
      if (!mounted) return;
      // 处理 ApiException
      if (err is ApiException) {
        // 如果已经有 nameError，显示 nameError
        if (_nameError != null) {
          ToastUtil.showError(_nameError!);
        } else {
          ToastUtil.showError('${_submitErrorText}${err.message}');
        }
      } else {
        ToastUtil.showError('$_submitErrorText$err');
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Widget _readonlyField(ThemeData theme, String label, String value) {
    final colors = theme.extension<AppColors>();
    final subtleText = colors?.subtleText ?? theme.hintColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: subtleText),
        ),
        const SizedBox(height: LayoutTokens.gapSm),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _salespersonStateField(
    BuildContext context,
    CustomerViewModel viewModel,
    ThemeData theme,
  ) {
    final salespersonsError = viewModel.salespersonsError;

    if (viewModel.loadingSalespersons) {
      return Row(
        children: [
          const SizedBox(
            width: _loadingIndicatorSize,
            height: _loadingIndicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: _indicatorStrokeWidth,
            ),
          ),
          const SizedBox(width: _inlineSpacing),
          const Text(_loadingSalespersonsText),
        ],
      );
    }

    if (salespersonsError != null && salespersonsError.isNotEmpty) {
      return Row(
        children: [
          Expanded(
            child: Text(
              salespersonsError,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          TextButton(
            onPressed: viewModel.loadSalespersons,
            child: const Text('重试'),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerViewModel>(
      builder: (context, viewModel, _) {
        return AdaptiveFormPanel(
          formKey: _formKey,
          submitText: '保存',
          cancelText: '取消',
          submitting: _submitting,
          submitEnabled: _canSave(context),
          onSubmit: () => _submit(viewModel),
          child: _CustomerFormBody(
            customer: widget.customer,
            viewModel: viewModel,
            selectedSalespersonId: _salespersonId,
            nameController: _nameController,
            contactController: _contactController,
            phoneController: _phoneController,
            emailController: _emailController,
            addressController: _addressController,
            notesController: _notesController,
            readonlyField: _readonlyField,
            salespersonStateField: _salespersonStateField,
            onSalespersonChanged: (value) {
              setState(() => _salespersonId = value as int?);
            },
          ),
        );
      },
    );
  }
}

class _CustomerFormBody extends StatelessWidget {
  const _CustomerFormBody({
    required this.customer,
    required this.viewModel,
    required this.selectedSalespersonId,
    required this.nameController,
    required this.contactController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.notesController,
    required this.readonlyField,
    required this.salespersonStateField,
    required this.onSalespersonChanged,
  });

  final Customer? customer;
  final CustomerViewModel viewModel;
  final int? selectedSalespersonId;
  final TextEditingController nameController;
  final TextEditingController contactController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController notesController;
  final Widget Function(ThemeData theme, String label, String value)
      readonlyField;
  final Widget Function(
    BuildContext context,
    CustomerViewModel viewModel,
    ThemeData theme,
  ) salespersonStateField;
  final ValueChanged<dynamic> onSalespersonChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showSalespersonState = viewModel.loadingSalespersons ||
        (viewModel.salespersonsError?.isNotEmpty ?? false);
    final sections = <Widget>[
      _CustomerFormSection(
        title: _CustomerEditLabels.basicSection,
        child: _CustomerFieldList(
          children: [
            CrudFieldConfig.text(
              label: _CustomerEditLabels.name,
              controller: nameController,
              validator: FormValidators.compose<String>([
                FormValidators.required(_CustomerEditLabels.nameRequired),
                FormValidators.minLength(2, _CustomerEditLabels.nameLength),
              ]),
            ).build(context),
            CrudFieldConfig.dropdown(
              label: _CustomerEditLabels.salesperson,
              value: selectedSalespersonId,
              options: [
                const AppDropdownOption<dynamic>(
                  value: null,
                  label: _CustomerEditLabels.none,
                ),
                ...viewModel.salespersons.map(
                  (item) => AppDropdownOption<dynamic>(
                    value: item.id,
                    label: item.name,
                  ),
                ),
              ],
              onChanged: onSalespersonChanged,
            ).build(context),
            if (showSalespersonState)
              salespersonStateField(context, viewModel, theme),
          ],
        ),
      ),
      const SizedBox(height: LayoutTokens.gapLg),
      _CustomerFormSection(
        title: _CustomerEditLabels.contactSection,
        child: _CustomerFieldList(
          children: [
            CrudFieldConfig.text(
              label: _CustomerEditLabels.contact,
              controller: contactController,
            ).build(context),
            CrudFieldConfig.phone(
              label: _CustomerEditLabels.phone,
              controller: phoneController,
              validator: FormValidators.pattern(
                RegExp(r'^[\d\-+() ]+$'),
                _CustomerEditLabels.phoneInvalid,
              ),
            ).build(context),
            CrudFieldConfig.email(
              label: _CustomerEditLabels.email,
              controller: emailController,
              validator: FormValidators.email(_CustomerEditLabels.emailInvalid),
            ).build(context),
          ],
        ),
      ),
      const SizedBox(height: LayoutTokens.gapLg),
      _CustomerFormSection(
        title: _CustomerEditLabels.extraSection,
        child: _CustomerFieldList(
          children: [
            CrudFieldConfig.textarea(
              label: _CustomerEditLabels.address,
              controller: addressController,
              minLines: 2,
              maxLines: 2,
            ).build(context),
            CrudFieldConfig.textarea(
              label: _CustomerEditLabels.notes,
              controller: notesController,
              maxLines: 3,
            ).build(context),
          ],
        ),
      ),
      if (customer != null) ...[
        const SizedBox(height: LayoutTokens.gapLg),
        _CustomerFormSection(
          title: _CustomerEditLabels.systemSection,
          child: _CustomerFieldList(
            children: [
              readonlyField(
                theme,
                _CustomerEditLabels.createdAt,
                customer?.createdAt.toYMDHM ?? '-',
              ),
              readonlyField(
                theme,
                _CustomerEditLabels.updatedAt,
                customer?.updatedAt.toYMDHM ?? '-',
              ),
            ],
          ),
        ),
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sections,
    );
  }
}

class _CustomerFormSection extends StatelessWidget {
  const _CustomerFormSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: LayoutTokens.gapMd),
          child,
        ],
      ),
    );
  }
}

class _CustomerFieldList extends StatelessWidget {
  const _CustomerFieldList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: LayoutTokens.gapMd),
          children[index],
        ],
      ],
    );
  }
}

class _CustomerEditLabels {
  const _CustomerEditLabels._();

  static const String name = '客户名称';
  static const String contact = '联系人';
  static const String phone = '联系电话';
  static const String email = '邮箱';
  static const String salesperson = '业务员';
  static const String address = '地址';
  static const String notes = '备注';
  static const String none = '不指定';
  static const String basicSection = '基本信息';
  static const String contactSection = '联系信息';
  static const String extraSection = '补充信息';
  static const String systemSection = '系统信息';
  static const String createdAt = '创建时间';
  static const String updatedAt = '更新时间';
  static const String nameRequired = '请输入客户名称';
  static const String nameLength = '客户名称至少需要2个字符';
  static const String phoneInvalid = '电话号码格式不正确';
  static const String emailInvalid = '请输入正确的邮箱地址';
}
