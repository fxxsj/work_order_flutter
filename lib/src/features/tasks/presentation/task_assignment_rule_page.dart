import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/tasks/application/task_assignment_rule_view_model.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_dto.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_repository_impl.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule_repository.dart';

class TaskAssignmentRuleEntry extends StatefulWidget {
  const TaskAssignmentRuleEntry({super.key});

  @override
  State<TaskAssignmentRuleEntry> createState() =>
      _TaskAssignmentRuleEntryState();
}

class _TaskAssignmentRuleEntryState extends State<TaskAssignmentRuleEntry> {
  TaskAssignmentRuleApiService? _apiService;
  TaskAssignmentRuleRepositoryImpl? _repository;
  TaskAssignmentRuleViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = TaskAssignmentRuleApiService(apiClient);
    _repository = TaskAssignmentRuleRepositoryImpl(_apiService!);
    _viewModel = TaskAssignmentRuleViewModel(_repository!);
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
    if (_apiService == null || _repository == null || _viewModel == null) {
      return const SizedBox.shrink();
    }
    return MultiProvider(
      providers: [
        Provider<TaskAssignmentRuleApiService>.value(value: _apiService!),
        Provider<TaskAssignmentRuleRepository>.value(value: _repository!),
        ChangeNotifierProvider<TaskAssignmentRuleViewModel>.value(
            value: _viewModel!),
      ],
      child: const TaskAssignmentRulePage(),
    );
  }
}

class TaskAssignmentRulePage extends StatelessWidget {
  const TaskAssignmentRulePage({super.key});

  @override
  Widget build(BuildContext context) => const _TaskAssignmentRuleView();
}

class _TaskAssignmentRuleView extends StatefulWidget {
  const _TaskAssignmentRuleView();

  @override
  State<_TaskAssignmentRuleView> createState() =>
      _TaskAssignmentRuleViewState();
}

class _TaskAssignmentRuleViewState extends State<_TaskAssignmentRuleView> {
  static const _searchDebounceDuration = Duration(milliseconds: 400);
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _refreshButtonText = '刷新';
  static const String _resetButtonText = '重置筛选';
  static const String _createButtonText = '新建规则';
  static const String _emptyText = '暂无分派规则';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  List<Process> _processes = [];
  List<Department> _departments = [];
  bool _previewLoading = false;
  List<Map<String, dynamic>> _previewData = [];
  bool _globalEnabled = true;
  List<TaskAssignmentRule>? _reorderPreview;
  bool _reordering = false;

