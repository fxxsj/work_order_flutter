import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_dto.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_list_tile.dart';

/// 施工单列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class WorkOrderListEntry extends StatefulWidget {
  const WorkOrderListEntry({super.key});

  @override
  State<WorkOrderListEntry> createState() => _WorkOrderListEntryState();
}

class _WorkOrderListEntryState extends State<WorkOrderListEntry> {
  WorkOrderApiService? _apiService;
  WorkOrderRepositoryImpl? _repository;
  WorkOrderViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = WorkOrderApiService(apiClient);
    _repository = WorkOrderRepositoryImpl(_apiService!);
    _viewModel = WorkOrderViewModel(_repository!);
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
        Provider<WorkOrderApiService>.value(value: apiService),
        Provider<WorkOrderRepository>.value(value: repository),
        ChangeNotifierProvider<WorkOrderViewModel>.value(value: viewModel),
      ],
      child: const WorkOrderListPage(),
    );
  }
}

/// 施工单列表页视图，只负责渲染。
class WorkOrderListPage extends StatelessWidget {
  const WorkOrderListPage({super.key});

  @override
  Widget build(BuildContext context) => const _WorkOrderListView();
}

class _WorkOrderListView extends StatefulWidget {
  const _WorkOrderListView();

  @override
  State<_WorkOrderListView> createState() => _WorkOrderListViewState();
}

