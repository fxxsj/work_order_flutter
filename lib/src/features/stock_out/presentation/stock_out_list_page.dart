import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class StockOutListEntry extends StatelessWidget {
  const StockOutListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'stock_outs',
        title: '出库单',
        endpoint: '/stock-outs/',
        searchHintText: '搜索出库单号/发货单号',
        emptyText: '暂无出库单',
        emptyIcon: Icons.exit_to_app_outlined,
        columns: const [
          GenericColumn(label: '出库单号', value: _orderNumber),
          GenericColumn(label: '出库类型', value: _outType),
          GenericColumn(label: '发货单号', value: _deliveryOrderNumber),
          GenericColumn(label: '状态', value: _status),
          GenericColumn(label: '操作员', value: _operator),
          GenericColumn(label: '创建时间', value: _createdAt),
        ],
        summaryFields: const [
          GenericSummaryField(label: '出库类型', value: _outType),
          GenericSummaryField(label: '发货单号', value: _deliveryOrderNumber),
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

  static String _outType(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('out_type_display'));
  }

  static String _deliveryOrderNumber(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('delivery_order_number'));
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
