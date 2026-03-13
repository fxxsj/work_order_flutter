import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/purchase_orders/application/purchase_order_view_model.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_repository_impl.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_receive_record_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_repository.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_dto.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';

/// 采购单列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class PurchaseOrderListEntry extends StatefulWidget {
  const PurchaseOrderListEntry({super.key});

  @override
  State<PurchaseOrderListEntry> createState() => _PurchaseOrderListEntryState();
}

class _PurchaseOrderListEntryState extends State<PurchaseOrderListEntry> {
  PurchaseOrderApiService? _apiService;
  PurchaseOrderRepositoryImpl? _repository;
  PurchaseOrderViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = PurchaseOrderApiService(apiClient);
    _repository = PurchaseOrderRepositoryImpl(_apiService!);
    _viewModel = PurchaseOrderViewModel(_repository!);
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _viewModel?.initialize();
      });
    }
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
        Provider<PurchaseOrderApiService>.value(value: apiService),
        Provider<PurchaseOrderRepository>.value(value: repository),
        ChangeNotifierProvider<PurchaseOrderViewModel>.value(value: viewModel),
      ],
      child: const PurchaseOrderListPage(),
    );
  }
}

/// 采购单列表页视图，只负责渲染。
class PurchaseOrderListPage extends StatelessWidget {
  const PurchaseOrderListPage({super.key});

  @override
  Widget build(BuildContext context) => const _PurchaseOrderListView();
}

class _PurchaseOrderListView extends StatefulWidget {
  const _PurchaseOrderListView();

  @override
  State<_PurchaseOrderListView> createState() => _PurchaseOrderListViewState();
}

