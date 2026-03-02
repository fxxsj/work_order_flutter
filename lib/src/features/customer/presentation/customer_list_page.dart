import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/features/customer/application/customer_view_model.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_repository_impl.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_edit_page.dart';
import 'package:work_order_app/src/features/customer/presentation/widgets/customer_list_tile.dart';

/// 客户列表页入口，负责注入依赖并渲染列表视图。
class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CustomerRepository>(
          create: (_) => CustomerRepositoryImpl(CustomerApiService()),
        ),
        ChangeNotifierProvider<CustomerViewModel>(
          create: (context) => CustomerViewModel(
            context.read<CustomerRepository>(),
          )..initialize(),
        ),
      ],
      child: const _CustomerListView(),
    );
  }
}

class _CustomerListView extends StatefulWidget {
  const _CustomerListView();

  @override
  State<_CustomerListView> createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<_CustomerListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = 12;

  static const String _titleText = '客户管理';
  static const String _createButtonText = '新建客户';
  static const String _searchHintText = '搜索客户名称、联系人、电话';
  static const String _searchButtonText = '搜索';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无客户数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除客户 \"{name}\" 吗？此操作不可恢复。';
  static const String _cancelText = '取消';
  static const String _deleteText = '删除';
  static const String _clearText = '清空';
  static const String _deleteSuccessText = '删除成功';
  static const String _deleteFailedText = '删除失败: ';
  static const String _createSuccessText = '创建成功';
  static const String _updateSuccessText = '更新成功';

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

  Future<void> _openEditPage(BuildContext context, CustomerViewModel viewModel, Customer? customer) async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(customer == null ? _createSuccessText : _updateSuccessText)),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, CustomerViewModel viewModel, Customer customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(_deleteDialogContent.replaceFirst('{name}', customer.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(_cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(_deleteText),
          ),
        ],
      ),
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
    final theme = Theme.of(context);

    return Consumer<CustomerViewModel>(
      builder: (context, viewModel, _) {
        final customers = viewModel.customers;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _titleText,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openEditPage(context, viewModel, null),
                  icon: const Icon(Icons.add),
                  label: const Text(_createButtonText),
                ),
              ],
            ),
            const SizedBox(height: _spacingSm),
            Wrap(
              spacing: _spacingSm,
              runSpacing: _spacingSm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: _searchWidth,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _scheduleSearch(viewModel),
                    onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
                    decoration: InputDecoration(
                      hintText: _searchHintText,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: _clearText,
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _searchController.clear();
                                _scheduleSearch(viewModel, immediate: true);
                                setState(() {});
                              },
                            ),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _scheduleSearch(viewModel, immediate: true),
                  icon: const Icon(Icons.search),
                  label: const Text(_searchButtonText),
                ),
                TextButton.icon(
                  onPressed: () => viewModel.loadCustomers(resetPage: true),
                  icon: const Icon(Icons.refresh),
                  label: const Text(_refreshButtonText),
                ),
              ],
            ),
            const SizedBox(height: _spacingSm),
            if (viewModel.loading && customers.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (viewModel.errorMessage != null && !viewModel.loading)
              _ErrorState(
                message: viewModel.errorMessage ?? _errorFallbackText,
                onRetry: () => viewModel.loadCustomers(resetPage: true),
              )
            else if (!viewModel.loading && customers.isEmpty)
              const _EmptyState()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return CustomerListTile(
                      customer: customer,
                      onTap: () => _openEditPage(context, viewModel, customer),
                      onDelete: () => _confirmDelete(context, viewModel, customer),
                    );
                  },
                ),
            if (viewModel.total > 0) ...[
              const SizedBox(height: _spacingSm),
              _PaginationBar(viewModel: viewModel),
            ],
          ],
        );
      },
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.viewModel});

  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final CustomerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          _pageInfoTemplate
              .replaceFirst('{page}', viewModel.page.toString())
              .replaceFirst('{total}', viewModel.totalPages.toString())
              .replaceFirst('{count}', viewModel.total.toString()),
          style: theme.textTheme.bodySmall,
        ),
        const Spacer(),
        DropdownButton<int>(
          value: viewModel.pageSize,
          items: viewModel.pageSizeOptions
              .map(
                (size) => DropdownMenuItem<int>(
                  value: size,
                  child: Text(_pageSizeLabel.replaceFirst('{size}', size.toString())),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            viewModel.setPageSize(value);
          },
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: viewModel.hasPrev ? () => viewModel.setPage(viewModel.page - 1) : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text('${viewModel.page}'),
        IconButton(
          onPressed: viewModel.hasNext ? () => viewModel.setPage(viewModel.page + 1) : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  static const double _verticalPadding = 32;
  static const double _borderRadius = 12;
  static const double _iconSize = 36;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: theme.colorScheme.primary.withOpacity(0.05),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _CustomerListViewState._spacingSm),
          Text(_CustomerListViewState._emptyText, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  static const double _verticalPadding = 32;
  static const double _borderRadius = 12;
  static const double _iconSize = 32;

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: theme.colorScheme.error.withOpacity(0.06),
        border: Border.all(color: theme.colorScheme.error.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: _iconSize),
          const SizedBox(height: _CustomerListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _CustomerListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_CustomerListViewState._retryText),
          ),
        ],
      ),
    );
  }
}
