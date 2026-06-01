import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/application/customer_view_model.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_detail_page.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_edit_page.dart';

/// 客户列表页视图，只负责渲染。
class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  static const CrudDeleteConfig<Customer> _deleteConfig = CrudDeleteConfig(
    title: '确认删除',
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    errorMessagePrefix: '删除失败: ',
  );

  static const CrudListConfig<Customer, CustomerViewModel> _config =
      CrudListConfig(
        searchHintText: '搜索客户名称、联系人、电话',
        emptyText: '暂无客户数据',
        emptyIcon: Icons.people_outline,
        loadItems: _loadCustomers,
        titleBuilder: _titleText,
        subtitleBuilder: _subtitleText,
        summaryChipsBuilder: _summaryChips,
        summaryFieldsBuilder: _summaryFields,
        headerActionsBuilder: _headerActions,
        rowActionsBuilder: _rowActions,
        columns: [
          CrudTableColumn(label: '客户', cellBuilder: _buildNameCell),
          CrudTableColumn(label: '联系人', cellBuilder: _buildContactCell),
          CrudTableColumn(label: '电话', cellBuilder: _buildPhoneCell),
          CrudTableColumn(label: '业务员', cellBuilder: _buildSalespersonCell),
          CrudTableColumn(label: '更新日期', cellBuilder: _buildUpdatedAtCell),
          CrudTableColumn(label: '地址', cellBuilder: _buildAddressCell),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return const CrudListPage<Customer, CustomerViewModel>(config: _config);
  }

  static Future<void> _loadCustomers(
    CustomerViewModel viewModel, {
    bool resetPage = false,
  }) {
    return viewModel.loadCustomers(resetPage: resetPage);
  }

  static Future<void> _openEditPage(
    BuildContext context,
    CustomerViewModel viewModel,
    Customer? customer,
  ) async {
    final result = await showCustomerEditDrawer(
      context,
      viewModel: viewModel,
      customer: customer,
    );
    if (result) {
      ToastUtil.showSuccess(customer == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    CustomerViewModel viewModel,
    Customer customer,
  ) {
    return confirmCrudDeletion(
      context,
      item: customer,
      onDelete: (item) => viewModel.deleteCustomer(item.id),
      config: _deleteConfig,
    );
  }

  static Future<void> _openDetailPage(BuildContext context, Customer customer) {
    return context.pushNamed<void>(
      'customers_detail',
      pathParameters: {'id': customer.id.toString()},
      extra: CustomerDetailPage(customer: customer),
    );
  }

  static List<Widget> _headerActions(
    BuildContext context,
    CustomerViewModel viewModel,
  ) {
    final permissions = PermissionUtil.snapshot(context);
    final canCreateCustomer = permissions.has('workorder.add_customer');
    final canChangeCustomer = permissions.has('workorder.change_customer');

    return [
      SizedBox(
        width: 132,
        child: AppSelect<String>(
          options: const [
            AppDropdownOption(value: '-created_at', label: '最新创建'),
            AppDropdownOption(value: 'name', label: '名称升序'),
            AppDropdownOption(value: '-name', label: '名称降序'),
            AppDropdownOption(value: 'contact_person', label: '联系人升序'),
            AppDropdownOption(value: 'phone', label: '电话升序'),
          ],
          value: viewModel.ordering ?? '-created_at',
          onChanged: (value) {
            if (value != null) viewModel.setOrdering(value);
          },
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(width: 8),
      if (canChangeCustomer)
        PageActionButton.outlined(
          onPressed: () => _handleExport(context, viewModel),
          icon: const Icon(Icons.download),
          label: '导出',
        ),
      PageActionButton.outlined(
        onPressed: () => _handleImport(context, viewModel),
        icon: const Icon(Icons.upload),
        label: '导入',
      ),
      if (canCreateCustomer)
        PageActionButton.filled(
          onPressed: () => _openEditPage(context, viewModel, null),
          icon: const Icon(Icons.add),
          label: '新建客户',
        ),
    ];
  }

  static Future<void> _handleExport(
    BuildContext context,
    CustomerViewModel viewModel,
  ) async {
    try {
      await viewModel.exportCustomers();
      if (context.mounted) {
        ToastUtil.showSuccess('导出成功');
      }
    } catch (err) {
      if (context.mounted) {
        ToastUtil.showError('导出失败: $err');
      }
    }
  }

  static Future<void> _handleImport(
    BuildContext context,
    CustomerViewModel viewModel,
  ) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );
    if (result == null || result.files.isEmpty) {
      return;
    }
    final file = result.files.first;
    if (file.bytes == null) {
      if (context.mounted) {
        ToastUtil.showError('无法读取文件');
      }
      return;
    }
    try {
      final importResult = await viewModel.importCustomers(file);
      if (context.mounted) {
        final created = importResult.createdCount ?? 0;
        final updated = importResult.updatedCount ?? 0;
        if (importResult.errorCount == 0) {
          ToastUtil.showSuccess('导入成功: 新增 $created 条, 更新 $updated 条');
        } else {
          ToastUtil.showError(
            '导入完成: 新增 $created 条, 更新 $updated 条, 失败 ${importResult.errorCount} 条',
          );
        }
      }
    } catch (err) {
      if (context.mounted) {
        ToastUtil.showError('导入失败: $err');
      }
    }
  }

  static List<RowAction> _rowActions(
    BuildContext context,
    CustomerViewModel viewModel,
    Customer customer,
  ) {
    final permissions = PermissionUtil.snapshot(context);
    final canChangeCustomer = permissions.has('workorder.change_customer');
    final canDeleteCustomer = permissions.isAdmin;

    return [
      RowAction(
        label: '详情',
        onPressed: () => _openDetailPage(context, customer),
      ),
      if (canChangeCustomer)
        RowAction(
          label: '编辑',
          onPressed: () => _openEditPage(context, viewModel, customer),
        ),
      if (canDeleteCustomer)
        RowAction(
          label: '删除',
          onPressed: () => _confirmDelete(context, viewModel, customer),
          destructive: true,
        ),
    ];
  }

  static Widget _buildNameCell(BuildContext context, Customer customer) {
    return Text(
      _titleText(customer),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  static Widget _buildContactCell(BuildContext context, Customer customer) {
    return _buildBodyText(
      context,
      AppValueFormatter.text(customer.contactPerson),
    );
  }

  static Widget _buildPhoneCell(BuildContext context, Customer customer) {
    return _buildBodyText(context, AppValueFormatter.text(customer.phone));
  }

  static Widget _buildSalespersonCell(BuildContext context, Customer customer) {
    return _buildBodyText(
      context,
      AppValueFormatter.text(customer.salespersonName),
    );
  }

  static Widget _buildUpdatedAtCell(BuildContext context, Customer customer) {
    return _buildBodyText(context, AppValueFormatter.date(customer.updatedAt));
  }

  static Widget _buildAddressCell(BuildContext context, Customer customer) {
    return _buildBodyText(context, AppValueFormatter.text(customer.address));
  }

  static Widget _buildBodyText(BuildContext context, String value) {
    return Text(value, style: Theme.of(context).textTheme.bodySmall);
  }

  static String _titleText(Customer customer) {
    return AppValueFormatter.text(customer.name);
  }

  static String _subtitleText(Customer customer) {
    final contact = customer.contactPerson?.trim();
    final phone = customer.phone?.trim();
    final parts = [
      if (contact != null && contact.isNotEmpty) contact,
      if (phone != null && phone.isNotEmpty) phone,
    ];
    if (parts.isEmpty) {
      return AppValueFormatter.empty;
    }
    return parts.join(' · ');
  }

  static List<CrudSummaryChipData> _summaryChips(Customer customer) {
    final chips = <CrudSummaryChipData>[];
    final salesperson = customer.salespersonName?.trim();
    if (salesperson != null && salesperson.isNotEmpty) {
      chips.add(CrudSummaryChipData(label: '业务员', value: salesperson));
    }
    chips.add(
      CrudSummaryChipData(
        label: '更新',
        value: AppValueFormatter.date(customer.updatedAt),
      ),
    );
    return chips;
  }

  static List<CrudSummaryFieldData> _summaryFields(Customer customer) {
    return [
      CrudSummaryFieldData(
        label: '联系人',
        value: AppValueFormatter.text(customer.contactPerson),
      ),
      CrudSummaryFieldData(
        label: '电话',
        value: AppValueFormatter.text(customer.phone),
      ),
      CrudSummaryFieldData(
        label: '邮箱',
        value: AppValueFormatter.text(customer.email),
      ),
      CrudSummaryFieldData(
        label: '业务员',
        value: AppValueFormatter.text(customer.salespersonName),
      ),
      CrudSummaryFieldData(
        label: '更新日期',
        value: AppValueFormatter.date(customer.updatedAt),
      ),
      CrudSummaryFieldData(
        label: '地址',
        value: AppValueFormatter.text(customer.address),
      ),
      CrudSummaryFieldData(
        label: '备注',
        value: AppValueFormatter.text(customer.notes),
      ),
    ];
  }

  static String _buildDeleteSummary(Customer customer) {
    return '即将删除客户 ${_titleText(customer)}。删除后，相关业务单据再按该客户回溯会变得困难。';
  }

  static List<String> _buildDeleteImpacts(Customer customer) {
    return [
      if ((customer.contactPerson ?? '').trim().isNotEmpty)
        '联系人：${customer.contactPerson!.trim()}',
      '如已有客户订单、施工单或财务记录引用，删除可能失败或需要额外清理',
      '删除后不能直接恢复，建议先确认该客户是否仍在历史单据中使用',
    ];
  }

  static String _buildDeleteAuditHint(Customer customer) {
    return '如果只是停用合作，优先考虑保留客户资料并停止新增业务，而不是直接删除。';
  }
}
