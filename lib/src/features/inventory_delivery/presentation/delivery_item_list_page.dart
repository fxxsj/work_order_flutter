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
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_item_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_support_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';

class DeliveryItemListEntry extends StatelessWidget {
  const DeliveryItemListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'delivery_items',
        title: '发货明细',
        endpoint: '/delivery-items/',
        searchHintText: '搜索发货明细/产品',
        emptyText: '暂无发货明细',
        emptyIcon: Icons.local_shipping_outlined,
        columns: const [
          GenericColumn(label: '发货单', value: _orderId),
          GenericColumn(label: '产品名称', value: _productName),
          GenericColumn(label: '产品编码', value: _productCode),
          GenericColumn(label: '数量', value: _quantity, numeric: true),
          GenericColumn(label: '备注', value: _notes),
        ],
        summaryFields: const [
          GenericSummaryField(label: '产品名称', value: _productName),
          GenericSummaryField(label: '产品编码', value: _productCode),
          GenericSummaryField(label: '数量', value: _quantity),
          GenericSummaryField(label: '备注', value: _notes),
        ],
        titleBuilder: _productName,
        headerActionsBuilder: (context, viewModel) => [
          PageActionButton.filled(
            onPressed: () => _openDeliveryItemForm(context),
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
              onPressed: () => _openDeliveryItemForm(context, record: record),
            ),
            RowAction(
              label: '删除',
              icon: Icons.delete_outline,
              destructive: true,
              onPressed: () => _deleteDeliveryItem(context, record.id),
            ),
          ];
          final orderId = record.getNumber('delivery_order') ??
              int.tryParse(record.getString('delivery_order') ?? '');
          if (orderId != null && orderId.toInt() > 0) {
            actions.add(RowAction(
              label: '查看发货单',
              icon: Icons.local_shipping_outlined,
              onPressed: () =>
                  _openDeliveryOrderDialog(context, orderId.toInt()),
            ));
          }
          return actions;
        },
      ),
    );
  }

  static String _orderId(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('delivery_order') ??
        record.getString('delivery_order'));
  }

  static String _productName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('product_name'));
  }

  static String _productCode(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('product_code'));
  }

  static String _quantity(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('quantity'));
  }

  static String _notes(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('notes'));
  }

  static Future<void> _openDeliveryItemForm(
    BuildContext context, {
    GenericRecord? record,
  }) async {
    final apiClient = context.read<ApiClient>();
    final productApi = ProductApiService(apiClient);
    final itemApi = DeliveryItemApiService(apiClient);
    final isEdit = record != null;
    final recordId = record?.id;
    final orderController = TextEditingController(
      text: record?.getNumber('delivery_order')?.toString() ??
          record?.getString('delivery_order') ??
          '',
    );
    final salesItemController = TextEditingController(
      text: record?.getNumber('sales_order_item')?.toString() ??
          record?.getString('sales_order_item') ??
          '',
    );
    final quantityController = TextEditingController(
      text: record?.getNumber('quantity')?.toString() ?? '',
    );
    final unitController = TextEditingController(
      text: record?.getString('unit') ?? '件',
    );
    final unitPriceController = TextEditingController(
      text: record?.getNumber('unit_price')?.toString() ?? '',
    );
    final stockBatchController = TextEditingController(
      text: record?.getString('stock_batch') ?? '',
    );
    final notesController = TextEditingController(
      text: record?.getString('notes') ?? '',
    );

    int? selectedProductId = record?.getNumber('product')?.toInt();

    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        bool loading = false;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(isEdit ? '编辑发货明细' : '新增发货明细'),
            content: SizedBox(
              width: 520,
              child: FutureBuilder(
                future: productApi.fetchProducts(pageSize: 200),
                builder: (context, snapshot) {
                  final products = snapshot.data ?? const [];
                  if (snapshot.connectionState != ConnectionState.done &&
                      products.isEmpty) {
                    return const SizedBox(
                      height: 140,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: orderController,
                          keyboardType: TextInputType.number,
                          readOnly: isEdit,
                          decoration: const InputDecoration(labelText: '发货单ID'),
                        ),
                        const SizedBox(height: 12),
                        SearchableDropdownFormField<int>(
                          initialValue: selectedProductId,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: '产品'),
                          items: products
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item.id,
                                  child: Text(
                                    item.name.isNotEmpty
                                        ? '${item.name} (${item.code})'
                                        : '产品 #${item.id}',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => selectedProductId = value,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: salesItemController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: '销售订单明细ID（可选）'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: quantityController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(labelText: '发货数量'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: unitController,
                          decoration: const InputDecoration(labelText: '单位'),
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
                          controller: stockBatchController,
                          decoration: const InputDecoration(labelText: '库存批次号'),
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
                        if (!isEdit && orderId == null) {
                          ToastUtil.showError('请输入发货单ID');
                          return;
                        }
                        if (selectedProductId == null) {
                          ToastUtil.showError('请选择产品');
                          return;
                        }
                        final quantity =
                            double.tryParse(quantityController.text.trim());
                        if (quantity == null || quantity <= 0) {
                          ToastUtil.showError('请输入发货数量');
                          return;
                        }
                        final unitPriceText = unitPriceController.text.trim();
                        final unitPrice = unitPriceText.isEmpty
                            ? 0
                            : double.tryParse(unitPriceText);
                        if (unitPrice == null || unitPrice < 0) {
                          ToastUtil.showError('请输入正确的单价');
                          return;
                        }
                        final salesItemText = salesItemController.text.trim();
                        final salesOrderItemId = salesItemText.isEmpty
                            ? null
                            : int.tryParse(salesItemText);
                        if (salesItemText.isNotEmpty &&
                            salesOrderItemId == null) {
                          ToastUtil.showError('请输入正确的销售订单明细ID');
                          return;
                        }
                        setState(() => loading = true);
                        try {
                          final payload = {
                            'product': selectedProductId,
                            'sales_order_item': salesOrderItemId,
                            'quantity': quantity,
                            'unit': unitController.text.trim().isEmpty
                                ? '件'
                                : unitController.text.trim(),
                            'unit_price': unitPrice,
                            'stock_batch': stockBatchController.text.trim(),
                            'notes': notesController.text.trim(),
                          };
                          if (!isEdit && orderId != null) {
                            payload['delivery_order'] = orderId;
                          }
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
    salesItemController.dispose();
    quantityController.dispose();
    unitController.dispose();
    unitPriceController.dispose();
    stockBatchController.dispose();
    notesController.dispose();
  }

  static Future<void> _deleteDeliveryItem(
    BuildContext context,
    int id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除该发货明细吗？'),
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
      final supportService =
          DeliveryOrderSupportService(context.read<ApiClient>());
      await supportService.deleteItem(id);
      if (!context.mounted) return;
      context.read<GenericListViewModel>().reload(resetPage: true);
      ToastUtil.showSuccess('已删除');
    } catch (err) {
      ToastUtil.showError('删除失败: $err');
    }
  }

  static Future<void> _openDeliveryOrderDialog(
    BuildContext context,
    int orderId,
  ) async {
    final supportService =
        DeliveryOrderSupportService(context.read<ApiClient>());
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
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
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
