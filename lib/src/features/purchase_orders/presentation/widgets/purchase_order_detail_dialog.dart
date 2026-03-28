import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';

Future<void> showPurchaseOrderDetailDialog(
  BuildContext context, {
  required PurchaseOrderDetail detail,
  String title = '采购单详情',
  String closeText = '取消',
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => BaseDialog(
      title: title,
      maxWidth: LayoutTokens.pageWidthWide,
      content: SizedBox(
        width: LayoutTokens.pageWidthWide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(label: '采购单号', value: detail.orderNumber),
            _DetailRow(label: '供应商', value: _displayText(detail.supplierName)),
            if ((detail.supplierContact ?? '').trim().isNotEmpty)
              _DetailRow(
                  label: '联系人', value: _displayText(detail.supplierContact)),
            if ((detail.supplierPhone ?? '').trim().isNotEmpty)
              _DetailRow(
                  label: '联系电话', value: _displayText(detail.supplierPhone)),
            _DetailRow(
              label: '状态',
              value: _displayText(detail.statusDisplay ?? detail.status),
            ),
            _DetailRow(
                label: '关联施工单', value: _displayText(detail.workOrderNumber)),
            _DetailRow(label: '预计到货', value: _formatDate(detail.expectedDate)),
            _DetailRow(label: '下单日期', value: _formatDate(detail.orderedDate)),
            _DetailRow(
                label: '实际到货', value: _formatDate(detail.actualReceivedDate)),
            _DetailRow(label: '总金额', value: _formatAmount(detail.totalAmount)),
            _DetailRow(
                label: '提交人', value: _displayText(detail.submittedByName)),
            _DetailRow(
                label: '提交时间', value: _formatDateTime(detail.submittedAt)),
            _DetailRow(
                label: '审核人', value: _displayText(detail.approvedByName)),
            _DetailRow(
                label: '审核时间', value: _formatDateTime(detail.approvedAt)),
            if ((detail.notes ?? '').trim().isNotEmpty)
              _DetailRow(label: '备注', value: detail.notes ?? ''),
            if ((detail.rejectionReason ?? '').trim().isNotEmpty)
              _DetailRow(label: '拒绝原因', value: detail.rejectionReason ?? ''),
            if (detail.items.isNotEmpty) ...[
              const SizedBox(height: LayoutTokens.gapMd),
              Text('采购明细', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: LayoutTokens.gapSm),
              ...detail.items.map((item) {
                final quantity =
                    '${_formatAmount(item.quantity)} ${_displayText(item.materialUnit)}';
                return Card(
                  margin: const EdgeInsets.only(bottom: LayoutTokens.gapSm),
                  child: Padding(
                    padding: const EdgeInsets.all(LayoutTokens.cardPaddingSm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_displayText(item.materialCode)} ${_displayText(item.materialName)}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: LayoutTokens.gapXxs),
                        Wrap(
                          spacing: LayoutTokens.gapMd,
                          runSpacing: LayoutTokens.gapXs,
                          children: [
                            _InlineMeta(label: '采购数量', value: quantity),
                            _InlineMeta(
                              label: '已收货',
                              value: _formatAmount(item.receivedQuantity),
                            ),
                            _InlineMeta(
                              label: '单价',
                              value: _formatAmount(item.unitPrice),
                            ),
                            _InlineMeta(
                              label: '小计',
                              value: _formatAmount(item.subtotal),
                            ),
                            _InlineMeta(
                              label: '状态',
                              value: _displayText(
                                  item.statusDisplay ?? item.status),
                            ),
                          ],
                        ),
                        if ((item.notes ?? '').trim().isNotEmpty) ...[
                          const SizedBox(height: LayoutTokens.gapXxs),
                          Text('备注: ${item.notes}'),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(closeText),
        ),
      ],
    ),
  );
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
            width: 96,
            child: Text(
              '$label：',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _InlineMeta extends StatelessWidget {
  const _InlineMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

String _displayText(String? value) {
  final text = value?.trim() ?? '';
  return text.isEmpty ? '-' : text;
}

String _formatAmount(double? value) {
  if (value == null) return '-';
  return value.toStringAsFixed(2);
}

String _formatDate(DateTime? value) {
  if (value == null) return '-';
  final local = value.toLocal();
  final year = local.year.toString().padLeft(4, '0');
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

String _formatDateTime(DateTime? value) {
  if (value == null) return '-';
  final local = value.toLocal();
  final year = local.year.toString().padLeft(4, '0');
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$year-$month-$day $hour:$minute';
}
