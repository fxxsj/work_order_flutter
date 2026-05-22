import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_date_picker.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';

typedef DeliverySalesOrderChanged = Future<void> Function(
  int id, {
  VoidCallback? refresh,
});

typedef DeliveryFormSubmit = Future<void> Function(VoidCallback refresh);

Future<void> showDeliveryOrderFormDialog(
  BuildContext context, {
  required bool isEdit,
  required String title,
  required String cancelText,
  required String submitText,
  required bool productsLoading,
  required GlobalKey<FormState> formKey,
  required List<SalesOrderDto> salesOrders,
  required List<ProductOption> products,
  required int? selectedSalesOrderId,
  required DateTime? deliveryDate,
  required TextEditingController receiverNameController,
  required TextEditingController receiverPhoneController,
  required TextEditingController addressController,
  required TextEditingController logisticsController,
  required TextEditingController trackingController,
  required TextEditingController freightController,
  required TextEditingController packageCountController,
  required TextEditingController packageWeightController,
  required TextEditingController notesController,
  required List<DeliveryItemDraft> items,
  required DeliverySalesOrderChanged onSalesOrderChanged,
  required ValueChanged<DateTime> onDatePicked,
  required DeliveryFormSubmit onSubmit,
}) {
  return showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: title,
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: _DeliveryOrderFormPanel(
      isEdit: isEdit,
      cancelText: cancelText,
      submitText: submitText,
      productsLoading: productsLoading,
      formKey: formKey,
      salesOrders: salesOrders,
      products: products,
      selectedSalesOrderId: selectedSalesOrderId,
      deliveryDate: deliveryDate,
      receiverNameController: receiverNameController,
      receiverPhoneController: receiverPhoneController,
      addressController: addressController,
      logisticsController: logisticsController,
      trackingController: trackingController,
      freightController: freightController,
      packageCountController: packageCountController,
      packageWeightController: packageWeightController,
      notesController: notesController,
      items: items,
      onSalesOrderChanged: onSalesOrderChanged,
      onDatePicked: onDatePicked,
      onSubmit: onSubmit,
    ),
  );
}

class _DeliveryOrderFormPanel extends StatefulWidget {
  const _DeliveryOrderFormPanel({
    required this.isEdit,
    required this.cancelText,
    required this.submitText,
    required this.productsLoading,
    required this.formKey,
    required this.salesOrders,
    required this.products,
    required this.selectedSalesOrderId,
    required this.deliveryDate,
    required this.receiverNameController,
    required this.receiverPhoneController,
    required this.addressController,
    required this.logisticsController,
    required this.trackingController,
    required this.freightController,
    required this.packageCountController,
    required this.packageWeightController,
    required this.notesController,
    required this.items,
    required this.onSalesOrderChanged,
    required this.onDatePicked,
    required this.onSubmit,
  });

  final bool isEdit;
  final String cancelText;
  final String submitText;
  final bool productsLoading;
  final GlobalKey<FormState> formKey;
  final List<SalesOrderDto> salesOrders;
  final List<ProductOption> products;
  final int? selectedSalesOrderId;
  final DateTime? deliveryDate;
  final TextEditingController receiverNameController;
  final TextEditingController receiverPhoneController;
  final TextEditingController addressController;
  final TextEditingController logisticsController;
  final TextEditingController trackingController;
  final TextEditingController freightController;
  final TextEditingController packageCountController;
  final TextEditingController packageWeightController;
  final TextEditingController notesController;
  final List<DeliveryItemDraft> items;
  final DeliverySalesOrderChanged onSalesOrderChanged;
  final ValueChanged<DateTime> onDatePicked;
  final DeliveryFormSubmit onSubmit;

  @override
  State<_DeliveryOrderFormPanel> createState() =>
      _DeliveryOrderFormPanelState();
}

class _DeliveryOrderFormPanelState extends State<_DeliveryOrderFormPanel> {
  bool submitting = false;

