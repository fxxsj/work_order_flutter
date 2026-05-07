import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_sales_order_candidate.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_form_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_row_widgets.dart';

const workOrderProductSourceOptions = <AppDropdownOption<String>>[
  AppDropdownOption(value: 'sales_order', label: '客户订单'),
  AppDropdownOption(value: 'stock', label: '库存生产'),
  AppDropdownOption(value: 'reprint', label: '补印'),
  AppDropdownOption(value: 'sample', label: '打样'),
];

class WorkOrderFormSectionCard extends StatelessWidget {
  const WorkOrderFormSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DetailSectionCard(title: title, child: child);
  }
}

class WorkOrderFormSubsectionTitle extends StatelessWidget {
  const WorkOrderFormSubsectionTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: colors?.sidebarText,
      ),
    );
  }
}

class WorkOrderOptionItem {
  const WorkOrderOptionItem(this.id, this.label);

  final int id;
  final String label;
}

class WorkOrderProductDraft {
  WorkOrderProductDraft()
      : quantityController = TextEditingController(text: '1'),
        unitController = TextEditingController(text: '件'),
        specController = TextEditingController(),
        sortOrderController = TextEditingController(text: '0');

  WorkOrderProductDraft.fromDetail(WorkOrderProductItem item)
      : productId = item.productId,
        sourceType = item.sourceType ?? 'stock',
        sourceSalesOrderId = item.sourceSalesOrderId,
        salesOrderItemId = item.salesOrderItemId,
        quantityController =
            TextEditingController(text: item.quantity?.toString() ?? '1'),
        unitController = TextEditingController(text: item.unit ?? '件'),
        specController = TextEditingController(text: item.specification ?? ''),
        sortOrderController =
            TextEditingController(text: item.sortOrder?.toString() ?? '0');

  int? productId;
  String sourceType = 'stock';
  int? sourceSalesOrderId;
  int? salesOrderItemId;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final TextEditingController specController;
  final TextEditingController sortOrderController;

  int get quantityValue => int.tryParse(quantityController.text.trim()) ?? 1;
  String get unitValue =>
      unitController.text.trim().isEmpty ? '件' : unitController.text.trim();
  String get specificationValue => specController.text.trim();
  int get sortOrderValue => int.tryParse(sortOrderController.text.trim()) ?? 0;

  void dispose() {
    quantityController.dispose();
    unitController.dispose();
    specController.dispose();
    sortOrderController.dispose();
  }
}

class WorkOrderMaterialDraft {
  WorkOrderMaterialDraft()
      : sizeController = TextEditingController(),
        usageController = TextEditingController(),
        notesController = TextEditingController();

  WorkOrderMaterialDraft.fromDetail(WorkOrderMaterialItem item)
      : materialId = item.materialId,
        sizeController = TextEditingController(text: item.materialSize ?? ''),
        usageController = TextEditingController(text: item.materialUsage ?? ''),
        notesController = TextEditingController(text: item.notes ?? ''),
        needCutting = item.needCutting ?? false;

  int? materialId;
  final TextEditingController sizeController;
  final TextEditingController usageController;
  final TextEditingController notesController;
  bool needCutting = false;

  String get sizeValue => sizeController.text.trim();
  String get usageValue => usageController.text.trim();
  String get notesValue => notesController.text.trim();

  void dispose() {
    sizeController.dispose();
    usageController.dispose();
    notesController.dispose();
  }
}

class _SalesOrderDropdown extends StatelessWidget {
  const _SalesOrderDropdown({
    required this.salesOrderId,
    required this.salesOrders,
    required this.onChanged,
  });

  final int? salesOrderId;
  final List<WorkOrderSalesOrderCandidate> salesOrders;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = salesOrders
        .map((item) => AppDropdownOption<int>(
              value: item.id,
              label: item.orderNumber,
              secondaryLabel: [
                if (item.customerName?.isNotEmpty == true) item.customerName!,
                if (item.statusDisplay?.isNotEmpty == true) item.statusDisplay!,
              ].join(' · '),
            ))
        .toList();

