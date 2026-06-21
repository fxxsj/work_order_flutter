import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_loading_indicator.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/tasks/application/task_assignment_rule_view_model.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule_repository.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_assignment_rule_sections.dart';
import 'package:work_order_app/src/core/utils/debounce_controller.dart';

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
  static const double _spacingSm = SpacingTokens.sm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _refreshButtonText = '刷新';
  static const String _resetButtonText = '重置筛选';
  static const String _createButtonText = '新增默认部门';
  static const String _emptyText = '暂无默认分派部门';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  final _debounce = DebounceController();
  List<Process> _processes = [];
  List<TaskDepartmentOption> _departments = [];
  String? _lookupError;
  bool _previewLoading = false;
  List<Map<String, dynamic>> _previewData = [];
  bool _globalEnabled = true;
  bool _setupRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_setupRequested) return;
    _setupRequested = true;
    _loadLookup();
    _loadPreview();
    _loadGlobalState();
  }

  @override
  void dispose() {
    _debounce.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLookup() async {
    try {
      final lookup = await context.read<TaskAssignmentRuleRepository>().loadLookup();
      if (!mounted) return;
      setState(() {
        _processes = lookup.processes;
        _departments = lookup.departments;
        _lookupError = null;
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        _lookupError = err.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _loadPreview() async {
    setState(() => _previewLoading = true);
    try {
      final previewData = await context.read<TaskAssignmentRuleRepository>().loadPreview();
      if (!mounted) return;
      setState(() {
        _previewData = previewData.previewItems;
        if (previewData.globalEnabled != null) {
          _globalEnabled = previewData.globalEnabled!;
        }
      });
    } catch (err) {
      ToastUtil.showError(
        '生成预览失败: ${err.toString().replaceFirst('Exception: ', '')}',
      );
    } finally {
      if (mounted) setState(() => _previewLoading = false);
    }
  }

  Future<void> _loadGlobalState() async {
    try {
      final enabled = await context.read<TaskAssignmentRuleRepository>().getGlobalState();
      if (!mounted) return;
      setState(() => _globalEnabled = enabled);
    } catch (_) {
      // ignore
    }
  }

  Future<void> _toggleGlobal(bool value) async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.change_taskassignmentrule')) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
    }
    setState(() => _globalEnabled = value);
    try {
      final enabled = await context.read<TaskAssignmentRuleRepository>().setGlobalState(value);
      setState(() => _globalEnabled = enabled);
      ToastUtil.showSuccess(_globalEnabled ? '默认分派已启用' : '默认分派已禁用');
      _loadPreview();
    } catch (err) {
      setState(() => _globalEnabled = !value);
      ToastUtil.showError(
        '更新失败: ${err.toString().replaceFirst('Exception: ', '')}',
      );
    }
  }

  void _scheduleSearch(
    TaskAssignmentRuleViewModel viewModel, {
    bool immediate = false,
  }) {
    if (immediate) {
      _debounce.cancel();
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadRules(resetPage: true);
      return;
    }
    _debounce.run(() {
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
    final isMobile = ResponsiveLayout.isMobile(context);

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
      const AppDropdownOption<int?>(value: null, label: '全部工序'),
      ..._processes.map(
        (process) => AppDropdownOption<int?>(
          value: process.id,
          label: '${process.code} ${process.name}',
        ),
      ),
    ];
    final departmentItems = [
      const AppDropdownOption<int?>(value: null, label: '全部部门'),
      ..._departments.map(
        (dept) => AppDropdownOption<int?>(value: dept.id, label: dept.name),
      ),
    ];
    final activeItems = const [
      AppDropdownOption<bool?>(value: null, label: '全部状态'),
      AppDropdownOption<bool?>(value: true, label: '仅启用'),
      AppDropdownOption<bool?>(value: false, label: '仅禁用'),
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
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
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
            barrierColor: Theme.of(
              context,
            ).shadowColor.withValues(alpha: OpacityTokens.scrim),
            transitionDuration: AnimationTokens.slide,
            pageBuilder: (dialogContext, animation, secondaryAnimation) {
              return Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Theme.of(dialogContext).colorScheme.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: SizedBox(
                    width: LayoutTokens.dialogWidthXs,
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
              final offsetTween = Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              );
              return SlideTransition(
                position: animation
                    .drive(CurveTween(curve: Curves.easeOutCubic))
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
            if (PermissionUtil.snapshot(
              context,
            ).has('workorder.add_taskassignmentrule'))
              PageActionButton.filled(
                onPressed: () => _openRuleDialog(context, viewModel, null),
                icon: const Icon(Icons.add),
                label: _createButtonText,
              ),
            PageActionButton.outlined(
              onPressed: _previewLoading ? null : _openPreviewDialog,
              icon: _previewLoading
                  ? const AppLoadingIndicator(
                      centered: false,
                      size: LayoutTokens.iconXs,
                    )
                  : const Icon(Icons.visibility_outlined, size: 16),
              label: '预览',
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
    required List<AppDropdownOption<int?>> processItems,
    required List<AppDropdownOption<int?>> departmentItems,
    required List<AppDropdownOption<bool?>> activeItems,
  }) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    return ListView(
      padding: LayoutTokens.pagePadding(context),
      children: [
        AppSelect<int?>(
          key: ValueKey<int?>(viewModel.processId),
          value: viewModel.processId,
          decoration: const InputDecoration(labelText: '工序'),
          options: processItems,
          onChanged: (value) {
            viewModel.setProcessId(value);
            viewModel.loadRules(resetPage: true);
          },
        ),
        SizedBox(height: spacing),
        AppSelect<int?>(
          key: ValueKey<int?>(viewModel.departmentId),
          value: viewModel.departmentId,
          decoration: const InputDecoration(labelText: '部门'),
          options: departmentItems,
          onChanged: (value) {
            viewModel.setDepartmentId(value);
            viewModel.loadRules(resetPage: true);
          },
        ),
        SizedBox(height: spacing),
        AppSelect<bool?>(
          key: ValueKey<bool?>(viewModel.isActive),
          value: viewModel.isActive,
          decoration: const InputDecoration(labelText: '状态'),
          options: activeItems,
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
    final permissions = PermissionUtil.snapshot(context);
    final canChangeRule = permissions.has(
      'workorder.change_taskassignmentrule',
    );
    return ListView(
      children: [
        _buildGlobalToggle(),
        SizedBox(height: SpacingTokens.md),
        DetailSectionCard(
          title: '工序默认部门',
          child: rules.isEmpty
              ? _buildEmptyRulesContent(context, viewModel)
              : Column(
                  children: [
                    ...rules.map(
                      (rule) => Padding(
                        padding: EdgeInsets.only(bottom: SpacingTokens.md),
                        child: TaskAssignmentRuleCard(
                          rule: rule,
                          onEdit: canChangeRule
                              ? () => _openRuleDialog(context, viewModel, rule)
                              : null,
                          onDelete: canChangeRule
                              ? () => _deleteRule(viewModel, rule)
                              : null,
                          onToggle: canChangeRule
                              ? (value) => _toggleRule(viewModel, rule, value)
                              : null,
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
    final canChangeRule = PermissionUtil.snapshot(
      context,
    ).has('workorder.change_taskassignmentrule');
    return DetailSectionCard(
      title: '默认分派部门',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            onPressed: _previewLoading ? null : _openPreviewDialog,
            icon: const Icon(Icons.visibility_outlined, size: 16),
            label: const Text('查看预览'),
          ),
          Switch(
            value: _globalEnabled,
            onChanged: canChangeRule ? _toggleGlobal : null,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _globalEnabled
                ? '施工单审核通过后，任务会按工序默认分派到部门。'
                : '默认分派已禁用，任务生成后需由主管手动分派部门。',
          ),
          if (_lookupError != null) ...[
            SizedBox(height: SpacingTokens.sm),
            Text(
              '工序或部门加载失败：$_lookupError',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            SizedBox(height: SpacingTokens.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _loadLookup,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('重新加载基础数据'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyRulesContent(
    BuildContext context,
    TaskAssignmentRuleViewModel viewModel,
  ) {
    final theme = Theme.of(context);
    final canCreateRule = PermissionUtil.snapshot(
      context,
    ).has('workorder.add_taskassignmentrule');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.rule_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: SpacingTokens.sm),
            Expanded(
              child: Text(_emptyText, style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
        SizedBox(height: SpacingTokens.md),
        if (canCreateRule)
          PageActionButton.filled(
            onPressed: () => _openRuleDialog(context, viewModel, null),
            icon: const Icon(Icons.add),
            label: _createButtonText,
          ),
      ],
    );
  }

  Future<void> _openPreviewDialog() async {
    await _loadPreview();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AppDialog(
        title: '分派效果预览',
        maxWidth: LayoutTokens.dialogWidthMd,
        content: SizedBox(
          width: double.maxFinite,
          child: TaskAssignmentRulePreviewContent(items: _previewData),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRule(
    TaskAssignmentRuleViewModel viewModel,
    TaskAssignmentRule rule,
  ) async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.change_taskassignmentrule')) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
    }
    final confirmed = await showTaskAssignmentRuleDeleteDialog(
      context,
      content:
          '确定要删除 ${rule.processName ?? '工序'} - ${rule.departmentName ?? '部门'} 的默认分派吗？',
    );
    if (confirmed != true) return;
    try {
      await viewModel.deleteRule(rule.id);
      ToastUtil.showSuccess('默认分派已删除');
      _loadPreview();
    } catch (err) {
      ToastUtil.showError(
        '删除失败: ${err.toString().replaceFirst('Exception: ', '')}',
      );
    }
  }

  Future<void> _toggleRule(
    TaskAssignmentRuleViewModel viewModel,
    TaskAssignmentRule rule,
    bool value,
  ) async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.change_taskassignmentrule')) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
    }
    try {
      await viewModel.updateRuleSilently(rule.id, {'is_active': value});
      ToastUtil.showSuccess(value ? '已启用' : '已禁用');
      _loadPreview();
    } catch (err) {
      ToastUtil.showError(
        '更新失败: ${err.toString().replaceFirst('Exception: ', '')}',
      );
    }
  }

  Future<void> _openRuleDialog(
    BuildContext context,
    TaskAssignmentRuleViewModel viewModel,
    TaskAssignmentRule? rule,
  ) async {
    final requiredPermission = rule == null
        ? 'workorder.add_taskassignmentrule'
        : 'workorder.change_taskassignmentrule';
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has(requiredPermission)) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
    }
    if (_processes.isEmpty || _departments.isEmpty) {
      ToastUtil.showError('请先加载工序与部门列表');
      return;
    }
    await showTaskAssignmentRuleEditDrawer(
      context,
      rule: rule,
      processes: _processes,
      departments: _departments,
      onSubmit: (payload) async {
        if (!PermissionUtil.snapshot(context).has(requiredPermission)) {
          ToastUtil.showError('当前账号无权执行该操作');
          return;
        }
        try {
          if (rule == null) {
            await viewModel.createRule(payload);
            ToastUtil.showSuccess('默认分派已创建');
          } else {
            await viewModel.updateRule(rule.id, payload);
            ToastUtil.showSuccess('默认分派已更新');
          }
          _loadPreview();
        } catch (err) {
          ToastUtil.showError(
            '保存失败: ${err.toString().replaceFirst('Exception: ', '')}',
          );
          rethrow;
        }
      },
    );
  }

  String _pageInfoText(TaskAssignmentRuleViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }
}