  @override
  void initState() {
    super.initState();
    _loadLookup();
    _loadPreview();
    _loadGlobalState();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLookup() async {
    try {
      final apiClient = context.read<ApiClient>();
      final processApi = ProcessApiService(apiClient);
      final deptApi = DepartmentApiService(apiClient);
      final processPage =
          await processApi.fetchProcesses(page: 1, pageSize: 200);
      final departmentPage =
          await deptApi.fetchDepartments(page: 1, pageSize: 200);
      if (!mounted) return;
      setState(() {
        _processes = processPage.items.map((dto) => dto.toEntity()).toList();
        _departments =
            departmentPage.items.map((dto) => dto.toEntity()).toList();
      });
    } catch (_) {
      // ignore
    }
  }

  Future<void> _loadPreview() async {
    setState(() => _previewLoading = true);
    try {
      final api = context.read<TaskAssignmentRuleApiService>();
      final payload = await api.preview();
      final preview = payload['preview'];
      if (!mounted) return;
      setState(() {
        _previewData = preview is List
            ? preview
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList()
            : [];
        final enabled = payload['global_enabled'];
        if (enabled is bool) {
          _globalEnabled = enabled;
        }
      });
    } catch (err) {
      ToastUtil.showError(
          '生成预览失败: ${err.toString().replaceFirst('Exception: ', '')}');
    } finally {
      if (mounted) setState(() => _previewLoading = false);
    }
  }

  Future<void> _loadGlobalState() async {
    try {
      final api = context.read<TaskAssignmentRuleApiService>();
      final payload = await api.getGlobalState();
      if (!mounted) return;
      setState(() {
        _globalEnabled = payload['enabled'] == true;
      });
    } catch (_) {
      // ignore
    }
  }

  Future<void> _toggleGlobal(bool value) async {
    setState(() => _globalEnabled = value);
    try {
      final api = context.read<TaskAssignmentRuleApiService>();
      final payload = await api.setGlobalState(value);
      setState(() => _globalEnabled = payload['enabled'] == true);
      ToastUtil.showSuccess(_globalEnabled ? '自动分派已启用' : '自动分派已禁用');
      _loadPreview();
    } catch (err) {
      setState(() => _globalEnabled = !value);
      ToastUtil.showError(
          '更新失败: ${err.toString().replaceFirst('Exception: ', '')}');
    }
  }

  void _scheduleSearch(TaskAssignmentRuleViewModel viewModel,
      {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadRules(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadRules(resetPage: true);
    });
  }

  void _resetFilters(TaskAssignmentRuleViewModel viewModel) {
    _searchController.clear();
    viewModel
      ..setSearchText('')
      ..setProcessId(null)
      ..setDepartmentId(null)
      ..setIsActive(null);
    viewModel.loadRules(resetPage: true);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<TaskAssignmentRuleViewModel>(
      builder: (context, viewModel, _) {
        final rules = viewModel.rules;
        final stats = [
          WorkbenchStatItem(label: '规则总数', value: '${viewModel.total}'),
          WorkbenchStatItem(
            label: '当前启用',
            value: '${rules.where((rule) => rule.isActive).length}',
          ),
          WorkbenchStatItem(label: '预览工序', value: '${_previewData.length}'),
        ];

        return ListPageScaffold(
          spacing: _spacingSm,
          header: WorkbenchHeaderBar(
            breadcrumb: breadcrumb.isEmpty ? null : breadcrumb.join(' / '),
            title: '分派规则配置',
            subtitle: '维护自动分派规则与预览效果。',
            stats: stats,
            titleMaxWidth: isMobile ? double.infinity : 420,
            hideSubtitleOnMobile: true,
            mobileStatCount: 2,
            hideBreadcrumbOnMobile: true,
            actions: _buildFilters(context, viewModel, isMobile),
          ),
          body: _buildBody(context, viewModel, rules, isMobile),
          footer: viewModel.total > 0
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

  Widget _buildFilters(
    BuildContext context,
    TaskAssignmentRuleViewModel viewModel,
    bool isMobile,
  ) {
    final processItems = [
      const DropdownMenuItem<int?>(value: null, child: Text('全部工序')),
      ..._processes.map(
        (process) => DropdownMenuItem<int?>(
          value: process.id,
          child: Text('${process.code} ${process.name}'),
        ),
      ),
    ];
    final departmentItems = [
      const DropdownMenuItem<int?>(value: null, child: Text('全部部门')),
      ..._departments.map(
        (dept) => DropdownMenuItem<int?>(
          value: dept.id,
          child: Text(dept.name),
        ),
      ),
    ];
    final activeItems = const [
      DropdownMenuItem<bool?>(value: null, child: Text('全部状态')),
      DropdownMenuItem<bool?>(value: true, child: Text('仅启用')),
      DropdownMenuItem<bool?>(value: false, child: Text('仅禁用')),
    ];

    final searchField = ListSearchField(
      controller: _searchController,
      hintText: '搜索工序/部门/备注',
      height: _controlHeight,
      width: isMobile ? double.infinity : 260,
      onChanged: (_) => _scheduleSearch(viewModel),
      onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
      onClear: () {
        _searchController.clear();
        _scheduleSearch(viewModel, immediate: true);
      },
    );

    return ListToolbar(
      isMobile: isMobile,
      searchField: searchField,
      actions: [
        SizedBox(
          width: isMobile ? double.infinity : 180,
          child: DropdownButtonFormField<int?>(
            key: ValueKey<int?>(viewModel.processId),
            initialValue: viewModel.processId,
            decoration: const InputDecoration(labelText: '工序'),
            items: processItems,
            onChanged: (value) {
              viewModel.setProcessId(value);
              viewModel.loadRules(resetPage: true);
            },
          ),
        ),
        SizedBox(
          width: isMobile ? double.infinity : 180,
          child: DropdownButtonFormField<int?>(
            key: ValueKey<int?>(viewModel.departmentId),
            initialValue: viewModel.departmentId,
            decoration: const InputDecoration(labelText: '部门'),
            items: departmentItems,
            onChanged: (value) {
              viewModel.setDepartmentId(value);
              viewModel.loadRules(resetPage: true);
            },
          ),
        ),
        SizedBox(
          width: isMobile ? double.infinity : 150,
          child: DropdownButtonFormField<bool?>(
            key: ValueKey<bool?>(viewModel.isActive),
            initialValue: viewModel.isActive,
            decoration: const InputDecoration(labelText: '状态'),
            items: activeItems,
            onChanged: (value) {
              viewModel.setIsActive(value);
              viewModel.loadRules(resetPage: true);
            },
          ),
        ),
        ListToolbarButton(
          onPressed: () => _resetFilters(viewModel),
          icon: Icons.restart_alt,
          label: _resetButtonText,
          height: _controlHeight,
          compact: isMobile,
        ),
        ListToolbarButton(
          onPressed: () => viewModel.loadRules(resetPage: true),
          icon: Icons.refresh,
          label: _refreshButtonText,
          height: _controlHeight,
          compact: isMobile,
        ),
        ListToolbarButton(
          onPressed: () => _openRuleDialog(context, viewModel, null),
          icon: Icons.add,
          label: _createButtonText,
          height: _controlHeight,
          compact: isMobile,
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    TaskAssignmentRuleViewModel viewModel,
    List<TaskAssignmentRule> rules,
    bool isMobile,
  ) {
    if (viewModel.loading && rules.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadRules(resetPage: true),
      );
    }
    if (!viewModel.loading && rules.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.rule_outlined,
        text: _emptyText,
      );
    }

    final displayedRules = _reorderPreview ?? rules;
    final processIds = displayedRules.map((rule) => rule.processId).toSet();
    final canReorder = processIds.length == 1 && displayedRules.length > 1;

    return ListView(
      children: [
        _buildGlobalToggle(),
        const SizedBox(height: 12),
        _buildPreviewSection(),
        const SizedBox(height: 12),
        DetailSectionCard(
          title: '规则列表',
          trailing: canReorder
              ? Text(
                  '拖拽调整优先级',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : null,
          child: canReorder
              ? ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorder: (oldIndex, newIndex) => _handleReorder(
                      viewModel, displayedRules, oldIndex, newIndex),
                  itemCount: displayedRules.length,
                  itemBuilder: (context, index) {
                    final rule = displayedRules[index];
                    return Padding(
                      key: ValueKey(rule.id),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RuleCard(
                        rule: rule,
                        onEdit: _reordering
                            ? null
                            : () => _openRuleDialog(context, viewModel, rule),
                        onDelete: _reordering
                            ? null
                            : () => _deleteRule(viewModel, rule),
                        onToggle: _reordering
                            ? null
                            : (value) => _toggleRule(viewModel, rule, value),
                        dragHandle: ReorderableDragStartListener(
                          index: index,
                          child: Icon(
                            Icons.drag_indicator,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Column(
                  children: [
                    if (!canReorder)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          '选择单个工序后可拖拽调整优先级。',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ...displayedRules.map(
                      (rule) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _RuleCard(
                          rule: rule,
                          onEdit: () =>
                              _openRuleDialog(context, viewModel, rule),
                          onDelete: () => _deleteRule(viewModel, rule),
                          onToggle: (value) =>
                              _toggleRule(viewModel, rule, value),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildGlobalToggle() {
    return DetailSectionCard(
      title: '自动分派',
      trailing: Switch(
        value: _globalEnabled,
        onChanged: _toggleGlobal,
      ),
      child: Text(
        _globalEnabled ? '已启用自动分派，任务将按规则分派到部门。' : '自动分派已禁用，仅提供预览。',
      ),
    );
  }

  Widget _buildPreviewSection() {
    return DetailSectionCard(
      title: '分派效果预览',
      trailing: TextButton.icon(
        onPressed: _previewLoading ? null : _loadPreview,
        icon: _previewLoading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh, size: 16),
        label: const Text('刷新预览'),
      ),
      child: _previewData.isEmpty
          ? const Text('暂无预览数据')
          : Column(
              children: _previewData.map((item) {
                final process = item['process_name']?.toString() ?? '-';
                final target =
                    item['target_department_name']?.toString() ?? '-';
                final priority = item['priority']?.toString() ?? '-';
                final strategy =
                    item['operator_selection_strategy']?.toString() ?? '-';
                final load = item['current_load']?.toString() ?? '0';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DetailSectionCard(
                    title: process,
                    child: SummaryFieldWrap(
                      isMobile: BreakpointsUtil.isMobile(context),
                      children: [
                        SummaryField(label: '目标部门', value: target),
                        SummaryField(label: '优先级', value: priority),
                        SummaryField(label: '当前负载', value: load),
                        SummaryField(label: '操作员策略', value: strategy),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Future<void> _deleteRule(
      TaskAssignmentRuleViewModel viewModel, TaskAssignmentRule rule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text(
            '确定要删除 ${rule.processName ?? '工序'} - ${rule.departmentName ?? '部门'} 规则吗？'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('删除')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await viewModel.deleteRule(rule.id);
      ToastUtil.showSuccess('规则已删除');
      _loadPreview();
    } catch (err) {
      ToastUtil.showError(
          '删除失败: ${err.toString().replaceFirst('Exception: ', '')}');
    }
  }

  Future<void> _toggleRule(
    TaskAssignmentRuleViewModel viewModel,
    TaskAssignmentRule rule,
    bool value,
  ) async {
    try {
      await viewModel.updateRule(rule.id, {'is_active': value});
      ToastUtil.showSuccess(value ? '已启用' : '已禁用');
      _loadPreview();
    } catch (err) {
      ToastUtil.showError(
          '更新失败: ${err.toString().replaceFirst('Exception: ', '')}');
    }
  }

  Future<void> _openRuleDialog(
    BuildContext context,
    TaskAssignmentRuleViewModel viewModel,
    TaskAssignmentRule? rule,
  ) async {
    if (_processes.isEmpty || _departments.isEmpty) {
      ToastUtil.showError('请先加载工序与部门列表');
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (context) => _RuleDialog(
        rule: rule,
        processes: _processes,
        departments: _departments,
        onSubmit: (payload) async {
          try {
            if (rule == null) {
              await viewModel.createRule(payload);
              ToastUtil.showSuccess('规则已创建');
            } else {
              await viewModel.updateRule(rule.id, payload.toPayload());
              ToastUtil.showSuccess('规则已更新');
            }
            _loadPreview();
          } catch (err) {
            ToastUtil.showError(
                '保存失败: ${err.toString().replaceFirst('Exception: ', '')}');
            rethrow;
          }
        },
      ),
    );
  }

  Future<void> _handleReorder(
    TaskAssignmentRuleViewModel viewModel,
    List<TaskAssignmentRule> rules,
    int oldIndex,
    int newIndex,
  ) async {
    if (_reordering) return;
    final updated = List<TaskAssignmentRule>.from(rules);
    if (newIndex > oldIndex) newIndex -= 1;
    final moved = updated.removeAt(oldIndex);
    updated.insert(newIndex, moved);
    setState(() {
      _reorderPreview = updated;
      _reordering = true;
    });
    try {
      await _persistRuleOrder(viewModel, updated);
      ToastUtil.showSuccess('优先级已更新');
      await viewModel.loadRules(resetPage: true);
      _loadPreview();
    } catch (err) {
      ToastUtil.showError(
          '更新失败: ${err.toString().replaceFirst('Exception: ', '')}');
      await viewModel.loadRules(resetPage: true);
    } finally {
      if (mounted) {
        setState(() {
          _reordering = false;
          _reorderPreview = null;
        });
      }
    }
  }

  Future<void> _persistRuleOrder(
    TaskAssignmentRuleViewModel viewModel,
    List<TaskAssignmentRule> rules,
  ) async {
    if (rules.isEmpty) return;
    const maxPriority = 100;
    const minPriority = 0;
    final steps = rules.length > 1
        ? (maxPriority - minPriority) / (rules.length - 1)
        : 0.0;
    for (var i = 0; i < rules.length; i++) {
      final priority =
          (maxPriority - (steps * i)).round().clamp(minPriority, maxPriority);
      final rule = rules[i];
      if (rule.priority == priority) continue;
      await viewModel.updateRule(rule.id, {'priority': priority},
          reload: false);
    }
  }

  String _pageInfoText(TaskAssignmentRuleViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }
}

class _RuleDialog extends StatefulWidget {
  const _RuleDialog({
    required this.rule,
    required this.processes,
    required this.departments,
    required this.onSubmit,
  });

  final TaskAssignmentRule? rule;
  final List<Process> processes;
  final List<Department> departments;
  final Future<void> Function(TaskAssignmentRuleDto payload) onSubmit;

  @override
  State<_RuleDialog> createState() => _RuleDialogState();
}

class _RuleDialogState extends State<_RuleDialog> {
  final _formKey = GlobalKey<FormState>();
  late int _processId;
  late int _departmentId;
  int _priority = 50;
  bool _isActive = true;
  String _strategy = 'least_tasks';
  String _notes = '';
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final rule = widget.rule;
    _processId = rule?.processId ?? widget.processes.first.id;
    _departmentId = rule?.departmentId ?? widget.departments.first.id;
    _priority = rule?.priority ?? 50;
    _isActive = rule?.isActive ?? true;
    _strategy = rule?.operatorSelectionStrategy ?? 'least_tasks';
    _notes = rule?.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.rule != null;
    return AlertDialog(
      title: Text(isEdit ? '编辑分派规则' : '新建分派规则'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  key: ValueKey<int>(_processId),
                  initialValue: _processId,
                  decoration: const InputDecoration(labelText: '工序'),
                  items: widget.processes
                      .map((p) => DropdownMenuItem(
                            value: p.id,
                            child: Text('${p.code} ${p.name}'),
                          ))
                      .toList(),
                  onChanged: isEdit
                      ? null
                      : (value) =>
                          setState(() => _processId = value ?? _processId),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  key: ValueKey<int>(_departmentId),
                  initialValue: _departmentId,
                  decoration: const InputDecoration(labelText: '分派部门'),
                  items: widget.departments
                      .map((d) => DropdownMenuItem(
                            value: d.id,
                            child: Text(d.name),
                          ))
                      .toList(),
                  onChanged: isEdit
                      ? null
                      : (value) => setState(
                          () => _departmentId = value ?? _departmentId),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _priority.toString(),
                  decoration: const InputDecoration(labelText: '优先级 (0-100)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed < 0 || parsed > 100) {
                      return '请输入 0-100 的整数';
                    }
                    return null;
                  },
                  onChanged: (value) =>
                      _priority = int.tryParse(value) ?? _priority,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey<String>(_strategy),
                  initialValue: _strategy,
                  decoration: const InputDecoration(labelText: '操作员选择策略'),
                  items: const [
                    DropdownMenuItem(value: 'least_tasks', child: Text('任务最少')),
                    DropdownMenuItem(value: 'random', child: Text('随机选择')),
                    DropdownMenuItem(value: 'round_robin', child: Text('轮询分配')),
                    DropdownMenuItem(
                        value: 'first_available', child: Text('第一个可用')),
                  ],
                  onChanged: (value) =>
                      setState(() => _strategy = value ?? _strategy),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                  title: const Text('启用规则'),
                  contentPadding: EdgeInsets.zero,
                ),
                TextFormField(
                  initialValue: _notes,
                  decoration: const InputDecoration(labelText: '备注（可选）'),
                  onChanged: (value) => _notes = value,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: _submitting ? null : () => Navigator.of(context).pop(),
            child: const Text('取消')),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('保存'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    final payload = TaskAssignmentRuleDto(
      id: widget.rule?.id ?? 0,
      processId: _processId,
      departmentId: _departmentId,
      priority: _priority,
      operatorSelectionStrategy: _strategy,
      isActive: _isActive,
      notes: _notes,
    );
    try {
      await widget.onSubmit(payload);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      // keep dialog open on failure
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    required this.rule,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    this.dragHandle,
  });

  final TaskAssignmentRule rule;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onToggle;
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final subtitle = '${rule.processCode ?? ''} · ${rule.departmentName ?? ''}';
    return DetailSectionCard(
      title: rule.processName ?? '未命名工序',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dragHandle != null) ...[
            dragHandle!,
            const SizedBox(width: 4),
          ],
          Switch(value: rule.isActive, onChanged: onToggle),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: onDelete, icon: const Icon(Icons.delete_outline)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 8),
          SummaryFieldWrap(
            isMobile: BreakpointsUtil.isMobile(context),
            children: [
              SummaryField(label: '优先级', value: rule.priority.toString()),
              SummaryField(
                label: '操作员策略',
                value: rule.operatorSelectionStrategyDisplay ??
                    rule.operatorSelectionStrategy,
              ),
              SummaryField(label: '部门编码', value: rule.departmentCode ?? '-'),
              SummaryField(
                  label: '备注',
                  value: rule.notes?.isNotEmpty == true ? rule.notes! : '-'),
            ],
          ),
        ],
      ),
    );
  }
}
