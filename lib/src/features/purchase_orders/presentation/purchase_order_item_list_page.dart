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
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_item_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';

class PurchaseOrderItemListEntry extends StatelessWidget {
  const PurchaseOrderItemListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'purchase_order_items',
        title: '采购明细',
        endpoint: '/purchase-order-items/',
        searchHintText: '搜索采购明细/物料',
        emptyText: '暂无采购明细',
        emptyIcon: Icons.playlist_add_check_outlined,
        columns: const [
          GenericColumn(label: '采购单', value: _orderId),
          GenericColumn(label: '物料名称', value: _materialName),
          GenericColumn(label: '物料编码', value: _materialCode),
          GenericColumn(label: '数量', value: _quantity, numeric: true),
          GenericColumn(label: '单价', value: _unitPrice, numeric: true),
          GenericColumn(label: '小计', value: _subtotal, numeric: true),
          GenericColumn(label: '状态', value: _status),
        ],
        summaryFields: const [
          GenericSummaryField(label: '物料名称', value: _materialName),
          GenericSummaryField(label: '数量', value: _quantity),
          GenericSummaryField(label: '单价', value: _unitPrice),
          GenericSummaryField(label: '状态', value: _status),
        ],
        titleBuilder: _materialName,
        headerActionsBuilder: (context, viewModel) => [
          PageActionButton.filled(
            onPressed: () => _openPurchaseOrderItemForm(context),
            icon: const Icon(Icons.add),
            label: '新增明细',
          ),
        ],
        rowActionsBuilder: (context, record, openDetails) {
          final actions = <RowAction>[
            RowAction(
              label: '查看',
              icon: Icons.visibility_outlined,
              onPressed: openDetails,
            ),
            RowAction(
              label: '编辑',
              icon: Icons.edit_outlined,
              onPressed: () =>
                  _openPurchaseOrderItemForm(context, record: record),
            ),
            RowAction(
              label: '删除',
              icon: Icons.delete_outline,
              destructive: true,
              onPressed: () => _deletePurchaseOrderItem(context, record.id),
            ),
          ];
          final orderId = record.getNumber('purchase_order') ??
              int.tryParse(record.getString('purchase_order') ?? '');
          if (orderId != null && orderId.toInt() > 0) {
            actions.add(RowAction(
              label: '查看采购单',
              icon: Icons.receipt_long_outlined,
              onPressed: () =>
                  _openPurchaseOrderDialog(context, orderId.toInt()),
            ));
          }
          return actions;
        },
      ),
    );
  }

  static String _orderId(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('purchase_order') ??
        record.getString('purchase_order'));
  }

  static String _materialName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('material_name'));
  }

  static String _materialCode(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('material_code'));
  }

  static String _quantity(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('quantity'));
  }

  static String _unitPrice(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('unit_price'));
  }

  static String _subtotal(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('subtotal'));
  }

  static String _status(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('status_display'));
  }

  static Future<void> _openPurchaseOrderItemForm(
    BuildContext context, {
    GenericRecord? record,
  }) async {
    final apiClient = context.read<ApiClient>();
    final materialApi = MaterialApiService(apiClient);
    final itemApi = PurchaseOrderItemApiService(apiClient);
    final isEdit = record != null;
    final recordId = record?.id;
    final orderController = TextEditingController(
      text: record?.getNumber('purchase_order')?.toString() ??
          record?.getString('purchase_order') ??
          '',
    );
    final quantityController = TextEditingController(
      text: record?.getNumber('quantity')?.toString() ?? '',
    );
    final unitPriceController = TextEditingController(
      text: record?.getNumber('unit_price')?.toString() ?? '',
    );
    final supplierCodeController = TextEditingController(
      text: record?.getString('supplier_code') ?? '',
    );
    final notesController = TextEditingController(
      text: record?.getString('notes') ?? '',
    );

    int? selectedMaterialId = record?.getNumber('material')?.toInt();

    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        bool loading = false;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(isEdit ? '编辑采购明细' : '新增采购明细'),
            content: SizedBox(
              width: 520,
              child: FutureBuilder(
                future: materialApi.fetchMaterials(pageSize: 200),
                builder: (context, snapshot) {
                  final materials = snapshot.data?.items ?? [];
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: orderController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: '采购单ID'),
                        ),
                        const SizedBox(height: 12),
                        SearchableDropdownFormField<int>(
                          initialValue: selectedMaterialId,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: '物料'),
                          items: materials
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item.id,
                                  child: Text(
                                    item.name.isNotEmpty
                                        ? '${item.name} (${item.code})'
                                        : '物料 #${item.id}',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => selectedMaterialId = value,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: quantityController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(labelText: '采购数量'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: unitPriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(labelText: '单价'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: supplierCodeController,
                          decoration:
                              const InputDecoration(labelText: '供应商物料编码'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: notesController,
                          decoration: const InputDecoration(labelText: '备注'),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  );
                },
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
                        final orderId =
                            int.tryParse(orderController.text.trim());
                        if (orderId == null) {
                          ToastUtil.showError('请输入采购单ID');
                          return;
                        }
                        if (selectedMaterialId == null) {
                          ToastUtil.showError('请选择物料');
                          return;
                        }
                        final quantity =
                            double.tryParse(quantityController.text.trim());
                        if (quantity == null || quantity <= 0) {
                          ToastUtil.showError('请输入采购数量');
                          return;
                        }
                        final unitPrice =
                            double.tryParse(unitPriceController.text.trim());
                        if (unitPrice == null || unitPrice < 0) {
                          ToastUtil.showError('请输入单价');
                          return;
                        }
                        setState(() => loading = true);
                        try {
                          final payload = {
                            'purchase_order': orderId,
                            'material': selectedMaterialId,
                            'quantity': quantity,
                            'unit_price': unitPrice,
                            'supplier_code': supplierCodeController.text.trim(),
                            'notes': notesController.text.trim(),
                          };
                          if (isEdit && recordId != null) {
                            await itemApi.updateItem(recordId, payload);
                          } else {
                            await itemApi.createItem(payload);
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

    orderController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    supplierCodeController.dispose();
    notesController.dispose();
  }

  static Future<void> _deletePurchaseOrderItem(
    BuildContext context,
    int id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除该采购明细吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final itemApi = PurchaseOrderItemApiService(context.read<ApiClient>());
      await itemApi.deleteItem(id);
      if (!context.mounted) return;
      context.read<GenericListViewModel>().reload(resetPage: true);
      ToastUtil.showSuccess('已删除');
    } catch (err) {
      ToastUtil.showError('删除失败: $err');
    }
  }

  static Future<void> _openPurchaseOrderDialog(
    BuildContext context,
    int orderId,
  ) async {
    final apiService = PurchaseOrderApiService(context.read<ApiClient>());
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('采购单详情'),
        content: FutureBuilder<PurchaseOrderDetail>(
          future: apiService.fetchDetail(orderId),
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
                    _DetailRow(label: '采购单号', value: detail.orderNumber),
                    _DetailRow(label: '供应商', value: detail.supplierName ?? '-'),
                    _DetailRow(
                        label: '状态',
                        value: detail.statusDisplay ?? detail.status ?? '-'),
                    _DetailRow(
                        label: '关联施工单', value: detail.workOrderNumber ?? '-'),
                    _DetailRow(
                        label: '预计到货', value: _formatDate(detail.expectedDate)),
                    _DetailRow(
                        label: '下单日期', value: _formatDate(detail.orderedDate)),
                    _DetailRow(
                        label: '总金额', value: _formatAmount(detail.totalAmount)),
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
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String _formatAmount(double? value) {
    if (value == null) return '-';
    return value.toStringAsFixed(2);
  }
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
