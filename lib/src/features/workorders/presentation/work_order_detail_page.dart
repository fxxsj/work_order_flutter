import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';

class WorkOrderDetailEntry extends StatefulWidget {
  const WorkOrderDetailEntry({super.key, required this.workOrderId});

  final int workOrderId;

  @override
  State<WorkOrderDetailEntry> createState() => _WorkOrderDetailEntryState();
}

class _WorkOrderDetailEntryState extends State<WorkOrderDetailEntry> {
  WorkOrderApiService? _apiService;
  WorkOrderRepositoryImpl? _repository;
  WorkOrderViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = WorkOrderApiService(apiClient);
    _repository = WorkOrderRepositoryImpl(_apiService!);
    _viewModel = WorkOrderViewModel(_repository!);
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
        Provider<WorkOrderApiService>.value(value: apiService),
        Provider<WorkOrderRepository>.value(value: repository),
        ChangeNotifierProvider<WorkOrderViewModel>.value(value: viewModel),
      ],
      child: WorkOrderDetailPage(workOrderId: widget.workOrderId),
    );
  }
}

class WorkOrderDetailPage extends StatefulWidget {
  const WorkOrderDetailPage({super.key, required this.workOrderId});

  final int workOrderId;

  @override
  State<WorkOrderDetailPage> createState() => _WorkOrderDetailPageState();
}

class _WorkOrderDetailPageState extends State<WorkOrderDetailPage> {
  static const double _spacing = 12;
  static const double _sectionSpacing = 16;
  static const String _breadcrumbSeparator = ' / ';
  static const String _emptyText = '-';

  WorkOrderDetail? _detail;
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
      final viewModel = context.read<WorkOrderViewModel>();
      final detail = await viewModel.fetchDetail(widget.workOrderId);
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

