import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_loading_indicator.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/tasks/application/task_assignment_rule_view_model.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_support_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_repository_impl.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule_repository.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_assignment_rule_sections.dart';

class TaskAssignmentRuleEntry extends StatelessWidget {
  const TaskAssignmentRuleEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<TaskAssignmentRuleApiService,
        TaskAssignmentRuleRepository, TaskAssignmentRuleViewModel>(
      createService: (context) =>
          TaskAssignmentRuleApiService(context.read<ApiClient>()),
      createRepository: (context) => TaskAssignmentRuleRepositoryImpl(
        context.read<TaskAssignmentRuleApiService>(),
      ),
      createViewModel: (context) => TaskAssignmentRuleViewModel(
        context.read<TaskAssignmentRuleRepository>(),
      ),
      initialize: (viewModel) => viewModel.initialize(),
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
  TaskAssignmentRuleSupportService? _supportService;
  bool _setupRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService ??=
        TaskAssignmentRuleSupportService(context.read<ApiClient>());
    if (_setupRequested) return;
    _setupRequested = true;
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
      final lookup = await _supportService!.loadLookup();
      if (!mounted) return;
      setState(() {
        _processes = lookup.processes;
        _departments = lookup.departments;
      });
    } catch (_) {
      // ignore
    }
  }

  Future<void> _loadPreview() async {
    setState(() => _previewLoading = true);
    try {
      final previewData = await _supportService!.loadPreview();
      if (!mounted) return;
      setState(() {
        _previewData = previewData.previewItems;
        if (previewData.globalEnabled != null) {
          _globalEnabled = previewData.globalEnabled!;
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
      final enabled = await _supportService!.getGlobalState();
      if (!mounted) return;
      setState(() => _globalEnabled = enabled);
    } catch (_) {
      // ignore
    }
  }

  Future<void> _toggleGlobal(bool value) async {
    setState(() => _globalEnabled = value);
    try {
      final enabled = await _supportService!.setGlobalState(value);
      setState(() => _globalEnabled = enabled);
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

  int _activeFilterCount(TaskAssignmentRuleViewModel viewModel) {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (viewModel.processId != null) count += 1;
    if (viewModel.departmentId != null) count += 1;
    if (viewModel.isActive != null) count += 1;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<TaskAssignmentRuleViewModel>(
      builder: (context, viewModel, _) {
        final rules = viewModel.rules;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: PageHeaderBar(
            breadcrumb: null,
            useSurface: false,
            showDivider: false,
            padding: EdgeInsets.zero,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final activeCount = _activeFilterCount(viewModel);
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
                return TaskAssignmentRuleFilterDrawerContent(
                  title: activeCount > 0 ? '筛选 ($activeCount)' : '筛选',
                  child: _buildFilterPanel(
                    sheetContext,
                    viewModel,
                    processItems: processItems,
                    departmentItems: departmentItems,
                    activeItems: activeItems,
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
            barrierColor: Theme.of(context)
                .shadowColor
                .withValues(alpha: OpacityTokens.scrim),
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
                      child: TaskAssignmentRuleFilterDrawerContent(
                        title: activeCount > 0 ? '筛选 ($activeCount)' : '筛选',
                        child: _buildFilterPanel(
                          dialogContext,
                          viewModel,
                          processItems: processItems,
                          departmentItems: departmentItems,
                          activeItems: activeItems,
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

        final searchField = ListSearchField(
          controller: _searchController,
          hintText: '搜索工序/部门/备注',
          height: _controlHeight,
          width: isMobile ? constraints.maxWidth : 260,
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
            PageActionButton.outlined(
              onPressed: () => viewModel.loadRules(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.filled(
              onPressed: () => _openRuleDialog(context, viewModel, null),
              icon: const Icon(Icons.add),
              label: _createButtonText,
            ),
            PageActionButton.outlined(
              onPressed: openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: activeCount > 0 ? '筛选 $activeCount' : '筛选',
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterPanel(
    BuildContext context,
    TaskAssignmentRuleViewModel viewModel, {
    required List<DropdownMenuItem<int?>> processItems,
    required List<DropdownMenuItem<int?>> departmentItems,
    required List<DropdownMenuItem<bool?>> activeItems,
  }) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    return ListView(
      padding: LayoutTokens.pagePadding(context),
      children: [
        SearchableDropdownFormField<int?>(
          key: ValueKey<int?>(viewModel.processId),
          initialValue: viewModel.processId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '工序'),
          items: processItems,
          onChanged: (value) {
            viewModel.setProcessId(value);
            viewModel.loadRules(resetPage: true);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<int?>(
          key: ValueKey<int?>(viewModel.departmentId),
          initialValue: viewModel.departmentId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '部门'),
          items: departmentItems,
          onChanged: (value) {
            viewModel.setDepartmentId(value);
            viewModel.loadRules(resetPage: true);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<bool?>(
          key: ValueKey<bool?>(viewModel.isActive),
          initialValue: viewModel.isActive,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '状态'),
          items: activeItems,
          onChanged: (value) {
            viewModel.setIsActive(value);
            viewModel.loadRules(resetPage: true);
          },
        ),
        SizedBox(height: spacing),
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
  }

  Widget _buildBody(
    BuildContext context,
    TaskAssignmentRuleViewModel viewModel,
    List<TaskAssignmentRule> rules,
    bool isMobile,
  ) {
    if (viewModel.loading && rules.isEmpty) {
      return const AppLoadingIndicator();
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
        SizedBox(height: LayoutTokens.gapMd),
        _buildPreviewSection(),
        SizedBox(height: LayoutTokens.gapMd),
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
                      padding: EdgeInsets.only(bottom: LayoutTokens.gapMd),
                      child: TaskAssignmentRuleCard(
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
                        padding: EdgeInsets.only(bottom: LayoutTokens.gapMd),
                        child: Text(
                          '选择单个工序后可拖拽调整优先级。',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ...displayedRules.map(
                      (rule) => Padding(
                        padding: EdgeInsets.only(bottom: LayoutTokens.gapMd),
                        child: TaskAssignmentRuleCard(
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
            ? const AppLoadingIndicator(
                centered: false,
                size: LayoutTokens.iconXs,
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
                  padding: EdgeInsets.only(bottom: LayoutTokens.gapMd),
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
    final confirmed = await showTaskAssignmentRuleDeleteDialog(
      context,
      content:
          '确定要删除 ${rule.processName ?? '工序'} - ${rule.departmentName ?? '部门'} 规则吗？',
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
      builder: (context) => TaskAssignmentRuleDialog(
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
