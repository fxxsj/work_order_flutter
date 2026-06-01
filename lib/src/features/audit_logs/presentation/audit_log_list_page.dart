import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/features/audit_logs/application/audit_log_view_model.dart';
import 'package:work_order_app/src/features/audit_logs/data/audit_log_api_service.dart';
import 'package:work_order_app/src/features/audit_logs/data/audit_log_repository_impl.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log_repository.dart';
import 'package:work_order_app/src/core/utils/debounce_controller.dart';

/// 审计日志列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class AuditLogListEntry extends StatelessWidget {
  const AuditLogListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      AuditLogApiService,
      AuditLogRepository,
      AuditLogViewModel
    >(
      createService: (context) => AuditLogApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          AuditLogRepositoryImpl(context.read<AuditLogApiService>()),
      createViewModel: (context) =>
          AuditLogViewModel(context.read<AuditLogRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const AuditLogListPage(),
    );
  }
}

/// 审计日志列表页视图，只负责渲染。
class AuditLogListPage extends StatelessWidget {
  const AuditLogListPage({super.key});

  @override
  Widget build(BuildContext context) => const _AuditLogListView();
}

class _AuditLogListView extends StatefulWidget {
  const _AuditLogListView();

  @override
  State<_AuditLogListView> createState() => _AuditLogListViewState();
}

