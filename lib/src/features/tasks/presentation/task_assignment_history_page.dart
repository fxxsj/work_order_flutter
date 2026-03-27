import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/date_range_filter_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/auth/data/auth_api.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';

class TaskAssignmentHistoryEntry extends StatelessWidget {
  const TaskAssignmentHistoryEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TaskApiService>(
          create: (context) => TaskApiService(context.read<ApiClient>()),
        ),
        Provider<AuthApi>(
          create: (context) => AuthApi(context.read<ApiClient>()),
        ),
      ],
      child: const TaskAssignmentHistoryPage(),
    );
  }
}

class TaskAssignmentHistoryPage extends StatelessWidget {
  const TaskAssignmentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) => const _TaskAssignmentHistoryView();
}

class _TaskAssignmentHistoryView extends StatefulWidget {
  const _TaskAssignmentHistoryView();

  @override
  State<_TaskAssignmentHistoryView> createState() =>
      _TaskAssignmentHistoryViewState();
}

class _TaskAssignmentHistoryViewState
    extends State<_TaskAssignmentHistoryView> {
  static const double _spacingSm = LayoutTokens.gapSm;
  static const String _refreshButtonText = '刷新';
  static const String _resetButtonText = '重置筛选';
  static const String _emptyText = '暂无分派历史记录';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  bool _loading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _items = [];
  int _page = 1;
  int _pageSize = 20;
  int _total = 0;

  List<Department> _departments = [];
  List<Map<String, dynamic>> _users = [];
  int? _departmentId;
  int? _operatorId;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadFilters();
    _loadData(resetPage: true);
  }

  Future<void> _loadFilters() async {
    try {
      final apiClient = context.read<ApiClient>();
      final deptApi = DepartmentApiService(apiClient);
      final deptPage = await deptApi.fetchDepartments(page: 1, pageSize: 200);
      final usersResponse =
          await context.read<AuthApi>().getUsersByDepartment();
      final users = usersResponse.data ?? const [];
      if (!mounted) return;
      setState(() {
        _departments = deptPage.items.map((dto) => dto.toEntity()).toList();
        _users = users
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      });
    } catch (_) {
      // ignore
    }
  }

  Future<void> _loadData({required bool resetPage}) async {
    if (resetPage) _page = 1;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final params = <String, dynamic>{
        'page': _page,
        'page_size': _pageSize,
      };
      if (_departmentId != null) params['department_id'] = _departmentId;
      if (_operatorId != null) params['operator_id'] = _operatorId;
      if (_startDate != null) params['start_date'] = _formatDate(_startDate!);
      if (_endDate != null) params['end_date'] = _formatDate(_endDate!);
      final payload = await context
          .read<TaskApiService>()
          .fetchAssignmentHistory(params: params);
      final results = payload['results'];
      setState(() {
        _items = results is List
            ? results
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList()
            : [];
        _total = _toInt(payload['total']);
      });
    } catch (err) {
      setState(() {
        _errorMessage = err.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  int get _totalPages {
    if (_total <= 0) return 1;
    final pages = (_total / _pageSize).ceil();
    return pages < 1 ? 1 : pages;
  }

  bool get _hasPrev => _page > 1;

  bool get _hasNext => _page < _totalPages;

  void _resetFilters() {
    setState(() {
      _departmentId = null;
      _operatorId = null;
      _startDate = null;
      _endDate = null;
    });
    _loadData(resetPage: true);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    return ListPageScaffold(
      spacing: _spacingSm,
      header: PageHeaderBar(
        breadcrumb: null,
        useSurface: false,
        showDivider: false,
        padding: EdgeInsets.zero,
        actions: _buildFilters(isMobile),
      ),
      body: _buildBody(context),
      footer: _total > 0
          ? ResponsivePaginationBar(
              infoText: _pageInfoText(),
              page: _page,
              pageSize: _pageSize,
              pageSizeOptions: const [10, 20, 50, 100],
              onPageSizeChanged: (size) {
                setState(() => _pageSize = size);
                _loadData(resetPage: true);
              },
              onPrev: () {
                if (!_hasPrev) return;
                setState(() => _page -= 1);
                _loadData(resetPage: false);
              },
              onNext: () {
                if (!_hasNext) return;
                setState(() => _page += 1);
                _loadData(resetPage: false);
              },
              hasPrev: _hasPrev,
              hasNext: _hasNext,
              pageSizeLabelBuilder: (size) =>
                  _pageSizeLabel.replaceFirst('{size}', size.toString()),
            )
          : null,
    );
  }

  Widget _buildFilters(bool isMobile) {
    final deptItems = [
      const DropdownMenuItem<int?>(value: null, child: Text('全部部门')),
      ..._departments.map(
        (dept) =>
            DropdownMenuItem<int?>(value: dept.id, child: Text(dept.name)),
      ),
    ];
    final userItems = [
      const DropdownMenuItem<int?>(value: null, child: Text('全部操作员')),
      ..._users.map((user) {
        final id = _toInt(user['id']);
        final name = user['username']?.toString() ?? '用户 $id';
        return DropdownMenuItem<int?>(value: id, child: Text(name));
      }),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        void openFilterDrawer() {
          if (isMobile) {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              showDragHandle: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              builder: (sheetContext) {
                return _FilterDrawerContent(
                  title: '筛选',
                  child: _buildFilterPanel(
                    sheetContext,
                    deptItems: deptItems,
                    userItems: userItems,
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
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  child: SizedBox(
                    width: 360,
                    height: double.infinity,
                    child: SafeArea(
                      child: _FilterDrawerContent(
                        title: '筛选',
                        child: _buildFilterPanel(
                          dialogContext,
                          deptItems: deptItems,
                          userItems: userItems,
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

        return ListToolbar(
          isMobile: isMobile,
          actions: [
            PageActionButton.outlined(
              onPressed: () => _loadData(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.outlined(
              onPressed: openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: '筛选',
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterPanel(
    BuildContext context, {
    required List<DropdownMenuItem<int?>> deptItems,
    required List<DropdownMenuItem<int?>> userItems,
  }) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [
        DateRangeFilterField(
          label: '日期范围',
          startDate: _startDate,
          endDate: _endDate,
          helperText: '筛选分派记录时间范围',
          onChanged: (range) {
            setState(() {
              _startDate = range?.start;
              _endDate = range?.end;
            });
            _loadData(resetPage: true);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<int?>(
          key: ValueKey<int?>(_departmentId),
          initialValue: _departmentId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '部门'),
          items: deptItems,
          onChanged: (value) {
            setState(() => _departmentId = value);
            _loadData(resetPage: true);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<int?>(
          key: ValueKey<int?>(_operatorId),
          initialValue: _operatorId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '操作员'),
          items: userItems,
          onChanged: (value) {
            setState(() => _operatorId = value);
            _loadData(resetPage: true);
          },
        ),
        SizedBox(height: spacing),
        Row(
          children: [
            PageActionButton.outlined(
              onPressed: _resetFilters,
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
  }

  Widget _buildBody(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null && !_loading) {
      return ErrorStateCard(
        message: _errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => _loadData(resetPage: true),
      );
    }
    if (_items.isEmpty && !_loading) {
      return const EmptyStateCard(
        icon: Icons.history_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context);
    }

    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _items[index];
        return _HistoryCard(
          item: item,
          onOpenWorkOrder: (id) => context.go('/workorders/$id'),
        );
      },
    );
  }

  Widget _buildDesktopTable(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('任务')),
        DataColumn(label: Text('当前部门')),
        DataColumn(label: Text('当前操作员')),
        DataColumn(label: Text('操作人')),
        DataColumn(label: Text('内容')),
        DataColumn(label: Text('时间')),
        DataColumn(label: Text('施工单')),
      ],
      rows: _items.map(
        (item) {
          final createdAt = item['created_at']?.toString() ?? '-';
          final content = item['content']?.toString() ?? '-';
          final operatorName = item['operator_name']?.toString() ?? '-';
          final taskInfo = item['task_info'];
          final workOrderInfo = item['work_order_info'];

          final taskTitle = taskInfo is Map
              ? taskInfo['work_content']?.toString() ??
                  '任务 #${taskInfo['id'] ?? '-'}'
              : '-';
          final department = taskInfo is Map
              ? taskInfo['assigned_department']?.toString() ?? '未分配部门'
              : '未分配部门';
          final assignedOperator = taskInfo is Map
              ? taskInfo['assigned_operator']?.toString() ?? '未分配操作员'
              : '未分配操作员';

          final workOrderId =
              _toInt(workOrderInfo is Map ? workOrderInfo['id'] : null);
          final workOrderNumber = workOrderInfo is Map
              ? workOrderInfo['order_number']?.toString()
              : null;

          return DataRow(
            cells: [
              DataCell(Text(taskTitle, style: theme.textTheme.bodyMedium)),
              DataCell(Text(department, style: textStyle)),
              DataCell(Text(assignedOperator, style: textStyle)),
              DataCell(Text(operatorName, style: textStyle)),
              DataCell(Text(content, style: textStyle)),
              DataCell(Text(createdAt, style: textStyle)),
              DataCell(
                workOrderId > 0 && workOrderNumber != null
                    ? TextButton(
                        onPressed: () => context.go('/workorders/$workOrderId'),
                        child: Text('查看 $workOrderNumber'),
                      )
                    : Text('-', style: textStyle),
              ),
            ],
          );
        },
      ).toList(),
    );
  }

  String _pageInfoText() {
    return _pageInfoTemplate
        .replaceFirst('{page}', _page.toString())
        .replaceFirst('{total}', _totalPages.toString())
        .replaceFirst('{count}', _total.toString());
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class _FilterDrawerContent extends StatelessWidget {
  const _FilterDrawerContent({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: '关闭',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item, required this.onOpenWorkOrder});

  final Map<String, dynamic> item;
  final ValueChanged<int> onOpenWorkOrder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final createdAt = item['created_at']?.toString() ?? '-';
    final content = item['content']?.toString() ?? '-';
    final operatorName = item['operator_name']?.toString() ?? '-';
    final taskInfo = item['task_info'];
    final workOrderInfo = item['work_order_info'];

    final taskTitle = taskInfo is Map
        ? taskInfo['work_content']?.toString() ?? '任务 #${taskInfo['id'] ?? '-'}'
        : '-';
    final department = taskInfo is Map
        ? taskInfo['assigned_department']?.toString() ?? '未分配部门'
        : '未分配部门';
    final assignedOperator = taskInfo is Map
        ? taskInfo['assigned_operator']?.toString() ?? '未分配操作员'
        : '未分配操作员';

    final workOrderId =
        _toInt(workOrderInfo is Map ? workOrderInfo['id'] : null);
    final workOrderNumber =
        workOrderInfo is Map ? workOrderInfo['order_number']?.toString() : null;

    return DetailSectionCard(
      title: taskTitle,
      trailing: Text(
        createdAt,
        style: theme.textTheme.bodySmall?.copyWith(color: colors.subtleText),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          SummaryFieldWrap(
            isMobile: BreakpointsUtil.isMobile(context),
            children: [
              SummaryField(label: '当前部门', value: department),
              SummaryField(label: '当前操作员', value: assignedOperator),
              SummaryField(label: '操作人', value: operatorName),
            ],
          ),
          if (workOrderId > 0 && workOrderNumber != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: OutlinedButton.icon(
                onPressed: () => onOpenWorkOrder(workOrderId),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text('查看施工单 $workOrderNumber'),
              ),
            ),
        ],
      ),
    );
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
