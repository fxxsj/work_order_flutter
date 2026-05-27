import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';

class ProcessLogListEntry extends StatelessWidget {
  const ProcessLogListEntry({super.key});

  static const String _listRoute = '/process-logs';

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'process_logs',
        title: '工序日志',
        endpoint: '/process-logs/',
        searchHintText: '搜索工序日志',
        emptyText: '暂无工序日志',
        emptyIcon: Icons.article_outlined,
        openDetailsOnPrimaryTap: true,
        columns: const [
          GenericColumn(label: '施工单', value: _workOrder),
          GenericColumn(label: '工序', value: _process),
          GenericColumn(label: '类型', value: _logType),
          GenericColumn(label: '操作人', value: _operator),
          GenericColumn(label: '创建时间', value: _createdAt),
        ],
        summaryFields: const [
          GenericSummaryField(label: '施工单', value: _workOrder),
          GenericSummaryField(label: '工序', value: _process),
          GenericSummaryField(label: '类型', value: _logType),
          GenericSummaryField(label: '操作人', value: _operator),
        ],
        titleBuilder: _logType,
        detailFields: const [
          GenericDetailField(label: '施工单', value: _workOrder),
          GenericDetailField(label: '工序', value: _process),
          GenericDetailField(label: '类型', value: _logType),
          GenericDetailField(label: '操作人', value: _operator),
          GenericDetailField(label: '创建时间', value: _createdAt),
          GenericDetailField(label: '内容', value: _content),
        ],
        extraParamsBuilder: _extraParamsBuilder,
        headerActionsBuilder: _buildHeaderActions,
      ),
    );
  }

  static String _workOrder(GenericRecord record) {
    return GenericValueFormatter.text(
      record.getString('work_order_number') ??
          record.getString('work_order_process_label'),
    );
  }

  static String _process(GenericRecord record) {
    return GenericValueFormatter.text(
      record.getString('process_name') ??
          record.getString('work_order_process_label'),
    );
  }

  static String _logType(GenericRecord record) {
    return GenericValueFormatter.text(
      record.getString('log_type_display') ??
          _logTypeLabel(record.getString('log_type')),
    );
  }

  static String _operator(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('operator_name'));
  }

  static String _createdAt(GenericRecord record) {
    return GenericValueFormatter.date(record.getString('created_at'));
  }

  static String _content(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('content'));
  }

  static Map<String, dynamic> _extraParamsBuilder(Uri uri) {
    final extraParams = <String, dynamic>{};
    final logType = uri.queryParameters['log_type']?.trim() ?? '';
    if (logType.isNotEmpty) {
      extraParams['log_type'] = logType;
    }
    final ordering = uri.queryParameters['ordering']?.trim() ?? '';
    extraParams['ordering'] = ordering.isEmpty ? '-created_at' : ordering;
    return extraParams;
  }

  static List<Widget> _buildHeaderActions(
    BuildContext context,
    GenericListViewModel viewModel,
  ) {
    return [
      if (_hasActiveFilter(viewModel))
        OutlinedButton.icon(
          onPressed: () => context.go(_listRoute),
          icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
          label: const Text('清除筛选'),
        ),
      SizedBox(
        width: 140,
        child: AppSelect<String>(
          key: ValueKey<String>(_currentLogType(viewModel)),
          value: _currentLogType(viewModel).isEmpty
              ? null
              : _currentLogType(viewModel),
          selectHintText: '日志类型',
          options: const [
            AppDropdownOption<String>(value: '', label: '全部类型'),
            AppDropdownOption<String>(value: 'start', label: '开始'),
            AppDropdownOption<String>(value: 'pause', label: '暂停'),
            AppDropdownOption<String>(value: 'resume', label: '恢复'),
            AppDropdownOption<String>(value: 'complete', label: '完成'),
            AppDropdownOption<String>(value: 'note', label: '备注'),
          ],
          onChanged: (value) =>
              _openFilter(context, viewModel, logType: value ?? ''),
        ),
      ),
      SizedBox(
        width: 170,
        child: AppSelect<String>(
          key: ValueKey<String>(_currentOrdering(viewModel)),
          value: _currentOrdering(viewModel),
          selectHintText: '排序',
          options: const [
            AppDropdownOption<String>(value: '-created_at', label: '时间降序'),
            AppDropdownOption<String>(value: 'created_at', label: '时间升序'),
            AppDropdownOption<String>(value: 'log_type', label: '类型升序'),
            AppDropdownOption<String>(value: '-log_type', label: '类型降序'),
            AppDropdownOption<String>(
              value: 'work_order_process__work_order__order_number',
              label: '施工单升序',
            ),
            AppDropdownOption<String>(
              value: '-work_order_process__work_order__order_number',
              label: '施工单降序',
            ),
          ],
          onChanged: (value) =>
              _openFilter(context, viewModel, ordering: value ?? '-created_at'),
        ),
      ),
      PageActionButton.outlined(
        onPressed: viewModel.reload,
        icon: const Icon(Icons.refresh),
        label: '刷新',
      ),
    ];
  }

  static String _currentLogType(GenericListViewModel viewModel) {
    return viewModel.extraParams['log_type']?.toString().trim() ?? '';
  }

  static String _currentOrdering(GenericListViewModel viewModel) {
    final value = viewModel.extraParams['ordering']?.toString().trim() ?? '';
    return value.isEmpty ? '-created_at' : value;
  }

  static bool _hasActiveFilter(GenericListViewModel viewModel) {
    return _currentLogType(viewModel).isNotEmpty ||
        _currentOrdering(viewModel) != '-created_at';
  }

  static void _openFilter(
    BuildContext context,
    GenericListViewModel viewModel, {
    String? logType,
    String? ordering,
  }) {
    final query = <String, String>{};
    final search = viewModel.searchText.trim();
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    final nextLogType = logType ?? _currentLogType(viewModel);
    if (nextLogType.trim().isNotEmpty) {
      query['log_type'] = nextLogType.trim();
    }
    final nextOrdering = ordering ?? _currentOrdering(viewModel);
    if (nextOrdering.trim().isNotEmpty && nextOrdering != '-created_at') {
      query['ordering'] = nextOrdering.trim();
    }
    context.go(Uri(path: _listRoute, queryParameters: query).toString());
  }

  static String _logTypeLabel(String? value) {
    switch (value) {
      case 'start':
        return '开始';
      case 'pause':
        return '暂停';
      case 'resume':
        return '恢复';
      case 'complete':
        return '完成';
      case 'note':
        return '备注';
      default:
        return value ?? '';
    }
  }
}