  @override
  Widget build(BuildContext context) {
    return AdaptiveFormPanel(
      formKey: widget.formKey,
      cancelText: widget.cancelText,
      submitText: widget.submitText,
      submitting: submitting,
      onSubmit: _submit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isEdit) ...[
            _DeliveryFormSection(
              title: '关联单据',
              subtitle: '先选择客户订单，系统会回填收货信息并带出待发货明细。',
              child: AppSelect<int>(
                key: ValueKey<int?>(widget.selectedSalesOrderId),
                value: widget.selectedSalesOrderId,
                decoration: const InputDecoration(
                  labelText: '客户订单',
                  border: OutlineInputBorder(),
                ),
                options: widget.salesOrders
                    .map(
                      (order) => AppDropdownOption<int>(
                        value: order.id,
                        label: order.orderNumber,
                      ),
                    )
                    .toList(),
                onChanged: submitting
                    ? null
                    : (value) {
                        if (value == null) return;
                        widget.onSalesOrderChanged(value, refresh: _refresh);
                      },
                validator: (value) {
                  if (!widget.isEdit && (value == null || value == 0)) {
                    return '请选择客户订单';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: LayoutTokens.gapLg),
          ],
          _DeliveryFormSection(
            title: '收货信息',
            child: Column(
              children: [
                CrudFieldConfig.text(
                  label: '收货人',
                  controller: widget.receiverNameController,
                  enabled: !submitting,
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) ? '请输入收货人' : null,
                ).build(context),
                const SizedBox(height: LayoutTokens.gapMd),
                CrudFieldConfig.text(
                  label: '联系电话',
                  controller: widget.receiverPhoneController,
                  enabled: !submitting,
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) ? '请输入联系电话' : null,
                ).build(context),
                const SizedBox(height: LayoutTokens.gapMd),
                CrudFieldConfig.text(
                  label: '送货地址',
                  controller: widget.addressController,
                  enabled: !submitting,
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) ? '请输入送货地址' : null,
                ).build(context),
                const SizedBox(height: LayoutTokens.gapMd),
                DeliveryDateField(
                  label: '发货日期',
                  value: widget.deliveryDate,
                  onPicked: widget.onDatePicked,
                ),
              ],
            ),
          ),
          const SizedBox(height: LayoutTokens.gapLg),
          _DeliveryFormSection(
            title: '物流与备注',
            child: Column(
              children: [
                CrudFieldConfig.text(
                  label: '物流公司',
                  controller: widget.logisticsController,
                  enabled: !submitting,
                ).build(context),
                const SizedBox(height: LayoutTokens.gapMd),
                CrudFieldConfig.text(
                  label: '物流单号',
                  controller: widget.trackingController,
                  enabled: !submitting,
                ).build(context),
                const SizedBox(height: LayoutTokens.gapMd),
                _buildMetricsFields(),
                const SizedBox(height: LayoutTokens.gapMd),
                CrudFieldConfig.textarea(
                  label: '备注',
                  controller: widget.notesController,
                  enabled: !submitting,
                  maxLines: 3,
                ).build(context),
              ],
            ),
          ),
          const SizedBox(height: LayoutTokens.gapLg),
          _DeliveryFormSection(
            title: '发货明细',
            subtitle: '支持逐行调整数量、单位、单价和批次。',
            trailing: PageActionButton.outlined(
              onPressed: submitting || widget.productsLoading
                  ? null
                  : () {
                      setState(() {
                        widget.items.add(
                          DeliveryItemDraft(
                            productId: 0,
                            productName: '-',
                            maxQuantity: 0,
                            initialQuantity: 1,
                          ),
                        );
                      });
                    },
              icon: const Icon(Icons.add, size: 16),
              label: '添加明细',
            ),
            child: widget.items.isEmpty
                ? Text(
                    '暂无明细，请先选择客户订单或手动添加产品。',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : Column(
                    children: widget.items
                        .map(
                          (item) => DeliveryItemRow(
                            item: item,
                            enabled: !submitting,
                            products: widget.products,
                            onRemove: () {
                              setState(() {
                                widget.items.remove(item);
                                item.dispose();
                              });
                            },
                            onProductChanged: (product) {
                              setState(() {
                                item.productId = product.id;
                                item.productName = product.displayLabel;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsFields() {
    final isCompact =
        ResponsiveLayout.isXs(context) || ResponsiveLayout.isSm(context);
    if (isCompact) {
      return Column(
        children: [
          CrudFieldConfig.number(
            label: '运费',
            controller: widget.freightController,
            enabled: !submitting,
            decimal: true,
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFieldConfig.number(
            label: '包裹数',
            controller: widget.packageCountController,
            enabled: !submitting,
          ).build(context),
          const SizedBox(height: LayoutTokens.gapMd),
          CrudFieldConfig.number(
            label: '总重量(kg)',
            controller: widget.packageWeightController,
            enabled: !submitting,
            decimal: true,
          ).build(context),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: CrudFieldConfig.number(
            label: '运费',
            controller: widget.freightController,
            enabled: !submitting,
            decimal: true,
          ).build(context),
        ),
        const SizedBox(width: LayoutTokens.gapMd),
        Expanded(
          child: CrudFieldConfig.number(
            label: '包裹数',
            controller: widget.packageCountController,
            enabled: !submitting,
          ).build(context),
        ),
        const SizedBox(width: LayoutTokens.gapMd),
        Expanded(
          child: CrudFieldConfig.number(
            label: '总重量(kg)',
            controller: widget.packageWeightController,
            enabled: !submitting,
            decimal: true,
          ).build(context),
        ),
      ],
    );
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _submit() async {
    if (submitting) return;
    setState(() => submitting = true);
    await widget.onSubmit(_refresh);
    if (mounted) {
      setState(() => submitting = false);
    }
  }
}

class _DeliveryFormSection extends StatelessWidget {
  const _DeliveryFormSection({
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: LayoutTokens.gapXxxs),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: LayoutTokens.gapMd),
          child,
        ],
      ),
    );
  }
}

class DeliveryItemDraft {
  DeliveryItemDraft({
    required this.productId,
    required this.productName,
    required this.maxQuantity,
    required double initialQuantity,
    double unitPrice = 0,
    String unit = '',
    String stockBatch = '',
  })  : quantityController =
            TextEditingController(text: initialQuantity.toStringAsFixed(2)),
        unitPriceController =
            TextEditingController(text: unitPrice.toStringAsFixed(2)),
        unitController = TextEditingController(text: unit),
        stockBatchController = TextEditingController(text: stockBatch);

  int productId;
  String productName;
  final double maxQuantity;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;
  final TextEditingController unitController;
  final TextEditingController stockBatchController;

  double get quantity => double.tryParse(quantityController.text.trim()) ?? 0;
  double get unitPrice => double.tryParse(unitPriceController.text.trim()) ?? 0;
  String get unit => unitController.text.trim();
  String get stockBatch => stockBatchController.text.trim();

  void dispose() {
    quantityController.dispose();
    unitPriceController.dispose();
    unitController.dispose();
    stockBatchController.dispose();
  }
}

class DeliveryItemRow extends StatelessWidget {
  const DeliveryItemRow({
    super.key,
    required this.item,
    required this.enabled,
    required this.products,
    required this.onRemove,
    required this.onProductChanged,
  });

  final DeliveryItemDraft item;
  final bool enabled;
  final List<ProductOption> products;
  final VoidCallback onRemove;
  final ValueChanged<ProductOption> onProductChanged;

  @override
  Widget build(BuildContext context) {
    final isCompact =
        ResponsiveLayout.isXs(context) || ResponsiveLayout.isSm(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: LayoutTokens.gapSm),
      child: AppCard(
        padding: const EdgeInsets.all(LayoutTokens.gapMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppSelect<int>(
                    key: ValueKey<int?>(item.productId),
                    value: item.productId == 0 ? null : item.productId,
                    decoration: const InputDecoration(
                      labelText: '产品',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    options: products
                        .map(
                          (product) => AppDropdownOption<int>(
                            value: product.id,
                            label: product.displayLabel,
                          ),
                        )
                        .toList(),
                    onChanged: enabled
                        ? (value) {
                            if (value == null) return;
                            final selected =
                                products.firstWhere((p) => p.id == value);
                            onProductChanged(selected);
                          }
                        : null,
                    validator: (value) {
                      if (value == null || value == 0) return '请选择产品';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: LayoutTokens.gapSm),
                IconButton(
                  onPressed: enabled ? onRemove : null,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: LayoutTokens.gapSm),
            if (isCompact) ...[
              Row(
                children: [
                  Expanded(
                    child: _DeliveryDenseField(
                      controller: item.quantityController,
                      enabled: enabled,
                      label: '数量',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed <= 0) {
                          return '无效';
                        }
                        if (item.maxQuantity > 0 && parsed > item.maxQuantity) {
                          return '最多${item.maxQuantity.toStringAsFixed(2)}';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: LayoutTokens.gapSm),
                  Expanded(
                    child: _DeliveryDenseField(
                      controller: item.unitController,
                      enabled: enabled,
                      label: '单位',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: LayoutTokens.gapSm),
              Row(
                children: [
                  Expanded(
                    child: _DeliveryDenseField(
                      controller: item.unitPriceController,
                      enabled: enabled,
                      label: '单价',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: LayoutTokens.gapSm),
                  Expanded(
                    child: _DeliveryDenseField(
                      controller: item.stockBatchController,
                      enabled: enabled,
                      label: '批次',
                    ),
                  ),
                ],
              ),
            ] else
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: _DeliveryDenseField(
                      controller: item.quantityController,
                      enabled: enabled,
                      label: '数量',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed <= 0) {
                          return '无效';
                        }
                        if (item.maxQuantity > 0 && parsed > item.maxQuantity) {
                          return '最多${item.maxQuantity.toStringAsFixed(2)}';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: LayoutTokens.gapSm),
                  SizedBox(
                    width: 90,
                    child: _DeliveryDenseField(
                      controller: item.unitController,
                      enabled: enabled,
                      label: '单位',
                    ),
                  ),
                  const SizedBox(width: LayoutTokens.gapSm),
                  SizedBox(
                    width: 110,
                    child: _DeliveryDenseField(
                      controller: item.unitPriceController,
                      enabled: enabled,
                      label: '单价',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: LayoutTokens.gapSm),
                  SizedBox(
                    width: 120,
                    child: _DeliveryDenseField(
                      controller: item.stockBatchController,
                      enabled: enabled,
                      label: '批次',
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryDenseField extends StatelessWidget {
  const _DeliveryDenseField({
    required this.controller,
    required this.enabled,
    required this.label,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final bool enabled;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return CrudFieldConfig.text(
      label: label,
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      isDense: true,
      validator: validator,
    ).build(context);
  }
}

class DeliveryDateField extends StatelessWidget {
  const DeliveryDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onPicked,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onPicked;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    final text = _formatDate(value);
    final theme = Theme.of(context);
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showAppDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 5),
          lastDate: DateTime(now.year + 5),
        );
        if (picked != null) {
          onPicked(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.date_range_outlined),
        ),
        isEmpty: text.isEmpty,
        child: Text(
          text.isEmpty ? '请选择日期' : text,
          style: text.isEmpty
              ? theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                )
              : theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
