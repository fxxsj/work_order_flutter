import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/attachment_open_button.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/approval_rejection_notice_card.dart';
import 'package:work_order_app/src/core/utils/file_link_util.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_repository.dart';

class DeliveryOrderDetailPage extends StatefulWidget {
  const DeliveryOrderDetailPage({super.key, required this.deliveryOrderId});

  final int deliveryOrderId;

  @override
  State<DeliveryOrderDetailPage> createState() =>
      _DeliveryOrderDetailPageState();
}

class _DeliveryOrderDetailPageState extends State<DeliveryOrderDetailPage> {
  DeliveryOrderDetail? _detail;
  bool _loading = false;
  String? _errorMessage;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final detail = await context.read<DeliveryOrderRepository>().getDeliveryOrderDetail(widget.deliveryOrderId);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _loading = false;
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        _errorMessage = '加载失败: $err';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    final theme = Theme.of(context);
    final sectionSpacing = LayoutTokens.sectionSpacing(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(detail?.orderNumber ?? '送货单详情'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading || detail == null
          ? _buildBodyFallback(context)
          : SingleChildScrollView(
              padding: EdgeInsets.all(sectionSpacing),
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
                      nextStep:
                          '先核对发货信息与客户订单，再进入发票列表按当前客户订单预填创建发票。',
                      primaryAction: detail.salesOrderId == null
                          ? null
                          : FilledButton.icon(
                              onPressed: () {
                                final customerId =
                                    detail.customerId == null ||
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
                                context.go(
                                  '/sales-orders/${detail.salesOrderId}',
                                );
                              },
                              icon: const Icon(Icons.open_in_new, size: 18),
                              label: const Text('查看客户订单'),
                            ),
                    ),
                    SizedBox(height: sectionSpacing),
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
                                context.go(
                                  '/sales-orders/${detail.salesOrderId}',
                                );
                              },
                              icon: const Icon(Icons.open_in_new, size: 18),
                              label: const Text('查看客户订单'),
                            ),
                    ),
                    SizedBox(height: sectionSpacing),
                  ],
                  DetailSectionCard(
                    title: '基本信息',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(
                          label: '送货单号',
                          value: detail.orderNumber,
                        ),
                        _DetailRow(label: '客户', value: _displayText(detail.customerName)),
                        _DetailRow(
                          label: '客户订单',
                          value: _displayText(detail.salesOrderNumber),
                        ),
                        _DetailRow(
                          label: '状态',
                          value: _displayText(
                            detail.statusDisplay ?? detail.status,
                          ),
                        ),
                        _DetailRow(
                          label: '发货日期',
                          value: _formatDate(detail.deliveryDate),
                        ),
                        _DetailRow(
                          label: '收货人',
                          value: _displayText(detail.receiverName),
                        ),
                        _DetailRow(
                          label: '联系电话',
                          value: _displayText(detail.receiverPhone),
                        ),
                        _DetailRow(
                          label: '送货地址',
                          value: _displayText(detail.deliveryAddress),
                        ),
                        _DetailRow(
                          label: '物流公司',
                          value: _displayText(detail.logisticsCompany),
                        ),
                        _DetailRow(
                          label: '物流单号',
                          value: _displayText(detail.trackingNumber),
                        ),
                        _DetailRow(
                          label: '运费',
                          value: _formatAmount(detail.freight),
                        ),
                        _DetailRow(
                          label: '包裹数',
                          value: detail.packageCount?.toString() ?? '-',
                        ),
                        _DetailRow(
                          label: '总重量',
                          value: _formatAmount(detail.packageWeight),
                        ),
                        _DetailRow(
                          label: '签收附件',
                          value: _hasReceiverSignature(detail) ? '已上传' : '-',
                        ),
                        _DetailRow(
                          label: '关联发票',
                          value: _formatInvoiceSummary(detail),
                        ),
                        if ((detail.receivedNotes ?? '').trim().isNotEmpty)
                          _DetailRow(
                            label: '签收备注',
                            value: detail.receivedNotes ?? '',
                          ),
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
                          SizedBox(height: SpacingTokens.sm),
                          AttachmentOpenButton(
                            fileUrl: detail.receiverSignatureUrl,
                            label: '查看签收附件',
                            errorPrefix: '打开签收附件失败',
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  DetailSectionCard(
                    title: '发货明细',
                    child: detail.items.isEmpty
                        ? Text('暂无发货明细', style: theme.textTheme.bodyMedium)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final item in detail.items)
                                _DetailRow(
                                  label: _displayText(item.productName),
                                  value:
                                      '${_formatAmount(item.quantity)} ${item.unit ?? ''}'
                                          .trim(),
                                ),
                            ],
                          ),
                  ),
                  if ((detail.notes ?? '').trim().isNotEmpty) ...[
                    SizedBox(height: sectionSpacing),
                    DetailSectionCard(
                      title: '备注',
                      child: Text(detail.notes ?? ''),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildBodyFallback(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return ErrorStateCard(
        message: _errorMessage!,
        retryLabel: '重新加载',
        onRetry: _loadDetail,
      );
    }
    return const Center(child: Text('暂无数据'));
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
      return notes.isEmpty
          ? '已登记处理：$resolution。'
          : '已登记处理：$resolution；$notes';
    }
    return '请先核对拒收原因；如需继续交付，请回到客户订单重新安排补发，并补充备注说明。';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
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
