import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_repository_impl.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';

class SalesOrderDetailEntry extends StatefulWidget {
  const SalesOrderDetailEntry({super.key, required this.orderId});

  final int orderId;

  @override
  State<SalesOrderDetailEntry> createState() => _SalesOrderDetailEntryState();
}

class _SalesOrderDetailEntryState extends State<SalesOrderDetailEntry> {
  SalesOrderApiService? _apiService;
  SalesOrderRepositoryImpl? _repository;
  SalesOrderViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = SalesOrderApiService(apiClient);
    _repository = SalesOrderRepositoryImpl(_apiService!);
    _viewModel = SalesOrderViewModel(_repository!);
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = _apiService;
    final repository = _repository;
    final viewModel = _viewModel;
    if (apiService == null || repository == null || viewModel == null) {
      return const SizedBox.shrink();
    }
    return MultiProvider(
      providers: [
        Provider<SalesOrderApiService>.value(value: apiService),
        Provider<SalesOrderRepository>.value(value: repository),
        ChangeNotifierProvider<SalesOrderViewModel>.value(value: viewModel),
      ],
      child: SalesOrderDetailPage(orderId: widget.orderId),
    );
  }
}

class SalesOrderDetailPage extends StatefulWidget {
  const SalesOrderDetailPage({super.key, required this.orderId});

  final int orderId;

  @override
  State<SalesOrderDetailPage> createState() => _SalesOrderDetailPageState();
}

class _SalesOrderDetailPageState extends State<SalesOrderDetailPage> {
  static const double _spacing = 12;
  static const double _sectionSpacing = 16;
  static const String _breadcrumbSeparator = ' / ';
  static const String _emptyText = '-';

