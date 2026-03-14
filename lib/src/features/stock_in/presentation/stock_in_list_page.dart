import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class StockInListEntry extends StatelessWidget {
  const StockInListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'stock_ins',
        title: '入库单',
        endpoint: '/stock-ins/',
        searchHintText: '搜索入库单号/施工单',
        emptyText: '暂无入库单',
        emptyIcon: Icons.inventory_2_outlined,
        columns: const [
          GenericColumn(label: '入库单号', value: _orderNumber),
          GenericColumn(label: '施工单号', value: _workOrderNumber),
          GenericColumn(label: '入库日期', value: _stockInDate),
          GenericColumn(label: '状态', value: _status),
          GenericColumn(label: '操作员', value: _operator),
          GenericColumn(label: '创建时间', value: _createdAt),
        ],
        summaryFields: const [
          GenericSummaryField(label: '施工单号', value: _workOrderNumber),
          GenericSummaryField(label: '入库日期', value: _stockInDate),
          GenericSummaryField(label: '状态', value: _status),
          GenericSummaryField(label: '操作员', value: _operator),
        ],
        titleBuilder: _orderNumber,
      ),
    );
  }

  static String _orderNumber(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('order_number'));
  }

  static String _workOrderNumber(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('work_order_number'));
  }

  static String _stockInDate(GenericRecord record) {
    return GenericValueFormatter.date(record.getString('stock_in_date'));
  }

  static String _status(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('status_display'));
  }

  static String _operator(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('operator_name'));
  }

  static String _createdAt(GenericRecord record) {
    return GenericValueFormatter.date(record.getString('created_at'));
  }
}
