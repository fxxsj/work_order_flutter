import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_sales_order_candidate.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_card.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_draft.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_row_widgets.dart';

/// Product list section for work order form.
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
