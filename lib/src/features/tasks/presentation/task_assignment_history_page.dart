import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/auth/data/auth_api.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';

class TaskAssignmentHistoryEntry extends StatefulWidget {
  const TaskAssignmentHistoryEntry({super.key});

  @override
  State<TaskAssignmentHistoryEntry> createState() => _TaskAssignmentHistoryEntryState();
}

class _TaskAssignmentHistoryEntryState extends State<TaskAssignmentHistoryEntry> {
  TaskApiService? _taskApi;
  AuthApi? _authApi;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_taskApi != null) return;
    final apiClient = context.read<ApiClient>();
    _taskApi = TaskApiService(apiClient);
    _authApi = AuthApi(apiClient);
  }

  @override
  Widget build(BuildContext context) {
    if (_taskApi == null || _authApi == null) return const SizedBox.shrink();
    return MultiProvider(
      providers: [
        Provider<TaskApiService>.value(value: _taskApi!),
        Provider<AuthApi>.value(value: _authApi!),
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
  State<_TaskAssignmentHistoryView> createState() => _TaskAssignmentHistoryViewState();
}

class _TaskAssignmentHistoryViewState extends State<_TaskAssignmentHistoryView> {
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
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
      final usersResponse = await context.read<AuthApi>().getUsersByDepartment();
      final users = usersResponse.data ?? const [];
      if (!mounted) return;
      setState(() {
        _departments = deptPage.items.map((dto) => dto.toEntity()).toList();
        _users = users.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
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
      final payload = await context.read<TaskApiService>().fetchAssignmentHistory(params: params);
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

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
    _loadData(resetPage: true);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );
    final summary = _buildSummary();

    return ListPageScaffold(
      spacing: _spacingSm,
      header: WorkbenchHeaderBar(
        breadcrumb: breadcrumb.isEmpty ? null : breadcrumb.join(' / '),
        title: '分派历史',
        subtitle: '追踪任务分派与调整记录。',
        stats: summary,
        titleMaxWidth: isMobile ? double.infinity : 420,
        hideSubtitleOnMobile: true,
        mobileStatCount: 2,
        hideBreadcrumbOnMobile: true,
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
        (dept) => DropdownMenuItem<int?>(value: dept.id, child: Text(dept.name)),
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

    return ListToolbar(
      isMobile: isMobile,
      actions: [
        SizedBox(
          width: isMobile ? double.infinity : 160,
          child: _DateField(
            label: '开始日期',
            value: _startDate,
            onTap: () => _pickDate(isStart: true),
            onClear: () {
              setState(() => _startDate = null);
              _loadData(resetPage: true);
            },
          ),
        ),
        SizedBox(
          width: isMobile ? double.infinity : 160,
          child: _DateField(
            label: '结束日期',
            value: _endDate,
            onTap: () => _pickDate(isStart: false),
            onClear: () {
              setState(() => _endDate = null);
              _loadData(resetPage: true);
            },
          ),
        ),
        SizedBox(
          width: isMobile ? double.infinity : 180,
          child: DropdownButtonFormField<int?>(
            value: _departmentId,
            decoration: const InputDecoration(labelText: '部门'),
            items: deptItems,
            onChanged: (value) {
              setState(() => _departmentId = value);
              _loadData(resetPage: true);
            },
          ),
        ),
        SizedBox(
          width: isMobile ? double.infinity : 180,
          child: DropdownButtonFormField<int?>(
            value: _operatorId,
            decoration: const InputDecoration(labelText: '操作员'),
            items: userItems,
            onChanged: (value) {
              setState(() => _operatorId = value);
              _loadData(resetPage: true);
            },
          ),
        ),
        ListToolbarButton(
          onPressed: _resetFilters,
          icon: Icons.restart_alt,
          label: _resetButtonText,
          height: _controlHeight,
          compact: isMobile,
        ),
        ListToolbarButton(
          onPressed: () => _loadData(resetPage: true),
          icon: Icons.refresh,
          label: _refreshButtonText,
          height: _controlHeight,
          compact: isMobile,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
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

  List<WorkbenchStatItem> _buildSummary() {
    final uniqueTasks = <int>{};
    final uniqueDepartments = <String>{};
    final uniqueOperators = <String>{};

    for (final item in _items) {
      final taskInfo = item['task_info'];
      if (taskInfo is Map) {
        final taskId = _toInt(taskInfo['id']);
        if (taskId > 0) uniqueTasks.add(taskId);
        final dept = taskInfo['assigned_department']?.toString();
        if (dept != null && dept.isNotEmpty) uniqueDepartments.add(dept);
        final op = taskInfo['assigned_operator']?.toString();
        if (op != null && op.isNotEmpty) uniqueOperators.add(op);
      }
      final operatorName = item['operator_name']?.toString();
      if (operatorName != null && operatorName.isNotEmpty) {
        uniqueOperators.add(operatorName);
      }
    }

    return [
      WorkbenchStatItem(label: '总记录', value: '$_total'),
      WorkbenchStatItem(label: '涉及任务', value: '${uniqueTasks.length}'),
      WorkbenchStatItem(label: '涉及部门', value: '${uniqueDepartments.length}'),
      WorkbenchStatItem(label: '涉及操作员', value: '${uniqueOperators.length}'),
    ];
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

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? ''
        : '${value!.year.toString().padLeft(4, '0')}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}';
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: value == null
              ? const Icon(Icons.calendar_today, size: 16)
              : IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: onClear,
                ),
        ),
        child: Text(text.isEmpty ? '请选择' : text),
      ),
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

    final workOrderId = _toInt(workOrderInfo is Map ? workOrderInfo['id'] : null);
    final workOrderNumber = workOrderInfo is Map
        ? workOrderInfo['order_number']?.toString()
        : null;

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