class _PurchaseOrderListViewState extends State<_PurchaseOrderListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索采购单号/供应商';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建采购单';
  static const String _lowStockButtonText = '库存预警';
  static const String _resetButtonText = '重置';
  static const String _emptyText = '暂无采购单数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _statusFilterLabel = '状态';
  static const String _supplierFilterLabel = '供应商';
  static const String _detailTitle = '采购单详情';
  static const String _createTitle = '新增采购单';
  static const String _editTitle = '编辑采购单';
  static const String _receiveTitle = '采购收货';
  static const String _inspectionTitle = '质检确认';
  static const String _lowStockTitle = '库存不足预警';
  static const String _cancelText = '取消';
  static const String _submitText = '提交';
  static const String _approveText = '批准';
  static const String _rejectText = '拒绝';
  static const String _placeOrderText = '下单';
  static const String _receiveText = '收货';
  static const String _inspectText = '质检';
  static const String _cancelOrderText = '取消采购单';
  static const String _deletePrompt = '确认取消该采购单？';
  static const String _breadcrumbSeparator = ' / ';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  List<SupplierDto> _suppliers = [];
  bool _suppliersLoading = false;
  List<MaterialDto> _materials = [];
  bool _materialsLoading = false;
  List<WorkOrderDto> _workOrders = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSuppliers();
      _loadMaterials();
      _loadWorkOrders();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(PurchaseOrderViewModel viewModel,
      {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadPurchaseOrders(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadPurchaseOrders(resetPage: true);
    });
  }

  Future<void> _loadSuppliers() async {
    final apiService = SupplierApiService(context.read<ApiClient>());
    setState(() => _suppliersLoading = true);
    try {
      final page = await apiService.fetchSuppliers(pageSize: 200);
      if (!mounted) return;
      setState(() => _suppliers = page.items);
    } catch (_) {
      if (!mounted) return;
      setState(() => _suppliers = []);
    } finally {
      if (!mounted) return;
      setState(() => _suppliersLoading = false);
    }
  }

  Future<void> _loadMaterials() async {
    final apiService = MaterialApiService(context.read<ApiClient>());
    setState(() => _materialsLoading = true);
    try {
      final page = await apiService.fetchMaterials(pageSize: 400);
      if (!mounted) return;
      setState(() => _materials = page.items);
    } catch (_) {
      if (!mounted) return;
      setState(() => _materials = []);
    } finally {
      if (!mounted) return;
      setState(() => _materialsLoading = false);
    }
  }

  Future<void> _loadWorkOrders() async {
    final apiService = WorkOrderApiService(context.read<ApiClient>());
    try {
      final page = await apiService.fetchWorkOrders(
        pageSize: 200,
        approvalStatus: 'approved',
        ordering: '-created_at',
      );
      final items = page.items
          .where((order) =>
              order.status != 'completed' && order.status != 'cancelled')
          .toList();
      if (!mounted) return;
      setState(() => _workOrders = items);
    } catch (_) {
      if (!mounted) return;
      setState(() => _workOrders = []);
    }
  }

  void _resetFilters(PurchaseOrderViewModel viewModel) {
    _searchController.clear();
    viewModel.setSearchText('');
    viewModel.setStatusFilter('');
    viewModel.setSupplierId(0);
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  Future<PurchaseOrderDetail?> _fetchDetail(int id) async {
    final apiService = context.read<PurchaseOrderApiService>();
    try {
      return await apiService.fetchDetail(id);
    } catch (err) {
      ToastUtil.showError('获取采购单详情失败: $err');
      return null;
    }
  }

  Future<void> _openDetailDialog(PurchaseOrder order) async {
    final detail = await _fetchDetail(order.id);
    if (!mounted) return;
    final resolved = detail ??
        PurchaseOrderDetail(
          id: order.id,
          orderNumber: order.orderNumber,
          supplierName: order.supplierName,
          status: order.status,
          statusDisplay: order.statusDisplay,
          totalAmount: order.totalAmount,
          workOrderNumber: order.workOrderNumber,
        );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(_detailTitle),
        content: SizedBox(
          width: 700,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: '采购单号', value: resolved.orderNumber),
                _DetailRow(
                    label: '供应商', value: _displayText(resolved.supplierName)),
                if ((resolved.supplierContact ?? '').trim().isNotEmpty)
                  _DetailRow(
                    label: '联系人',
                    value: _displayText(resolved.supplierContact),
                  ),
                if ((resolved.supplierPhone ?? '').trim().isNotEmpty)
                  _DetailRow(
                    label: '联系电话',
                    value: _displayText(resolved.supplierPhone),
                  ),
                _DetailRow(
                  label: '状态',
                  value:
                      _displayText(resolved.statusDisplay ?? resolved.status),
                ),
                _DetailRow(
                  label: '关联施工单',
                  value: _displayText(resolved.workOrderNumber),
                ),
                _DetailRow(
                  label: '预计到货',
                  value: _formatDate(resolved.expectedDate),
                ),
                _DetailRow(
                  label: '下单日期',
                  value: _formatDate(resolved.orderedDate),
                ),
                _DetailRow(
                  label: '实际到货',
                  value: _formatDate(resolved.actualReceivedDate),
                ),
                _DetailRow(
                  label: '总金额',
                  value: _formatAmount(resolved.totalAmount),
                ),
                _DetailRow(
                  label: '提交人',
                  value: _displayText(resolved.submittedByName),
                ),
                _DetailRow(
                  label: '提交时间',
                  value: _formatDateTime(resolved.submittedAt),
                ),
                _DetailRow(
                  label: '审核人',
                  value: _displayText(resolved.approvedByName),
                ),
                _DetailRow(
                  label: '审核时间',
                  value: _formatDateTime(resolved.approvedAt),
                ),
                if ((resolved.notes ?? '').trim().isNotEmpty)
                  _DetailRow(label: '备注', value: resolved.notes ?? ''),
                if ((resolved.rejectionReason ?? '').trim().isNotEmpty)
                  _DetailRow(
                    label: '拒绝原因',
                    value: resolved.rejectionReason ?? '',
                  ),
                if (resolved.items.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('采购明细', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  ...resolved.items.map((item) {
                    final name = _displayText(item.materialName);
                    final code = _displayText(item.materialCode);
                    final quantity =
                        '${_formatAmount(item.quantity)} ${_displayText(item.materialUnit)}';
                    final received = _formatAmount(item.receivedQuantity);
                    final unitPrice = _formatAmount(item.unitPrice);
                    final subtotal = _formatAmount(item.subtotal);
                    final status =
                        _displayText(item.statusDisplay ?? item.status);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$code $name',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 12,
                              runSpacing: 4,
                              children: [
                                _InlineMeta(label: '采购数量', value: quantity),
                                _InlineMeta(label: '已收货', value: received),
                                _InlineMeta(label: '单价', value: unitPrice),
                                _InlineMeta(label: '小计', value: subtotal),
                                _InlineMeta(label: '状态', value: status),
                              ],
                            ),
                            if ((item.notes ?? '').trim().isNotEmpty) ...[
                              const SizedBox(height: 6),
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(_cancelText),
          ),
        ],
      ),
    );
  }

  Future<void> _openLowStockDialog(
    PurchaseOrderViewModel viewModel,
  ) async {
    final apiService = context.read<PurchaseOrderApiService>();
    List<Map<String, dynamic>> materials = [];
    try {
      final response = await apiService.getLowStockMaterials();
      final list = response['materials'];
      materials = list is List
          ? list
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
          : <Map<String, dynamic>>[];
    } catch (err) {
      ToastUtil.showError('获取库存预警失败: $err');
    }

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(_lowStockTitle),
        content: SizedBox(
          width: 720,
          child: materials.isEmpty
              ? const EmptyStateCard(
                  icon: Icons.inventory_outlined,
                  text: '暂无库存不足的物料',
                )
              : SizedBox(
                  height: 360,
                  child: ListView.separated(
                    itemCount: materials.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = materials[index];
                      final name = item['name']?.toString() ?? '-';
                      final code = item['code']?.toString() ?? '-';
                      final stock = item['stock_quantity']?.toString() ?? '-';
                      final minStock =
                          item['min_stock_quantity']?.toString() ?? '-';
                      final needed = item['needed_quantity']?.toString() ?? '-';
                      final supplier =
                          item['default_supplier__name']?.toString() ?? '-';
                      return Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$code $name',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 12,
                                runSpacing: 4,
                                children: [
                                  _InlineMeta(label: '当前库存', value: stock),
                                  _InlineMeta(label: '最小库存', value: minStock),
                                  _InlineMeta(label: '建议采购', value: needed),
                                  _InlineMeta(label: '默认供应商', value: supplier),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(_cancelText),
          ),
          if (materials.isNotEmpty)
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _openFormDialog(
                  viewModel,
                  prefillMaterials: materials,
                );
              },
              child: const Text('创建采购单'),
            ),
        ],
      ),
    );
  }

  Future<void> _openFormDialog(
    PurchaseOrderViewModel viewModel, {
    PurchaseOrder? order,
    List<Map<String, dynamic>>? prefillMaterials,
  }) async {
    final apiService = context.read<PurchaseOrderApiService>();
    final isEdit = order != null;
    PurchaseOrderDetail? detail;
    if (isEdit && order != null) {
      detail = await _fetchDetail(order.id);
      if (detail == null) return;
    }

    int? supplierId = detail?.supplierId;
    int? workOrderId = detail?.workOrderId;
    final notesController = TextEditingController(text: detail?.notes ?? '');
    List<_PurchaseItemDraft> items = [];

    if (detail != null && detail.items.isNotEmpty) {
      items = detail.items
          .map((item) => _PurchaseItemDraft(
                materialId: item.materialId ?? 0,
                materialName: item.materialName ?? '-',
                materialCode: item.materialCode ?? '',
                unit: item.materialUnit ?? '',
                unitPrice: item.unitPrice ?? 0,
                quantity: item.quantity ?? 0,
              ))
          .toList();
    }

    if (!isEdit && (prefillMaterials?.isNotEmpty ?? false)) {
      items = prefillMaterials!.map((item) {
        final materialId = toInt(item['id']) ?? 0;
        final materialName = item['name']?.toString() ?? '-';
        final materialCode = item['code']?.toString() ?? '';
        final needed = _toDouble(item['needed_quantity']) ?? 0;
        final match = _materials
            .cast<MaterialDto?>()
            .firstWhere((m) => m?.id == materialId, orElse: () => null);
        return _PurchaseItemDraft(
          materialId: materialId,
          materialName: materialName,
          materialCode: materialCode,
          unit: match?.unit ?? '',
          unitPrice: match?.unitPrice ?? 0,
          quantity: needed,
        );
      }).toList();
    }

    final formKey = GlobalKey<FormState>();
    bool submitting = false;

    Future<void> submit(StateSetter setState) async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      if (supplierId == null || supplierId == 0) {
        ToastUtil.showError('请选择供应商');
        return;
      }
      if (items.isEmpty) {
        ToastUtil.showError('请添加采购明细');
        return;
      }
      setState(() => submitting = true);
      try {
        final payload = <String, dynamic>{
          'supplier': supplierId,
          'work_order': workOrderId,
          'notes': notesController.text.trim(),
          'items_data': items
              .map((item) => {
                    'material': item.materialId,
                    'quantity': item.quantity,
                    'unit_price': item.unitPrice,
                  })
              .toList(),
        };

        if (isEdit && order != null) {
          await apiService.updatePurchaseOrder(order.id, payload);
        } else {
          await apiService.createPurchaseOrder(payload);
        }
        if (!mounted) return;
        Navigator.of(context).pop();
        ToastUtil.showSuccess(isEdit ? '采购单已更新' : '采购单已创建');
        await viewModel.loadPurchaseOrders(resetPage: false);
      } catch (err) {
        if (!mounted) return;
        setState(() => submitting = false);
        ToastUtil.showError('提交失败: $err');
      }
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final totalAmount = items.fold<double>(
              0,
              (sum, item) => sum + item.quantity * item.unitPrice,
            );
            final workOrderOptions = List<WorkOrderDto>.from(_workOrders);
            if (workOrderId != null &&
                workOrderId != 0 &&
                !workOrderOptions.any((order) => order.id == workOrderId)) {
              workOrderOptions.add(
                WorkOrderDto(
                  id: workOrderId!,
                  orderNumber: detail?.workOrderNumber ?? '施工单 #$workOrderId',
                ),
              );
            }
            return AlertDialog(
              title: Text(isEdit ? _editTitle : _createTitle),
              content: SizedBox(
                width: 720,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<int>(
                          value: supplierId,
                          decoration: const InputDecoration(
                            labelText: '供应商',
                            border: OutlineInputBorder(),
                          ),
                          items: _suppliers
                              .map(
                                (supplier) => DropdownMenuItem<int>(
                                  value: supplier.id,
                                  child: Text(supplier.name),
                                ),
                              )
                              .toList(),
                          onChanged: submitting
                              ? null
                              : (value) => setState(() => supplierId = value),
                          validator: (value) {
                            if (value == null || value == 0) {
                              return '请选择供应商';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          value: workOrderId,
                          decoration: const InputDecoration(
                            labelText: '关联施工单',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<int>(
                              value: 0,
                              child: Text('不关联'),
                            ),
                            ...workOrderOptions.map(
                              (order) => DropdownMenuItem<int>(
                                value: order.id,
                                child: Text(order.orderNumber),
                              ),
                            ),
                          ],
                          onChanged: submitting
                              ? null
                              : (value) => setState(() {
                                    if (value == 0) {
                                      workOrderId = null;
                                    } else {
                                      workOrderId = value;
                                    }
                                  }),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: '备注',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Text('采购明细',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ),
                            TextButton.icon(
                              onPressed: submitting || _materialsLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        items.add(
                                          _PurchaseItemDraft(
                                            materialId: 0,
                                            materialName: '-',
                                            materialCode: '',
                                            quantity: 1,
                                            unitPrice: 0,
                                            unit: '',
                                          ),
                                        );
                                      });
                                    },
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('添加明细'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (items.isEmpty)
                          const Text('暂无明细')
                        else
                          Column(
                            children: items
                                .map(
                                  (item) => _PurchaseItemRow(
                                    item: item,
                                    enabled: !submitting,
                                    materials: _materials,
                                    onRemove: () {
                                      setState(() {
                                        items.remove(item);
                                        item.dispose();
                                      });
                                    },
                                    onMaterialChanged: (material) {
                                      setState(() {
                                        item.materialId = material.id;
                                        item.materialName = material.name;
                                        item.materialCode = material.code;
                                        item.setUnit(
                                            material.unit ?? item.unit);
                                        item.setUnitPrice(material.unitPrice ??
                                            item.unitPrice);
                                      });
                                    },
                                    onChanged: () => setState(() {}),
                                  ),
                                )
                                .toList(),
                          ),
                        if (items.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '合计金额: ${totalAmount.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: submitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(_cancelText),
                ),
                FilledButton(
                  onPressed: submitting ? null : () => submit(setState),
                  child: Text(submitting ? '提交中...' : _submitText),
                ),
              ],
            );
          },
        );
      },
    );

    notesController.dispose();
    for (final item in items) {
      item.dispose();
    }
  }

  Future<void> _openReceiveDialog(
    PurchaseOrderViewModel viewModel,
    PurchaseOrder order,
  ) async {
    final apiService = context.read<PurchaseOrderApiService>();
    final detail = await _fetchDetail(order.id);
    if (detail == null) return;

    final receivedDate = ValueNotifier<DateTime?>(DateTime.now());
    final deliveryNoteController = TextEditingController();
    final items = detail.items
        .map((item) => _ReceiveItemDraft(
              itemId: item.id,
              materialName: item.materialName ?? '-',
              materialCode: item.materialCode ?? '-',
              quantity: item.quantity ?? 0,
              receivedQuantity: item.receivedQuantity ?? 0,
              remainingQuantity: item.remainingQuantity ??
                  ((item.quantity ?? 0) - (item.receivedQuantity ?? 0)),
            ))
        .toList();

    bool submitting = false;
    final formKey = GlobalKey<FormState>();

    Future<void> submit(StateSetter setState) async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      final payloadItems = items
          .where((item) => item.receiveQuantity > 0)
          .map((item) => {
                'item_id': item.itemId,
                'received_quantity': item.receiveQuantity,
                'delivery_note_number': deliveryNoteController.text.trim(),
                'notes': item.notes,
              })
          .toList();
      if (payloadItems.isEmpty) {
        ToastUtil.showError('请输入收货数量');
        return;
      }
      setState(() => submitting = true);
      try {
        await apiService.receive(order.id, {
          'items': payloadItems,
          'received_date': _formatDate(receivedDate.value),
        });
        if (!mounted) return;
        Navigator.of(context).pop();
        ToastUtil.showSuccess('收货成功，请进行质检');
        await viewModel.loadPurchaseOrders(resetPage: false);
        _openInspectionDialog(order);
      } catch (err) {
        if (!mounted) return;
        setState(() => submitting = false);
        ToastUtil.showError('收货失败: $err');
      }
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final selectedItems =
                items.where((item) => item.receiveQuantity > 0).toList();
            final hasReceiveItems = selectedItems.isNotEmpty;
            final totalQty = selectedItems.fold<double>(
              0,
              (sum, item) => sum + item.receiveQuantity,
            );
            final summaryText = hasReceiveItems
                ? '本次收货 ${selectedItems.length} 种物料，共计 ${totalQty.toStringAsFixed(2)} 件'
                : '请输入本次收货数量';
            return AlertDialog(
              title: const Text(_receiveTitle),
              content: SizedBox(
                width: 760,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(label: '采购单号', value: detail.orderNumber),
                        _DetailRow(
                            label: '供应商',
                            value: _displayText(detail.supplierName)),
                        _DetailRow(
                          label: '状态',
                          value: _displayText(
                              detail.statusDisplay ?? detail.status),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _DateField(
                                label: '收货日期',
                                value: receivedDate.value,
                                onPicked: (picked) =>
                                    setState(() => receivedDate.value = picked),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: deliveryNoteController,
                                decoration: const InputDecoration(
                                  labelText: '送货单号',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...items.map(
                          (item) => _ReceiveItemRow(
                            item: item,
                            enabled: !submitting,
                            onChanged: () => setState(() {}),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          summaryText,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: submitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(_cancelText),
                ),
                FilledButton(
                  onPressed: submitting ? null : () => submit(setState),
                  child: Text(submitting ? '提交中...' : '确认收货'),
                ),
              ],
            );
          },
        );
      },
    );

    deliveryNoteController.dispose();
    for (final item in items) {
      item.dispose();
    }
  }

  Future<void> _openInspectionDialog(PurchaseOrder order) async {
    final apiService = context.read<PurchaseOrderApiService>();
    final recordApi =
        PurchaseReceiveRecordApiService(context.read<ApiClient>());
    List<Map<String, dynamic>> records = [];
    bool loading = true;

    Future<void> loadRecords() async {
      try {
        final response = await apiService.getReceiveRecords(order.id);
        final data = response['data'] ?? response['results'] ?? response;
        if (data is List) {
          records = data
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      } catch (err) {
        ToastUtil.showError('加载收货记录失败: $err');
      } finally {
        loading = false;
      }
    }

    await loadRecords();
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> reload() async {
              loading = true;
              setState(() {});
              await loadRecords();
              if (!mounted) return;
              setState(() {});
            }

            return AlertDialog(
              title: const Text(_inspectionTitle),
              content: SizedBox(
                width: 720,
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : records.isEmpty
                        ? const EmptyStateCard(
                            icon: Icons.verified_outlined,
                            text: '暂无收货记录',
                          )
                        : SizedBox(
                            height: 360,
                            child: ListView.separated(
                              itemCount: records.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final record = records[index];
                                final status =
                                    record['inspection_status']?.toString() ??
                                        '';
                                final statusDisplay =
                                    record['inspection_status_display']
                                            ?.toString() ??
                                        '-';
                                final qualified =
                                    _toDouble(record['qualified_quantity']) ??
                                        0;
                                final isStocked = record['is_stocked'] == true;
                                final canInspect = status == 'pending';
                                final canStockIn = (status == 'qualified' ||
                                        status == 'partial_qualified') &&
                                    !isStocked &&
                                    qualified > 0;
                                return Card(
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${record['material_code'] ?? '-'} ${record['material_name'] ?? '-'}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const SizedBox(height: 6),
                                        Wrap(
                                          spacing: 12,
                                          runSpacing: 4,
                                          children: [
                                            _InlineMeta(
                                              label: '收货数量',
                                              value: record['received_quantity']
                                                      ?.toString() ??
                                                  '-',
                                            ),
                                            _InlineMeta(
                                              label: '状态',
                                              value: statusDisplay,
                                            ),
                                            _InlineMeta(
                                              label: '收货日期',
                                              value: record['received_date']
                                                      ?.toString() ??
                                                  '-',
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          children: [
                                            if (canInspect)
                                              OutlinedButton(
                                                onPressed: () async {
                                                  await _openInspectionForm(
                                                    dialogContext,
                                                    recordApi,
                                                    record,
                                                  );
                                                  await reload();
                                                },
                                                child: const Text('质检'),
                                              ),
                                            if (canStockIn)
                                              OutlinedButton(
                                                onPressed: () async {
                                                  final confirmed =
                                                      await showDialog<bool>(
                                                    context: dialogContext,
                                                    builder: (confirmContext) =>
                                                        AlertDialog(
                                                      title: const Text('确认入库'),
                                                      content: Text(
                                                          '确定将 $qualified 件物料入库吗？'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      confirmContext)
                                                                  .pop(false),
                                                          child: const Text(
                                                              _cancelText),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      confirmContext)
                                                                  .pop(true),
                                                          child:
                                                              const Text('确认'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirmed != true) return;
                                                  try {
                                                    await recordApi.stockIn(
                                                        record['id'] as int);
                                                    ToastUtil.showSuccess(
                                                        '入库成功');
                                                    await reload();
                                                  } catch (err) {
                                                    ToastUtil.showError(
                                                        '入库失败: $err');
                                                  }
                                                },
                                                child: const Text('入库'),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(_cancelText),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _openInspectionForm(
    BuildContext context,
    PurchaseReceiveRecordApiService apiService,
    Map<String, dynamic> record,
  ) async {
    final formKey = GlobalKey<FormState>();
    final received = _toDouble(record['received_quantity']) ?? 0;
    final qualifiedController =
        TextEditingController(text: received.toStringAsFixed(2));
    final unqualifiedController = TextEditingController(text: '0');
    final reasonController = TextEditingController();
    bool submitting = false;

    Future<void> submit(StateSetter setState) async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      final qualified = double.tryParse(qualifiedController.text.trim()) ?? 0;
      final unqualified =
          double.tryParse(unqualifiedController.text.trim()) ?? 0;
      if ((qualified + unqualified - received).abs() > 0.01) {
        ToastUtil.showError('合格数量 + 不合格数量 必须等于收货数量');
        return;
      }
      setState(() => submitting = true);
      try {
        await apiService.confirmInspection(
          record['id'] as int,
          {
            'qualified_quantity': qualified,
            'unqualified_quantity': unqualified,
            'unqualified_reason': reasonController.text.trim(),
          },
        );
        if (!mounted) return;
        Navigator.of(context).pop();
        ToastUtil.showSuccess('质检确认成功');
      } catch (err) {
        if (!mounted) return;
        setState(() => submitting = false);
        ToastUtil.showError('质检确认失败: $err');
      }
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('填写质检结果'),
              content: SizedBox(
                width: 420,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _DetailRow(
                        label: '收货数量',
                        value: received.toStringAsFixed(2),
                      ),
                      TextFormField(
                        controller: qualifiedController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(labelText: '合格数量'),
                        validator: (value) {
                          final parsed = double.tryParse(value?.trim() ?? '');
                          if (parsed == null || parsed < 0) return '请输入有效数量';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: unqualifiedController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(labelText: '不合格数量'),
                        validator: (value) {
                          final parsed = double.tryParse(value?.trim() ?? '');
                          if (parsed == null || parsed < 0) return '请输入有效数量';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: '不合格原因'),
                        validator: (value) {
                          final unqualified = double.tryParse(
                                  unqualifiedController.text.trim()) ??
                              0;
                          if (unqualified > 0 &&
                              (value?.trim().isEmpty ?? true)) {
                            return '请填写不合格原因';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: submitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(_cancelText),
                ),
                FilledButton(
                  onPressed: submitting ? null : () => submit(setState),
                  child: Text(submitting ? '提交中...' : '确认'),
                ),
              ],
            );
          },
        );
      },
    );

    qualifiedController.dispose();
    unqualifiedController.dispose();
    reasonController.dispose();
  }

  Future<void> _handleStatusAction(
    PurchaseOrderViewModel viewModel,
    PurchaseOrder order,
    String action,
  ) async {
    final apiService = context.read<PurchaseOrderApiService>();
    try {
      if (action == 'submit') {
        await apiService.submit(order.id);
        ToastUtil.showSuccess('提交成功');
      } else if (action == 'approve') {
        await apiService.approve(order.id);
        ToastUtil.showSuccess('批准成功');
      } else if (action == 'reject') {
        final reason = await _openReasonDialog('拒绝原因');
        if (reason == null) return;
        await apiService.reject(order.id, {'rejection_reason': reason});
        ToastUtil.showSuccess('已拒绝，采购单已退回草稿');
      } else if (action == 'place') {
        final date = await _openDateDialog('下单日期');
        final payload = <String, dynamic>{};
        if (date != null) {
          payload['ordered_date'] = _formatDate(date);
        }
        await apiService.placeOrder(order.id, payload);
        ToastUtil.showSuccess('下单成功');
      } else if (action == 'cancel') {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text(_cancelOrderText),
            content: const Text(_deletePrompt),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text(_cancelText),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('确认'),
              ),
            ],
          ),
        );
        if (confirmed != true) return;
        await apiService.cancel(order.id);
        ToastUtil.showSuccess('取消成功');
      }
      await viewModel.loadPurchaseOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('操作失败: $err');
    }
  }

  Future<String?> _openReasonDialog(String title) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextFormField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(labelText: '原因'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(_cancelText),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('确认'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || result.trim().isEmpty) return null;
    return result.trim();
  }

  Future<DateTime?> _openDateDialog(String title) async {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      helpText: title,
    );
  }

  static String _pageInfoText(PurchaseOrderViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<PurchaseOrderViewModel>(
      builder: (context, viewModel, _) {
        final orders = viewModel.purchaseOrders;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, orders, isMobile),
          footer: viewModel.total > 0
              ? ResponsivePaginationBar(
                  infoText: _pageInfoText(viewModel),
                  page: viewModel.page,
                  pageSize: viewModel.pageSize,
                  pageSizeOptions: viewModel.pageSizeOptions,
                  onPageSizeChanged: viewModel.setPageSize,
                  onPrev: () => viewModel.setPage(viewModel.page - 1),
                  onNext: () => viewModel.setPage(viewModel.page + 1),
                  hasPrev: viewModel.hasPrev,
                  hasNext: viewModel.hasNext,
                  pageSizeLabelBuilder: (size) =>
                      _pageSizeLabel.replaceFirst('{size}', size.toString()),
                )
              : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    PurchaseOrderViewModel viewModel,
    List<PurchaseOrder> orders,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadPurchaseOrders(resetPage: true),
      );
    }
    if (!viewModel.loading && orders.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.receipt_long_outlined,
        text: _emptyText,
      );
    }

    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildSummaryCard(context, viewModel, order, isMobile);
      },
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    PurchaseOrderViewModel viewModel,
    List<String> breadcrumb,
    bool isMobile,
  ) {
    return PageHeaderBar(
      breadcrumb:
          breadcrumb.isEmpty ? null : breadcrumb.join(_breadcrumbSeparator),
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final searchField = ListSearchField(
            controller: _searchController,
            hintText: _searchHintText,
            height: PageActionStyle.height,
            width: isMobile ? constraints.maxWidth : _searchWidth,
            onChanged: (_) => _scheduleSearch(viewModel),
            onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
            onClear: () {
              _searchController.clear();
              _scheduleSearch(viewModel, immediate: true);
            },
          );

          final statusValue =
              viewModel.statusFilter.isEmpty ? '' : viewModel.statusFilter;
          final statusField = SizedBox(
            width: isMobile ? constraints.maxWidth : 150,
            child: DropdownButtonFormField<String>(
              value: statusValue,
              decoration: const InputDecoration(
                labelText: _statusFilterLabel,
                isDense: true,
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: '', child: Text('全部状态')),
                DropdownMenuItem(value: 'draft', child: Text('草稿')),
                DropdownMenuItem(value: 'submitted', child: Text('已提交')),
                DropdownMenuItem(value: 'approved', child: Text('已批准')),
                DropdownMenuItem(value: 'ordered', child: Text('已下单')),
                DropdownMenuItem(value: 'received', child: Text('已收货')),
                DropdownMenuItem(value: 'cancelled', child: Text('已取消')),
              ],
              onChanged: (value) => viewModel.setStatusFilter(value ?? ''),
            ),
          );

          final supplierValue = viewModel.supplierId;
          final supplierField = SizedBox(
            width: isMobile ? constraints.maxWidth : 180,
            child: DropdownButtonFormField<int>(
              value: supplierValue,
              decoration: const InputDecoration(
                labelText: _supplierFilterLabel,
                isDense: true,
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<int>(
                  value: 0,
                  child: Text('全部供应商'),
                ),
                ..._suppliers.map(
                  (supplier) => DropdownMenuItem<int>(
                    value: supplier.id,
                    child: Text(supplier.name),
                  ),
                ),
              ],
              onChanged: _suppliersLoading
                  ? null
                  : (value) => viewModel.setSupplierId(value ?? 0),
            ),
          );

          final actions = <Widget>[
            statusField,
            supplierField,
            PageActionButton.outlined(
              onPressed: () => viewModel.loadPurchaseOrders(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.outlined(
              onPressed: () => _resetFilters(viewModel),
              icon: const Icon(Icons.restart_alt_outlined, size: 16),
              label: _resetButtonText,
            ),
            PageActionButton.outlined(
              onPressed: () => _openLowStockDialog(viewModel),
              icon: const Icon(Icons.warning_amber_outlined, size: 16),
              label: _lowStockButtonText,
            ),
            PageActionButton.filled(
              onPressed: () => _openFormDialog(viewModel),
              icon: const Icon(Icons.add),
              label: _createButtonText,
            ),
          ];

          return ListToolbar(
            isMobile: isMobile,
            searchField: searchField,
            actions: actions,
            spacing: _spacingSm,
          );
        },
      ),
    );
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  String _formatAmount(double? value) {
    if (value == null) return _emptyCellText;
    return value.toStringAsFixed(2);
  }

  Widget _buildSummaryCard(
    BuildContext context,
    PurchaseOrderViewModel viewModel,
    PurchaseOrder order,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number =
        order.orderNumber.isEmpty ? '采购单 #${order.id}' : order.orderNumber;
    final supplier = _displayText(order.supplierName);
    final status = order.statusDisplay ?? order.status ?? _emptyCellText;
    final totalAmount = _formatAmount(order.totalAmount);
    final itemsCount = order.itemsCount?.toString() ?? _emptyCellText;
    final receivedProgress = order.receivedProgress == null
        ? _emptyCellText
        : '${order.receivedProgress!.toStringAsFixed(0)}%';
    final workOrder = _displayText(order.workOrderNumber);
    final submittedBy = _displayText(order.submittedByName);
    final approvedBy = _displayText(order.approvedByName);
    final createdAt = _formatDateTime(order.createdAt);
    final statusCode = order.status ?? '';
    final canEdit = statusCode == 'draft';
    final canSubmit = statusCode == 'draft';
    final canApprove = statusCode == 'submitted';
    final canReject = statusCode == 'submitted';
    final canPlaceOrder = statusCode == 'approved';
    final canReceive = statusCode == 'ordered';
    final canInspect = statusCode == 'ordered';
    final canCancel = statusCode == 'draft' ||
        statusCode == 'submitted' ||
        statusCode == 'approved';

    return ExpandableSummaryCard(
      headerBuilder: (context, expanded) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    number,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    supplier,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '金额', value: totalAmount),
                      _SummaryChip(label: '状态', value: status),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more,
                size: 20,
                color: colors?.subtleText ?? theme.hintColor,
              ),
            ),
          ],
        );
      },
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryFieldWrap(
            isMobile: isMobile,
            children: [
              _SummaryField(label: '采购单号', value: number),
              _SummaryField(label: '供应商', value: supplier),
              _SummaryField(label: '状态', value: status),
              _SummaryField(label: '金额', value: totalAmount),
              _SummaryField(label: '明细数', value: itemsCount),
              _SummaryField(label: '收货进度', value: receivedProgress),
              _SummaryField(label: '关联施工单', value: workOrder),
              _SummaryField(label: '提交人', value: submittedBy),
              _SummaryField(label: '审核人', value: approvedBy),
              _SummaryField(label: '创建时间', value: createdAt),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _openDetailDialog(order),
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('查看'),
              ),
              if (canEdit)
                OutlinedButton.icon(
                  onPressed: () => _openFormDialog(viewModel, order: order),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('编辑'),
                ),
              if (canSubmit)
                OutlinedButton.icon(
                  onPressed: () =>
                      _handleStatusAction(viewModel, order, 'submit'),
                  icon: const Icon(Icons.send_outlined, size: 16),
                  label: const Text(_submitText),
                ),
              if (canApprove)
                OutlinedButton.icon(
                  onPressed: () =>
                      _handleStatusAction(viewModel, order, 'approve'),
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  label: const Text(_approveText),
                ),
              if (canReject)
                OutlinedButton.icon(
                  onPressed: () =>
                      _handleStatusAction(viewModel, order, 'reject'),
                  icon: const Icon(Icons.cancel_outlined, size: 16),
                  label: const Text(_rejectText),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
              if (canPlaceOrder)
                OutlinedButton.icon(
                  onPressed: () =>
                      _handleStatusAction(viewModel, order, 'place'),
                  icon: const Icon(Icons.local_shipping_outlined, size: 16),
                  label: const Text(_placeOrderText),
                ),
              if (canReceive)
                OutlinedButton.icon(
                  onPressed: () => _openReceiveDialog(viewModel, order),
                  icon: const Icon(Icons.inventory_2_outlined, size: 16),
                  label: const Text(_receiveText),
                ),
              if (canInspect)
                OutlinedButton.icon(
                  onPressed: () => _openInspectionDialog(order),
                  icon: const Icon(Icons.verified_outlined, size: 16),
                  label: const Text(_inspectText),
                ),
              if (canCancel)
                OutlinedButton.icon(
                  onPressed: () =>
                      _handleStatusAction(viewModel, order, 'cancel'),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('取消'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;

class _PurchaseItemDraft {
  _PurchaseItemDraft({
    required this.materialId,
    required this.materialName,
    required this.materialCode,
    required double quantity,
    required double unitPrice,
    String unit = '',
  })  : quantityController =
            TextEditingController(text: quantity.toStringAsFixed(2)),
        unitPriceController =
            TextEditingController(text: unitPrice.toStringAsFixed(2)),
        unitController = TextEditingController(text: unit);

  int materialId;
  String materialName;
  String materialCode;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;
  final TextEditingController unitController;

  double get quantity => double.tryParse(quantityController.text.trim()) ?? 0;
  double get unitPrice => double.tryParse(unitPriceController.text.trim()) ?? 0;
  String get unit => unitController.text.trim();

  void setUnit(String value) {
    unitController.text = value;
  }

  void setUnitPrice(double value) {
    unitPriceController.text = value.toStringAsFixed(2);
  }

  void dispose() {
    quantityController.dispose();
    unitPriceController.dispose();
    unitController.dispose();
  }
}

class _PurchaseItemRow extends StatelessWidget {
  const _PurchaseItemRow({
    required this.item,
    required this.enabled,
    required this.materials,
    required this.onRemove,
    required this.onMaterialChanged,
    this.onChanged,
  });

  final _PurchaseItemDraft item;
  final bool enabled;
  final List<MaterialDto> materials;
  final VoidCallback onRemove;
  final ValueChanged<MaterialDto> onMaterialChanged;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final options = List<MaterialDto>.from(materials);
    if (item.materialId != 0 &&
        !options.any((material) => material.id == item.materialId)) {
      options.add(
        MaterialDto(
          id: item.materialId,
          code: item.materialCode,
          name: item.materialName,
          unit: item.unit,
          unitPrice: item.unitPrice,
        ),
      );
    }
    final selectedValue =
        options.any((material) => material.id == item.materialId)
            ? item.materialId
            : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              value: selectedValue,
              decoration: const InputDecoration(
                labelText: '物料',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              items: options
                  .map(
                    (material) => DropdownMenuItem<int>(
                      value: material.id,
                      child: Text('${material.code} ${material.name}'),
                    ),
                  )
                  .toList(),
              onChanged: enabled
                  ? (value) {
                      if (value == null) return;
                      final selected =
                          materials.firstWhere((m) => m.id == value);
                      onMaterialChanged(selected);
                      onChanged?.call();
                    }
                  : null,
              validator: (value) {
                if (value == null || value == 0) return '请选择物料';
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: TextFormField(
              controller: item.quantityController,
              enabled: enabled,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '数量',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => onChanged?.call(),
              validator: (value) {
                final parsed = double.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed <= 0) {
                  return '无效';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: TextFormField(
              controller: item.unitController,
              enabled: false,
              decoration: const InputDecoration(
                labelText: '单位',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: TextFormField(
              controller: item.unitPriceController,
              enabled: enabled,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '单价',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => onChanged?.call(),
              validator: (value) {
                final parsed = double.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed < 0) {
                  return '无效';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: enabled ? onRemove : null,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}

class _ReceiveItemDraft {
  _ReceiveItemDraft({
    required this.itemId,
    required this.materialName,
    required this.materialCode,
    required this.quantity,
    required this.receivedQuantity,
    required this.remainingQuantity,
  })  : receiveController = TextEditingController(text: '0'),
        notesController = TextEditingController();

  final int itemId;
  final String materialName;
  final String materialCode;
  final double quantity;
  final double receivedQuantity;
  final double remainingQuantity;
  final TextEditingController receiveController;
  final TextEditingController notesController;

  double get receiveQuantity =>
      double.tryParse(receiveController.text.trim()) ?? 0;
  String get notes => notesController.text.trim();

  void dispose() {
    receiveController.dispose();
    notesController.dispose();
  }
}

class _ReceiveItemRow extends StatelessWidget {
  const _ReceiveItemRow({
    required this.item,
    required this.enabled,
    this.onChanged,
  });

  final _ReceiveItemDraft item;
  final bool enabled;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final isDisabled = !enabled || item.remainingQuantity <= 0;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.materialCode} ${item.materialName}',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  _InlineMeta(
                    label: '采购数量',
                    value: item.quantity.toStringAsFixed(2),
                  ),
                  _InlineMeta(
                    label: '已收货',
                    value: item.receivedQuantity.toStringAsFixed(2),
                  ),
                  _InlineMeta(
                    label: '剩余',
                    value: item.remainingQuantity.toStringAsFixed(2),
                    valueColor: item.remainingQuantity > 0
                        ? theme.colorScheme.error
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      controller: item.receiveController,
                      enabled: !isDisabled,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: '本次收货',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => onChanged?.call(),
                      validator: (value) {
                        if (isDisabled) return null;
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed < 0) return '无效';
                        if (parsed > item.remainingQuantity) {
                          return '最多${item.remainingQuantity.toStringAsFixed(2)}';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: item.notesController,
                      enabled: !isDisabled,
                      decoration: const InputDecoration(
                        labelText: '备注',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineMeta extends StatelessWidget {
  const _InlineMeta({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label ',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(color: valueColor),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onPicked,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onPicked;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: _formatDate(value));
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.date_range_outlined),
      ),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 5),
          lastDate: DateTime(now.year + 5),
        );
        if (picked != null) {
          onPicked(picked);
        }
      },
    );
  }
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
