import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/attachment_open_button.dart';
import 'package:work_order_app/src/core/utils/file_link_util.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';

Future<void> showDeliveryOrderDetailDialog(
  BuildContext context, {
  required DeliveryOrderDetail detail,
  String title = '发货单详情',
  String closeText = '取消',
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 700,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(label: '发货单号', value: detail.orderNumber),
              _DetailRow(label: '客户', value: _displayText(detail.customerName)),
              _DetailRow(
                  label: '客户订单', value: _displayText(detail.salesOrderNumber)),
              _DetailRow(
                label: '状态',
                value: _displayText(detail.statusDisplay ?? detail.status),
              ),
              _DetailRow(
                  label: '发货日期', value: _formatDate(detail.deliveryDate)),
              _DetailRow(
                  label: '收货人', value: _displayText(detail.receiverName)),
              _DetailRow(
                  label: '联系电话', value: _displayText(detail.receiverPhone)),
              _DetailRow(
                  label: '送货地址', value: _displayText(detail.deliveryAddress)),
              _DetailRow(
                  label: '物流公司', value: _displayText(detail.logisticsCompany)),
              _DetailRow(
                  label: '物流单号', value: _displayText(detail.trackingNumber)),
              _DetailRow(label: '运费', value: _formatAmount(detail.freight)),
              _DetailRow(
                label: '包裹数',
                value: detail.packageCount?.toString() ?? '-',
              ),
              _DetailRow(
                  label: '总重量', value: _formatAmount(detail.packageWeight)),
              _DetailRow(
                label: '签收附件',
                value: _hasReceiverSignature(detail) ? '已上传' : '-',
              ),
              if ((detail.receivedNotes ?? '').trim().isNotEmpty)
                _DetailRow(label: '签收备注', value: detail.receivedNotes ?? ''),
              if (_hasReceiverSignature(detail)) ...[
                const SizedBox(height: 8),
                AttachmentOpenButton(
                  fileUrl: detail.receiverSignatureUrl,
                  label: '查看签收附件',
                  errorPrefix: '打开签收附件失败',
                ),
              ],
              if (detail.items.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text('发货明细', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                ...detail.items.map(
                  (item) => _DetailRow(
                    label: _displayText(item.productName),
                    value: '${_formatAmount(item.quantity)} ${item.unit ?? ''}'
                        .trim(),
                  ),
                ),
              ],
              if ((detail.notes ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                _DetailRow(label: '备注', value: detail.notes ?? ''),
              ],
            ],
          ),
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

bool _hasReceiverSignature(DeliveryOrderDetail detail) {
  return FileLinkUtil.hasLink(detail.receiverSignatureUrl);
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
