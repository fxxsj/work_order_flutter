import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_plan_api_service.dart';

class PaymentPlanListEntry extends StatelessWidget {
  const PaymentPlanListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'payment_plans',
        title: '收款计划',
        endpoint: '/payment-plans/',
        searchHintText: '搜索客户订单/计划日期',
        emptyText: '暂无收款计划',
        emptyIcon: Icons.event_note_outlined,
        columns: const [
          GenericColumn(label: '客户订单号', value: _salesOrderNumber),
          GenericColumn(label: '计划金额', value: _planAmount, numeric: true),
          GenericColumn(label: '计划日期', value: _planDate),
          GenericColumn(label: '状态', value: _status),
          GenericColumn(label: '已收金额', value: _paidAmount, numeric: true),
        ],
        summaryFields: const [
          GenericSummaryField(label: '计划金额', value: _planAmount),
          GenericSummaryField(label: '计划日期', value: _planDate),
          GenericSummaryField(label: '状态', value: _status),
          GenericSummaryField(label: '已收金额', value: _paidAmount),
        ],
        titleBuilder: _salesOrderNumber,
        rowActionsBuilder: (context, record, openDetails) {
          return [
            RowAction(
              label: '查看',
              icon: Icons.visibility_outlined,
              onPressed: openDetails,
            ),
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
      final actionService = PaymentPlanActionService(context.read<ApiClient>());
      await actionService.updateStatus(record.id);
      ToastUtil.showSuccess('状态已更新');
      final viewModel = context.read<GenericListViewModel>();
      await viewModel.loadItems(resetPage: false);
    } catch (err) {
      ToastUtil.showError('更新失败: $err');
    }
  }

  static String _salesOrderNumber(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('sales_order_number'));
  }

  static String _planAmount(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('plan_amount'));
  }

  static String _planDate(GenericRecord record) {
    return GenericValueFormatter.date(record.getString('plan_date'));
  }

  static String _status(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('status_display'));
  }

  static String _paidAmount(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('paid_amount'));
  }
}