    return AppSelect<int>(
      value: salesOrderId,
      options: options,
      decoration: const InputDecoration(labelText: '客户订单'),
      selectHintText: salesOrders.isEmpty ? '无可用订单' : '请选择客户订单',
      minOptionsForSearch: 1,
      onChanged: onChanged,
    );
  }
}

class _CustomerDropdown extends StatelessWidget {
  const _CustomerDropdown({
    required this.customerId,
    required this.customers,
    required this.onChanged,
    this.onCreateCustomer,
  });

  final int? customerId;
  final List<Customer> customers;
  final ValueChanged<int?> onChanged;
  final VoidCallback? onCreateCustomer;

  @override
  Widget build(BuildContext context) {
    final options = customers
        .map((item) => AppDropdownOption<int>(
              value: item.id,
              label: item.name,
            ))
        .toList();
    if (onCreateCustomer != null) {
      options.add(
        AppDropdownOption<int>(
          value: -1,
          label: '新增客户',
          icon: Icons.add,
          onSelected: onCreateCustomer,
        ),
      );
    }

    return AppSelect<int>(
      value: customerId,
      options: options,
      decoration: const InputDecoration(labelText: '客户'),
      selectHintText: customers.isEmpty ? '新增客户' : '请选择客户',
      minOptionsForSearch: 1,
      onChanged: onChanged,
    );
  }
}

class WorkOrderBasicInfoSection extends StatelessWidget {
  const WorkOrderBasicInfoSection({
    super.key,
    required this.mode,
    required this.salesOrderId,
    required this.salesOrders,
    required this.customerId,
    required this.customers,
    required this.status,
    required this.priority,
    required this.orderDateController,
    required this.deliveryDateController,
    required this.productionQuantityController,
    required this.defectiveQuantityController,
    required this.actualDeliveryDateController,
    required this.notesController,
    required this.onSalesOrderChanged,
    required this.onCustomerChanged,
    this.onCreateCustomer,
    required this.onStatusChanged,
    required this.onPriorityChanged,
    required this.onPickOrderDate,
    required this.onPickDeliveryDate,
    required this.onPickActualDeliveryDate,
  });

  final WorkOrderFormMode mode;
  final int? salesOrderId;
  final List<WorkOrderSalesOrderCandidate> salesOrders;
  final int? customerId;
  final List<Customer> customers;
  final String status;
  final String priority;
  final TextEditingController orderDateController;
  final TextEditingController deliveryDateController;
  final TextEditingController productionQuantityController;
  final TextEditingController defectiveQuantityController;
  final TextEditingController actualDeliveryDateController;
  final TextEditingController notesController;
  final ValueChanged<int?> onSalesOrderChanged;
  final ValueChanged<int?> onCustomerChanged;
  final VoidCallback? onCreateCustomer;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onPriorityChanged;
  final VoidCallback onPickOrderDate;
  final VoidCallback onPickDeliveryDate;
  final VoidCallback onPickActualDeliveryDate;

