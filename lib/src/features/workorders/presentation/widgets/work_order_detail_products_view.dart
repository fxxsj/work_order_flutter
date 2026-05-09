import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_data_sections.dart';

/// 产品物料视图：Products + Materials
class WorkOrderDetailProductsView extends StatelessWidget {
  const WorkOrderDetailProductsView({
    super.key,
    required this.detail,
    required this.buildSection,
    required this.emptyText,
  });

  final WorkOrderDetail detail;
  final Widget Function(String title, Widget child) buildSection;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(LayoutTokens.sectionSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSection(
            '产品清单',
            WorkOrderProductsSection(
              items: detail.products,
              emptyText: emptyText,
            ),
          ),
          SizedBox(height: LayoutTokens.sectionSpacing(context)),
          buildSection(
            '物料需求',
            WorkOrderMaterialsSection(
              items: detail.materials,
              emptyText: emptyText,
            ),
          ),
        ],
      ),
    );
  }
}
