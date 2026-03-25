import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
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
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_list_sections.dart';

/// 施工单列表入口。
class WorkOrderListEntry extends StatelessWidget {
  const WorkOrderListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<WorkOrderApiService, WorkOrderRepository,
        WorkOrderViewModel>(
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
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
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
  static const String _deleteDialogContent = '确定要删除施工单 "{name}" 吗？此操作不可恢复。';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
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
  bool _exporting = false;
  WorkOrderListSupportService? _supportService;
  bool _optionsRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService ??= WorkOrderListSupportService(context.read<ApiClient>());
    if (_optionsRequested) return;
    _optionsRequested = true;
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
      final savedPath = await saveBytes(result.bytes, result.filename,
          mimeType:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
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
    final isMobile = BreakpointsUtil.isMobile(context);

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
    final canChangeWorkOrder =
        PermissionUtil.hasPermission(context, 'workorder.change_workorder');
    final canDeleteWorkOrder =
        PermissionUtil.hasPermission(context, 'workorder.delete_workorder');
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
                DataCell(Text(
                  workOrder.orderNumber.isEmpty
                      ? '施工单 #${workOrder.id}'
                      : workOrder.orderNumber,
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(Text(workOrder.customerName ?? _emptyCellText,
                    style: textStyle)),
                DataCell(Text(workOrder.productName ?? _emptyCellText,
                    style: textStyle)),
                DataCell(Text(
                  workOrder.statusDisplay ?? workOrder.status ?? _emptyCellText,
                  style: textStyle,
                )),
                DataCell(Text(
                  workOrder.approvalStatusDisplay ??
                      workOrder.approvalStatus ??
                      _emptyCellText,
                  style: textStyle,
                )),
                DataCell(Text(
                  workOrder.priorityDisplay ??
                      workOrder.priority ??
                      _emptyCellText,
                  style: textStyle,
                )),
                DataCell(Text(_formatDate(workOrder.deliveryDate),
                    style: textStyle)),
                DataCell(Text(_formatAmount(workOrder.totalAmount),
                    style: textStyle)),
                DataCell(Text(
                  workOrder.progressPercentage == null
                      ? _emptyCellText
                      : '${workOrder.progressPercentage}%',
                  style: textStyle,
                )),
                DataCell(Text(workOrder.managerName ?? _emptyCellText,
                    style: textStyle)),
                DataCell(Text(workOrder.salespersonName ?? _emptyCellText,
                    style: textStyle)),
                DataCell(Text(
                  _formatQuantity(workOrder.quantity, workOrder.unit),
                  style: textStyle,
                )),
                DataCell(RowActionGroup(
                  actions: [
                    RowAction(
                      label: '查看',
                      onPressed: () =>
                          context.go('/workorders/${workOrder.id}'),
                    ),
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
                )),
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
        workOrder.statusDisplay ?? workOrder.status ?? _emptyCellText;
    final approval = workOrder.approvalStatusDisplay ??
        workOrder.approvalStatus ??
        _emptyCellText;
    final priority =
        workOrder.priorityDisplay ?? workOrder.priority ?? _emptyCellText;
    final deliveryDate = _formatDate(workOrder.deliveryDate);
    final amount = _formatAmount(workOrder.totalAmount);
    final progress = workOrder.progressPercentage == null
        ? _emptyCellText
        : '${workOrder.progressPercentage}%';
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final isCompact = BreakpointsUtil.isMobile(context);

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
                      _SummaryChip(label: '审核', value: approval),
                      _SummaryChip(label: '优先级', value: priority),
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
                  duration: const Duration(milliseconds: 200),
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
          SummaryFieldWrap(
            isMobile: isCompact,
            desktopWidth: 180,
            children: [
              _SummaryField(label: '交货日期', value: deliveryDate),
              _SummaryField(label: '进度', value: progress),
              _SummaryField(
                  label: '负责人', value: workOrder.managerName ?? _emptyCellText),
              _SummaryField(
                  label: '业务员',
                  value: workOrder.salespersonName ?? _emptyCellText),
              _SummaryField(
                  label: '数量',
                  value: _formatQuantity(workOrder.quantity, workOrder.unit)),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => context.go('/workorders/${workOrder.id}'),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('查看'),
              ),
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
    final canCreateWorkOrder =
        PermissionUtil.hasPermission(context, 'workorder.add_workorder');
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
      const DropdownMenuItem<int?>(
          value: null, child: Text('全部客户', overflow: TextOverflow.ellipsis)),
      ..._customers.map(
        (item) => DropdownMenuItem<int?>(
          value: item.id,
          child: Text(item.name, overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
    final productItems = [
      const DropdownMenuItem<int?>(
          value: null, child: Text('全部产品', overflow: TextOverflow.ellipsis)),
      ..._products.map(
        (item) => DropdownMenuItem<int?>(
          value: item.id,
          child: Text(item.displayLabel, overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
    final processItems = [
      const DropdownMenuItem<int?>(
          value: null, child: Text('全部工序', overflow: TextOverflow.ellipsis)),
      ..._processes.map(
        (item) => DropdownMenuItem<int?>(
          value: item.id,
          child: Text(item.name, overflow: TextOverflow.ellipsis),
        ),
      ),
    ];

    void openFilterDrawer() {
      if (isMobile) {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          builder: (sheetContext) {
            return WorkOrderListFilterDrawerContent(
              title: '筛选',
              child: _buildFilterPanel(
                sheetContext,
                viewModel,
                statusItems: statusItems,
                priorityItems: priorityItems,
                approvalItems: approvalItems,
                customerItems: customerItems,
                productItems: productItems,
                processItems: processItems,
                bottomSpacing: 16,
              ),
            );
          },
        );
        return;
      }

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '筛选',
        barrierColor: Colors.black.withValues(alpha: 0.3),
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (dialogContext, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Theme.of(dialogContext).colorScheme.surface,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: SizedBox(
                width: 360,
                height: double.infinity,
                child: SafeArea(
                  child: WorkOrderListFilterDrawerContent(
                    title: '筛选',
                    child: _buildFilterPanel(
                      dialogContext,
                      viewModel,
                      statusItems: statusItems,
                      priorityItems: priorityItems,
                      approvalItems: approvalItems,
                      customerItems: customerItems,
                      productItems: productItems,
                      processItems: processItems,
                      bottomSpacing: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final offsetTween =
              Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
          return SlideTransition(
            position: animation
                .drive(
                  CurveTween(curve: Curves.easeOutCubic),
                )
                .drive(offsetTween),
            child: child,
          );
        },
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
          final rejectedCount = viewModel.workOrders
              .where((item) => (item.approvalStatus ?? '') == 'rejected')
              .length;
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
            if (rejectedCount > 0)
              StatusHintChip(label: '待处理退回', count: rejectedCount),
            PageActionButton.outlined(
              onPressed: _exporting ? null : () => _exportWorkOrders(viewModel),
              icon: const Icon(Icons.download_outlined, size: 16),
              label: _exporting ? '导出中' : '导出',
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
    required List<DropdownMenuItem<String>> statusItems,
    required List<DropdownMenuItem<String>> priorityItems,
    required List<DropdownMenuItem<String>> approvalItems,
    required List<DropdownMenuItem<int?>> customerItems,
    required List<DropdownMenuItem<int?>> productItems,
    required List<DropdownMenuItem<int?>> processItems,
    required double bottomSpacing,
  }) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_loadingOptions) const LinearProgressIndicator(minHeight: 2),
        SearchableDropdownFormField<String>(
          initialValue: _statusFilter,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '状态'),
          items: statusItems,
          onChanged: (value) {
            setState(() => _statusFilter = value);
            _applyFilters(viewModel);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<String>(
          initialValue: _priorityFilter,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '优先级'),
          items: priorityItems,
          onChanged: (value) {
            setState(() => _priorityFilter = value);
            _applyFilters(viewModel);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<String>(
          initialValue: _approvalStatusFilter,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '审核状态'),
          items: approvalItems,
          onChanged: (value) {
            setState(() => _approvalStatusFilter = value);
            _applyFilters(viewModel);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<int?>(
          initialValue: _customerFilterId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '客户'),
          items: customerItems,
          onChanged: (value) {
            setState(() => _customerFilterId = value);
            _applyFilters(viewModel);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<int?>(
          initialValue: _productFilterId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '产品'),
          items: productItems,
          onChanged: (value) {
            setState(() => _productFilterId = value);
            _applyFilters(viewModel);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<int?>(
          initialValue: _processFilterId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '工序'),
          items: processItems,
          onChanged: (value) {
            setState(() => _processFilterId = value);
            _applyFilters(viewModel);
          },
        ),
        SizedBox(height: bottomSpacing),
        Row(
          children: [
            PageActionButton.outlined(
              onPressed: () => _resetFilters(viewModel),
              icon: const Icon(Icons.restart_alt, size: 16),
              label: _resetButtonText,
            ),
            SizedBox(width: spacing),
            PageActionButton.filled(
              onPressed: () => Navigator.of(context).maybePop(),
              label: '完成',
            ),
          ],
        ),
      ],
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [content],
    );
  }

  int _activeFilterCount() {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (_statusFilter != null && _statusFilter!.isNotEmpty) count += 1;
    if (_priorityFilter != null && _priorityFilter!.isNotEmpty) count += 1;
    if (_approvalStatusFilter != null && _approvalStatusFilter!.isNotEmpty)
      count += 1;
    if (_customerFilterId != null) count += 1;
    if (_productFilterId != null) count += 1;
    if (_processFilterId != null) count += 1;
    return count;
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WorkOrderViewModel viewModel,
    WorkOrder workOrder,
  ) async {
    final confirmed = await showWorkOrderDeleteConfirmDialog(
      context,
      title: _deleteDialogTitle,
      content:
          _deleteDialogContent.replaceFirst('{name}', workOrder.orderNumber),
    );
    if (confirmed != true) return;
    await viewModel
        .deleteAndReload(() => viewModel.deleteWorkOrder(workOrder.id));
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
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