  @override
  Widget build(BuildContext context) {
    return WorkOrderFormSectionCard(
      title: '基本信息',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final fieldSpacing = LayoutTokens.gapLg;
              final fieldWidth = maxWidth < Breakpoints.sm
                  ? maxWidth
                  : (maxWidth - fieldSpacing) / 2;
              return Wrap(
                spacing: fieldSpacing,
                runSpacing: LayoutTokens.gapMd,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: _SalesOrderDropdown(
                      salesOrderId: salesOrderId,
                      salesOrders: salesOrders,
                      onChanged: onSalesOrderChanged,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _CustomerDropdown(
                      customerId: customerId,
                      customers: customers,
                      onChanged: onCustomerChanged,
                      onCreateCustomer: onCreateCustomer,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: AppSelect<String>(
                      value: status,
                      options: const [
                        AppDropdownOption(value: 'pending', label: '待开始'),
                        AppDropdownOption(value: 'in_progress', label: '进行中'),
                        AppDropdownOption(value: 'paused', label: '已暂停'),
                        AppDropdownOption(value: 'completed', label: '已完成'),
                        AppDropdownOption(value: 'cancelled', label: '已取消'),
                      ],
                      decoration: const InputDecoration(labelText: '状态'),
                      onChanged: (value) => onStatusChanged(value),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: AppSelect<String>(
                      value: priority,
                      options: const [
                        AppDropdownOption(value: 'low', label: '低'),
                        AppDropdownOption(value: 'normal', label: '普通'),
                        AppDropdownOption(value: 'high', label: '高'),
                        AppDropdownOption(value: 'urgent', label: '紧急'),
                      ],
                      decoration: const InputDecoration(labelText: '优先级'),
                      onChanged: (value) => onPriorityChanged(value),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CrudFieldConfig.text(
                      label: '下单日期',
                      controller: orderDateController,
                      readOnly: true,
                      onTap: onPickOrderDate,
                    ).build(context),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CrudFieldConfig.text(
                      label: '交货日期',
                      controller: deliveryDateController,
                      readOnly: true,
                      onTap: onPickDeliveryDate,
                      validator: (value) =>
                          (value == null || value.isEmpty) ? '请选择交货日期' : null,
                    ).build(context),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CrudFieldConfig.number(
                      label: '生产数量',
                      controller: productionQuantityController,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return null;
                        final parsed = int.tryParse(text);
                        if (parsed == null || parsed <= 0) {
                          return '请输入有效数量';
                        }
                        return null;
                      },
                    ).build(context),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CrudFieldConfig.number(
                      label: '预损数量',
                      controller: defectiveQuantityController,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return null;
                        final parsed = int.tryParse(text);
                        if (parsed == null || parsed < 0) {
                          return '请输入有效数量';
                        }
                        return null;
                      },
                    ).build(context),
                  ),
                  if (mode == WorkOrderFormMode.edit)
                    SizedBox(
                      width: fieldWidth,
                      child: CrudFieldConfig.text(
                        label: '实际交货日期',
                        controller: actualDeliveryDateController,
                        readOnly: true,
                        onTap: onPickActualDeliveryDate,
                      ).build(context),
                    ),
                ],
              );
            },
          ),
          SizedBox(height: LayoutTokens.gapMd),
          CrudFieldConfig.textarea(
            label: '备注',
            controller: notesController,
            maxLines: 3,
          ).build(context),
        ],
      ),
    );
  }
}

class WorkOrderCustomerSection extends StatelessWidget {
  const WorkOrderCustomerSection({
    super.key,
    required this.customerId,
    required this.customers,
    required this.onCustomerChanged,
    this.requiredSelection = true,
    this.onCreateCustomer,
  });

  final int? customerId;
  final List<Customer> customers;
  final ValueChanged<int?> onCustomerChanged;
  final bool requiredSelection;
  final VoidCallback? onCreateCustomer;

  @override
  Widget build(BuildContext context) {
    final options = customers
        .map(
          (item) => AppDropdownOption<int>(
            value: item.id,
            label: item.name,
          ),
        )
        .toList();
    if (onCreateCustomer != null) {
      options.add(
        AppDropdownOption<int>(
          value: -1,
          label: '新增客户',
          icon: Icons.add,
          onSelected: onCreateCustomer,
        ),
      );
    }

    return WorkOrderFormSectionCard(
      title: '客户信息',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelect<int>(
            value: customerId,
            options: options,
            decoration: const InputDecoration(labelText: '客户'),
            selectHintText: customers.isEmpty ? '新增客户' : '请选择',
            minOptionsForSearch: 1,
            onChanged: (value) => onCustomerChanged(value),
            validator: (value) =>
                requiredSelection && value == null ? '请选择客户' : null,
          ),
          if (customers.isEmpty && onCreateCustomer != null) ...[
            const SizedBox(height: LayoutTokens.gapSm),
            TextButton.icon(
              onPressed: onCreateCustomer,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('新增客户'),
            ),
          ],
        ],
      ),
    );
  }
}

