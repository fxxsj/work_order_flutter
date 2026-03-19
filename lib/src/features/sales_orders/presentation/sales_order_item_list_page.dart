import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_item_api_service.dart';

class SalesOrderItemListEntry extends StatelessWidget {
  const SalesOrderItemListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'sales_order_items',
        title: '销售明细',
        endpoint: '/sales-order-items/',
        searchHintText: '搜索销售明细/产品',
        emptyText: '暂无销售明细',
        emptyIcon: Icons.list_alt_outlined,
        columns: const [
          GenericColumn(label: '销售订单', value: _orderId),
          GenericColumn(label: '产品名称', value: _productName),
          GenericColumn(label: '产品编码', value: _productCode),
          GenericColumn(label: '数量', value: _quantity, numeric: true),
          GenericColumn(label: '单价', value: _unitPrice, numeric: true),
          GenericColumn(label: '小计', value: _subtotal, numeric: true),
        ],
        summaryFields: const [
          GenericSummaryField(label: '产品名称', value: _productName),
          GenericSummaryField(label: '数量', value: _quantity),
          GenericSummaryField(label: '单价', value: _unitPrice),
          GenericSummaryField(label: '小计', value: _subtotal),
        ],
        titleBuilder: _productName,
        headerActionsBuilder: (context, viewModel) => [
          PageActionButton.filled(
            onPressed: () => _openSalesOrderItemForm(context),
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
              onPressed: () => _openSalesOrderItemForm(context, record: record),
            ),
            RowAction(
              label: '删除',
              icon: Icons.delete_outline,
              destructive: true,
              onPressed: () => _deleteSalesOrderItem(context, record.id),
            ),
          ];
          final orderId = record.getNumber('sales_order') ??
              int.tryParse(record.getString('sales_order') ?? '');
          if (orderId != null && orderId.toInt() > 0) {
            actions.add(RowAction(
              label: '查看订单',
              icon: Icons.receipt_long_outlined,
              onPressed: () => context.go('/sales-orders/${orderId.toInt()}'),
            ));
          }
          return actions;
        },
      ),
    );
  }

  static String _orderId(GenericRecord record) {
    return GenericValueFormatter.text(
        record.getNumber('sales_order') ?? record.getString('sales_order'));
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

  static String _unitPrice(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('unit_price'));
  }

  static String _subtotal(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('subtotal'));
  }

  static Future<void> _openSalesOrderItemForm(
    BuildContext context, {
    GenericRecord? record,
  }) async {
    final apiClient = context.read<ApiClient>();
    final productApi = ProductApiService(apiClient);
    final itemApi = SalesOrderItemApiService(apiClient);
    final isEdit = record != null;
    final recordId = record?.id;
    final orderController = TextEditingController(
      text: record?.getNumber('sales_order')?.toString() ??
          record?.getString('sales_order') ??
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
    final taxRateController = TextEditingController(
      text: record?.getNumber('tax_rate')?.toString() ?? '',
    );
    final discountController = TextEditingController(
      text: record?.getNumber('discount_amount')?.toString() ?? '',
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
            title: Text(isEdit ? '编辑销售明细' : '新增销售明细'),
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
                          decoration:
                              const InputDecoration(labelText: '销售订单ID'),
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
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: '数量'),
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
                          controller: taxRateController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(labelText: '税率（%）'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: discountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(labelText: '折扣金额'),
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
                          ToastUtil.showError('请输入销售订单ID');
                          return;
                        }
                        if (selectedProductId == null) {
                          ToastUtil.showError('请选择产品');
                          return;
                        }
                        final quantity =
                            int.tryParse(quantityController.text.trim());
                        if (quantity == null || quantity <= 0) {
                          ToastUtil.showError('请输入数量');
                          return;
                        }
                        final unitPrice =
                            double.tryParse(unitPriceController.text.trim());
                        if (unitPrice == null || unitPrice < 0) {
                          ToastUtil.showError('请输入单价');
                          return;
                        }
                        final taxRateText = taxRateController.text.trim();
                        final taxRate = taxRateText.isEmpty
                            ? 0
                            : double.tryParse(taxRateText);
                        if (taxRate == null || taxRate < 0) {
                          ToastUtil.showError('请输入正确的税率');
                          return;
                        }
                        final discountText = discountController.text.trim();
                        final discountAmount = discountText.isEmpty
                            ? 0
                            : double.tryParse(discountText);
                        if (discountAmount == null || discountAmount < 0) {
                          ToastUtil.showError('请输入正确的折扣金额');
                          return;
                        }
                        setState(() => loading = true);
                        try {
                          final payload = {
                            'product': selectedProductId,
                            'quantity': quantity,
                            'unit': unitController.text.trim().isEmpty
                                ? '件'
                                : unitController.text.trim(),
                            'unit_price': unitPrice,
                            'tax_rate': taxRate,
                            'discount_amount': discountAmount,
                            'notes': notesController.text.trim(),
                          };
                          if (!isEdit && orderId != null) {
                            payload['sales_order'] = orderId;
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
    quantityController.dispose();
    unitController.dispose();
    unitPriceController.dispose();
    taxRateController.dispose();
    discountController.dispose();
    notesController.dispose();
  }

  static Future<void> _deleteSalesOrderItem(
    BuildContext context,
    int id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除该销售明细吗？'),
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
      final itemApi = SalesOrderItemApiService(context.read<ApiClient>());
      await itemApi.deleteItem(id);
      if (!context.mounted) return;
      context.read<GenericListViewModel>().reload(resetPage: true);
      ToastUtil.showSuccess('已删除');
    } catch (err) {
      ToastUtil.showError('删除失败: $err');
    }
  }
}
