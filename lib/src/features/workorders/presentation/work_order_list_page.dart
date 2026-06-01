import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart'
    show StatusHintChip, StatusChipVariant;
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/file_download.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_list_support_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_delete_confirm_dialog.dart';
import 'package:work_order_app/src/core/utils/debounce_controller.dart';

/// 施工单列表入口。
class WorkOrderListEntry extends StatelessWidget {
  const WorkOrderListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      WorkOrderApiService,
      WorkOrderRepository,
      WorkOrderViewModel
    >(
      createService: (context) =>
          WorkOrderApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          WorkOrderRepositoryImpl(context.read<WorkOrderApiService>()),
      createViewModel: (context) =>
          WorkOrderViewModel(context.read<WorkOrderRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
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

class _WorkOrderListViewState extends State<_WorkOrderListView>
    with SingleTickerProviderStateMixin {
  static const double _searchWidth = 320;
  static const double _spacingSm = SpacingTokens.sm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索订单号/客户/产品';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建施工单';
  static const String _emptyText = '暂无施工单数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _resetButtonText = '重置筛选';
  static const String _deleteDialogTitle = '确认删除';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  final _debounce = DebounceController();
  String? _statusFilter;
  String? _priorityFilter;
  String? _approvalStatusFilter;
  int? _customerFilterId;
  int? _productFilterId;
  int? _processFilterId;
  String _ordering = '-created_at';

  bool _loadingOptions = false;
  List<Customer> _customers = [];
  List<ProductOption> _products = [];
  List<Process> _processes = [];
  bool _exporting = false;
  WorkOrderListSupportService? _supportService;
  bool _optionsRequested = false;
  String? _routeSignature;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService ??= WorkOrderListSupportService(context.read<ApiClient>());
    if (!_optionsRequested) {
      _optionsRequested = true;
      _loadFilterOptions();
    }
    final uri = GoRouterState.of(context).uri;
    final routeSearch = uri.queryParameters['search']?.trim() ?? '';
    final routeApprovalStatus =
        uri.queryParameters['approval_status']?.trim() ?? '';
    final signature = '$routeSearch|$routeApprovalStatus';
    final hadRouteState = _routeSignature != null;
    if (_routeSignature == signature) return;
    _routeSignature = signature;
    _searchController.text = routeSearch;
    _approvalStatusFilter = routeApprovalStatus.isEmpty
        ? null
        : routeApprovalStatus;
    final hasRouteFilter =
        routeSearch.isNotEmpty || routeApprovalStatus.isNotEmpty;
    if (!hasRouteFilter && !hadRouteState) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<WorkOrderViewModel>().applyRoutePrefill(
        search: routeSearch,
        approvalStatus: routeApprovalStatus,
      );
    });
  }