class _WorkOrderListViewState extends State<_WorkOrderListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = 8;
  static const double _controlHeight = PageActionStyle.height;
  static const double _controlRadius = PageActionStyle.radius;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索订单号/客户/产品';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建施工单';
  static const String _emptyText = '暂无施工单数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _breadcrumbSeparator = ' / ';
  static const String _resetButtonText = '重置筛选';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除施工单 "{name}" 吗？此操作不可恢复。';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _denseTable = false;
  final GlobalKey _columnsMenuKey = GlobalKey();
  final Set<_WorkOrderColumn> _visibleColumns = {
    _WorkOrderColumn.orderNumber,
    _WorkOrderColumn.customer,
    _WorkOrderColumn.product,
    _WorkOrderColumn.status,
    _WorkOrderColumn.approval,
    _WorkOrderColumn.deliveryDate,
    _WorkOrderColumn.progress,
    _WorkOrderColumn.totalAmount,
    _WorkOrderColumn.actions,
  };
  String? _statusFilter;
  String? _priorityFilter;
  String? _approvalStatusFilter;
  int? _customerFilterId;
  int? _productFilterId;
  int? _processFilterId;

  bool _loadingOptions = false;
  List<Customer> _customers = [];
  List<ProductOption> _products = [];
  List<Process> _processes = [];

  @override
  void initState() {
    super.initState();
    _loadFilterOptions();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(WorkOrderViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadWorkOrders(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadWorkOrders(resetPage: true);
    });
  }

  void _applyFilters(WorkOrderViewModel viewModel) {
    viewModel
      ..setStatusFilter(_statusFilter)
      ..setPriorityFilter(_priorityFilter)
      ..setApprovalStatusFilter(_approvalStatusFilter)
      ..setCustomerFilterId(_customerFilterId)
      ..setProductFilterId(_productFilterId)
      ..setProcessFilterId(_processFilterId);
    viewModel.loadWorkOrders(resetPage: true);
  }

  void _resetFilters(WorkOrderViewModel viewModel) {
    _searchController.clear();
    _statusFilter = null;
    _priorityFilter = null;
    _approvalStatusFilter = null;
    _customerFilterId = null;
    _productFilterId = null;
    _processFilterId = null;
    viewModel.setSearchText('');
    _applyFilters(viewModel);
  }

  Future<void> _loadFilterOptions() async {
    setState(() => _loadingOptions = true);
    try {
      final apiClient = context.read<ApiClient>();
      final customerApi = CustomerApiService(apiClient);
      final productApi = ProductApiService(apiClient);
      final processApi = ProcessApiService(apiClient);
      final results = await Future.wait([
        customerApi.fetchCustomers(page: 1, pageSize: 200),
        productApi.fetchProducts(pageSize: 200, isActive: true),
        processApi.fetchProcesses(page: 1, pageSize: 200),
      ]);
      final customerPage = results[0] as CustomerPageDto;
      final productOptions = results[1] as List<ProductOption>;
      final processPage = results[2] as ProcessPageDto;
      if (!mounted) return;
      setState(() {
        _customers = customerPage.items.map<Customer>((item) => item.toEntity()).toList();
        _products = productOptions;
        _processes = processPage.items.map<Process>((item) => item.toEntity()).toList();
      });
    } catch (err) {
      ToastUtil.showError('加载筛选项失败: $err');
    } finally {
      if (mounted) setState(() => _loadingOptions = false);
    }
  }

  void _openColumnsMenu(BuildContext context) {
    final menuContext = _columnsMenuKey.currentContext;
    final renderBox = menuContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final overlay = Overlay.of(menuContext!, rootOverlay: true).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(Offset.zero, ancestor: overlay),
        renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<_WorkOrderColumn>(
      context: menuContext,
      position: position,
      items: _workOrderOptionalColumns.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_WorkOrderColumn>(
          value: value,
          checked: checked,
          child: Text(value.label),
          onTap: () {
            setState(() {
              if (checked && _visibleColumns.length > 2) {
                _visibleColumns.remove(value);
              } else {
                _visibleColumns.add(value);
              }
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<WorkOrderViewModel>(
      builder: (context, viewModel, _) {
        final workOrders = viewModel.workOrders;
        _statusFilter = viewModel.statusFilter;
        _priorityFilter = viewModel.priorityFilter;
        _approvalStatusFilter = viewModel.approvalStatusFilter;
        _customerFilterId = viewModel.customerFilterId;
        _productFilterId = viewModel.productFilterId;
        _processFilterId = viewModel.processFilterId;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, workOrders, isMobile),
          footer: viewModel.total > 0 ? _PaginationBar(viewModel: viewModel) : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    WorkOrderViewModel viewModel,
    List<WorkOrder> workOrders,
    bool isMobile,
  ) {
    if (viewModel.loading && workOrders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadWorkOrders(resetPage: true),
      );
    }
    if (!viewModel.loading && workOrders.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.separated(
        itemCount: workOrders.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final workOrder = workOrders[index];
          return WorkOrderListTile(
            workOrder: workOrder,
            onTap: () => context.go('/workorders/${workOrder.id}'),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(context, viewModel, workOrders);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                columnSpacing: _denseTable ? 16 : 24,
                horizontalMargin: _denseTable ? 12 : 16,
                headingRowHeight: _denseTable ? 38 : 44,
                dataRowMinHeight: _denseTable ? 34 : 40,
                dataRowMaxHeight: _denseTable ? 44 : 52,
                columns: columns,
                rows: rows,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    WorkOrderViewModel viewModel,
    List<String> breadcrumb,
    bool isMobile,
  ) {
    final statusItems = const [
      DropdownMenuItem(value: 'pending', child: Text('待开始')),
      DropdownMenuItem(value: 'in_progress', child: Text('进行中')),
      DropdownMenuItem(value: 'paused', child: Text('已暂停')),
      DropdownMenuItem(value: 'completed', child: Text('已完成')),
      DropdownMenuItem(value: 'cancelled', child: Text('已取消')),
    ];
    final priorityItems = const [
      DropdownMenuItem(value: 'low', child: Text('低')),
      DropdownMenuItem(value: 'normal', child: Text('普通')),
      DropdownMenuItem(value: 'high', child: Text('高')),
      DropdownMenuItem(value: 'urgent', child: Text('紧急')),
    ];
    final approvalItems = const [
      DropdownMenuItem(value: 'pending', child: Text('待审核')),
      DropdownMenuItem(value: 'approved', child: Text('已通过')),
      DropdownMenuItem(value: 'rejected', child: Text('已拒绝')),
    ];

    final customerItems = [
      const DropdownMenuItem<int?>(value: null, child: Text('全部客户')),
      ..._customers.map(
        (item) => DropdownMenuItem<int?>(
          value: item.id,
          child: Text(item.name),
        ),
      ),
    ];
    final productItems = [
      const DropdownMenuItem<int?>(value: null, child: Text('全部产品')),
      ..._products.map(
        (item) => DropdownMenuItem<int?>(
          value: item.id,
          child: Text(item.displayLabel),
        ),
      ),
    ];
    final processItems = [
      const DropdownMenuItem<int?>(value: null, child: Text('全部工序')),
      ..._processes.map(
        (item) => DropdownMenuItem<int?>(
          value: item.id,
          child: Text(item.name),
        ),
      ),
    ];

    return PageHeaderBar(
      breadcrumb: breadcrumb.isEmpty ? null : breadcrumb.join(_breadcrumbSeparator),
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final searchField = SizedBox(
            width: isMobile ? constraints.maxWidth : _searchWidth,
            child: SizedBox(
              height: _controlHeight,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, _) {
                  return TextField(
                    controller: _searchController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (_) => _scheduleSearch(viewModel),
                    onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
                    decoration: InputDecoration(
                      constraints: const BoxConstraints.tightFor(height: _controlHeight),
                      hintText: _searchHintText,
                      prefixIcon: const Icon(Icons.search, size: 18),
                      suffixIcon: value.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: '清空',
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                _scheduleSearch(viewModel, immediate: true);
                              },
                            ),
                      border: const OutlineInputBorder(),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                  );
                },
              ),
            ),
          );

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                searchField,
                const SizedBox(height: _spacingSm),
                if (_loadingOptions)
                  const LinearProgressIndicator(minHeight: 2),
                DropdownButtonFormField<String>(
                  value: _statusFilter,
                  decoration: const InputDecoration(labelText: '状态', border: OutlineInputBorder()),
                  items: statusItems,
                  onChanged: (value) {
                    setState(() => _statusFilter = value);
                    _applyFilters(viewModel);
                  },
                ),
                const SizedBox(height: _spacingSm),
                DropdownButtonFormField<String>(
                  value: _priorityFilter,
                  decoration: const InputDecoration(labelText: '优先级', border: OutlineInputBorder()),
                  items: priorityItems,
                  onChanged: (value) {
                    setState(() => _priorityFilter = value);
                    _applyFilters(viewModel);
                  },
                ),
                const SizedBox(height: _spacingSm),
                DropdownButtonFormField<String>(
                  value: _approvalStatusFilter,
                  decoration: const InputDecoration(labelText: '审核状态', border: OutlineInputBorder()),
                  items: approvalItems,
                  onChanged: (value) {
                    setState(() => _approvalStatusFilter = value);
                    _applyFilters(viewModel);
                  },
                ),
                const SizedBox(height: _spacingSm),
                DropdownButtonFormField<int?>(
                  value: _customerFilterId,
                  decoration: const InputDecoration(labelText: '客户', border: OutlineInputBorder()),
                  items: customerItems,
                  onChanged: (value) {
                    setState(() => _customerFilterId = value);
                    _applyFilters(viewModel);
                  },
                ),
                const SizedBox(height: _spacingSm),
                DropdownButtonFormField<int?>(
                  value: _productFilterId,
                  decoration: const InputDecoration(labelText: '产品', border: OutlineInputBorder()),
                  items: productItems,
                  onChanged: (value) {
                    setState(() => _productFilterId = value);
                    _applyFilters(viewModel);
                  },
                ),
                const SizedBox(height: _spacingSm),
                DropdownButtonFormField<int?>(
                  value: _processFilterId,
                  decoration: const InputDecoration(labelText: '工序', border: OutlineInputBorder()),
                  items: processItems,
                  onChanged: (value) {
                    setState(() => _processFilterId = value);
                    _applyFilters(viewModel);
                  },
                ),
                const SizedBox(height: _spacingSm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PageActionButton.outlined(
                      onPressed: () => viewModel.loadWorkOrders(resetPage: true),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: _refreshButtonText,
                    ),
                    const SizedBox(width: _spacingSm),
                    PageActionButton.outlined(
                      onPressed: () => _resetFilters(viewModel),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: _resetButtonText,
                    ),
                    const SizedBox(width: _spacingSm),
                    PageActionButton.filled(
                      onPressed: () => context.go('/workorders/create'),
                      icon: const Icon(Icons.add),
                      label: _createButtonText,
                    ),
                  ],
                ),
              ],
            );
          }

          return Wrap(
            spacing: _spacingSm,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              searchField,
              if (_loadingOptions)
                const SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String>(
                  value: _statusFilter,
                  decoration: const InputDecoration(labelText: '状态', border: OutlineInputBorder()),
                  items: statusItems,
                  onChanged: (value) {
                    setState(() => _statusFilter = value);
                    _applyFilters(viewModel);
                  },
                ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String>(
                  value: _priorityFilter,
                  decoration: const InputDecoration(labelText: '优先级', border: OutlineInputBorder()),
                  items: priorityItems,
                  onChanged: (value) {
                    setState(() => _priorityFilter = value);
                    _applyFilters(viewModel);
                  },
                ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String>(
                  value: _approvalStatusFilter,
                  decoration: const InputDecoration(labelText: '审核状态', border: OutlineInputBorder()),
                  items: approvalItems,
                  onChanged: (value) {
                    setState(() => _approvalStatusFilter = value);
                    _applyFilters(viewModel);
                  },
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<int?>(
                  value: _customerFilterId,
                  decoration: const InputDecoration(labelText: '客户', border: OutlineInputBorder()),
                  items: customerItems,
                  onChanged: (value) {
                    setState(() => _customerFilterId = value);
                    _applyFilters(viewModel);
                  },
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<int?>(
                  value: _productFilterId,
                  decoration: const InputDecoration(labelText: '产品', border: OutlineInputBorder()),
                  items: productItems,
                  onChanged: (value) {
                    setState(() => _productFilterId = value);
                    _applyFilters(viewModel);
                  },
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<int?>(
                  value: _processFilterId,
                  decoration: const InputDecoration(labelText: '工序', border: OutlineInputBorder()),
                  items: processItems,
                  onChanged: (value) {
                    setState(() => _processFilterId = value);
                    _applyFilters(viewModel);
                  },
                ),
              ),
              PageActionButton.outlined(
                onPressed: () => viewModel.loadWorkOrders(resetPage: true),
                icon: const Icon(Icons.refresh, size: 16),
                label: _refreshButtonText,
              ),
              PageActionButton.outlined(
                onPressed: () => _resetFilters(viewModel),
                icon: const Icon(Icons.refresh, size: 16),
                label: _resetButtonText,
              ),
              PageActionButton.outlined(
                onPressed: () => setState(() => _denseTable = !_denseTable),
                icon: Icon(_denseTable ? Icons.table_rows : Icons.table_chart),
                label: _denseTable ? '舒适' : '紧凑',
              ),
              SizedBox(
                key: _columnsMenuKey,
                height: _controlHeight,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_controlRadius),
                    ),
                  ),
                  onPressed: () => _openColumnsMenu(context),
                  icon: const Icon(Icons.view_column, size: 18),
                  label: const Text('列管理'),
                ),
              ),
              PageActionButton.filled(
                onPressed: () => context.go('/workorders/create'),
                icon: const Icon(Icons.add),
                label: _createButtonText,
              ),
            ],
          );
        },
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return _WorkOrderColumn.values
        .where(_visibleColumns.contains)
        .map(
          (column) => DataColumn(
            label: Text(column.label),
          ),
        )
        .toList();
  }

  List<DataRow> _buildRows(
    BuildContext context,
    WorkOrderViewModel viewModel,
    List<WorkOrder> workOrders,
  ) {
    return workOrders.map((workOrder) {
      final cells = _WorkOrderColumn.values
          .where(_visibleColumns.contains)
          .map((column) => DataCell(_buildCell(context, viewModel, workOrder, column)))
          .toList();
      return DataRow(
        cells: cells,
        onSelectChanged: (_) => context.go('/workorders/${workOrder.id}'),
      );
    }).toList();
  }

  Widget _buildCell(
    BuildContext context,
    WorkOrderViewModel viewModel,
    WorkOrder workOrder,
    _WorkOrderColumn column,
  ) {
    switch (column) {
      case _WorkOrderColumn.orderNumber:
        return Text(workOrder.orderNumber.isEmpty ? '施工单 #${workOrder.id}' : workOrder.orderNumber);
      case _WorkOrderColumn.customer:
        return Text(workOrder.customerName ?? _emptyCellText);
      case _WorkOrderColumn.product:
        return Text(workOrder.productName ?? _emptyCellText);
      case _WorkOrderColumn.status:
        return Text(workOrder.statusDisplay ?? workOrder.status ?? _emptyCellText);
      case _WorkOrderColumn.approval:
        return Text(workOrder.approvalStatusDisplay ?? workOrder.approvalStatus ?? _emptyCellText);
      case _WorkOrderColumn.priority:
        return Text(workOrder.priorityDisplay ?? workOrder.priority ?? _emptyCellText);
      case _WorkOrderColumn.deliveryDate:
        return Text(_formatDate(workOrder.deliveryDate));
      case _WorkOrderColumn.progress:
        final progress = workOrder.progressPercentage;
        return Text(progress == null ? _emptyCellText : '$progress%');
      case _WorkOrderColumn.totalAmount:
        return Text(_formatAmount(workOrder.totalAmount));
      case _WorkOrderColumn.actions:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: '查看',
              icon: const Icon(Icons.visibility_outlined, size: 18),
              onPressed: () => context.go('/workorders/${workOrder.id}'),
            ),
            IconButton(
              tooltip: '编辑',
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: () => context.go('/workorders/${workOrder.id}/edit'),
            ),
            IconButton(
              tooltip: '删除',
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: () => _confirmDelete(context, viewModel, workOrder),
            ),
          ],
        );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WorkOrderViewModel viewModel,
    WorkOrder workOrder,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(_deleteDialogContent.replaceFirst('{name}', workOrder.orderNumber)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('取消')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('删除')),
        ],
      ),
    );
    if (confirmed != true) return;
    await viewModel.deleteAndReload(() => viewModel.deleteWorkOrder(workOrder.id));
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatAmount(double? value) {
    if (value == null) return _emptyCellText;
    return value.toStringAsFixed(2);
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.viewModel});

  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final WorkOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final info = _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(info, style: theme.textTheme.bodySmall),
        const SizedBox(width: 12),
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
        const SizedBox(width: 4),
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
          Icon(Icons.description_outlined, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _WorkOrderListViewState._spacingSm),
          Text(_WorkOrderListViewState._emptyText, style: theme.textTheme.bodyMedium),
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
          const SizedBox(height: _WorkOrderListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _WorkOrderListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_WorkOrderListViewState._retryText),
          ),
        ],
      ),
    );
  }
}