class WorkOrderSalesOrderSection extends StatelessWidget {
  const WorkOrderSalesOrderSection({
    super.key,
    required this.salesOrderId,
    required this.salesOrders,
    required this.onSalesOrderChanged,
  });

  final int? salesOrderId;
  final List<WorkOrderSalesOrderCandidate> salesOrders;
  final ValueChanged<int?> onSalesOrderChanged;

  @override
  Widget build(BuildContext context) {
    final options = <AppDropdownOption<int>>[
      const AppDropdownOption<int>(
        value: -1,
        label: '不关联客户订单',
      ),
      ...salesOrders.map(
        (item) => AppDropdownOption<int>(
          value: item.id,
          label: item.orderNumber,
          secondaryLabel: [
            if (item.customerName?.isNotEmpty == true) item.customerName!,
            if (item.statusDisplay?.isNotEmpty == true) item.statusDisplay!,
          ].join(' · '),
        ),
      ),
    ];

    return WorkOrderFormSectionCard(
      title: '来源客户订单',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelect<int>(
            value: salesOrderId,
            options: options,
            decoration: const InputDecoration(
              labelText: '客户订单',
              helperText: '仅显示仍有未开施工单产品的客户订单，选择后会同步限制可选产品',
            ),
            selectHintText: salesOrders.isEmpty ? '暂无可关联客户订单' : '请选择',
            minOptionsForSearch: 1,
            onChanged: onSalesOrderChanged,
          ),
        ],
      ),
    );
  }
}

class WorkOrderProductListSection extends StatelessWidget {
  const WorkOrderProductListSection({
    super.key,
    required this.drafts,
    required this.products,
    required this.salesOrders,
    required this.defaultSalesOrderId,
    required this.onAdd,
    required this.onRemove,
    this.onProductSelectionChanged,
    this.onCreateProduct,
  });

  final List<WorkOrderProductDraft> drafts;
  final List<ProductOption> products;
  final List<WorkOrderSalesOrderCandidate> salesOrders;
  final int? defaultSalesOrderId;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final VoidCallback? onProductSelectionChanged;
  final Future<ProductOption?> Function()? onCreateProduct;

  @override
  Widget build(BuildContext context) {
    return WorkOrderFormSectionCard(
      title: '产品清单',
      child: Column(
        children: [
          for (var index = 0; index < drafts.length; index++)
            WorkOrderProductRow(
              draft: drafts[index],
              products: products,
              salesOrders: salesOrders,
              defaultSalesOrderId: defaultSalesOrderId,
              onRemove: drafts.length > 1 ? () => onRemove(index) : null,
              onProductChanged: onProductSelectionChanged,
              onCreateProduct: onCreateProduct,
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: PageActionButton.outlined(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 16),
              label: '新增产品',
            ),
          ),
        ],
      ),
    );
  }
}

class WorkOrderMaterialListSection extends StatelessWidget {
  const WorkOrderMaterialListSection({
    super.key,
    required this.drafts,
    required this.materials,
    required this.onAdd,
    required this.onRemove,
    this.onCreateMaterial,
  });

  final List<WorkOrderMaterialDraft> drafts;
  final List<MaterialItem> materials;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final Future<MaterialItem?> Function()? onCreateMaterial;

  @override
  Widget build(BuildContext context) {
    return WorkOrderFormSectionCard(
      title: '物料清单',
      child: Column(
        children: [
          for (var index = 0; index < drafts.length; index++)
            WorkOrderMaterialRow(
              draft: drafts[index],
              materials: materials,
              onRemove: () => onRemove(index),
              onCreateMaterial: onCreateMaterial,
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: PageActionButton.outlined(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 16),
              label: '新增物料',
            ),
          ),
        ],
      ),
    );
  }
}

class WorkOrderProcessConfigSection extends StatelessWidget {
  const WorkOrderProcessConfigSection({
    super.key,
    required this.processes,
    required this.processIds,
    required this.onSelectionChanged,
  });

