import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';

class TaskStatsEntry extends StatelessWidget {
  const TaskStatsEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<TaskApiService>(
      create: (context) => TaskApiService(context.read<ApiClient>()),
      child: const TaskStatsPage(),
    );
  }
}

class TaskStatsPage extends StatelessWidget {
  const TaskStatsPage({super.key});

  @override
  Widget build(BuildContext context) => const _TaskStatsView();
}

class _TaskStatsView extends StatefulWidget {
  const _TaskStatsView();

  @override
  State<_TaskStatsView> createState() => _TaskStatsViewState();
}

class _TaskStatsViewState extends State<_TaskStatsView> {
  static const double _spacingSm = LayoutTokens.gapSm;
  static const String _refreshButtonText = '刷新';
  static const String _resetButtonText = '重置筛选';
  static const String _emptyText = '暂无统计数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';

  bool _loading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _stats = [];

  List<Department> _departments = [];
  int? _departmentId;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
    _loadStats();
  }

  Future<void> _loadDepartments() async {
    try {
      final apiClient = context.read<ApiClient>();
      final deptApi = DepartmentApiService(apiClient);
      final page = await deptApi.fetchDepartments(page: 1, pageSize: 200);
      if (!mounted) return;
      setState(() {
        _departments = page.items.map((dto) => dto.toEntity()).toList();
      });
    } catch (_) {
      // ignore
    }
  }

  Future<void> _loadStats() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final api = context.read<TaskApiService>();
      final params = <String, dynamic>{};
      if (_startDate != null) {
        params['start_date'] = _formatDate(_startDate!);
      }
      if (_endDate != null) {
        params['end_date'] = _formatDate(_endDate!);
      }
      if (_departmentId != null) {
        params['department_id'] = _departmentId;
      }
      final payload = await api.fetchCollaborationStats(params: params);
      final results = payload['results'];
      setState(() {
        _stats = results is List
            ? results
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList()
            : [];
      });
    } catch (err) {
      setState(() {
        _errorMessage = err.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _resetFilters() {
    setState(() {
      _departmentId = null;
      _startDate = null;
      _endDate = null;
    });
    _loadStats();
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
    _loadStats();
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
    );
  }

  Widget _buildFilters(bool isMobile) {
    final departmentItems = [
      const DropdownMenuItem<int?>(
        value: null,
        child: Text('全部部门', overflow: TextOverflow.ellipsis),
      ),
      ..._departments.map(
        (dept) => DropdownMenuItem<int?>(
          value: dept.id,
          child: Text(dept.name, overflow: TextOverflow.ellipsis),
        ),
      ),
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
                    departmentItems: departmentItems,
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
                          departmentItems: departmentItems,
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
              onPressed: _loadStats,
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
    required List<DropdownMenuItem<int?>> departmentItems,
  }) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [
        _DateField(
          label: '开始日期',
          value: _startDate,
          onTap: () => _pickDate(isStart: true),
          onClear: () {
            setState(() => _startDate = null);
            _loadStats();
          },
        ),
        SizedBox(height: spacing),
        _DateField(
          label: '结束日期',
          value: _endDate,
          onTap: () => _pickDate(isStart: false),
          onClear: () {
            setState(() => _endDate = null);
            _loadStats();
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<int?>(
          key: ValueKey<int?>(_departmentId),
          initialValue: _departmentId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '部门'),
          items: departmentItems,
          onChanged: (value) {
            setState(() => _departmentId = value);
            _loadStats();
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
    if (_loading && _stats.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null && !_loading) {
      return ErrorStateCard(
        message: _errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: _loadStats,
      );
    }
    if (_stats.isEmpty && !_loading) {
      return const EmptyStateCard(
        icon: Icons.insights_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context);
    }

    return ListView.separated(
      itemCount: _stats.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _stats[index];
        return _StatsCard(item: item);
      },
    );
  }

  Widget _buildDesktopTable(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('操作员')),
        DataColumn(label: Text('部门')),
        DataColumn(label: Text('完成率')),
        DataColumn(label: Text('任务总数')),
        DataColumn(label: Text('已完成')),
        DataColumn(label: Text('进行中')),
        DataColumn(label: Text('待开始')),
        DataColumn(label: Text('完成总数')),
        DataColumn(label: Text('不良品数')),
        DataColumn(label: Text('不良品率')),
        DataColumn(label: Text('平均完成时长')),
      ],
      rows: _stats.map(
        (item) {
          final name = item['operator_name']?.toString() ??
              item['operator_username']?.toString() ??
              '-';
          final departments = item['departments'] as List? ?? const [];
          final deptText =
              departments.isEmpty ? '未分配部门' : departments.join('、');
          final completionRate = _toNum(item['completion_rate']);
          final defectiveRate = _toNum(item['defective_rate']);
          final avgHours = item['avg_completion_hours'] == null
              ? '-'
              : '${_toNum(item['avg_completion_hours']).toStringAsFixed(1)} 小时';

          return DataRow(
            cells: [
              DataCell(Text(name, style: theme.textTheme.bodyMedium)),
              DataCell(Text(deptText, style: textStyle)),
              DataCell(Text('${completionRate.toStringAsFixed(1)}%',
                  style: textStyle)),
              DataCell(
                  Text('${_toInt(item['total_tasks'])}', style: textStyle)),
              DataCell(
                  Text('${_toInt(item['completed_tasks'])}', style: textStyle)),
              DataCell(Text('${_toInt(item['in_progress_tasks'])}',
                  style: textStyle)),
              DataCell(
                  Text('${_toInt(item['pending_tasks'])}', style: textStyle)),
              DataCell(Text(
                  _toNum(item['total_completed_quantity']).toStringAsFixed(0),
                  style: textStyle)),
              DataCell(Text(
                  _toNum(item['total_defective_quantity']).toStringAsFixed(0),
                  style: textStyle)),
              DataCell(Text('${defectiveRate.toStringAsFixed(2)}%',
                  style: textStyle)),
              DataCell(Text(avgHours, style: textStyle)),
            ],
          );
        },
      ).toList(),
    );
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _toNum(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final name = item['operator_name']?.toString() ??
        item['operator_username']?.toString() ??
        '-';
    final departments = item['departments'] as List? ?? const [];
    final completionRate = _toNum(item['completion_rate']);
    final defectiveRate = _toNum(item['defective_rate']);

    return DetailSectionCard(
      title: name,
      trailing: Text(
        '完成率 ${completionRate.toStringAsFixed(1)}%',
        style: theme.textTheme.bodySmall?.copyWith(color: colors.subtleText),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (departments.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: departments
                  .map((dept) => Chip(label: Text(dept.toString())))
                  .toList(),
            )
          else
            Text(
              '未分配部门',
              style:
                  theme.textTheme.bodySmall?.copyWith(color: colors.subtleText),
            ),
          const SizedBox(height: 12),
          SummaryFieldWrap(
            isMobile: BreakpointsUtil.isMobile(context),
            children: [
              SummaryField(
                  label: '任务总数', value: '${_toInt(item['total_tasks'])}'),
              SummaryField(
                  label: '已完成', value: '${_toInt(item['completed_tasks'])}'),
              SummaryField(
                  label: '进行中', value: '${_toInt(item['in_progress_tasks'])}'),
              SummaryField(
                  label: '待开始', value: '${_toInt(item['pending_tasks'])}'),
              SummaryField(
                  label: '完成总数',
                  value:
                      '${_toNum(item['total_completed_quantity']).toStringAsFixed(0)}'),
              SummaryField(
                  label: '不良品数',
                  value:
                      '${_toNum(item['total_defective_quantity']).toStringAsFixed(0)}'),
              SummaryField(
                  label: '不良品率', value: '${defectiveRate.toStringAsFixed(2)}%'),
              SummaryField(
                label: '平均完成时长',
                value: item['avg_completion_hours'] == null
                    ? '-'
                    : '${_toNum(item['avg_completion_hours']).toStringAsFixed(1)} 小时',
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _toNum(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