enum _WorkOrderColumn {
  orderNumber,
  customer,
  product,
  status,
  approval,
  priority,
  deliveryDate,
  progress,
  totalAmount,
  actions,
}

const List<_WorkOrderColumn> _workOrderOptionalColumns = [
  _WorkOrderColumn.orderNumber,
  _WorkOrderColumn.customer,
  _WorkOrderColumn.product,
  _WorkOrderColumn.status,
  _WorkOrderColumn.approval,
  _WorkOrderColumn.priority,
  _WorkOrderColumn.deliveryDate,
  _WorkOrderColumn.progress,
  _WorkOrderColumn.totalAmount,
  _WorkOrderColumn.actions,
];

extension _WorkOrderColumnLabel on _WorkOrderColumn {
  String get label {
    switch (this) {
      case _WorkOrderColumn.orderNumber:
        return '订单号';
      case _WorkOrderColumn.customer:
        return '客户';
      case _WorkOrderColumn.product:
        return '产品';
      case _WorkOrderColumn.status:
        return '状态';
      case _WorkOrderColumn.approval:
        return '审核';
      case _WorkOrderColumn.priority:
        return '优先级';
      case _WorkOrderColumn.deliveryDate:
        return '交货日期';
      case _WorkOrderColumn.progress:
        return '进度';
      case _WorkOrderColumn.totalAmount:
        return '金额';
      case _WorkOrderColumn.actions:
        return '操作';
    }
  }
}
