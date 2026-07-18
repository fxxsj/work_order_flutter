import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/traceability_summary_section.dart';

/// 施工单详情 - 采购 Tab 视图
class WorkOrderDetailProcurementView extends StatelessWidget {
  const WorkOrderDetailProcurementView({
    super.key,
    required this.detail,
    required this.buildSection,
    required this.emptyText,
    required this.onCreatePurchaseOrder,
    required this.onViewPurchaseOrder,
    required this.onViewPurchaseOrdersList,
    this.onPlanMaterial,
  });

  final WorkOrderDetail detail;
  final Widget Function(String title, Widget child) buildSection;
  final String emptyText;
  final VoidCallback? onCreatePurchaseOrder;
  final ValueChanged<int>? onViewPurchaseOrder;
  final VoidCallback? onViewPurchaseOrdersList;
  final ValueChanged<WorkOrderMaterialItem>? onPlanMaterial;

  @override
  Widget build(BuildContext context) {
    final hasPendingMaterials = detail.materials.any(
      (m) => m.purchaseStatus == 'pending' || m.purchaseStatus == null,
    );
    final plansReady = detail.materials
        .where((m) => m.planningRequired)
        .every((m) => m.planningStatus == 'confirmed');

    return SingleChildScrollView(
      padding: LayoutTokens.pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 创建采购单按钮
          if (hasPendingMaterials)
            Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.md),
              child: FilledButton.icon(
                onPressed: plansReady ? onCreatePurchaseOrder : null,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('创建待处理采购单'),
              ),
            ),

          // 物料采购状态
          _buildMaterialsStatusSection(context),

          const SizedBox(height: SpacingTokens.lg),

          // 关联采购单
          _buildPurchaseOrdersSection(context),
        ],
      ),
    );
  }

  Widget _buildMaterialsStatusSection(BuildContext context) {
    final theme = Theme.of(context);

    return DetailSectionCard(
      title: '物料采购状态',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (detail.materials.isEmpty)
            Text(emptyText, style: theme.textTheme.bodyMedium)
          else
            ...detail.materials.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
                child: _MaterialStatusCard(
                  materialName: m.materialName ?? emptyText,
                  materialCode: m.materialCode ?? emptyText,
                  purchaseStatus: m.purchaseStatus ?? 'pending',
                  purchaseStatusDisplay: m.purchaseStatusDisplay ?? '待采购',
                  unit: m.materialUnit ?? '',
                  usage: m.materialUsage ?? '',
                  calculationMode: m.calculationMode,
                  planningRequired: m.planningRequired,
                  planningStatus: m.planningStatus,
                  planningStatusDisplay: m.planningStatusDisplay,
                  purchaseMaterialName: m.purchaseMaterialName,
                  purchaseQuantity: m.purchaseQuantity,
                  onPlan: onPlanMaterial == null
                      ? null
                      : () => onPlanMaterial!(m),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPurchaseOrdersSection(BuildContext context) {
    return TraceabilitySummarySection(
      title: '关联采购单',
      groups: [
        TraceabilitySummaryGroupData(
          title: '采购单',
          items: detail.purchaseOrderSummaries,
          actionLabel: detail.purchaseOrderSummaries.isEmpty ? null : '查看全部',
          onActionTap: detail.purchaseOrderSummaries.isEmpty
              ? null
              : onViewPurchaseOrdersList,
          onItemTap: (item) {
            if (item.id != null) {
              onViewPurchaseOrder?.call(item.id!);
            }
          },
        ),
      ],
      emptyText: emptyText,
    );
  }
}

class _MaterialStatusCard extends StatelessWidget {
  const _MaterialStatusCard({
    required this.materialName,
    required this.materialCode,
    required this.purchaseStatus,
    required this.purchaseStatusDisplay,
    required this.unit,
    required this.usage,
    required this.calculationMode,
    required this.planningRequired,
    this.planningStatus,
    this.planningStatusDisplay,
    this.purchaseMaterialName,
    this.purchaseQuantity,
    this.onPlan,
  });

  final String materialName;
  final String materialCode;
  final String purchaseStatus;
  final String purchaseStatusDisplay;
  final String unit;
  final String usage;
  final String calculationMode;
  final bool planningRequired;
  final String? planningStatus;
  final String? planningStatusDisplay;
  final String? purchaseMaterialName;
  final double? purchaseQuantity;
  final VoidCallback? onPlan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(purchaseStatus);

    return Container(
      padding: LayoutTokens.cardPadding(context),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(RadiusTokens.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: SpacingTokens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materialName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$materialCode · $usage $unit',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.sm,
                  vertical: SpacingTokens.sm,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(RadiusTokens.md),
                ),
                child: Text(
                  purchaseStatusDisplay,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (planningRequired) ...[
            const SizedBox(height: SpacingTokens.sm),
            Row(
              children: [
                Expanded(
                  child: Text(
                    planningStatus == 'confirmed'
                        ? '已选 ${purchaseMaterialName ?? '-'}，需采购 ${purchaseQuantity ?? 0}'
                        : calculationMode == 'specification_selection'
                        ? '待确认本单实际使用的物料规格和数量'
                        : '待拼版后确认原纸、开料尺寸和备料方式',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: onPlan,
                  child: Text(planningStatus == 'confirmed' ? '查看/作废' : '规划规格'),
                ),
                Text(planningStatusDisplay ?? planningStatus ?? '待规划'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'received' || 'completed' => Colors.green,
      'ordered' || 'cut' => Colors.blue,
      'pending' => Colors.orange,
      _ => Colors.grey,
    };
  }
}