  final List<Process> processes;
  final Set<int> processIds;
  final VoidCallback onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return WorkOrderFormSectionCard(
      title: '工序配置',
      child: WorkOrderMultiSelectField(
        items: processes
            .map((item) => WorkOrderOptionItem(item.id, item.name))
            .toList(),
        selected: processIds,
        emptyText: '暂无工序数据',
        placeholder: '请选择（可多选）',
        onChanged: onSelectionChanged,
      ),
    );
  }
}

class WorkOrderResourcesSection extends StatelessWidget {
  const WorkOrderResourcesSection({
    super.key,
    required this.printingType,
    required this.printingCmyk,
    required this.printingOtherColorsController,
    required this.artworks,
    required this.artworkIds,
    required this.dies,
    required this.dieIds,
    required this.foilingPlates,
    required this.foilingPlateIds,
    required this.embossingPlates,
    required this.embossingPlateIds,
    required this.onPrintingTypeChanged,
    required this.onToggleCmyk,
    required this.onSelectionChanged,
  });

  final String printingType;
  final Set<String> printingCmyk;
  final TextEditingController printingOtherColorsController;
  final List<Artwork> artworks;
  final Set<int> artworkIds;
  final List<Die> dies;
  final Set<int> dieIds;
  final List<FoilingPlate> foilingPlates;
  final Set<int> foilingPlateIds;
  final List<EmbossingPlate> embossingPlates;
  final Set<int> embossingPlateIds;
  final ValueChanged<String?> onPrintingTypeChanged;
  final ValueChanged<String> onToggleCmyk;
  final VoidCallback onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final showPrintingDetails = printingType != 'none';
    return WorkOrderFormSectionCard(
      title: '印刷与版信息',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < Breakpoints.lg;
          final columnSpacing = LayoutTokens.gapLg;
          final leftColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSelect<String>(
                value: printingType,
                options: const [
                  AppDropdownOption(value: 'none', label: '不需要印刷'),
                  AppDropdownOption(value: 'front', label: '正面印刷'),
                  AppDropdownOption(value: 'back', label: '背面印刷'),
                  AppDropdownOption(value: 'self_reverse', label: '自反印刷'),
                  AppDropdownOption(value: 'reverse_gripper', label: '反咬口印刷'),
                  AppDropdownOption(value: 'register', label: '套版印刷'),
                ],
                decoration: const InputDecoration(labelText: '印刷形式'),
                onChanged: (value) => onPrintingTypeChanged(value),
              ),
              if (showPrintingDetails) ...[
                SizedBox(height: LayoutTokens.gapMd),
                const WorkOrderFormSubsectionTitle(title: '图稿'),
                SizedBox(height: LayoutTokens.gapSm),
                WorkOrderMultiSelectField(
                  items: artworks
                      .map(
                        (item) => WorkOrderOptionItem(
                          item.id,
                          item.fullCode.isNotEmpty ? item.fullCode : item.name,
                        ),
                      )
                      .toList(),
                  selected: artworkIds,
                  emptyText: '暂无图稿数据',
                  placeholder: '请选择（可多选）',
                  onChanged: onSelectionChanged,
                ),
                SizedBox(height: LayoutTokens.gapMd),
                const WorkOrderFormSubsectionTitle(title: 'CMYK 颜色'),
                SizedBox(height: LayoutTokens.gapSm),
                Wrap(
                  spacing: 8,
                  children: ['C', 'M', 'Y', 'K']
                      .map(
                        (color) => FilterChip(
                          label: Text(color),
                          selected: printingCmyk.contains(color),
                          onSelected: (_) => onToggleCmyk(color),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: LayoutTokens.gapMd),
                CrudFieldConfig.text(
                  label: '其他颜色（逗号分隔）',
                  controller: printingOtherColorsController,
                ).build(context),
              ],
            ],
          );

          final rightColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WorkOrderFormSubsectionTitle(title: '刀模'),
              SizedBox(height: LayoutTokens.gapSm),
              WorkOrderMultiSelectField(
                items: dies
                    .map(
                      (item) => WorkOrderOptionItem(
                        item.id,
                        item.code?.isNotEmpty == true
                            ? '${item.name} (${item.code})'
                            : item.name,
                      ),
                    )
                    .toList(),
                selected: dieIds,
                emptyText: '暂无刀模数据',
                placeholder: '请选择（可多选）',
                onChanged: onSelectionChanged,
              ),
              SizedBox(height: LayoutTokens.gapMd),
              const WorkOrderFormSubsectionTitle(title: '烫金版'),
              SizedBox(height: LayoutTokens.gapSm),
              WorkOrderMultiSelectField(
                items: foilingPlates
                    .map(
                      (item) => WorkOrderOptionItem(
                        item.id,
                        item.code?.isNotEmpty == true
                            ? '${item.name} (${item.code})'
                            : item.name,
                      ),
                    )
                    .toList(),
                selected: foilingPlateIds,
                emptyText: '暂无烫金版数据',
                placeholder: '请选择（可多选）',
                onChanged: onSelectionChanged,
              ),
              SizedBox(height: LayoutTokens.gapMd),
              const WorkOrderFormSubsectionTitle(title: '压凸版'),
              SizedBox(height: LayoutTokens.gapSm),
              WorkOrderMultiSelectField(
                items: embossingPlates
                    .map(
                      (item) => WorkOrderOptionItem(
                        item.id,
                        item.code?.isNotEmpty == true
                            ? '${item.name} (${item.code})'
                            : item.name,
                      ),
                    )
                    .toList(),
                selected: embossingPlateIds,
                emptyText: '暂无压凸版数据',
                placeholder: '请选择（可多选）',
                onChanged: onSelectionChanged,
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftColumn,
                SizedBox(height: columnSpacing),
                rightColumn,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: leftColumn),
              SizedBox(width: columnSpacing),
              Expanded(child: rightColumn),
            ],
          );
        },
      ),
    );
  }
}

