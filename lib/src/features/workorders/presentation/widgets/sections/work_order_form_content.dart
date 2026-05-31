import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_sales_order_candidate.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_form_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_basic_section.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_draft.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_material_list_section.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_process_section.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_product_list_section.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_resources_section.dart';

/// Main form content that composes all work order form sections.
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
    required this.requiredResources,
    required this.onSalesOrderChanged,
    required this.onCustomerChanged,
    this.onCreateCustomer,
    this.onSearchCustomer,
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
  /// Which prepress resources are required based on selected processes.
  final Set<String> requiredResources;
  final ValueChanged<int?> onSalesOrderChanged;
  final ValueChanged<int?> onCustomerChanged;
  final VoidCallback? onCreateCustomer;
  /// 客户远程搜索回调
  final Future<List<AppDropdownOption<int>>> Function(String query)? onSearchCustomer;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onPriorityChanged;
  final VoidCallback onPickOrderDate;
  final VoidCallback onPickDeliveryDate;
  final VoidCallback onPickActualDeliveryDate;
  final VoidCallback onAddProduct;
  final ValueChanged<int> onRemoveProduct;
  final ValueChanged<int> onProcessSelectionChanged;
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
          onSearchCustomer: onSearchCustomer,
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
          onToggleProcess: onProcessSelectionChanged,
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
          requiredResources: requiredResources,
          onPrintingTypeChanged: onPrintingTypeChanged,
          onToggleCmyk: onToggleCmyk,
          onSelectionChanged: onResourceSelectionChanged,
        ),
      ],
    );
  }
}