  @override
  void dispose() {
    _debounce.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(WorkOrderViewModel viewModel, {bool immediate = false}) {
    _debounce.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadWorkOrders(resetPage: true);
      return;
    }
    _debounce.run(() {
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
      ..setProcessFilterId(_processFilterId)
      ..setOrdering(_ordering);
    viewModel.loadWorkOrders(resetPage: true);
  }

  Future<void> _resetFilters(WorkOrderViewModel viewModel) async {
    _searchController.clear();
    _statusFilter = null;
    _priorityFilter = null;
    _approvalStatusFilter = null;
    _customerFilterId = null;
    _productFilterId = null;
    _processFilterId = null;
    _ordering = '-created_at';
    await viewModel.resetFilters();
  }

  Future<void> _exportWorkOrders(WorkOrderViewModel viewModel) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      final params = <String, dynamic>{
        if (_searchController.text.trim().isNotEmpty)
          'search': _searchController.text.trim(),
        if (viewModel.statusFilter != null &&
            viewModel.statusFilter!.isNotEmpty)
          'status': viewModel.statusFilter,
        if (viewModel.priorityFilter != null &&
            viewModel.priorityFilter!.isNotEmpty)
          'priority': viewModel.priorityFilter,
        if (viewModel.approvalStatusFilter != null &&
            viewModel.approvalStatusFilter!.isNotEmpty)
          'approval_status': viewModel.approvalStatusFilter,
        if ((viewModel.customerFilterId ?? 0) > 0)
          'customer': viewModel.customerFilterId,
        if ((viewModel.productFilterId ?? 0) > 0)
          'product': viewModel.productFilterId,
        if ((viewModel.processFilterId ?? 0) > 0)
          'process': viewModel.processFilterId,
      };
      final result = await _supportService!.export(params);
      final savedPath = await saveBytes(
        result.bytes,
        result.filename,
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
      if (savedPath == null) {
        ToastUtil.showSuccess('导出已开始');
      } else {
        ToastUtil.showSuccess('已导出到 $savedPath');
      }
    } catch (err) {
      ToastUtil.showError('导出失败: $err');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _loadFilterOptions() async {
    setState(() => _loadingOptions = true);
    try {
      final options = await _supportService!.loadFilterOptions();
      if (!mounted) return;
      setState(() {
        _customers = options.customers;
        _products = options.products;
        _processes = options.processes;
      });
    } catch (err) {
      ToastUtil.showError('加载筛选项失败: $err');
    } finally {
      if (mounted) setState(() => _loadingOptions = false);
    }
  }

  static String _pageInfoText(WorkOrderViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Consumer<WorkOrderViewModel>(
      builder: (context, viewModel, _) {
        final workOrders = viewModel.workOrders;
        _statusFilter = viewModel.statusFilter;
        _priorityFilter = viewModel.priorityFilter;
        _approvalStatusFilter = viewModel.approvalStatusFilter;
        _customerFilterId = viewModel.customerFilterId;
        _productFilterId = viewModel.productFilterId;
        _processFilterId = viewModel.processFilterId;
        _ordering = viewModel.ordering;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, workOrders, isMobile),
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
    WorkOrderViewModel viewModel,
    List<WorkOrder> workOrders,
    bool isMobile,
  ) {
    final permissions = PermissionUtil.snapshot(context);
    final canChangeWorkOrder = permissions.has('workorder.change_workorder');
    final canDeleteWorkOrder = permissions.has('workorder.delete_workorder');
    final sectionSpacing = LayoutTokens.sectionSpacing(context);

    if (viewModel.loading && workOrders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadWorkOrders(resetPage: true),
      );
    }
    if (!viewModel.loading && workOrders.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.description_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(
        context,
        viewModel,
        workOrders,
        canChangeWorkOrder: canChangeWorkOrder,
        canDeleteWorkOrder: canDeleteWorkOrder,
      );
    }

    return ListView.separated(
      itemCount: workOrders.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final workOrder = workOrders[index];
        return _buildSummaryCard(
          context,
          workOrder,
          canChangeWorkOrder: canChangeWorkOrder,
          canDeleteWorkOrder: canDeleteWorkOrder,
        );
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    WorkOrderViewModel viewModel,
    List<WorkOrder> workOrders, {
    required bool canChangeWorkOrder,
    required bool canDeleteWorkOrder,
  }) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('施工单号')),
        DataColumn(label: Text('客户')),
        DataColumn(label: Text('产品')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('审核')),
        DataColumn(label: Text('任务')),
        DataColumn(label: Text('下一步')),
        DataColumn(label: Text('优先级')),
        DataColumn(label: Text('交货日期')),
        DataColumn(label: Text('金额')),
        DataColumn(label: Text('进度')),
        DataColumn(label: Text('负责人')),
        DataColumn(label: Text('业务员')),
        DataColumn(label: Text('数量')),
        DataColumn(label: Text('操作')),
      ],
      rows: workOrders
          .map(
            (workOrder) => DataRow(
              cells: [
                DataCell(
                  InkWell(
                    onTap: () => context.go('/workorders/${workOrder.id}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        workOrder.orderNumber.isEmpty
                            ? '施工单 #${workOrder.id}'
                            : workOrder.orderNumber,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    workOrder.customerName ?? _emptyCellText,
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(
                    workOrder.productName ?? _emptyCellText,
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(
                    workOrder.statusDisplay ??
                        workOrder.status ??
                        _emptyCellText,
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(
                    workOrder.approvalStatusDisplay ??
                        workOrder.approvalStatus ??
                        _emptyCellText,
                    style: textStyle,
                  ),
                ),
                DataCell(Text(_taskSummaryText(workOrder), style: textStyle)),
                DataCell(Text(_followUpText(workOrder), style: textStyle)),
                DataCell(
                  Text(
                    workOrder.priorityDisplay ??
                        workOrder.priority ??
                        _emptyCellText,
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(_formatDate(workOrder.deliveryDate), style: textStyle),
                ),
                DataCell(
                  Text(_formatAmount(workOrder.totalAmount), style: textStyle),
                ),
                DataCell(
                  Text(
                    workOrder.progressPercentage == null
                        ? _emptyCellText
                        : '${workOrder.progressPercentage}%',
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(
                    workOrder.managerName ?? _emptyCellText,
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(
                    workOrder.salespersonName ?? _emptyCellText,
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(
                    _formatQuantity(workOrder.quantity, workOrder.unit),
                    style: textStyle,
                  ),
                ),
                DataCell(
                  RowActionGroup(
                    actions: [
                      if (canChangeWorkOrder)
                        RowAction(
                          label: '编辑',
                          onPressed: () =>
                              context.go('/workorders/${workOrder.id}/edit'),
                        ),
                      if (canDeleteWorkOrder)
                        RowAction(
                          label: '删除',
                          onPressed: () =>
                              _confirmDelete(context, viewModel, workOrder),
                          destructive: true,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    WorkOrder workOrder, {
    required bool canChangeWorkOrder,
    required bool canDeleteWorkOrder,
  }) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final viewModel = context.read<WorkOrderViewModel>();
    final title = workOrder.orderNumber.isEmpty
        ? '施工单 #${workOrder.id}'
        : workOrder.orderNumber;
    final customer = workOrder.customerName ?? _emptyCellText;
    final product = workOrder.productName ?? _emptyCellText;
    final status =
        (workOrder.approvalStatus != null &&
            [
              'draft',
              'submitted',
              'rejected',
            ].contains(workOrder.approvalStatus))
        ? (workOrder.approvalStatusDisplay ??
              workOrder.approvalStatus ??
              _emptyCellText)
        : (workOrder.statusDisplay ?? workOrder.status ?? _emptyCellText);
    final priority =
        workOrder.priorityDisplay ?? workOrder.priority ?? _emptyCellText;
    final deliveryDate = _formatDate(workOrder.deliveryDate);
    final amount = _formatAmount(workOrder.totalAmount);
    final progress = workOrder.progressPercentage == null
        ? _emptyCellText
        : '${workOrder.progressPercentage}%';
    final taskSummary = _taskSummaryText(workOrder);
    final followUp = _followUpText(workOrder);
    final sectionSpacing = LayoutTokens.sectionSpacing(context);

    return ExpandableSummaryCard(
      headerBuilder: (context, expanded) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => context.go('/workorders/${workOrder.id}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    '$customer · $product',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '状态', value: status),
                      _SummaryChip(label: '任务', value: taskSummary),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors?.sidebarText,
                  ),
                ),
                SizedBox(height: sectionSpacing),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0.0,
                  duration: AnimationTokens.expandDuration,
                  child: Icon(
                    Icons.expand_more,
                    size: 20,
                    color: colors?.subtleText ?? theme.hintColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMobileFields(
            context,
            workOrder,
            deliveryDate: deliveryDate,
            progress: progress,
            taskSummary: taskSummary,
            followUp: followUp,
            priority: priority,
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (canChangeWorkOrder)
                OutlinedButton.icon(
                  onPressed: () =>
                      context.go('/workorders/${workOrder.id}/edit'),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('编辑'),
                ),
              if (canDeleteWorkOrder)
                OutlinedButton.icon(
                  onPressed: () =>
                      _confirmDelete(context, viewModel, workOrder),
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
    WorkOrderViewModel viewModel,
    bool isMobile,
  ) {
    final permissions = PermissionUtil.snapshot(context);
    final canCreateWorkOrder = permissions.has('workorder.add_workorder');
    final statusItems = const [
      AppDropdownOption(value: 'pending', label: '待开始'),
      AppDropdownOption(value: 'in_progress', label: '进行中'),
      AppDropdownOption(value: 'paused', label: '已暂停'),
      AppDropdownOption(value: 'completed', label: '已完成'),
      AppDropdownOption(value: 'cancelled', label: '已取消'),
    ];
    final priorityItems = const [
      AppDropdownOption(value: 'low', label: '低'),
      AppDropdownOption(value: 'normal', label: '普通'),
      AppDropdownOption(value: 'high', label: '高'),
      AppDropdownOption(value: 'urgent', label: '紧急'),
    ];
    final approvalItems = const [
      AppDropdownOption(value: 'draft', label: '草稿'),
      AppDropdownOption(value: 'submitted', label: '待审核'),
      AppDropdownOption(value: 'approved', label: '已通过'),
      AppDropdownOption(value: 'rejected', label: '已拒绝'),
    ];
    final orderingItems = const [
      AppDropdownOption(value: '-created_at', label: '最新创建'),
      AppDropdownOption(value: 'created_at', label: '最早创建'),
      AppDropdownOption(value: 'order_number', label: '单号升序'),
      AppDropdownOption(value: '-order_number', label: '单号降序'),
      AppDropdownOption(value: 'customer__name', label: '客户升序'),
      AppDropdownOption(value: '-customer__name', label: '客户降序'),
      AppDropdownOption(value: 'priority', label: '优先级升序'),
      AppDropdownOption(value: '-priority', label: '优先级降序'),
      AppDropdownOption(value: 'delivery_date', label: '交期升序'),
      AppDropdownOption(value: '-delivery_date', label: '交期降序'),
      AppDropdownOption(value: 'total_amount', label: '金额升序'),
      AppDropdownOption(value: '-total_amount', label: '金额降序'),
    ];
    final customerItems = [
      const AppDropdownOption<int?>(value: null, label: '全部客户'),
      ..._customers.map(
        (item) => AppDropdownOption<int?>(value: item.id, label: item.name),
      ),
    ];
    final productItems = [
      const AppDropdownOption<int?>(value: null, label: '全部产品'),
      ..._products.map(
        (item) =>
            AppDropdownOption<int?>(value: item.id, label: item.displayLabel),
      ),
    ];
    final processItems = [
      const AppDropdownOption<int?>(value: null, label: '全部工序'),
      ..._processes.map(
        (item) => AppDropdownOption<int?>(value: item.id, label: item.name),
      ),
    ];

    void openFilterDrawer() {
      showAdaptiveFilterDrawer(
        context,
        isMobile: isMobile,
        child: _buildFilterPanel(
          context,
          viewModel,
          statusItems: statusItems,
          priorityItems: priorityItems,
          approvalItems: approvalItems,
          orderingItems: orderingItems,
          customerItems: customerItems,
          productItems: productItems,
          processItems: processItems,
          bottomSpacing: isMobile ? 16 : 20,
        ),
      );
    }

    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final activeFilters = _activeFilterCount();
          final pendingApprovalCount = _summaryCount(
            viewModel,
            'pending_approval_count',
            fallback: viewModel.workOrders.where((item) {
              final status = item.approvalStatus ?? '';
              return status == 'submitted';
            }).length,
          );
          final rejectedCount = _summaryCount(
            viewModel,
            'rejected_approval_count',
            fallback: viewModel.workOrders
                .where((item) => (item.approvalStatus ?? '') == 'rejected')
                .length,
          );
          final searchField = ListSearchField(
            controller: _searchController,
            hintText: _searchHintText,
            height: _controlHeight,
            width: isMobile ? constraints.maxWidth : _searchWidth,
            onChanged: (_) => _scheduleSearch(viewModel),
            onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
            onClear: () {
              _searchController.clear();
              _scheduleSearch(viewModel, immediate: true);
            },
          );

          final actions = <Widget>[
            if (pendingApprovalCount > 0)
              StatusHintChip(
                label: '待审核施工单',
                count: pendingApprovalCount,
                icon: Icons.rule_folder_outlined,
                selected: viewModel.approvalStatusFilter == 'submitted',
                onTap: () => _openQuickFilter('submitted'),
                variant: StatusChipVariant.info,
              ),
            if (rejectedCount > 0)
              StatusHintChip(
                label: '待处理退回',
                count: rejectedCount,
                selected: viewModel.approvalStatusFilter == 'rejected',
                onTap: () => _openQuickFilter('rejected'),
                variant: StatusChipVariant.warning,
              ),
            if (_hasQuickFilter(viewModel))
              OutlinedButton.icon(
                onPressed: () async {
                  await _resetFilters(viewModel);
                  if (mounted) context.go('/workorders');
                },
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: const Text('清除筛选'),
              ),
            PageActionButton.outlined(
              onPressed: () => _exportWorkOrders(viewModel),
              icon: const Icon(Icons.download_outlined, size: 16),
              label: '导出',
              loading: _exporting,
            ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadWorkOrders(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            if (canCreateWorkOrder)
              PageActionButton.filled(
                onPressed: () => context.go('/workorders/create'),
                icon: const Icon(Icons.add),
                label: _createButtonText,
              ),
            PageActionButton.outlined(
              onPressed: openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: activeFilters > 0 ? '筛选 $activeFilters' : '筛选',
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

  Widget _buildFilterPanel(
    BuildContext context,
    WorkOrderViewModel viewModel, {
    required List<AppDropdownOption<String>> statusItems,
    required List<AppDropdownOption<String>> priorityItems,
    required List<AppDropdownOption<String>> approvalItems,
    required List<AppDropdownOption<String>> orderingItems,
    required List<AppDropdownOption<int?>> customerItems,
    required List<AppDropdownOption<int?>> productItems,
    required List<AppDropdownOption<int?>> processItems,
    required double bottomSpacing,
  }) {
    return FilterPanelBody(
      bottomSpacing: bottomSpacing,
      resetLabel: _resetButtonText,
      onReset: () => _resetFilters(viewModel),
      fields: [
        if (_loadingOptions) const LinearProgressIndicator(minHeight: 2),
        AppSelect<String>(
          value: _statusFilter,
          decoration: const InputDecoration(labelText: '生产状态'),
          options: statusItems,
          onChanged: (value) {
            setState(() => _statusFilter = value);
            _applyFilters(viewModel);
          },
        ),
        AppSelect<String>(
          value: _approvalStatusFilter,
          decoration: const InputDecoration(labelText: '审核状态'),
          options: approvalItems,
          onChanged: (value) {
            setState(() => _approvalStatusFilter = value);
            _applyFilters(viewModel);
          },
        ),
        AppSelect<String>(
          value: _priorityFilter,
          decoration: const InputDecoration(labelText: '优先级'),
          options: priorityItems,
          onChanged: (value) {
            setState(() => _priorityFilter = value);
            _applyFilters(viewModel);
          },
        ),
        AppSelect<String>(
          value: _ordering,
          decoration: const InputDecoration(labelText: '排序'),
          options: orderingItems,
          onChanged: (value) {
            setState(() => _ordering = value ?? '-created_at');
            _applyFilters(viewModel);
          },
        ),
        AppSelect<int?>(
          value: _customerFilterId,
          decoration: const InputDecoration(labelText: '客户'),
          options: customerItems,
          onChanged: (value) {
            setState(() => _customerFilterId = value);
            _applyFilters(viewModel);
          },
        ),
        AppSelect<int?>(
          value: _productFilterId,
          decoration: const InputDecoration(labelText: '产品'),
          options: productItems,
          onChanged: (value) {
            setState(() => _productFilterId = value);
            _applyFilters(viewModel);
          },
        ),
        AppSelect<int?>(
          value: _processFilterId,
          decoration: const InputDecoration(labelText: '工序'),
          options: processItems,
          onChanged: (value) {
            setState(() => _processFilterId = value);
            _applyFilters(viewModel);
          },
        ),
      ],
    );
  }

  int _activeFilterCount() {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (_statusFilter != null && _statusFilter!.isNotEmpty) count += 1;
    if (_priorityFilter != null && _priorityFilter!.isNotEmpty) count += 1;
    if (_approvalStatusFilter != null && _approvalStatusFilter!.isNotEmpty)
      count += 1;
    if (_ordering != '-created_at') count += 1;
    if (_customerFilterId != null) count += 1;
    if (_productFilterId != null) count += 1;
    if (_processFilterId != null) count += 1;
    return count;
  }

  int _summaryCount(
    WorkOrderViewModel viewModel,
    String key, {
    required int fallback,
  }) {
    final summary = viewModel.summary['summary'];
    if (summary is Map<String, dynamic>) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }
    if (summary is Map) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }
    return fallback;
  }

  bool _hasQuickFilter(WorkOrderViewModel viewModel) {
    return (viewModel.approvalStatusFilter ?? '').isNotEmpty ||
        viewModel.ordering != '-created_at';
  }

  void _openQuickFilter(String approvalStatus) {
    context.go(
      Uri(
        path: '/workorders',
        queryParameters: {'approval_status': approvalStatus},
      ).toString(),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WorkOrderViewModel viewModel,
    WorkOrder workOrder,
  ) async {
    final confirmed = await showWorkOrderDeleteConfirmDialog(
      context,
      title: _deleteDialogTitle,
      number: workOrder.orderNumber,
      customerName: workOrder.customerName,
    );
    if (confirmed != true) return;
    await viewModel.deleteAndReload(
      () => viewModel.deleteWorkOrder(workOrder.id),
    );
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

  String _formatQuantity(double? value, String? unit) {
    if (value == null) return _emptyCellText;
    final formatted = value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
    final unitText = unit?.trim().isNotEmpty == true ? unit! : '';
    return unitText.isEmpty ? formatted : '$formatted $unitText';
  }

  String _taskSummaryText(WorkOrder workOrder) {
    final total = workOrder.totalTaskCount ?? 0;
    if (total <= 0) {
      return '未生成';
    }
    return '$total 项';
  }

  String _followUpText(WorkOrder workOrder) {
    final approvalStatus = workOrder.approvalStatus ?? '';
    final status = workOrder.status ?? '';
    final total = workOrder.totalTaskCount ?? 0;

    if (approvalStatus == 'submitted') {
      return '待审批后下发任务';
    }
    if (approvalStatus == 'rejected') {
      return '待修改后重提';
    }
    if (status == 'cancelled') {
      return '施工单已取消';
    }
    if (total <= 0) {
      return '任务未生成，请检查工序配置';
    }
    if (status == 'pending') {
      return '待开始生产';
    }
    if (status == 'in_progress') {
      return '跟进生产进度';
    }
    if (status == 'completed') {
      return '推进质检/入库';
    }
    return _emptyCellText;
  }

  Widget _buildMobileFields(
    BuildContext context,
    WorkOrder workOrder, {
    required String deliveryDate,
    required String progress,
    required String taskSummary,
    required String followUp,
    required String priority,
  }) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: colors?.subtleText ?? theme.hintColor,
    );
    final fields = [
      ('客户', workOrder.customerName ?? _emptyCellText),
      ('产品', workOrder.productName ?? _emptyCellText),
      ('交货日期', deliveryDate),
      ('进度', progress),
      ('任务', taskSummary),
      ('下一步', followUp),
      ('负责人', workOrder.managerName ?? _emptyCellText),
      ('业务员', workOrder.salespersonName ?? _emptyCellText),
      ('优先级', priority),
      ('数量', _formatQuantity(workOrder.quantity, workOrder.unit)),
    ];
    return Column(
      children: [
        for (int i = 0; i < fields.length; i++)
          _mobileRow(
            context,
            labelStyle,
            fields[i].$1,
            fields[i].$2,
            last: i == fields.length - 1,
          ),
      ],
    );
  }

  Widget _mobileRow(
    BuildContext context,
    TextStyle? labelStyle,
    String label,
    String value, {
    bool last = false,
  }) {
    final theme = Theme.of(context);
    final spacing = LayoutTokens.sectionSpacing(context) * 0.6;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : spacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 72, child: Text(label, style: labelStyle)),
          Expanded(
            child: Text(
              value.isEmpty ? _emptyCellText : value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

typedef _SummaryChip = SummaryChip;