  Widget _buildProductsTable(List<WorkOrderProductItem> items) {
    if (items.isEmpty) {
      return Text('暂无产品信息', style: Theme.of(context).textTheme.bodyMedium);
    }
    final rows = items.map((item) {
      return DataRow(cells: [
        DataCell(Text(item.productName ?? _emptyText)),
        DataCell(Text(item.productCode ?? _emptyText)),
        DataCell(Text(item.quantity?.toString() ?? _emptyText)),
        DataCell(Text(item.unit ?? _emptyText)),
        DataCell(Text(item.specification ?? _emptyText)),
        DataCell(Text(item.impositionQuantity?.toString() ?? _emptyText)),
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
          DataColumn(label: Text('规格')),
          DataColumn(label: Text('拼版数')),
        ],
        rows: rows,
      ),
    );
  }

  Widget _buildProcessTable(List<WorkOrderProcessItem> items) {
    if (items.isEmpty) {
      return Text('暂无工序信息', style: Theme.of(context).textTheme.bodyMedium);
    }
    final rows = items.map((item) {
      final canStart = item.canStart == null ? _emptyText : (item.canStart! ? '可开始' : '不可开始');
      return DataRow(cells: [
        DataCell(Text(item.processName ?? _emptyText)),
        DataCell(Text(item.processCode ?? _emptyText)),
        DataCell(Text(item.statusDisplay ?? item.status ?? _emptyText)),
        DataCell(Text(item.operatorName ?? _emptyText)),
        DataCell(Text(item.departmentName ?? _emptyText)),
        DataCell(Text(item.tasksCount?.toString() ?? _emptyText)),
        DataCell(Text(canStart)),
      ]);
    }).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('工序')),
          DataColumn(label: Text('编码')),
          DataColumn(label: Text('状态')),
          DataColumn(label: Text('操作员')),
          DataColumn(label: Text('部门')),
          DataColumn(label: Text('任务数')),
          DataColumn(label: Text('可开始')),
        ],
        rows: rows,
      ),
    );
  }

  Widget _buildMaterialTable(List<WorkOrderMaterialItem> items) {
    if (items.isEmpty) {
      return Text('暂无物料信息', style: Theme.of(context).textTheme.bodyMedium);
    }
    final rows = items.map((item) {
      final needCutting = item.needCutting == null ? _emptyText : (item.needCutting! ? '是' : '否');
      return DataRow(cells: [
        DataCell(Text(item.materialName ?? _emptyText)),
        DataCell(Text(item.materialCode ?? _emptyText)),
        DataCell(Text(item.materialUnit ?? _emptyText)),
        DataCell(Text(item.materialSize ?? _emptyText)),
        DataCell(Text(item.materialUsage ?? _emptyText)),
        DataCell(Text(needCutting)),
        DataCell(Text(item.purchaseStatusDisplay ?? item.purchaseStatus ?? _emptyText)),
      ]);
    }).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('物料')),
          DataColumn(label: Text('编码')),
          DataColumn(label: Text('单位')),
          DataColumn(label: Text('规格')),
          DataColumn(label: Text('用量')),
          DataColumn(label: Text('需裁切')),
          DataColumn(label: Text('采购状态')),
        ],
        rows: rows,
      ),
    );
  }

  Widget _buildApprovalLogs(List<WorkOrderApprovalLog> logs) {
    if (logs.isEmpty) {
      return Text('暂无审批记录', style: Theme.of(context).textTheme.bodyMedium);
    }
    final theme = Theme.of(context);
    return Column(
      children: logs.map((log) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.dividerColor.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(log.approvalStatusDisplay ?? log.approvalStatus ?? _emptyText,
                  style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              Text('审核人: ${log.approvedByName ?? _emptyText}'),
              Text('时间: ${_formatDate(log.approvedAt)}'),
              if (log.approvalComment != null && log.approvalComment!.trim().isNotEmpty)
                Text('说明: ${log.approvalComment}'),
              if (log.rejectionReason != null && log.rejectionReason!.trim().isNotEmpty)
                Text('拒绝原因: ${log.rejectionReason}'),
            ],
          ),
        );
      }).toList(),
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
        ? '施工单 ${detail!.orderNumber}'
        : '施工单 #${widget.workOrderId}';

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
              onPressed: () => context.go('/workorders/${widget.workOrderId}/edit'),
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
                  ? const Center(child: Text('未找到施工单信息'))
                  : ListView(
                      children: [
                        _buildSection(
                          title,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoGrid([
                                _InfoItem('客户', detail.customerName ?? _emptyText),
                                _InfoItem('业务员', detail.salespersonName ?? _emptyText),
                                _InfoItem('负责人', detail.managerName ?? _emptyText),
                                _InfoItem('状态', detail.statusDisplay ?? detail.status ?? _emptyText),
                                _InfoItem('优先级', detail.priorityDisplay ?? detail.priority ?? _emptyText),
                                _InfoItem('审批状态', detail.approvalStatusDisplay ?? detail.approvalStatus ?? _emptyText),
                                _InfoItem('下单日期', _formatDate(detail.orderDate)),
                                _InfoItem('交货日期', _formatDate(detail.deliveryDate)),
                                _InfoItem('实际交货', _formatDate(detail.actualDeliveryDate)),
                                _InfoItem('生产数量', detail.productionQuantity?.toString() ?? _emptyText),
                                _InfoItem('不良数量', detail.defectiveQuantity?.toString() ?? _emptyText),
                                _InfoItem(
                                  '总金额',
                                  detail.totalAmount == null ? _emptyText : detail.totalAmount!.toStringAsFixed(2),
                                ),
                                _InfoItem(
                                  '进度',
                                  detail.progressPercentage == null ? _emptyText : '${detail.progressPercentage}%',
                                ),
                                _InfoItem('印刷形式', detail.printingTypeDisplay ?? detail.printingType ?? _emptyText),
                                _InfoItem('印刷色数', detail.printingColorsDisplay ?? _emptyText),
                              ]),
                              const SizedBox(height: 12),
                              _InfoRow(label: '备注', value: detail.notes ?? _emptyText),
                              const SizedBox(height: 12),
                              Text('图稿', style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 6),
                              _buildChipGroup(detail.artworkNames.isNotEmpty ? detail.artworkNames : detail.artworkCodes),
                              const SizedBox(height: 12),
                              Text('刀模', style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 6),
                              _buildChipGroup(detail.dieNames.isNotEmpty ? detail.dieNames : detail.dieCodes),
                              const SizedBox(height: 12),
                              Text('烫金版', style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 6),
                              _buildChipGroup(
                                detail.foilingPlateNames.isNotEmpty ? detail.foilingPlateNames : detail.foilingPlateCodes,
                              ),
                              const SizedBox(height: 12),
                              Text('压凸版', style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 6),
                              _buildChipGroup(
                                detail.embossingPlateNames.isNotEmpty
                                    ? detail.embossingPlateNames
                                    : detail.embossingPlateCodes,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: _sectionSpacing),
                        _buildSection('产品清单', _buildProductsTable(detail.products)),
                        const SizedBox(height: _sectionSpacing),
                        _buildSection('工序进度', _buildProcessTable(detail.processes)),
                        const SizedBox(height: _sectionSpacing),
                        _buildSection('物料需求', _buildMaterialTable(detail.materials)),
                        const SizedBox(height: _sectionSpacing),
                        _buildSection('审批记录', _buildApprovalLogs(detail.approvalLogs)),
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