class _AuditLogListViewState extends State<_AuditLogListView> {
  static const double _searchWidth = 320;
  static const double _spacingSm = SpacingTokens.sm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索用户/对象/类型';
  static const String _refreshButtonText = '刷新';
  static const String _resetButtonText = '重置筛选';
  static const String _emptyText = '暂无审计日志';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _objectIdController = TextEditingController();
  final TextEditingController _ipAddressController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final _debounce = DebounceController();
  String? _prefillKeyword;
  String? _actionType;
  String? _model;
  String? _requestMethod;
  String _ordering = '-created_at';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final keyword = GoRouterState.of(context).uri.queryParameters['search'];
    final trimmed = keyword?.trim() ?? '';
    if (trimmed == _prefillKeyword) return;
    _prefillKeyword = trimmed;
    _searchController.text = trimmed;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final viewModel = context.read<AuditLogViewModel>();
      viewModel.setSearchText(trimmed);
      viewModel.loadLogs(resetPage: true);
    });
  }

  @override
  void dispose() {
    _debounce.dispose();
    _searchController.dispose();
    _usernameController.dispose();
    _objectIdController.dispose();
    _ipAddressController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _scheduleSearch(AuditLogViewModel viewModel, {bool immediate = false}) {
    _debounce.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadLogs(resetPage: true);
      return;
    }
    _debounce.run(() {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadLogs(resetPage: true);
    });
  }

  static String _pageInfoText(AuditLogViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  void _applyFilters(AuditLogViewModel viewModel) {
    viewModel.setFilters(
      actionType: _actionType,
      model: _model,
      username: _usernameController.text,
      objectId: _objectIdController.text,
      ipAddress: _ipAddressController.text,
      requestMethod: _requestMethod,
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      ordering: _ordering,
    );
  }

  void _resetFilters(AuditLogViewModel viewModel) {
    _searchController.clear();
    _usernameController.clear();
    _objectIdController.clear();
    _ipAddressController.clear();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {
      _actionType = null;
      _model = null;
      _requestMethod = null;
      _ordering = '-created_at';
    });
    viewModel.resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Consumer<AuditLogViewModel>(
      builder: (context, viewModel, _) {
        final logs = viewModel.logs;
        _actionType = viewModel.actionType;
        _model = viewModel.model;
        _requestMethod = viewModel.requestMethod;
        _ordering = viewModel.ordering;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, logs, isMobile),
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
    AuditLogViewModel viewModel,
    List<AuditLog> logs,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && logs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadLogs(resetPage: true),
      );
    }
    if (!viewModel.loading && logs.isEmpty) {
      return const EmptyStateCard(icon: Icons.manage_search, text: _emptyText);
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, logs);
    }

    return ListView.separated(
      itemCount: logs.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildSummaryCard(context, log, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    AuditLogViewModel viewModel,
    List<AuditLog> logs,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('日志ID')),
        DataColumn(label: Text('操作类型')),
        DataColumn(label: Text('用户')),
        DataColumn(label: Text('对象类型')),
        DataColumn(label: Text('对象')),
        DataColumn(label: Text('对象ID')),
        DataColumn(label: Text('变更字段')),
        DataColumn(label: Text('IP')),
        DataColumn(label: Text('方法')),
        DataColumn(label: Text('时间')),
      ],
      rows: logs
          .map(
            (log) => DataRow(
              cells: [
                DataCell(
                  Text(log.id.toString(), style: theme.textTheme.bodyMedium),
                ),
                DataCell(Text(_displayText(log.actionType), style: textStyle)),
                DataCell(Text(_displayText(log.username), style: textStyle)),
                DataCell(
                  Text(_displayText(log.contentTypeName), style: textStyle),
                ),
                DataCell(Text(_displayText(log.objectRepr), style: textStyle)),
                DataCell(Text(_displayText(log.objectId), style: textStyle)),
                DataCell(
                  Text(_changedFieldsText(log.changedFields), style: textStyle),
                ),
                DataCell(Text(_displayText(log.ipAddress), style: textStyle)),
                DataCell(
                  Text(_displayText(log.requestMethod), style: textStyle),
                ),
                DataCell(
                  Text(_formatDateTime(log.createdAt), style: textStyle),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    AuditLogViewModel viewModel,
    bool isMobile,
  ) {
    final actionItems = const [
      AppDropdownOption(value: 'create', label: '创建'),
      AppDropdownOption(value: 'update', label: '更新'),
      AppDropdownOption(value: 'delete', label: '删除'),
      AppDropdownOption(value: 'view', label: '查看'),
      AppDropdownOption(value: 'export', label: '导出'),
      AppDropdownOption(value: 'import', label: '导入'),
      AppDropdownOption(value: 'approve', label: '审核通过'),
      AppDropdownOption(value: 'reject', label: '审核拒绝'),
      AppDropdownOption(value: 'login', label: '登录'),
      AppDropdownOption(value: 'logout', label: '登出'),
    ];
    final modelItems = const [
      AppDropdownOption(value: 'workorder', label: '施工单'),
      AppDropdownOption(value: 'workorderprocess', label: '施工单工序'),
      AppDropdownOption(value: 'workordertask', label: '施工单任务'),
      AppDropdownOption(value: 'customer', label: '客户'),
      AppDropdownOption(value: 'product', label: '产品'),
      AppDropdownOption(value: 'material', label: '物料'),
    ];
    final methodItems = const [
      AppDropdownOption(value: 'GET', label: 'GET'),
      AppDropdownOption(value: 'POST', label: 'POST'),
      AppDropdownOption(value: 'PUT', label: 'PUT'),
      AppDropdownOption(value: 'PATCH', label: 'PATCH'),
      AppDropdownOption(value: 'DELETE', label: 'DELETE'),
    ];
    final orderingItems = const [
      AppDropdownOption(value: '-created_at', label: '最新操作'),
      AppDropdownOption(value: 'created_at', label: '最早操作'),
      AppDropdownOption(value: 'action_type', label: '操作类型升序'),
      AppDropdownOption(value: '-action_type', label: '操作类型降序'),
      AppDropdownOption(value: 'username', label: '用户升序'),
      AppDropdownOption(value: '-username', label: '用户降序'),
      AppDropdownOption(value: 'content_type__model', label: '对象类型升序'),
      AppDropdownOption(value: 'ip_address', label: 'IP升序'),
    ];

    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final activeSearch = viewModel.searchText.trim();
          final activeFilters = _activeFilterCount(viewModel);
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

          void openFilterDrawer() {
            showAdaptiveFilterDrawer(
              context,
              isMobile: isMobile,
              title: activeFilters > 0 ? '筛选 ($activeFilters)' : '筛选',
              child: FilterPanelBody(
                bottomSpacing: LayoutTokens.formSectionSpacing(context),
                resetLabel: _resetButtonText,
                onReset: () => _resetFilters(viewModel),
                fields: [
                  AppSelect<String>(
                    value: _actionType,
                    decoration: const InputDecoration(labelText: '操作类型'),
                    options: actionItems,
                    onChanged: (value) {
                      setState(() => _actionType = value);
                      _applyFilters(viewModel);
                    },
                  ),
                  AppSelect<String>(
                    value: _model,
                    decoration: const InputDecoration(labelText: '对象类型'),
                    options: modelItems,
                    onChanged: (value) {
                      setState(() => _model = value);
                      _applyFilters(viewModel);
                    },
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: '用户名'),
                    onSubmitted: (_) => _applyFilters(viewModel),
                  ),
                  TextField(
                    controller: _objectIdController,
                    decoration: const InputDecoration(labelText: '对象ID'),
                    onSubmitted: (_) => _applyFilters(viewModel),
                  ),
                  TextField(
                    controller: _ipAddressController,
                    decoration: const InputDecoration(labelText: 'IP地址'),
                    onSubmitted: (_) => _applyFilters(viewModel),
                  ),
                  AppSelect<String>(
                    value: _requestMethod,
                    decoration: const InputDecoration(labelText: '请求方法'),
                    options: methodItems,
                    onChanged: (value) {
                      setState(() => _requestMethod = value);
                      _applyFilters(viewModel);
                    },
                  ),
                  TextField(
                    controller: _startDateController,
                    decoration: const InputDecoration(labelText: '开始日期'),
                    onSubmitted: (_) => _applyFilters(viewModel),
                  ),
                  TextField(
                    controller: _endDateController,
                    decoration: const InputDecoration(labelText: '结束日期'),
                    onSubmitted: (_) => _applyFilters(viewModel),
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
                ],
              ),
            );
          }

          final actions = <Widget>[
            if (activeSearch.isNotEmpty || activeFilters > 0)
              PageActionButton.outlined(
                onPressed: () => _resetFilters(viewModel),
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: '清除筛选',
              ),
            PageActionButton.outlined(
              onPressed: openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: activeFilters > 0 ? '筛选 $activeFilters' : '筛选',
            ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadLogs(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
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

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  int _activeFilterCount(AuditLogViewModel viewModel) {
    var count = 0;
    if ((viewModel.actionType ?? '').isNotEmpty) count += 1;
    if ((viewModel.model ?? '').isNotEmpty) count += 1;
    if ((viewModel.username ?? '').isNotEmpty) count += 1;
    if ((viewModel.objectId ?? '').isNotEmpty) count += 1;
    if ((viewModel.ipAddress ?? '').isNotEmpty) count += 1;
    if ((viewModel.requestMethod ?? '').isNotEmpty) count += 1;
    if ((viewModel.startDate ?? '').isNotEmpty) count += 1;
    if ((viewModel.endDate ?? '').isNotEmpty) count += 1;
    if (viewModel.ordering != '-created_at') count += 1;
    return count;
  }

  static String _changedFieldsText(List<String> fields) {
    if (fields.isEmpty) return _emptyCellText;
    return fields.join('、');
  }

  Widget _buildSummaryCard(BuildContext context, AuditLog log, bool isMobile) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final objectRepr = log.objectRepr?.trim().isNotEmpty == true
        ? log.objectRepr!
        : '日志 #${log.id}';
    final actionType = _displayText(log.actionType);
    final username = _displayText(log.username);
    final contentType = _displayText(log.contentTypeName);
    final objectId = _displayText(log.objectId);
    final changedFields = _changedFieldsText(log.changedFields);
    final ipAddress = _displayText(log.ipAddress);
    final requestMethod = _displayText(log.requestMethod);
    final requestPath = _displayText(log.requestPath);
    final createdAt = _formatDateTime(log.createdAt);

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
                    objectRepr,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    '$username · $actionType',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '对象类型', value: contentType),
                      _SummaryChip(label: 'IP', value: ipAddress),
                      _SummaryChip(label: '方法', value: requestMethod),
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
                  createdAt,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors?.subtleText ?? theme.hintColor,
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
      expandedChild: _buildMobileFields(
        context,
        logId: log.id.toString(),
        actionType: actionType,
        username: username,
        contentType: contentType,
        objectId: objectId,
        objectRepr: _displayText(log.objectRepr),
        changedFields: changedFields,
        ipAddress: ipAddress,
        requestMethod: requestMethod,
        requestPath: requestPath,
        createdAt: createdAt,
      ),
    );
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  static Widget _buildMobileFields(
    BuildContext context, {
    required String logId,
    required String actionType,
    required String username,
    required String contentType,
    required String objectId,
    required String objectRepr,
    required String changedFields,
    required String ipAddress,
    required String requestMethod,
    required String requestPath,
    required String createdAt,
  }) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.extension<AppColors>()?.subtleText ?? theme.hintColor,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mobileRow(context, labelStyle, '日志ID', logId),
        _mobileRow(context, labelStyle, '操作类型', actionType),
        _mobileRow(context, labelStyle, '用户', username),
        _mobileRow(context, labelStyle, '对象类型', contentType),
        _mobileRow(context, labelStyle, '对象ID', objectId),
        _mobileRow(context, labelStyle, '对象', objectRepr),
        _mobileRow(context, labelStyle, '变更字段', changedFields),
        _mobileRow(context, labelStyle, 'IP', ipAddress),
        _mobileRow(context, labelStyle, '方法', requestMethod),
        _mobileRow(context, labelStyle, '路径', requestPath),
        _mobileRow(context, labelStyle, '时间', createdAt, last: true),
      ],
    );
  }

  static Widget _mobileRow(
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
