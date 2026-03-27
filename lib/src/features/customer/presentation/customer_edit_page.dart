import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/utils/extensions/datetime_extensions.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/utils/validators.dart';
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
  static const double _loadingIndicatorSize = 14;
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
  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _nameRequiredText = '请输入客户名称';
  static const String _nameLengthText = '客户名称至少需要2个字符';
  static const String _phoneInvalidText = '电话号码格式不正确';
  static const String _emailInvalidText = '请输入正确的邮箱地址';
  static const String _basicSectionTitle = '基本信息';
  static const String _contactSectionTitle = '联系信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _systemSectionTitle = '系统信息';
  static const String _createdAtLabel = '创建时间';
  static const String _updatedAtLabel = '更新时间';

  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  int? _salespersonId;

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
    final requiredPermission = widget.customer == null
        ? 'workorder.add_customer'
        : 'workorder.change_customer';
    if (!PermissionUtil.hasPermission(context, requiredPermission)) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
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

    if (widget.customer == null) {
      await viewModel.createCustomer(payload);
    } else {
      await viewModel.updateCustomer(payload);
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
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);

    if (viewModel.loadingSalespersons) {
      return Padding(
        padding: EdgeInsets.only(top: sectionSpacing),
        child: Row(
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
        ),
      );
    }

    if (salespersonsError != null && salespersonsError.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: sectionSpacing),
        child: Row(
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
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;
    final viewModel = context.watch<CustomerViewModel>();
    final salespersons = viewModel.salespersons;

    return CrudEditPage<Customer, CustomerViewModel>(
      item: customer,
      config: CrudEditConfig<Customer, CustomerViewModel>(
        submitText: _submitText,
        submittingText: '保存中',
        errorMessagePrefix: _submitErrorText,
        canSave: (context, viewModel, item) => PermissionUtil.hasPermission(
          context,
          item == null ? 'workorder.add_customer' : 'workorder.change_customer',
        ),
        sectionsBuilder: (context, isMobile) {
          final theme = Theme.of(context);
          return [
            CrudFormSection(
              title: _basicSectionTitle,
              column: 0,
              fields: [
                CrudFormField.text(
                  label: _nameLabel,
                  controller: _nameController,
                  validator: FormValidators.compose<String>([
                    FormValidators.required(_nameRequiredText),
                    FormValidators.minLength(2, _nameLengthText),
                  ]),
                ),
                CrudFormField.dropdown(
                  label: _salespersonLabel,
                  value: _salespersonId,
                  options: [
                    const CrudFieldOption<dynamic>(
                      value: null,
                      label: _noSalespersonText,
                    ),
                    ...salespersons.map(
                      (item) => CrudFieldOption<dynamic>(
                        value: item.id,
                        label: item.name,
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _salespersonId = value as int?);
                  },
                ),
                CrudFormField.custom(
                  builder: (context) =>
                      _salespersonStateField(context, viewModel, theme),
                ),
              ],
            ),
            CrudFormSection(
              title: _contactSectionTitle,
              column: 0,
              fields: [
                CrudFormField.text(
                  label: _contactLabel,
                  controller: _contactController,
                ),
                CrudFormField.phone(
                  label: _phoneLabel,
                  controller: _phoneController,
                  validator: FormValidators.pattern(
                    RegExp(r'^[\d\-+() ]+$'),
                    _phoneInvalidText,
                  ),
                ),
                CrudFormField.email(
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
                CrudFormField.textarea(
                  label: _addressLabel,
                  controller: _addressController,
                  minLines: 2,
                  maxLines: 2,
                ),
                CrudFormField.textarea(
                  label: _notesLabel,
                  controller: _notesController,
                  maxLines: 3,
                ),
              ],
            ),
            CrudFormSection(
              title: _systemSectionTitle,
              column: isMobile ? 0 : 1,
              visible: customer != null,
              fields: [
                CrudFormField.custom(
                  builder: (context) => _readonlyField(
                    theme,
                    _createdAtLabel,
                    customer?.createdAt.toYMDHM ?? '-',
                  ),
                ),
                CrudFormField.custom(
                  builder: (context) => _readonlyField(
                    theme,
                    _updatedAtLabel,
                    customer?.updatedAt.toYMDHM ?? '-',
                  ),
                ),
              ],
            ),
          ];
        },
        onSave: (context, viewModel, item) => _handleSubmit(viewModel),
      ),
    );
  }
}
