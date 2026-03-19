import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';
import 'package:work_order_app/src/features/stock_out/data/stock_out_support_service.dart';

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
        headerActionsBuilder: (context, viewModel) => [
          PageActionButton.filled(
            onPressed: () => _openStockOutForm(context),
            icon: const Icon(Icons.add),
            label: '新建出库单',
          ),
        ],
        rowActionsBuilder: (context, record, openDetails) {
          final actions = <RowAction>[
            RowAction(label: '查看', onPressed: openDetails),
            RowAction(
              label: '编辑',
              icon: Icons.edit_outlined,
              onPressed: () => _openStockOutForm(context, record: record),
            ),
          ];
          final deliveryOrderId = record.getNumber('delivery_order') ??
              int.tryParse(record.getString('delivery_order') ?? '');
          if (deliveryOrderId != null && deliveryOrderId.toInt() > 0) {
            actions.add(RowAction(
              label: '查看发货单',
              icon: Icons.local_shipping_outlined,
              onPressed: () =>
                  _openDeliveryOrderDialog(context, deliveryOrderId.toInt()),
            ));
          }
          return actions;
        },
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
    return GenericValueFormatter.text(
        record.getString('delivery_order_number'));
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

  static const List<_OutTypeOption> _outTypeOptions = [
    _OutTypeOption(value: 'delivery', label: '发货出库'),
    _OutTypeOption(value: 'return', label: '退货出库'),
    _OutTypeOption(value: 'transfer', label: '调拨出库'),
    _OutTypeOption(value: 'defective', label: '次品出库'),
  ];

  static Future<void> _openStockOutForm(
    BuildContext context, {
    GenericRecord? record,
  }) async {
    final supportService = StockOutSupportService(context.read<ApiClient>());
    final isEdit = record != null;
    final recordId = record?.id;
    final outTypeController = TextEditingController(
      text: record?.getString('out_type') ?? 'delivery',
    );
    final deliveryOrderController = TextEditingController(
      text: record?.getNumber('delivery_order')?.toString() ??
          record?.getString('delivery_order') ??
          '',
    );
    final dateController = TextEditingController(
      text: _normalizeDate(record?.getString('stock_out_date')) ?? _today(),
    );
    final notesController = TextEditingController(
      text: record?.getString('notes') ?? '',
    );

    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        bool loading = false;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(isEdit ? '编辑出库单' : '新建出库单'),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SearchableDropdownFormField<String>(
                      initialValue: outTypeController.text,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: '出库类型'),
                      items: _outTypeOptions
                          .map(
                            (option) => DropdownMenuItem(
                              value: option.value,
                              child: Text(option.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          outTypeController.text = value ?? 'delivery',
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: deliveryOrderController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '发货单ID（可选）'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: '出库日期'),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.tryParse(dateController.text) ??
                              DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          dateController.text = _formatDate(picked);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(labelText: '备注'),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    loading ? null : () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: loading
                    ? null
                    : () async {
                        setState(() => loading = true);
                        try {
                          final payload = <String, dynamic>{
                            'out_type': outTypeController.text.trim(),
                            'stock_out_date': dateController.text.trim(),
                            'notes': notesController.text.trim(),
                          };
                          final deliveryOrderId =
                              int.tryParse(deliveryOrderController.text.trim());
                          if (deliveryOrderId != null) {
                            payload['delivery_order'] = deliveryOrderId;
                          }
                          await supportService.save(
                            id: isEdit ? recordId : null,
                            payload: payload,
                          );
                          if (!context.mounted) return;
                          context
                              .read<GenericListViewModel>()
                              .reload(resetPage: true);
                          Navigator.of(context).pop(true);
                          ToastUtil.showSuccess(isEdit ? '已更新' : '已创建');
                        } catch (err) {
                          ToastUtil.showError('保存失败: $err');
                        } finally {
                          if (context.mounted) setState(() => loading = false);
                        }
                      },
                child: Text(loading ? '保存中' : '保存'),
              ),
            ],
          ),
        );
      },
    );

    outTypeController.dispose();
    deliveryOrderController.dispose();
    dateController.dispose();
    notesController.dispose();
  }

  static Future<void> _openDeliveryOrderDialog(
    BuildContext context,
    int orderId,
  ) async {
    final supportService = StockOutSupportService(context.read<ApiClient>());
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('发货单详情'),
        content: FutureBuilder<DeliveryOrderDetail>(
          future: supportService.fetchDeliveryOrderDetail(orderId),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                width: 520,
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return SizedBox(
                width: 520,
                child: Text('加载失败: ${snapshot.error ?? '未知错误'}'),
              );
            }
            final detail = snapshot.data!;
            return SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(label: '发货单号', value: detail.orderNumber),
                    _DetailRow(label: '客户', value: detail.customerName ?? '-'),
                    _DetailRow(
                        label: '状态',
                        value: detail.statusDisplay ?? detail.status ?? '-'),
                    _DetailRow(
                        label: '销售单号', value: detail.salesOrderNumber ?? '-'),
                    _DetailRow(
                        label: '发货日期', value: _formatDate(detail.deliveryDate)),
                    _DetailRow(label: '收货人', value: detail.receiverName ?? '-'),
                    _DetailRow(
                        label: '物流公司', value: detail.logisticsCompany ?? '-'),
                    _DetailRow(
                        label: '运单号', value: detail.trackingNumber ?? '-'),
                    if ((detail.notes ?? '').trim().isNotEmpty)
                      _DetailRow(label: '备注', value: detail.notes ?? ''),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime? value) {
    if (value == null) return '-';
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String _today() {
    return _formatDate(DateTime.now());
  }

  static String? _normalizeDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return _formatDate(parsed);
  }
}

class _OutTypeOption {
  const _OutTypeOption({required this.value, required this.label});

  final String value;
  final String label;
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