class WorkOrderFormContent extends StatelessWidget {
  const WorkOrderFormContent({
    super.key,
    required this.mode,
    required this.salesOrderId,
    required this.salesOrders,
    required this.customerId,
    required this.customers,
    required this.status,
    required this.priority,
    required this.orderDateController,
    required this.deliveryDateController,
    required this.productionQuantityController,
    required this.defectiveQuantityController,
    required this.actualDeliveryDateController,
    required this.notesController,
    required this.productDrafts,
    required this.products,
    required this.processes,
    required this.processIds,
    required this.materialDrafts,
    required this.materials,
    required this.printingType,
    required this.printingCmyk,
    required this.printingOtherColorsController,
    required this.artworks,
    required this.artworkIds,
    required this.dies,
    required this.dieIds,
    required this.foilingPlates,
    required this.foilingPlateIds,
    required this.embossingPlates,
    required this.embossingPlateIds,
    required this.onSalesOrderChanged,
    required this.onCustomerChanged,
    this.onCreateCustomer,
    required this.onStatusChanged,
    required this.onPriorityChanged,
    required this.onPickOrderDate,
    required this.onPickDeliveryDate,
    required this.onPickActualDeliveryDate,
    required this.onAddProduct,
    required this.onRemoveProduct,
    required this.onProcessSelectionChanged,
    required this.onAddMaterial,
    required this.onRemoveMaterial,
    required this.onPrintingTypeChanged,
    required this.onToggleCmyk,
    required this.onResourceSelectionChanged,
    this.onProductSelectionChanged,
    this.onCreateProduct,
    this.onCreateMaterial,
    this.sectionSpacing = LayoutTokens.gapLg,
  });

