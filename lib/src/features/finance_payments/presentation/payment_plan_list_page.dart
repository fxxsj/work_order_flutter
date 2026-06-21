import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_plan_repository.dart';

/// 收款计划列表页视图，只负责渲染。
class PaymentPlanListPage extends StatelessWidget {
  const PaymentPlanListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'payment_plans',
        title: '收款计划',
        endpoint: '/payment-plans/',
        searchHintText: '搜索客户订单/客户/计划日期',
        emptyText: '暂无收款计划',
        emptyIcon: Icons.event_note_outlined,
        enableSummary: true,
        openDetailsOnPrimaryTap: true,
        columns: const [
          GenericColumn(label: '客户订单号', value: _salesOrderNumber),
          GenericColumn(label: '客户', value: _customerName),
          GenericColumn(label: '计划金额', value: _planAmount, numeric: true),
          GenericColumn(label: '计划日期', value: _planDate),
          GenericColumn(label: '状态', value: _status),
          GenericColumn(label: '待收金额', value: _remainingAmount, numeric: true),
          GenericColumn(label: '下一步', value: _followUp),
          GenericColumn(label: '已收金额', value: _paidAmount, numeric: true),
        ],
        summaryFields: const [
          GenericSummaryField(label: '客户', value: _customerName),
          GenericSummaryField(label: '计划金额', value: _planAmount),
          GenericSummaryField(label: '待收金额', value: _remainingAmount),
          GenericSummaryField(label: '计划日期', value: _planDate),
          GenericSummaryField(label: '状态', value: _status),
          GenericSummaryField(label: '下一步', value: _followUp),
          GenericSummaryField(label: '已收金额', value: _paidAmount),
        ],
        titleBuilder: _title,
        extraParamsBuilder: _extraParamsBuilder,
        headerActionsBuilder: _buildHeaderActions,
        rowActionsBuilder: (context, record, openDetails) {
          return [
            RowAction(
              label: '更新状态',
              icon: Icons.refresh_outlined,
              onPressed: () => _updateStatus(context, record),
            ),
          ];
        },
      ),
    );
  }

  static Future<void> _updateStatus(
    BuildContext context,
    GenericRecord record,
  ) async {
    try {
      await context.read<PaymentPlanRepository>().updateStatus(record.id);
      ToastUtil.showSuccess('状态已更新');
      final viewModel = context.read<GenericListViewModel>();
      await viewModel.loadItems(resetPage: false);
    } catch (err) {
      ToastUtil.showError('更新失败: $err');
    }
  }

  static String _salesOrderNumber(GenericRecord record) {
    return AppValueFormatter.text(record.getString('sales_order_number'));
  }

  static String _customerName(GenericRecord record) {
    return AppValueFormatter.text(record.getString('customer_name'));
  }

  static String _title(GenericRecord record) {
    final orderNumber = _salesOrderNumber(record);
    final customer = _customerName(record);
    if (customer == AppValueFormatter.empty) {
      return orderNumber;
    }
    return '$orderNumber · $customer';
  }

  static String _planAmount(GenericRecord record) {
    return AppValueFormatter.text(record.getNumber('plan_amount'));
  }

  static String _planDate(GenericRecord record) {
    return AppValueFormatter.date(record.getString('plan_date'));
  }

  static String _status(GenericRecord record) {
    return AppValueFormatter.text(record.getString('status_display'));
  }

  static String _paidAmount(GenericRecord record) {
    return AppValueFormatter.text(record.getNumber('paid_amount'));
  }

  static String _remainingAmount(GenericRecord record) {
    return AppValueFormatter.text(record.getNumber('remaining_amount'));
  }

  static String _followUp(GenericRecord record) {
    final text = record.getString('follow_up_text');
    if ((text ?? '').trim().isNotEmpty) {
      return AppValueFormatter.text(text);
    }
    if (record.getBool('is_overdue') == true) {
      final days = record.getNumber('overdue_days')?.toInt() ?? 0;
      return '推进收款，已逾期 $days 天';
    }
    return AppValueFormatter.empty;
  }

  static List<Widget> _buildHeaderActions(
    BuildContext context,
    GenericListViewModel viewModel,
  ) {
    final overdueCount = _summaryCount(viewModel, 'overdue_count');
    final dueTodayCount = _summaryCount(viewModel, 'due_today_count');
    final partialCount = _summaryCount(viewModel, 'partial_count');

    return [
      if (overdueCount > 0)
        StatusHintChip(
          label: '逾期计划',
          count: overdueCount,
          icon: Icons.warning_amber_outlined,
          selected: _currentTodo(viewModel) == 'overdue',
          onTap: () => _openQuickFilter(context, todo: 'overdue'),
        ),
      if (dueTodayCount > 0)
        StatusHintChip(
          label: '今日到期',
          count: dueTodayCount,
          icon: Icons.today_outlined,
          selected: _currentTodo(viewModel) == 'due_today',
          onTap: () => _openQuickFilter(context, todo: 'due_today'),
        ),
      if (partialCount > 0)
        StatusHintChip(
          label: '部分收款',
          count: partialCount,
          icon: Icons.pie_chart_outline,
          selected: _currentStatus(viewModel) == 'partial',
          onTap: () => _openQuickFilter(context, status: 'partial'),
        ),
      if (_hasActiveFilter(viewModel))
        OutlinedButton.icon(
          onPressed: () => context.go('/finance/payment-plans'),
          icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
          label: const Text('清除筛选'),
        ),
    ];
  }

  static Map<String, dynamic> _extraParamsBuilder(Uri uri) {
    final extraParams = <String, dynamic>{};
    final status = uri.queryParameters['status']?.trim() ?? '';
    final todo = uri.queryParameters['todo']?.trim() ?? '';
    final ordering = uri.queryParameters['ordering']?.trim() ?? '';
    if (status.isNotEmpty) {
      extraParams['status'] = status;
    }
    if (todo.isNotEmpty) {
      extraParams['todo'] = todo;
    }
    if (ordering.isNotEmpty) {
      extraParams['ordering'] = ordering;
    } else {
      extraParams['ordering'] = 'plan_date';
    }
    return extraParams;
  }

  static int _summaryCount(GenericListViewModel viewModel, String key) {
    final summary = viewModel.summary['summary'];
    if (summary is Map<String, dynamic>) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }
    if (summary is Map) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }
    return 0;
  }

  static bool _hasActiveFilter(GenericListViewModel viewModel) {
    final params = viewModel.extraParams;
    return (params['status']?.toString().trim() ?? '').isNotEmpty ||
        (params['todo']?.toString().trim() ?? '').isNotEmpty ||
        ((params['ordering']?.toString().trim() ?? 'plan_date') != 'plan_date');
  }

  static String _currentStatus(GenericListViewModel viewModel) {
    return viewModel.extraParams['status']?.toString().trim() ?? '';
  }

  static String _currentTodo(GenericListViewModel viewModel) {
    return viewModel.extraParams['todo']?.toString().trim() ?? '';
  }

  static void _openQuickFilter(
    BuildContext context, {
    String? status,
    String? todo,
  }) {
    final query = <String, String>{};
    if ((status ?? '').trim().isNotEmpty) {
      query['status'] = status!.trim();
    }
    if ((todo ?? '').trim().isNotEmpty) {
      query['todo'] = todo!.trim();
    }
    final ordering = context
        .read<GenericListViewModel>()
        .extraParams['ordering']
        ?.toString();
    if ((ordering ?? '').trim().isNotEmpty && ordering != 'plan_date') {
      query['ordering'] = ordering!.trim();
    }
    context.go(
      Uri(path: '/finance/payment-plans', queryParameters: query).toString(),
    );
  }
}