  SalesOrderDetail? _detail;
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
      final viewModel = context.read<SalesOrderViewModel>();
      final detail = await viewModel.fetchDetail(widget.orderId);
      if (!mounted) return;
      setState(() => _detail = detail);
    } catch (err) {
      if (!mounted) return;
      setState(() => _errorMessage = err.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Widget _buildSection(String title, Widget child) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoGrid(List<_InfoItem> items) {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: items
          .map(
            (item) => SizedBox(
              width: 240,
              child: _InfoRow(label: item.label, value: item.value),
            ),
          )
          .toList(),
    );
  }

  Widget _buildItemsTable(List<SalesOrderItem> items) {
    if (items.isEmpty) {
      return Text('暂无订单明细', style: Theme.of(context).textTheme.bodyMedium);
    }
    final rows = items.map((item) {
      return DataRow(cells: [
        DataCell(Text(item.productName ?? _emptyText)),
        DataCell(Text(item.productCode ?? _emptyText)),
        DataCell(Text(item.quantity?.toString() ?? _emptyText)),
        DataCell(Text(item.unit ?? _emptyText)),
        DataCell(Text(item.unitPrice == null ? _emptyText : item.unitPrice!.toStringAsFixed(2))),
        DataCell(Text(item.taxRate == null ? _emptyText : item.taxRate!.toStringAsFixed(2))),
        DataCell(Text(item.discountAmount == null ? _emptyText : item.discountAmount!.toStringAsFixed(2))),
        DataCell(Text(item.subtotal == null ? _emptyText : item.subtotal!.toStringAsFixed(2))),
      ]);
    }).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('产品')),
          DataColumn(label: Text('编码')),
          DataColumn(label: Text('数量')),
          DataColumn(label: Text('单位')),
          DataColumn(label: Text('单价')),
          DataColumn(label: Text('税率')),
          DataColumn(label: Text('折扣')),
          DataColumn(label: Text('小计')),
        ],
        rows: rows,
      ),
    );
  }

  Widget _buildChipGroup(List<String> items) {
    if (items.isEmpty) {
      return Text(_emptyText, style: Theme.of(context).textTheme.bodyMedium);
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((text) => Chip(label: Text(text))).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final breadcrumb = [
      ...buildBreadcrumbForPathWith(
        GoRouterState.of(context).uri.path,
        buildPathToIdMap(),
      ),
      '详情',
    ];

    final detail = _detail;
    final title = detail?.orderNumber.isNotEmpty == true
        ? '销售订单 ${detail!.orderNumber}'
        : '销售订单 #${widget.orderId}';

    return ListPageScaffold(
      spacing: _spacing,
      header: PageHeaderBar(
        breadcrumb: breadcrumb.join(_breadcrumbSeparator),
        useSurface: false,
        showDivider: false,
        padding: EdgeInsets.zero,
        actions: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PageActionButton.outlined(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: '返回',
            ),
            const SizedBox(width: _spacing),
            PageActionButton.filled(
              onPressed: () => context.go('/sales-orders/${widget.orderId}/edit'),
              icon: const Icon(Icons.edit, size: 16),
              label: '编辑',
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _loadDetail,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : detail == null
                  ? const Center(child: Text('未找到销售订单信息'))
                  : ListView(
                      children: [
                        _buildSection(
                          title,
                          _buildInfoGrid([
                            _InfoItem('客户', detail.customerName ?? _emptyText),
                            _InfoItem('状态', detail.statusDisplay ?? detail.status ?? _emptyText),
                            _InfoItem('付款状态', detail.paymentStatusDisplay ?? detail.paymentStatus ?? _emptyText),
                            _InfoItem('下单日期', _formatDate(detail.orderDate)),
                            _InfoItem('交货日期', _formatDate(detail.deliveryDate)),
                            _InfoItem('实际交货', _formatDate(detail.actualDeliveryDate)),
                            _InfoItem(
                              '订单金额',
                              detail.totalAmount == null ? _emptyText : detail.totalAmount!.toStringAsFixed(2),
                            ),
                            _InfoItem(
                              '税率',
                              detail.taxRate == null ? _emptyText : '${detail.taxRate!.toStringAsFixed(2)}%',
                            ),
                          ]),
                        ),
                        const SizedBox(height: _sectionSpacing),
                        _buildSection(
                          '客户信息',
                          _buildInfoGrid([
                            _InfoItem('联系人', detail.customerContact ?? detail.contactPerson ?? _emptyText),
                            _InfoItem('电话', detail.customerPhone ?? detail.contactPhone ?? _emptyText),
                            _InfoItem('地址', detail.customerAddress ?? detail.shippingAddress ?? _emptyText),
                          ]),
                        ),
                        const SizedBox(height: _sectionSpacing),
                        _buildSection('订单明细', _buildItemsTable(detail.items)),
                        const SizedBox(height: _sectionSpacing),
                        _buildSection(
                          '付款信息',
                          _buildInfoGrid([
                            _InfoItem(
                              '小计',
                              detail.subtotal == null ? _emptyText : detail.subtotal!.toStringAsFixed(2),
                            ),
                            _InfoItem(
                              '税额',
                              detail.taxAmount == null ? _emptyText : detail.taxAmount!.toStringAsFixed(2),
                            ),
                            _InfoItem(
                              '折扣',
                              detail.discountAmount == null ? _emptyText : detail.discountAmount!.toStringAsFixed(2),
                            ),
                            _InfoItem(
                              '定金',
                              detail.depositAmount == null ? _emptyText : detail.depositAmount!.toStringAsFixed(2),
                            ),
                            _InfoItem(
                              '已付金额',
                              detail.paidAmount == null ? _emptyText : detail.paidAmount!.toStringAsFixed(2),
                            ),
                            _InfoItem('付款日期', _formatDate(detail.paymentDate)),
                          ]),
                        ),
                        const SizedBox(height: _sectionSpacing),
                        _buildSection('关联施工单', _buildChipGroup(detail.workOrderNumbers)),
                      ],
                    ),
    );
  }
}

class _InfoItem {
  const _InfoItem(this.label, this.value);

  final String label;
  final String value;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
