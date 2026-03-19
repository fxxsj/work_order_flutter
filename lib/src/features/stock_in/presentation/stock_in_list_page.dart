import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/stock_in/data/stock_in_api_service.dart';

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
        headerActionsBuilder: (context, viewModel) => [
          PageActionButton.filled(
            onPressed: () => _openStockInForm(context),
            icon: const Icon(Icons.add),
            label: '新建入库单',
          ),
        ],
        rowActionsBuilder: (context, record, openDetails) {
          final actions = <RowAction>[
            RowAction(label: '查看', onPressed: openDetails),
            RowAction(
              label: '编辑',
              icon: Icons.edit_outlined,
              onPressed: () => _openStockInForm(context, record: record),
            ),
          ];
          final workOrderId = record.getNumber('work_order') ??
              int.tryParse(record.getString('work_order') ?? '');
          if (workOrderId != null && workOrderId.toInt() > 0) {
            actions.add(RowAction(
              label: '查看施工单',
              icon: Icons.description_outlined,
              onPressed: () => context.go('/workorders/${workOrderId.toInt()}'),
            ));
          }
          final status = record.getString('status');
          if (status == 'draft') {
            actions.add(RowAction(
              label: '提交',
              icon: Icons.send_outlined,
              onPressed: () => _submitStockIn(context, record.id),
            ));
          }
          if (status == 'submitted') {
            actions.add(RowAction(
              label: '审核',
              icon: Icons.fact_check_outlined,
              onPressed: () => _approveStockIn(context, record.id),
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

  static Future<void> _openStockInForm(
    BuildContext context, {
    GenericRecord? record,
  }) async {
    final apiService = StockInApiService(context.read<ApiClient>());
    final isEdit = record != null;
    final recordId = record?.id;
    final workOrderController = TextEditingController(
      text: record?.getNumber('work_order')?.toString() ??
          record?.getString('work_order') ??
          '',
    );
    final dateController = TextEditingController(
      text: _normalizeDate(record?.getString('stock_in_date')) ?? _today(),
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
            title: Text(isEdit ? '编辑入库单' : '新建入库单'),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: workOrderController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '施工单ID'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: '入库日期'),
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
                        final workOrderId =
                            int.tryParse(workOrderController.text.trim());
                        if (workOrderId == null) {
                          ToastUtil.showError('请输入有效的施工单ID');
                          return;
                        }
                        setState(() => loading = true);
                        try {
                          final payload = {
                            'work_order': workOrderId,
                            'stock_in_date': dateController.text.trim(),
                            'notes': notesController.text.trim(),
                          };
                          if (isEdit && recordId != null) {
                            await apiService.updateStockIn(recordId, payload);
                          } else {
                            await apiService.createStockIn(payload);
                          }
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

    workOrderController.dispose();
    dateController.dispose();
    notesController.dispose();
  }

  static Future<void> _submitStockIn(BuildContext context, int id) async {
    final apiService = StockInApiService(context.read<ApiClient>());
    try {
      await apiService.submit(id);
      if (!context.mounted) return;
      context.read<GenericListViewModel>().reload(resetPage: true);
      ToastUtil.showSuccess('已提交');
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    }
  }

  static Future<void> _approveStockIn(BuildContext context, int id) async {
    final apiService = StockInApiService(context.read<ApiClient>());
    try {
      await apiService.approve(id);
      if (!context.mounted) return;
      context.read<GenericListViewModel>().reload(resetPage: true);
      ToastUtil.showSuccess('已审核');
    } catch (err) {
      ToastUtil.showError('审核失败: $err');
    }
  }

  static String _formatDate(DateTime value) {
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
