import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/features/customer/application/customer_view_model.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_edit_page.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/risk_action_dialog.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_repository_impl.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';

/// 客户列表入口。
class CustomerListEntry extends StatelessWidget {
  const CustomerListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<CustomerApiService, CustomerRepository,
        CustomerViewModel>(
      createService: (context) => CustomerApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          CustomerRepositoryImpl(context.read<CustomerApiService>()),
      createViewModel: (context) =>
          CustomerViewModel(context.read<CustomerRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const CustomerListPage(),
    );
  }
}

/// 客户列表页视图，只负责渲染。
class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) => const _CustomerListView();
}

class _CustomerListView extends StatefulWidget {
  const _CustomerListView();

  @override
  State<_CustomerListView> createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<_CustomerListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 300;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const String _emptyCellText = '-';

  static const String _createButtonText = '新建客户';
  static const String _searchHintText = '搜索客户名称、联系人、电话';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无客户数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteSuccessText = '删除成功';
  static const String _deleteFailedText = '删除失败: ';
  static const String _createSuccessText = '创建成功';
  static const String _updateSuccessText = '更新成功';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(CustomerViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadCustomers(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadCustomers(resetPage: true);
    });
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String _pageInfoText(CustomerViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  Future<void> _openEditPage(BuildContext context, CustomerViewModel viewModel,
      Customer? customer) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: CustomerEditPage(customer: customer),
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ToastUtil.showSuccess(
          customer == null ? _createSuccessText : _updateSuccessText);
    }
  }

  Future<void> _confirmDelete(BuildContext context, CustomerViewModel viewModel,
      Customer customer) async {
    final confirmed = await showRiskActionConfirmDialog(
      context,
      title: _deleteDialogTitle,
      summary: '即将删除客户 ${customer.name}。删除后，相关业务单据再按该客户回溯会变得困难。',
      impacts: [
        if ((customer.contactPerson ?? '').trim().isNotEmpty)
          '联系人：${customer.contactPerson!.trim()}',
        '如已有客户订单、施工单或财务记录引用，删除可能失败或需要额外清理',
        '删除后不能直接恢复，建议先确认该客户是否仍在历史单据中使用',
      ],
      auditHint: '如果只是停用合作，优先考虑保留客户资料并停止新增业务，而不是直接删除。',
      confirmText: '确认删除',
      destructive: true,
    );
    if (confirmed != true) return;

    try {
      await viewModel.deleteCustomer(customer.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(_deleteSuccessText)),
      );
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_deleteFailedText$err')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<CustomerViewModel>(
      builder: (context, viewModel, _) {
        final customers = viewModel.customers;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(
            context,
            viewModel,
            isMobile,
          ),
          body: _buildListBody(context, viewModel, customers, isMobile),
          footer: viewModel.totalPages > 1
              ? ResponsivePaginationBar(
                  infoText: _pageInfoText(viewModel),
                  page: viewModel.page,
                  pageSize: viewModel.pageSize,
                  pageSizeOptions: viewModel.pageSizeOptions,
                  onPageSizeChanged: viewModel.setPageSize,
                  onPrev: () => viewModel.setPage(viewModel.page - 1),
                  onNext: () => viewModel.setPage(viewModel.page + 1),
                  hasPrev: viewModel.hasPrev,
                  hasNext: viewModel.hasNext,
                  pageSizeLabelBuilder: (size) =>
                      _pageSizeLabel.replaceFirst('{size}', size.toString()),
                )
              : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    CustomerViewModel viewModel,
    List<Customer> customers,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && customers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadCustomers(resetPage: true),
      );
    }
    if (!viewModel.loading && customers.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.people_outline,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, customers);
    }

    return ListView.separated(
      itemCount: customers.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final customer = customers[index];
        return _buildSummaryCard(context, viewModel, customer, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    CustomerViewModel viewModel,
    List<Customer> customers,
  ) {
    final canChangeCustomer =
        PermissionUtil.hasPermission(context, 'workorder.change_customer');
    final canDeleteCustomer =
        PermissionUtil.hasPermission(context, 'workorder.delete_customer');
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('客户')),
        DataColumn(label: Text('联系人')),
        DataColumn(label: Text('电话')),
        DataColumn(label: Text('业务员')),
        DataColumn(label: Text('更新日期')),
        DataColumn(label: Text('地址')),
        DataColumn(label: Text('操作')),
      ],
      rows: customers
          .map(
            (customer) => DataRow(
              cells: [
                DataCell(Text(
                  customer.name.isNotEmpty ? customer.name : _emptyCellText,
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(Text(
                  customer.contactPerson?.trim().isNotEmpty == true
                      ? customer.contactPerson!.trim()
                      : _emptyCellText,
                  style: textStyle,
                )),
                DataCell(Text(
                  customer.phone?.trim().isNotEmpty == true
                      ? customer.phone!.trim()
                      : _emptyCellText,
                  style: textStyle,
                )),
                DataCell(Text(
                  customer.salespersonName?.trim().isNotEmpty == true
                      ? customer.salespersonName!.trim()
                      : _emptyCellText,
                  style: textStyle,
                )),
                DataCell(
                    Text(_formatDate(customer.updatedAt), style: textStyle)),
                DataCell(Text(
                  customer.address?.trim().isNotEmpty == true
                      ? customer.address!.trim()
                      : _emptyCellText,
                  style: textStyle,
                )),
                DataCell(RowActionGroup(
                  actions: [
                    if (canChangeCustomer)
                      RowAction(
                        label: '编辑',
                        onPressed: () =>
                            _openEditPage(context, viewModel, customer),
                      ),
                    if (canDeleteCustomer)
                      RowAction(
                        label: '删除',
                        onPressed: () =>
                            _confirmDelete(context, viewModel, customer),
                        destructive: true,
                      ),
                  ],
                )),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    CustomerViewModel viewModel,
    Customer customer,
    bool isMobile,
  ) {
    final canChangeCustomer =
        PermissionUtil.hasPermission(context, 'workorder.change_customer');
    final canDeleteCustomer =
        PermissionUtil.hasPermission(context, 'workorder.delete_customer');
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final title = customer.name.isNotEmpty ? customer.name : _emptyCellText;
    final contact = customer.contactPerson?.trim();
    final phone = customer.phone?.trim();
    final contactText = [
      if (contact != null && contact.isNotEmpty) contact,
      if (phone != null && phone.isNotEmpty) phone,
    ].join(' · ');
    final subtitle = contactText.isEmpty ? _emptyCellText : contactText;
    final salesperson = customer.salespersonName?.trim();
    final updatedAt = _formatDate(customer.updatedAt);
    final email = customer.email?.trim();
    final address = customer.address?.trim();
    final notes = customer.notes?.trim();

    return ExpandableSummaryCard(
      headerBuilder: (context, expanded) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (salesperson != null && salesperson.isNotEmpty)
                        _SummaryChip(label: '业务员', value: salesperson),
                      _SummaryChip(label: '更新', value: updatedAt),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more,
                size: 20,
                color: colors?.subtleText ?? theme.hintColor,
              ),
            ),
          ],
        );
      },
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryFieldWrap(
            isMobile: isMobile,
            children: [
              _SummaryField(label: '联系人', value: contact ?? _emptyCellText),
              _SummaryField(label: '电话', value: phone ?? _emptyCellText),
              _SummaryField(label: '邮箱', value: email ?? _emptyCellText),
              _SummaryField(label: '业务员', value: salesperson ?? _emptyCellText),
              _SummaryField(label: '更新日期', value: updatedAt),
              _SummaryField(label: '地址', value: address ?? _emptyCellText),
              _SummaryField(label: '备注', value: notes ?? _emptyCellText),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (canChangeCustomer)
                OutlinedButton.icon(
                  onPressed: () => _openEditPage(context, viewModel, customer),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('编辑'),
                ),
              if (canDeleteCustomer)
                OutlinedButton.icon(
                  onPressed: () => _confirmDelete(context, viewModel, customer),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('删除'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    CustomerViewModel viewModel,
    bool isMobile,
  ) {
    final canCreateCustomer =
        PermissionUtil.hasPermission(context, 'workorder.add_customer');
    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final searchField = ListSearchField(
            controller: _searchController,
            hintText: _searchHintText,
            height: PageActionStyle.height,
            width: isMobile ? constraints.maxWidth : _searchWidth,
            onChanged: (_) => _scheduleSearch(viewModel),
            onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
            onClear: () {
              _searchController.clear();
              _scheduleSearch(viewModel, immediate: true);
            },
          );

          final actions = <Widget>[
            PageActionButton.outlined(
              onPressed: () => viewModel.loadCustomers(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            if (canCreateCustomer)
              PageActionButton.filled(
                onPressed: () => _openEditPage(context, viewModel, null),
                icon: const Icon(Icons.add),
                label: _createButtonText,
              ),
          ];

          return ListToolbar(
            isMobile: isMobile,
            searchField: searchField,
            actions: actions,
            spacing: _spacingSm,
          );
        },
      ),
    );
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
