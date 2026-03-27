import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/processes/application/process_view_model.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_repository_impl.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/processes/domain/process_repository.dart';
import 'package:work_order_app/src/features/processes/presentation/process_edit_page.dart';

/// 工序列表入口。
class ProcessListEntry extends StatelessWidget {
  const ProcessListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<ProcessApiService, ProcessRepository, ProcessViewModel>(
      createService: (context) => ProcessApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          ProcessRepositoryImpl(context.read<ProcessApiService>()),
      createViewModel: (context) =>
          ProcessViewModel(context.read<ProcessRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ProcessListPage(),
    );
  }
}

/// 工序列表页视图，只负责渲染。
class ProcessListPage extends StatelessWidget {
  const ProcessListPage({super.key});

  static const CrudDeleteConfig<Process> _deleteConfig = CrudDeleteConfig(
    title: '确认删除',
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    errorMessagePrefix: '删除失败: ',
  );

  static const CrudListConfig<Process, ProcessViewModel> _config =
      CrudListConfig(
    searchHintText: '搜索工序名称、编码',
    emptyText: '暂无工序数据',
    emptyIcon: Icons.account_tree_outlined,
    loadItems: _loadProcesses,
    titleBuilder: _titleText,
    subtitleBuilder: _subtitleText,
    summaryChipsBuilder: _summaryChips,
    summaryFieldsBuilder: _summaryFields,
    headerActionsBuilder: _headerActions,
    rowActionsBuilder: _rowActions,
    columns: [
      CrudTableColumn(label: '工序', cellBuilder: _buildNameCell),
      CrudTableColumn(label: '编码', cellBuilder: _buildCodeCell),
      CrudTableColumn(label: '标准工时(小时)', cellBuilder: _buildDurationCell),
      CrudTableColumn(label: '排序', cellBuilder: _buildSortOrderCell),
      CrudTableColumn(label: '状态', cellBuilder: _buildStatusCell),
      CrudTableColumn(label: '描述', cellBuilder: _buildDescriptionCell),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const CrudListPage<Process, ProcessViewModel>(config: _config);
  }

  static Future<void> _loadProcesses(
    ProcessViewModel viewModel, {
    bool resetPage = false,
  }) {
    return viewModel.loadProcesses(resetPage: resetPage);
  }

  static Future<void> _openEditPage(
    BuildContext context,
    ProcessViewModel viewModel,
    Process? process,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: ProcessEditPage(process: process),
        ),
      ),
    );
    if (result == true) {
      ToastUtil.showSuccess(process == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    ProcessViewModel viewModel,
    Process process,
  ) {
    return confirmCrudDeletion(
      context,
      item: process,
      onDelete: (item) => viewModel.deleteProcess(item.id),
      config: _deleteConfig,
    );
  }

  static List<Widget> _headerActions(
    BuildContext context,
    ProcessViewModel viewModel,
  ) {
    return [
      PageActionButton.filled(
        onPressed: () => _openEditPage(context, viewModel, null),
        icon: const Icon(Icons.add),
        label: '新建工序',
      ),
    ];
  }

  static List<RowAction> _rowActions(
    BuildContext context,
    ProcessViewModel viewModel,
    Process process,
  ) {
    return [
      RowAction(
        label: '编辑',
        onPressed: () => _openEditPage(context, viewModel, process),
      ),
      RowAction(
        label: '删除',
        onPressed: () => _confirmDelete(context, viewModel, process),
        destructive: true,
      ),
    ];
  }

  static Widget _buildNameCell(BuildContext context, Process process) {
    return Text(
      _titleText(process),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  static Widget _buildCodeCell(BuildContext context, Process process) {
    return _buildBodyText(context, CrudValueFormatter.text(process.code));
  }

  static Widget _buildDurationCell(BuildContext context, Process process) {
    return _buildBodyText(context, _durationText(process.standardDuration));
  }

  static Widget _buildSortOrderCell(BuildContext context, Process process) {
    return _buildBodyText(
      context,
      CrudValueFormatter.number(process.sortOrder),
    );
  }

  static Widget _buildStatusCell(BuildContext context, Process process) {
    return _buildBodyText(context, _statusText(process));
  }

  static Widget _buildDescriptionCell(BuildContext context, Process process) {
    return _buildBodyText(
        context, CrudValueFormatter.text(process.description));
  }

  static Widget _buildBodyText(BuildContext context, String value) {
    return Text(
      value,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  static String _titleText(Process process) {
    return CrudValueFormatter.text(process.name);
  }

  static String _subtitleText(Process process) {
    return '${CrudValueFormatter.text(process.code)} · '
        '${_durationText(process.standardDuration)} h';
  }

  static String _durationText(double? value) {
    if (value == null) {
      return CrudValueFormatter.empty;
    }
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }

  static String _statusText(Process process) {
    return process.isActive ? '启用' : '禁用';
  }

  static List<CrudSummaryChipData> _summaryChips(Process process) {
    return [
      CrudSummaryChipData(label: '状态', value: _statusText(process)),
      CrudSummaryChipData(
        label: '排序',
        value: CrudValueFormatter.number(process.sortOrder),
      ),
    ];
  }

  static List<CrudSummaryFieldData> _summaryFields(Process process) {
    return [
      CrudSummaryFieldData(
        label: '编码',
        value: CrudValueFormatter.text(process.code),
      ),
      CrudSummaryFieldData(
        label: '描述',
        value: CrudValueFormatter.text(process.description),
      ),
      CrudSummaryFieldData(
        label: '标准工时(小时)',
        value: _durationText(process.standardDuration),
      ),
      CrudSummaryFieldData(
        label: '排序',
        value: CrudValueFormatter.number(process.sortOrder),
      ),
      CrudSummaryFieldData(
        label: '状态',
        value: _statusText(process),
      ),
    ];
  }

  static String _buildDeleteSummary(Process process) {
    return '即将删除工序 ${_titleText(process)}。删除后，相关部门配置和默认流程可能需要重新调整。';
  }

  static List<String> _buildDeleteImpacts(Process process) {
    return [
      '工序编码：${CrudValueFormatter.text(process.code)}',
      '标准工时：${_durationText(process.standardDuration)} 小时',
      '若已有部门、产品或工单使用该工序，删除可能失败或需要先解除关联',
    ];
  }

  static String _buildDeleteAuditHint(Process process) {
    return '如果只是暂停使用该工序，优先考虑停用状态，而不是直接删除。';
  }
}
