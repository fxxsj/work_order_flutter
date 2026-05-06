import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/meta_chip.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/extensions/datetime_extensions.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';

class WorkOrderListTile extends StatelessWidget {
  const WorkOrderListTile({
    super.key,
    required this.workOrder,
    this.onTap,
  });

  final WorkOrder workOrder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isXs = BreakpointsUtil.isXs(context);
    final title = workOrder.orderNumber.isEmpty
        ? '施工单 #${workOrder.id}'
        : workOrder.orderNumber;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            LayoutTokens.gapLg,
            LayoutTokens.gapSm + LayoutTokens.gapXxs,
            LayoutTokens.gapLg,
            LayoutTokens.gapSm + LayoutTokens.gapXxs,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(
              bottom: BorderSide(color: colors.borderColor),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.sidebarText,
                      ),
                    ),
                  ),
                  if (workOrder.deliveryDate != null) ...[
                    SizedBox(
                        width: isXs ? LayoutTokens.gapSm : LayoutTokens.gapMd),
                    Flexible(
                      child: Text(
                        workOrder.deliveryDate.toYMD,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.subtleText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: LayoutTokens.gapMd),
              Wrap(
                spacing: LayoutTokens.gapSm,
                runSpacing: LayoutTokens.gapSm,
                children: [
                  if (workOrder.salesOrderNumber?.isNotEmpty == true)
                    MetaChip(label: '订单号', value: workOrder.salesOrderNumber!),
                  if (workOrder.customerName?.isNotEmpty == true)
                    MetaChip(label: '客户', value: workOrder.customerName!),
                  if (workOrder.productName?.isNotEmpty == true)
                    MetaChip(label: '产品', value: workOrder.productName!),
                  if (workOrder.statusDisplay?.isNotEmpty == true)
                    MetaChip(label: '状态', value: workOrder.statusDisplay!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
