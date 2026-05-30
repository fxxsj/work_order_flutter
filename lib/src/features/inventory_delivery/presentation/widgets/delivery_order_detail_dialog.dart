import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/approval_rejection_notice_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/attachment_open_button.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/utils/file_link_util.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';

Future<void> showDeliveryOrderDetailDialog(
  BuildContext context, {
  required DeliveryOrderDetail detail,
  String title = '送货单详情',
  String closeText = '取消',
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AppDialog(
      title: title,
      maxWidth: LayoutTokens.dialogWidthLg,
      content: SizedBox(
        width: LayoutTokens.dialogWidthLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_shouldPromptInvoice(detail)) ...[
              ApprovalRejectionNoticeCard(
                title: '该发货已进入开票阶段',
                icon: Icons.receipt_long_outlined,
                reasonLabel: '当前状态',
                reason: '当前送货单尚未关联发票，请尽快补齐开票凭证。',
                nextStepLabel: '建议动作',
                nextStep: '先核对发货信息与客户订单，再进入发票列表按当前客户订单预填创建发票。',
                primaryAction: detail.salesOrderId == null
                    ? null
                    : FilledButton.icon(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          final customerId = detail.customerId == null ||
                                  detail.customerId! <= 0
                              ? ''
                              : '&customer_id=${detail.customerId}';
                          context.go(
                            '/finance/invoices?create=1&sales_order_id=${detail.salesOrderId}$customerId',
                          );
                        },
                        icon: const Icon(Icons.add_card_outlined, size: 18),
                        label: const Text('去开票'),
                      ),
                secondaryAction: detail.salesOrderId == null
                    ? null
                    : OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context.go('/sales-orders/${detail.salesOrderId}');
                        },
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text('查看客户订单'),
                      ),
              ),
              SizedBox(height: LayoutTokens.gapLg),
            ],
            if (_isRejected(detail)) ...[
              ApprovalRejectionNoticeCard(
                title: '发货已拒收，库存已回退',
                icon: Icons.assignment_late_outlined,
                reasonLabel: '拒收原因',
                reason: _rejectReason(detail),
                nextStepLabel: '下一步',
                nextStep: _rejectFollowUpText(detail),
                primaryAction: detail.salesOrderId == null
                    ? null
                    : FilledButton.icon(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context.go('/sales-orders/${detail.salesOrderId}');
                        },
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text('查看客户订单'),
                      ),
              ),
              SizedBox(height: LayoutTokens.gapLg),
            ],
            _DetailRow(label: '送货单号', value: detail.orderNumber),
            _DetailRow(label: '客户', value: _displayText(detail.customerName)),
            _DetailRow(
                label: '客户订单', value: _displayText(detail.salesOrderNumber)),
            _DetailRow(
              label: '状态',
              value: _displayText(detail.statusDisplay ?? detail.status),
            ),
            _DetailRow(label: '发货日期', value: _formatDate(detail.deliveryDate)),
            _DetailRow(label: '收货人', value: _displayText(detail.receiverName)),
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
            _DetailRow(
              label: '关联发票',
              value: _formatInvoiceSummary(detail),
            ),
            if ((detail.receivedNotes ?? '').trim().isNotEmpty)
              _DetailRow(label: '签收备注', value: detail.receivedNotes ?? ''),
            if ((detail.exceptionResolutionDisplay ?? '').trim().isNotEmpty)
              _DetailRow(
                label: '拒收处理',
                value: detail.exceptionResolutionDisplay ?? '',
              ),
            if ((detail.exceptionResolutionNotes ?? '').trim().isNotEmpty)
              _DetailRow(
                label: '处理说明',
                value: detail.exceptionResolutionNotes ?? '',
              ),
            if (_hasReceiverSignature(detail)) ...[
              SizedBox(height: LayoutTokens.gapSm),
              AttachmentOpenButton(
                fileUrl: detail.receiverSignatureUrl,
                label: '查看签收附件',
                errorPrefix: '打开签收附件失败',
              ),
            ],
            if (detail.items.isNotEmpty) ...[
              SizedBox(height: LayoutTokens.gapMd),
              Text('发货明细', style: Theme.of(context).textTheme.titleSmall),
              SizedBox(height: LayoutTokens.gapSm),
              ...detail.items.map(
                (item) => _DetailRow(
                  label: _displayText(item.productName),
                  value: '${_formatAmount(item.quantity)} ${item.unit ?? ''}'
                      .trim(),
                ),
              ),
            ],
            if ((detail.notes ?? '').trim().isNotEmpty) ...[
              SizedBox(height: LayoutTokens.gapMd),
              _DetailRow(label: '备注', value: detail.notes ?? ''),
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

bool _hasReceiverSignature(DeliveryOrderDetail detail) {
  return FileLinkUtil.hasLink(detail.receiverSignatureUrl);
}

bool _isRejected(DeliveryOrderDetail detail) {
  return (detail.status ?? '') == 'rejected';
}

bool _shouldPromptInvoice(DeliveryOrderDetail detail) {
  final status = detail.status ?? '';
  final readyForInvoice =
      status == 'shipped' || status == 'in_transit' || status == 'received';
  final invoiceCount = detail.invoiceCount ?? 0;
  return readyForInvoice && invoiceCount <= 0 && detail.salesOrderId != null;
}

String _formatInvoiceSummary(DeliveryOrderDetail detail) {
  final count = detail.invoiceCount ?? detail.invoiceNumbers.length;
  if (count <= 0) {
    return '待开票';
  }
  if (detail.invoiceNumbers.isEmpty) {
    return '已关联 $count 张';
  }
  return detail.invoiceNumbers.join('、');
}

String _rejectReason(DeliveryOrderDetail detail) {
  final notes = (detail.receivedNotes ?? '').trim();
  if (notes.startsWith('拒收原因:')) {
    return notes.replaceFirst('拒收原因:', '').trim();
  }
  return notes.isEmpty ? '请查看发货备注' : notes;
}

String _rejectFollowUpText(DeliveryOrderDetail detail) {
  if ((detail.exceptionResolutionDisplay ?? '').trim().isNotEmpty) {
    final resolution = detail.exceptionResolutionDisplay ?? '';
    final notes = (detail.exceptionResolutionNotes ?? '').trim();
    return notes.isEmpty ? '已登记处理：$resolution。' : '已登记处理：$resolution；$notes';
  }
  return '请先核对拒收原因；如需继续交付，请回到客户订单重新安排补发，并补充备注说明。';
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: LayoutTokens.gapSm),
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
