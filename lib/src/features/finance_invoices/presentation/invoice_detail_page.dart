import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/utils/file_link_util.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_api_service.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';

class InvoiceDetailEntry extends StatelessWidget {
  const InvoiceDetailEntry({super.key, required this.invoiceId});

  final int invoiceId;

  @override
  Widget build(BuildContext context) {
    return InvoiceDetailPage(invoiceId: invoiceId);
  }
}

class InvoiceDetailPage extends StatefulWidget {
  const InvoiceDetailPage({super.key, required this.invoiceId});

  final int invoiceId;

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  Invoice? _invoice;
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
      final api = InvoiceApiService(context.read<ApiClient>());
      final invoice = await api.fetchDetail(widget.invoiceId);
      if (!mounted) return;
      setState(() {
        _invoice = invoice.toEntity();
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
    final invoice = _invoice;
    final sectionSpacing = LayoutTokens.sectionSpacing(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(invoice?.invoiceNumber ?? '发票详情'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading || invoice == null
          ? _buildBodyFallback(context)
          : SingleChildScrollView(
              padding: EdgeInsets.all(sectionSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailSectionCard(
                    title: '基本信息',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(
                          label: '发票号',
                          value: _displayText(invoice.invoiceNumber),
                        ),
                        _DetailRow(
                          label: '客户',
                          value: _displayText(invoice.customerName),
                        ),
                        _DetailRow(
                          label: '发票类型',
                          value: _displayText(
                            invoice.invoiceTypeDisplay ?? invoice.invoiceType,
                          ),
                        ),
                        _DetailRow(
                          label: '状态',
                          value: _displayText(
                            invoice.statusDisplay ?? invoice.status,
                          ),
                        ),
                        _DetailRow(
                          label: '开票日期',
                          value: _formatDate(invoice.issueDate),
                        ),
                        _DetailRow(
                          label: '金额',
                          value: _formatAmount(invoice.amount),
                        ),
                        _DetailRow(
                          label: '已回款',
                          value: _formatAmount(invoice.paymentReceivedAmount),
                        ),
                        _DetailRow(
                          label: '待回款',
                          value: _formatAmount(invoice.paymentRemainingAmount),
                        ),
                        _DetailRow(
                          label: '下一步',
                          value: _displayText(invoice.followUpText),
                        ),
                        _DetailRow(
                          label: '附件',
                          value: _hasAttachment(invoice) ? '已上传' : '-',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  DetailSectionCard(
                    title: '关联单据',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(
                          label: '客户订单',
                          value: _displayText(invoice.salesOrderNumber),
                        ),
                        _DetailRow(
                          label: '施工单',
                          value: _displayText(invoice.workOrderNumber),
                        ),
                        if ((invoice.salesOrderId ?? 0) > 0) ...[
                          SizedBox(height: SpacingTokens.sm),
                          TextButton.icon(
                            onPressed: () {
                              context.go('/sales-orders/${invoice.salesOrderId}');
                            },
                            icon: const Icon(Icons.open_in_new, size: 16),
                            label: const Text('查看客户订单'),
                          ),
                        ],
                        if ((invoice.workOrderId ?? 0) > 0) ...[
                          SizedBox(height: SpacingTokens.sm),
                          TextButton.icon(
                            onPressed: () {
                              context.go('/workorders/${invoice.workOrderId}');
                            },
                            icon: const Icon(Icons.open_in_new, size: 16),
                            label: const Text('查看施工单'),
                          ),
                        ],
                      ],
                    ),
                  ),
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

  bool _hasAttachment(Invoice invoice) {
    return FileLinkUtil.hasLink(invoice.attachmentUrl);
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
