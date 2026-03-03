import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/features/customer/application/customer_view_model.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_edit_page.dart';
import 'package:work_order_app/src/features/customer/presentation/widgets/customer_list_tile.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_repository_impl.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';

/// 客户列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class CustomerListEntry extends StatefulWidget {
  const CustomerListEntry({super.key});

  @override
  State<CustomerListEntry> createState() => _CustomerListEntryState();
}

class _CustomerListEntryState extends State<CustomerListEntry> {
  CustomerApiService? _apiService;
  CustomerRepositoryImpl? _repository;
  CustomerViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = CustomerApiService(apiClient);
    _repository = CustomerRepositoryImpl(_apiService!);
    _viewModel = CustomerViewModel(_repository!);
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _viewModel?.initialize();
      });
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = _apiService;
    final repository = _repository;
    final viewModel = _viewModel;
    if (apiService == null || repository == null || viewModel == null) {
      return const SizedBox.shrink();
    }
    return MultiProvider(
      providers: [
        Provider<CustomerApiService>.value(value: apiService),
        Provider<CustomerRepository>.value(value: repository),
        ChangeNotifierProvider<CustomerViewModel>.value(value: viewModel),
      ],
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
  static const double _searchWidth = 320;
  static const double _spacingSm = 12;
  static const double _controlHeight = 40;

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
    final isMobile = MediaQuery.sizeOf(context).width < 720;

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
                FilledButton.icon(
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
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (context, value, _) {
                      return TextField(
                        controller: _searchController,
                        onChanged: (_) => _scheduleSearch(viewModel),
                        onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
                        decoration: InputDecoration(
                          hintText: _searchHintText,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: value.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: _clearText,
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _searchController.clear();
                                    _scheduleSearch(viewModel, immediate: true);
                                  },
                                ),
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: _controlHeight,
                  child: OutlinedButton.icon(
                    onPressed: () => _scheduleSearch(viewModel, immediate: true),
                    icon: const Icon(Icons.search, size: 18),
                    label: const Text(_searchButtonText),
                  ),
                ),
                SizedBox(
                  height: _controlHeight,
                  child: OutlinedButton.icon(
                    onPressed: () => viewModel.loadCustomers(resetPage: true),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text(_refreshButtonText),
                  ),
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
                    useCard: isMobile,
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
    final info = _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(info, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            const SizedBox(width: 8),
            IconButton(
              onPressed: viewModel.hasPrev ? () => viewModel.setPage(viewModel.page - 1) : null,
              icon: const Icon(Icons.chevron_left),
            ),
            Text('${viewModel.page}', style: theme.textTheme.bodyMedium),
            IconButton(
              onPressed: viewModel.hasNext ? () => viewModel.setPage(viewModel.page + 1) : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
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