  final WorkOrderFormMode mode;
  final int? salesOrderId;
  final List<WorkOrderSalesOrderCandidate> salesOrders;
  final int? customerId;
  final List<Customer> customers;
  final String status;
  final String priority;
  final TextEditingController orderDateController;
  final TextEditingController deliveryDateController;
  final TextEditingController productionQuantityController;
  final TextEditingController defectiveQuantityController;
  final TextEditingController actualDeliveryDateController;
  final TextEditingController notesController;
  final List<WorkOrderProductDraft> productDrafts;
  final List<ProductOption> products;
  final List<Process> processes;
  final Set<int> processIds;
  final List<WorkOrderMaterialDraft> materialDrafts;
  final List<MaterialItem> materials;
  final String printingType;
  final Set<String> printingCmyk;
  final TextEditingController printingOtherColorsController;
  final List<Artwork> artworks;
  final Set<int> artworkIds;
  final List<Die> dies;
  final Set<int> dieIds;
  final List<FoilingPlate> foilingPlates;
  final Set<int> foilingPlateIds;
  final List<EmbossingPlate> embossingPlates;
  final Set<int> embossingPlateIds;
  final ValueChanged<int?> onSalesOrderChanged;
  final ValueChanged<int?> onCustomerChanged;
  final VoidCallback? onCreateCustomer;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onPriorityChanged;
  final VoidCallback onPickOrderDate;
  final VoidCallback onPickDeliveryDate;
  final VoidCallback onPickActualDeliveryDate;
  final VoidCallback onAddProduct;
  final ValueChanged<int> onRemoveProduct;
  final VoidCallback onProcessSelectionChanged;
  final VoidCallback onAddMaterial;
  final ValueChanged<int> onRemoveMaterial;
  final ValueChanged<String?> onPrintingTypeChanged;
  final ValueChanged<String> onToggleCmyk;
  final VoidCallback onResourceSelectionChanged;
  final VoidCallback? onProductSelectionChanged;
  final Future<ProductOption?> Function()? onCreateProduct;
  final Future<MaterialItem?> Function()? onCreateMaterial;
  final double sectionSpacing;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        WorkOrderBasicInfoSection(
          mode: mode,
          salesOrderId: salesOrderId,
          salesOrders: salesOrders,
          customerId: customerId,
          customers: customers,
          status: status,
          priority: priority,
          orderDateController: orderDateController,
          deliveryDateController: deliveryDateController,
          productionQuantityController: productionQuantityController,
          defectiveQuantityController: defectiveQuantityController,
          actualDeliveryDateController: actualDeliveryDateController,
          notesController: notesController,
          onSalesOrderChanged: onSalesOrderChanged,
          onCustomerChanged: onCustomerChanged,
          onCreateCustomer: onCreateCustomer,
          onStatusChanged: onStatusChanged,
          onPriorityChanged: onPriorityChanged,
          onPickOrderDate: onPickOrderDate,
          onPickDeliveryDate: onPickDeliveryDate,
          onPickActualDeliveryDate: onPickActualDeliveryDate,
        ),
        SizedBox(height: sectionSpacing),
        WorkOrderProductListSection(
          drafts: productDrafts,
          products: products,
          salesOrders: salesOrders,
          defaultSalesOrderId: salesOrderId,
          onAdd: onAddProduct,
          onRemove: onRemoveProduct,
          onProductSelectionChanged: onProductSelectionChanged,
          onCreateProduct: onCreateProduct,
        ),
        SizedBox(height: sectionSpacing),
        WorkOrderProcessConfigSection(
          processes: processes,
          processIds: processIds,
          onSelectionChanged: onProcessSelectionChanged,
        ),
        SizedBox(height: sectionSpacing),
        WorkOrderMaterialListSection(
          drafts: materialDrafts,
          materials: materials,
          onAdd: onAddMaterial,
          onRemove: onRemoveMaterial,
          onCreateMaterial: onCreateMaterial,
        ),
        SizedBox(height: sectionSpacing),
        WorkOrderResourcesSection(
          printingType: printingType,
          printingCmyk: printingCmyk,
          printingOtherColorsController: printingOtherColorsController,
          artworks: artworks,
          artworkIds: artworkIds,
          dies: dies,
          dieIds: dieIds,
          foilingPlates: foilingPlates,
          foilingPlateIds: foilingPlateIds,
          embossingPlates: embossingPlates,
          embossingPlateIds: embossingPlateIds,
          onPrintingTypeChanged: onPrintingTypeChanged,
          onToggleCmyk: onToggleCmyk,
          onSelectionChanged: onResourceSelectionChanged,
        ),
      ],
    );
  }
}
