import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class PaymentPlanListEntry extends StatelessWidget {
  const PaymentPlanListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'payment_plans',
        title: '收款计划',
        endpoint: '/payment-plans/',
        searchHintText: '搜索销售订单/计划日期',
        emptyText: '暂无收款计划',
        emptyIcon: Icons.event_note_outlined,
        columns: const [
          GenericColumn(label: '销售订单号', value: _salesOrderNumber),
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
      ),
    );
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
