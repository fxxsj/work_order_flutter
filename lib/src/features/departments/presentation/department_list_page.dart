import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/departments/application/department_view_model.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/data/department_repository_impl.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/departments/domain/department_repository.dart';
import 'package:work_order_app/src/features/departments/presentation/department_edit_page.dart';

/// 部门列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class DepartmentListEntry extends StatelessWidget {
  const DepartmentListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      DepartmentApiService,
      DepartmentRepository,
      DepartmentViewModel
    >(
      createService: (context) =>
          DepartmentApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          DepartmentRepositoryImpl(context.read<DepartmentApiService>()),
      createViewModel: (context) =>
          DepartmentViewModel(context.read<DepartmentRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const DepartmentListPage(),
    );
  }
}

/// 部门列表页视图，只负责渲染。
class DepartmentListPage extends StatelessWidget {
  const DepartmentListPage({super.key});

  static const CrudDeleteConfig<Department> _deleteConfig = CrudDeleteConfig(
    title: '确认删除',
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    errorMessagePrefix: '删除失败: ',
  );

  static const CrudListConfig<Department, DepartmentViewModel> _config =
      CrudListConfig(
        searchHintText: '搜索部门名称、编码',
        emptyText: '暂无部门数据',
        emptyIcon: Icons.apartment_outlined,
        loadItems: _loadDepartments,
        titleBuilder: _titleText,
        subtitleBuilder: _subtitleText,
        summaryChipsBuilder: _summaryChips,
        summaryFieldsBuilder: _summaryFields,
        headerActionsBuilder: _headerActions,
        rowActionsBuilder: _rowActions,
        columns: [
          CrudTableColumn(label: '部门', cellBuilder: _buildNameCell),
          CrudTableColumn(label: '编码', cellBuilder: _buildCodeCell),
          CrudTableColumn(label: '上级部门', cellBuilder: _buildParentCell),
          CrudTableColumn(label: '子部门', cellBuilder: _buildChildrenCountCell),
          CrudTableColumn(label: '工序', cellBuilder: _buildProcessesCell),
          CrudTableColumn(label: '排序', cellBuilder: _buildSortOrderCell),
          CrudTableColumn(label: '状态', cellBuilder: _buildStatusCell),
          CrudTableColumn(label: '创建时间', cellBuilder: _buildCreatedAtCell),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return const CrudListPage<Department, DepartmentViewModel>(config: _config);
  }

  static Future<void> _loadDepartments(
    DepartmentViewModel viewModel, {
    bool resetPage = false,
  }) {
    return viewModel.loadDepartments(resetPage: resetPage);
  }

  static Future<void> _openEditPage(
    BuildContext context,
    DepartmentViewModel viewModel,
    Department? department,
  ) async {
    final result = await showDepartmentEditDrawer(
      context,
      viewModel: viewModel,
      department: department,
    );
    if (result) {
      ToastUtil.showSuccess(department == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    DepartmentViewModel viewModel,
    Department department,
  ) {
    return confirmCrudDeletion(
      context,
      item: department,
      onDelete: (item) => viewModel.deleteDepartment(item.id),
      config: _deleteConfig,
    );
  }

  static List<Widget> _headerActions(
    BuildContext context,
    DepartmentViewModel viewModel,
  ) {
    return [
      SizedBox(
        width: 112,
        child: AppSelect<String>(
          options: const [
            AppDropdownOption(value: '', label: '全部状态'),
            AppDropdownOption(value: 'true', label: '启用'),
            AppDropdownOption(value: 'false', label: '禁用'),
          ],
          value: viewModel.isActive == null
              ? ''
              : viewModel.isActive == true
              ? 'true'
              : 'false',
          onChanged: (value) {
            if (value == null || value.isEmpty) {
              viewModel.setIsActive(null);
            } else {
              viewModel.setIsActive(value == 'true');
            }
          },
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(width: 8),
      SizedBox(
        width: 132,
        child: AppSelect<String>(
          options: const [
            AppDropdownOption(value: 'sort_order', label: '排序升序'),
            AppDropdownOption(value: '-sort_order', label: '排序降序'),
            AppDropdownOption(value: 'code', label: '编码升序'),
            AppDropdownOption(value: '-code', label: '编码降序'),
            AppDropdownOption(value: 'name', label: '名称升序'),
            AppDropdownOption(value: '-name', label: '名称降序'),
          ],
          value: viewModel.ordering ?? 'sort_order',
          onChanged: (value) {
            if (value != null) viewModel.setOrdering(value);
          },
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(width: 8),
      PageActionButton.filled(
        onPressed: () => _openEditPage(context, viewModel, null),
        icon: const Icon(Icons.add),
        label: '新建部门',
      ),
    ];
  }

  static List<RowAction> _rowActions(
    BuildContext context,
    DepartmentViewModel viewModel,
    Department department,
  ) {
    return [
      RowAction(
        label: '编辑',
        onPressed: () => _openEditPage(context, viewModel, department),
      ),
      RowAction(
        label: '删除',
        onPressed: () => _confirmDelete(context, viewModel, department),
        destructive: true,
      ),
    ];
  }

  static Widget _buildNameCell(BuildContext context, Department department) {
    return Text(
      _titleText(department),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  static Widget _buildCodeCell(BuildContext context, Department department) {
    return _buildBodyText(context, CrudValueFormatter.text(department.code));
  }

  static Widget _buildParentCell(BuildContext context, Department department) {
    return _buildBodyText(
      context,
      CrudValueFormatter.text(department.parentName),
    );
  }

  static Widget _buildChildrenCountCell(
    BuildContext context,
    Department department,
  ) {
    return _buildBodyText(
      context,
      CrudValueFormatter.number(department.childrenCount),
    );
  }

  static Widget _buildProcessesCell(
    BuildContext context,
    Department department,
  ) {
    return _DepartmentProcessesCell(processNames: department.processNames);
  }

  static Widget _buildSortOrderCell(
    BuildContext context,
    Department department,
  ) {
    return _buildBodyText(
      context,
      CrudValueFormatter.number(department.sortOrder),
    );
  }

  static Widget _buildStatusCell(BuildContext context, Department department) {
    return _buildBodyText(context, _statusText(department));
  }

  static Widget _buildCreatedAtCell(
    BuildContext context,
    Department department,
  ) {
    return _buildBodyText(
      context,
      CrudValueFormatter.dateTime(department.createdAt),
    );
  }

  static Widget _buildBodyText(BuildContext context, String value) {
    return Text(value, style: Theme.of(context).textTheme.bodySmall);
  }

  static String _titleText(Department department) {
    return CrudValueFormatter.text(department.name);
  }

  static String _subtitleText(Department department) {
    return '${CrudValueFormatter.text(department.code)} · '
        '${CrudValueFormatter.text(department.parentName)}';
  }

  static String _statusText(Department department) {
    return department.isActive ? '启用' : '禁用';
  }

  static String _processesText(Department department) {
    if (department.processNames.isEmpty) {
      return CrudValueFormatter.empty;
    }
    return department.processNames.join('、');
  }

  static List<CrudSummaryChipData> _summaryChips(Department department) {
    return [
      CrudSummaryChipData(label: '状态', value: _statusText(department)),
      CrudSummaryChipData(
        label: '子部门',
        value: CrudValueFormatter.number(department.childrenCount),
      ),
    ];
  }

  static List<CrudSummaryFieldData> _summaryFields(Department department) {
    return [
      CrudSummaryFieldData(
        label: '编码',
        value: CrudValueFormatter.text(department.code),
      ),
      CrudSummaryFieldData(
        label: '上级部门',
        value: CrudValueFormatter.text(department.parentName),
      ),
      CrudSummaryFieldData(
        label: '子部门',
        value: CrudValueFormatter.number(department.childrenCount),
      ),
      CrudSummaryFieldData(label: '工序', value: _processesText(department)),
      CrudSummaryFieldData(
        label: '排序',
        value: CrudValueFormatter.number(department.sortOrder),
      ),
      CrudSummaryFieldData(label: '状态', value: _statusText(department)),
      CrudSummaryFieldData(
        label: '创建时间',
        value: CrudValueFormatter.dateTime(department.createdAt),
      ),
    ];
  }

  static String _buildDeleteSummary(Department department) {
    return '即将删除部门 ${_titleText(department)}。删除后，组织层级和相关业务配置可能受到影响。';
  }

  static List<String> _buildDeleteImpacts(Department department) {
    return [
      '部门编码：${CrudValueFormatter.text(department.code)}',
      if ((department.childrenCount ?? 0) > 0)
        '当前存在 ${department.childrenCount} 个子部门，删除前需要先调整层级关系',
      if (department.processNames.isNotEmpty)
        '已关联工序：${department.processNames.join('、')}',
    ];
  }

  static String _buildDeleteAuditHint(Department department) {
    return '若只是停用部门，优先考虑调整状态或迁移人员归属，而不是直接删除。';
  }
}

class _DepartmentProcessesCell extends StatefulWidget {
  const _DepartmentProcessesCell({required this.processNames});

  final List<String> processNames;

  @override
  State<_DepartmentProcessesCell> createState() =>
      _DepartmentProcessesCellState();
}

class _DepartmentProcessesCellState extends State<_DepartmentProcessesCell> {
  static const int _collapsedVisibleCount = 1;

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final processNames = widget.processNames;
    if (processNames.isEmpty) {
      final theme = Theme.of(context);
      final colors = theme.extension<AppColors>();
      return Text(
        CrudValueFormatter.empty,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colors?.subtleText ?? theme.hintColor,
        ),
      );
    }

    final visibleProcesses =
        _expanded || processNames.length <= _collapsedVisibleCount
        ? processNames
        : processNames.take(_collapsedVisibleCount).toList();
    final remainingCount = processNames.length - _collapsedVisibleCount;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final processName in visibleProcesses) ...[
            _ProcessTag(label: processName),
            const SizedBox(width: LayoutTokens.gapXxs),
          ],
          if (processNames.length > _collapsedVisibleCount)
            _ProcessToggleTag(
              expanded: _expanded,
              hiddenCount: remainingCount,
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
        ],
      ),
    );
  }
}

class _ProcessTag extends StatelessWidget {
  const _ProcessTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final semantic = theme.extension<AppSemanticColors>();
    return Tooltip(
      message: label,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 140),
        padding: const EdgeInsets.symmetric(
          horizontal: LayoutTokens.gapSm,
          vertical: LayoutTokens.gapXxs,
        ),
        decoration: BoxDecoration(
          color:
              semantic?.surfaceAlt ?? theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(LayoutTokens.radiusXs),
          border: Border.all(color: colors?.borderColor ?? theme.dividerColor),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colors?.sidebarText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ProcessToggleTag extends StatelessWidget {
  const _ProcessToggleTag({
    required this.expanded,
    required this.hiddenCount,
    required this.onPressed,
  });

  final bool expanded;
  final int hiddenCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(LayoutTokens.radiusXs),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: LayoutTokens.gapSm,
          vertical: LayoutTokens.gapXxs,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(
            alpha: OpacityTokens.faint,
          ),
          borderRadius: BorderRadius.circular(LayoutTokens.radiusXs),
          border: Border.all(color: colors?.borderColor ?? theme.dividerColor),
        ),
        child: Text(
          expanded ? '收起' : '+$hiddenCount',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
