import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/inventory_delivery/application/delivery_order_view_model.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_repository_impl.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_repository.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';

/// 发货单列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class DeliveryOrderListEntry extends StatefulWidget {
  const DeliveryOrderListEntry({super.key});

  @override
  State<DeliveryOrderListEntry> createState() => _DeliveryOrderListEntryState();
}

class _DeliveryOrderListEntryState extends State<DeliveryOrderListEntry> {
  DeliveryOrderApiService? _apiService;
  DeliveryOrderRepositoryImpl? _repository;
  DeliveryOrderViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = DeliveryOrderApiService(apiClient);
    _repository = DeliveryOrderRepositoryImpl(_apiService!);
    _viewModel = DeliveryOrderViewModel(_repository!);
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
        Provider<DeliveryOrderApiService>.value(value: apiService),
        Provider<DeliveryOrderRepository>.value(value: repository),
        ChangeNotifierProvider<DeliveryOrderViewModel>.value(value: viewModel),
      ],
      child: const DeliveryOrderListPage(),
    );
  }
}

/// 发货单列表页视图，只负责渲染。
class DeliveryOrderListPage extends StatelessWidget {
  const DeliveryOrderListPage({super.key});

  @override
  Widget build(BuildContext context) => const _DeliveryOrderListView();
}

class _DeliveryOrderListView extends StatefulWidget {
  const _DeliveryOrderListView();

  @override
  State<_DeliveryOrderListView> createState() => _DeliveryOrderListViewState();
}

class _DeliveryOrderListViewState extends State<_DeliveryOrderListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索单号/客户/物流';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无发货单数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _shipTitle = '发货';
  static const String _receiveTitle = '签收';
  static const String _rejectTitle = '拒收';
  static const String _shipSuccessText = '发货成功';
  static const String _receiveSuccessText = '签收成功';
  static const String _rejectSuccessText = '拒收处理成功';
  static const String _shipErrorText = '发货失败: ';
  static const String _receiveErrorText = '签收失败: ';
  static const String _rejectErrorText = '拒收失败: ';
  static const String _createTitle = '新建发货单';
  static const String _editTitle = '编辑发货单';
  static const String _detailTitle = '发货单详情';
  static const String _deleteTitle = '删除发货单';
  static const String _deleteContent = '确认删除该发货单？';
  static const String _deleteSuccessText = '发货单已删除';
  static const String _deleteErrorText = '删除失败: ';
  static const String _statusFilterLabel = '发货状态';
  static const String _customerFilterLabel = '客户';
  static const String _resetButtonText = '重置筛选';
  static const String _submitText = '提交';
  static const String _cancelText = '取消';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  List<CustomerDto> _customers = [];
  bool _customersLoading = false;
  List<SalesOrderDto> _salesOrders = [];
  bool _salesOrdersLoading = false;
  List<ProductOption> _products = [];
  bool _productsLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCustomers();
      _loadSalesOrders();
      _loadProducts();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(DeliveryOrderViewModel viewModel,
      {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadDeliveryOrders(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadDeliveryOrders(resetPage: true);
    });
  }

  Future<void> _loadCustomers() async {
    final apiService = CustomerApiService(context.read<ApiClient>());
    setState(() => _customersLoading = true);
    try {
      final page = await apiService.fetchCustomers(pageSize: 200);
      if (!mounted) return;
      setState(() => _customers = page.items);
    } catch (_) {
      if (!mounted) return;
      setState(() => _customers = []);
    } finally {
      if (!mounted) return;
      setState(() => _customersLoading = false);
    }
  }

  Future<void> _loadSalesOrders() async {
    final apiService = SalesOrderApiService(context.read<ApiClient>());
    setState(() => _salesOrdersLoading = true);
    try {
      final page = await apiService.fetchSalesOrders(pageSize: 200);
      final items = page.items
          .where((order) =>
              order.status == 'approved' || order.status == 'in_production')
          .toList();
      if (!mounted) return;
      setState(() => _salesOrders = items);
    } catch (_) {
      if (!mounted) return;
      setState(() => _salesOrders = []);
    } finally {
      if (!mounted) return;
      setState(() => _salesOrdersLoading = false);
    }
  }

  Future<void> _loadProducts() async {
    final apiService = ProductApiService(context.read<ApiClient>());
    setState(() => _productsLoading = true);
    try {
      final items = await apiService.fetchProducts(pageSize: 300);
      if (!mounted) return;
      setState(() => _products = items);
    } catch (_) {
      if (!mounted) return;
      setState(() => _products = []);
    } finally {
      if (!mounted) return;
      setState(() => _productsLoading = false);
    }
  }

  Future<DeliveryOrderDetail?> _fetchDetail(DeliveryOrder order) async {
    final apiService = context.read<DeliveryOrderApiService>();
    try {
      return await apiService.fetchDetail(order.id);
    } catch (err) {
      ToastUtil.showError('获取发货单详情失败: $err');
      return null;
    }
  }

  Future<void> _openDetailDialog(DeliveryOrder order) async {
    DeliveryOrderDetail? detail = await _fetchDetail(order);
    detail ??= DeliveryOrderDetail(
      id: order.id,
      orderNumber: order.orderNumber,
      customerName: order.customerName,
      salesOrderNumber: order.salesOrderNumber,
      status: order.status,
      statusDisplay: order.statusDisplay,
      deliveryDate: order.deliveryDate,
      logisticsCompany: order.logisticsCompany,
      trackingNumber: order.trackingNumber,
    );

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(_detailTitle),
          content: SizedBox(
            width: 700,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(label: '发货单号', value: detail!.orderNumber),
                  _DetailRow(
                    label: '客户',
                    value: _displayText(detail.customerName),
                  ),
                  _DetailRow(
                    label: '销售订单',
                    value: _displayText(detail.salesOrderNumber),
                  ),
                  _DetailRow(
                    label: '状态',
                    value: _displayText(detail.statusDisplay ?? detail.status),
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
                    value: detail.packageCount?.toString() ?? _emptyCellText,
                  ),
                  _DetailRow(
                    label: '总重量',
                    value: _formatAmount(detail.packageWeight),
                  ),
                  if ((detail.receivedNotes ?? '').trim().isNotEmpty)
                    _DetailRow(
                      label: '签收备注',
                      value: detail.receivedNotes ?? '',
                    ),
                  if (detail.items.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('发货明细', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    ...detail.items.map(
                      (item) => _DetailRow(
                        label: _displayText(item.productName),
                        value:
                            '${_formatAmount(item.quantity)} ${item.unit ?? ''}'
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
              child: const Text(_cancelText),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(
    DeliveryOrderViewModel viewModel,
    DeliveryOrder order,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(_deleteTitle),
        content: const Text(_deleteContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(_cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final apiService = context.read<DeliveryOrderApiService>();
    try {
      await apiService.deleteDeliveryOrder(order.id);
      if (!mounted) return;
      ToastUtil.showSuccess(_deleteSuccessText);
      await viewModel.loadDeliveryOrders(resetPage: false);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_deleteErrorText$err');
    }
  }

  Future<void> _openFormDialog(
    DeliveryOrderViewModel viewModel, {
    DeliveryOrder? order,
  }) async {
    final apiService = context.read<DeliveryOrderApiService>();
    final salesOrderService = SalesOrderApiService(context.read<ApiClient>());
    final isEdit = order != null;
    DeliveryOrderDetail? detail;
    if (isEdit) {
      detail = await _fetchDetail(order);
      if (detail == null) {
        return;
      }
    }

    int? selectedSalesOrderId = detail?.salesOrderId;
    int? selectedCustomerId = detail?.customerId;
    DateTime? deliveryDate = detail?.deliveryDate;
    final receiverNameController =
        TextEditingController(text: detail?.receiverName ?? '');
    final receiverPhoneController =
        TextEditingController(text: detail?.receiverPhone ?? '');
    final addressController =
        TextEditingController(text: detail?.deliveryAddress ?? '');
    final logisticsController =
        TextEditingController(text: detail?.logisticsCompany ?? '');
    final trackingController =
        TextEditingController(text: detail?.trackingNumber ?? '');
    final freightController = TextEditingController(
      text: detail?.freight == null ? '' : detail!.freight!.toStringAsFixed(2),
    );
    final packageCountController = TextEditingController(
      text: detail?.packageCount?.toString() ?? '',
    );
    final packageWeightController = TextEditingController(
      text: detail?.packageWeight == null
          ? ''
          : detail!.packageWeight!.toStringAsFixed(2),
    );
    final notesController = TextEditingController(text: detail?.notes ?? '');

    List<_DeliveryItemDraft> items = [];
    if (detail != null && detail.items.isNotEmpty) {
      items = detail.items
          .map((item) => _DeliveryItemDraft(
                productId: item.productId ?? 0,
                productName: item.productName ?? '-',
                maxQuantity: item.quantity ?? 0,
                initialQuantity: item.quantity ?? 0,
                unitPrice: item.unitPrice ?? 0,
                unit: item.unit ?? '',
                stockBatch: item.stockBatch ?? '',
              ))
          .toList();
    }

    final formKey = GlobalKey<FormState>();
    bool submitting = false;

    Future<void> loadSalesOrderItems(int id, StateSetter setState) async {
      try {
        final detailDto = await salesOrderService.fetchSalesOrder(id);
        final salesDetail = detailDto.toEntity();
        final customerId = salesDetail.customerId ?? 0;
        for (final item in items) {
          item.dispose();
        }
        setState(() {
          selectedSalesOrderId = id;
          selectedCustomerId = customerId == 0 ? null : customerId;
          receiverNameController.text =
              salesDetail.contactPerson ?? receiverNameController.text;
          receiverPhoneController.text =
              salesDetail.contactPhone ?? receiverPhoneController.text;
          addressController.text =
              salesDetail.shippingAddress ?? addressController.text;
          deliveryDate = salesDetail.deliveryDate ?? deliveryDate;
          items = salesDetail.items.map((item) {
            final ordered = item.quantity ?? 0;
            final delivered = (item.deliveredQuantity ?? 0).toDouble();
            final remaining =
                (ordered - delivered).clamp(0, ordered).toDouble();
            return _DeliveryItemDraft(
              productId: item.productId ?? 0,
              productName: item.productName ?? '-',
              maxQuantity: remaining,
              initialQuantity: remaining,
              unitPrice: item.unitPrice ?? 0,
              unit: item.unit ?? '',
            );
          }).toList();
        });
      } catch (err) {
        ToastUtil.showError('获取销售订单失败: $err');
      }
    }

    Future<void> submit(StateSetter setState) async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      if (items.isEmpty) {
        ToastUtil.showError('请添加发货明细');
        return;
      }
      setState(() => submitting = true);
      try {
        final payload = <String, dynamic>{
          'delivery_date':
              deliveryDate == null ? null : _formatDate(deliveryDate),
          'receiver_name': receiverNameController.text.trim(),
          'receiver_phone': receiverPhoneController.text.trim(),
          'delivery_address': addressController.text.trim(),
          'logistics_company': logisticsController.text.trim(),
          'tracking_number': trackingController.text.trim(),
          'freight': double.tryParse(freightController.text.trim()),
          'package_count': int.tryParse(packageCountController.text.trim()),
          'package_weight':
              double.tryParse(packageWeightController.text.trim()),
          'notes': notesController.text.trim(),
          'items_data': items
              .map((item) => {
                    'product': item.productId,
                    'quantity': item.quantity,
                    'unit_price': item.unitPrice,
                    'unit': item.unit,
                    'stock_batch': item.stockBatch,
                  })
              .toList(),
        };

        if (isEdit) {
          await apiService.updateDeliveryOrder(order.id, payload);
        } else {
          if (selectedSalesOrderId == null || selectedCustomerId == null) {
            ToastUtil.showError('请选择销售订单');
            setState(() => submitting = false);
            return;
          }
          payload['sales_order'] = selectedSalesOrderId;
          payload['customer'] = selectedCustomerId;
          await apiService.createDeliveryOrder(payload);
        }
        if (!mounted) return;
        Navigator.of(context).pop();
        ToastUtil.showSuccess(isEdit ? '发货单已更新' : '发货单已创建');
        await viewModel.loadDeliveryOrders(resetPage: false);
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
                        if (!isEdit)
                          SearchableDropdownFormField<int>(
                            key: ValueKey<int?>(selectedSalesOrderId),
                            initialValue: selectedSalesOrderId,
                            decoration: const InputDecoration(
                              labelText: '销售订单',
                              border: OutlineInputBorder(),
                            ),
                            items: _salesOrders
                                .map(
                                  (order) => DropdownMenuItem(
                                    value: order.id,
                                    child: Text(order.orderNumber),
                                  ),
                                )
                                .toList(),
                            onChanged: submitting
                                ? null
                                : (value) {
                                    if (value == null) return;
                                    loadSalesOrderItems(value, setState);
                                  },
                            validator: (value) {
                              if (!isEdit && (value == null || value == 0)) {
                                return '请选择销售订单';
                              }
                              return null;
                            },
                          ),
                        if (!isEdit) const SizedBox(height: 12),
                        TextFormField(
                          controller: receiverNameController,
                          decoration: const InputDecoration(
                            labelText: '收货人',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              (value?.trim().isEmpty ?? true) ? '请输入收货人' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: receiverPhoneController,
                          decoration: const InputDecoration(
                            labelText: '联系电话',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => (value?.trim().isEmpty ?? true)
                              ? '请输入联系电话'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            labelText: '送货地址',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => (value?.trim().isEmpty ?? true)
                              ? '请输入送货地址'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _DateField(
                          label: '发货日期',
                          value: deliveryDate,
                          onPicked: (picked) =>
                              setState(() => deliveryDate = picked),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: logisticsController,
                          decoration: const InputDecoration(
                            labelText: '物流公司',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: trackingController,
                          decoration: const InputDecoration(
                            labelText: '物流单号',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: freightController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                  labelText: '运费',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: packageCountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: '包裹数',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: packageWeightController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                  labelText: '总重量(kg)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
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
                              child: Text('发货明细',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ),
                            TextButton.icon(
                              onPressed: submitting || _productsLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        items.add(
                                          _DeliveryItemDraft(
                                            productId: 0,
                                            productName: '-',
                                            maxQuantity: 0,
                                            initialQuantity: 1,
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
                                  (item) => _DeliveryItemRow(
                                    item: item,
                                    enabled: !submitting,
                                    products: _products,
                                    onRemove: () {
                                      setState(() {
                                        items.remove(item);
                                        item.dispose();
                                      });
                                    },
                                    onProductChanged: (product) {
                                      setState(() {
                                        item.productId = product.id;
                                        item.productName = product.displayLabel;
                                      });
                                    },
                                  ),
                                )
                                .toList(),
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
                  child: Text(submitting ? '提交中...' : _submitText),
                ),
              ],
            );
          },
        );
      },
    );

    receiverNameController.dispose();
    receiverPhoneController.dispose();
    addressController.dispose();
    logisticsController.dispose();
    trackingController.dispose();
    freightController.dispose();
    packageCountController.dispose();
    packageWeightController.dispose();
    notesController.dispose();
    for (final item in items) {
      item.dispose();
    }
  }

  Future<void> _openShipDialog(
    BuildContext context,
    DeliveryOrderViewModel viewModel,
    DeliveryOrder order,
  ) async {
    final apiService = context.read<DeliveryOrderApiService>();
    final formKey = GlobalKey<FormState>();
    final logisticsController =
        TextEditingController(text: order.logisticsCompany ?? '');
    final trackingController =
        TextEditingController(text: order.trackingNumber ?? '');
    bool submitting = false;

    Future<void> submit(StateSetter setState) async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      setState(() => submitting = true);
      try {
        final logistics = logisticsController.text.trim();
        final tracking = trackingController.text.trim();
        final payload = <String, dynamic>{};
        if (logistics.isNotEmpty) {
          payload['logistics_company'] = logistics;
        }
        if (tracking.isNotEmpty) {
          payload['tracking_number'] = tracking;
        }
        await apiService.ship(order.id, payload);
        if (!mounted) return;
        Navigator.of(context).pop();
        ToastUtil.showSuccess(_shipSuccessText);
        await viewModel.loadDeliveryOrders(resetPage: false);
      } catch (err) {
        if (!mounted) return;
        setState(() => submitting = false);
        ToastUtil.showError('$_shipErrorText$err');
      }
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(_shipTitle),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: logisticsController,
                          decoration: const InputDecoration(labelText: '物流公司'),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: trackingController,
                          decoration: const InputDecoration(labelText: '运单号'),
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
                  child: Text(submitting ? '提交中...' : _submitText),
                ),
              ],
            );
          },
        );
      },
    );

    logisticsController.dispose();
    trackingController.dispose();
  }

  Future<void> _openReceiveDialog(
    BuildContext context,
    DeliveryOrderViewModel viewModel,
    DeliveryOrder order,
  ) async {
    final apiService = context.read<DeliveryOrderApiService>();
    final formKey = GlobalKey<FormState>();
    final notesController = TextEditingController();
    bool submitting = false;

    Future<void> submit(StateSetter setState) async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      setState(() => submitting = true);
      try {
        final notes = notesController.text.trim();
        final payload = <String, dynamic>{};
        if (notes.isNotEmpty) {
          payload['received_notes'] = notes;
        }
        await apiService.receive(order.id, payload);
        if (!mounted) return;
        Navigator.of(context).pop();
        ToastUtil.showSuccess(_receiveSuccessText);
        await viewModel.loadDeliveryOrders(resetPage: false);
      } catch (err) {
        if (!mounted) return;
        setState(() => submitting = false);
        ToastUtil.showError('$_receiveErrorText$err');
      }
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(_receiveTitle),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: '签收备注'),
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
  }

  Future<void> _openRejectDialog(
    BuildContext context,
    DeliveryOrderViewModel viewModel,
    DeliveryOrder order,
  ) async {
    final apiService = context.read<DeliveryOrderApiService>();
    final formKey = GlobalKey<FormState>();
    final reasonController = TextEditingController();
    bool submitting = false;

    Future<void> submit(StateSetter setState) async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      setState(() => submitting = true);
      try {
        final reason = reasonController.text.trim();
        await apiService.reject(order.id, {'reject_reason': reason});
        if (!mounted) return;
        Navigator.of(context).pop();
        ToastUtil.showSuccess(_rejectSuccessText);
        await viewModel.loadDeliveryOrders(resetPage: false);
      } catch (err) {
        if (!mounted) return;
        setState(() => submitting = false);
        ToastUtil.showError('$_rejectErrorText$err');
      }
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(_rejectTitle),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: reasonController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: '拒收原因'),
                      validator: (value) {
                        if ((value?.trim() ?? '').isEmpty) {
                          return '请输入拒收原因';
                        }
                        return null;
                      },
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

    reasonController.dispose();
  }

  static String _pageInfoText(DeliveryOrderViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<DeliveryOrderViewModel>(
      builder: (context, viewModel, _) {
        final orders = viewModel.deliveryOrders;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, orders, isMobile),
          footer: viewModel.totalPages > 1
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
    DeliveryOrderViewModel viewModel,
    List<DeliveryOrder> orders,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    Widget listContent;
    if (viewModel.loading && orders.isEmpty) {
      listContent = const Center(child: CircularProgressIndicator());
    } else if (viewModel.errorMessage != null && !viewModel.loading) {
      listContent = ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadDeliveryOrders(resetPage: true),
      );
    } else if (!viewModel.loading && orders.isEmpty) {
      listContent = const EmptyStateCard(
        icon: Icons.local_shipping_outlined,
        text: _emptyText,
      );
    } else {
      if (!isMobile) {
        listContent = _buildDesktopTable(context, viewModel, orders);
      } else {
        listContent = ListView.separated(
          itemCount: orders.length,
          separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
          itemBuilder: (context, index) {
            final order = orders[index];
            return _buildSummaryCard(context, viewModel, order, isMobile);
          },
        );
      }
    }

    return listContent;
  }

  Widget _buildDesktopTable(
    BuildContext context,
    DeliveryOrderViewModel viewModel,
    List<DeliveryOrder> orders,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('发货单号')),
        DataColumn(label: Text('客户')),
        DataColumn(label: Text('销售订单')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('发货日期')),
        DataColumn(label: Text('明细数')),
        DataColumn(label: Text('发货数量')),
        DataColumn(label: Text('物流公司')),
        DataColumn(label: Text('运单号')),
        DataColumn(label: Text('操作')),
      ],
      rows: orders.map(
        (order) {
          final statusCode = order.status ?? '';
          final canShip = statusCode == 'pending';
          final canReceive =
              statusCode == 'shipped' || statusCode == 'in_transit';
          final canReject = canReceive;
          final canEdit = statusCode == 'pending';
          final canDelete = statusCode == 'pending';

          return DataRow(
            cells: [
              DataCell(Text(
                order.orderNumber.isEmpty
                    ? '发货单 #${order.id}'
                    : order.orderNumber,
                style: theme.textTheme.bodyMedium,
              )),
              DataCell(
                  Text(_displayText(order.customerName), style: textStyle)),
              DataCell(
                  Text(_displayText(order.salesOrderNumber), style: textStyle)),
              DataCell(Text(
                _displayText(order.statusDisplay ?? order.status),
                style: textStyle,
              )),
              DataCell(Text(_formatDate(order.deliveryDate), style: textStyle)),
              DataCell(Text(order.itemsCount?.toString() ?? _emptyCellText,
                  style: textStyle)),
              DataCell(
                  Text(_formatAmount(order.totalQuantity), style: textStyle)),
              DataCell(
                  Text(_displayText(order.logisticsCompany), style: textStyle)),
              DataCell(
                  Text(_displayText(order.trackingNumber), style: textStyle)),
              DataCell(RowActionGroup(
                actions: [
                  RowAction(
                    label: '查看',
                    onPressed: () => _openDetailDialog(order),
                  ),
                  if (canEdit)
                    RowAction(
                      label: '编辑',
                      onPressed: () => _openFormDialog(viewModel, order: order),
                    ),
                  if (canShip)
                    RowAction(
                      label: _shipTitle,
                      onPressed: () =>
                          _openShipDialog(context, viewModel, order),
                    ),
                  if (canReceive)
                    RowAction(
                      label: _receiveTitle,
                      onPressed: () =>
                          _openReceiveDialog(context, viewModel, order),
                    ),
                  if (canReject)
                    RowAction(
                      label: _rejectTitle,
                      onPressed: () =>
                          _openRejectDialog(context, viewModel, order),
                    ),
                  if (canDelete)
                    RowAction(
                      label: '删除',
                      onPressed: () => _confirmDelete(viewModel, order),
                      destructive: true,
                    ),
                ],
              )),
            ],
          );
        },
      ).toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    DeliveryOrderViewModel viewModel,
    bool isMobile,
  ) {
    void openFilterDrawer() {
      if (isMobile) {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          builder: (sheetContext) {
            return _FilterDrawerContent(
              title: '筛选',
              child: _buildFilterPanel(
                sheetContext,
                viewModel,
                bottomSpacing: 16,
              ),
            );
          },
        );
        return;
      }

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '筛选',
        barrierColor: Colors.black.withValues(alpha: 0.3),
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (dialogContext, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Theme.of(dialogContext).colorScheme.surface,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: SizedBox(
                width: 360,
                height: double.infinity,
                child: SafeArea(
                  child: _FilterDrawerContent(
                    title: '筛选',
                    child: _buildFilterPanel(
                      dialogContext,
                      viewModel,
                      bottomSpacing: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final offsetTween =
              Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
          return SlideTransition(
            position: animation
                .drive(
                  CurveTween(curve: Curves.easeOutCubic),
                )
                .drive(offsetTween),
            child: child,
          );
        },
      );
    }

    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final activeFilters = _activeFilterCount(viewModel);
          final searchField = ListSearchField(
            controller: _searchController,
            hintText: _searchHintText,
            height: _controlHeight,
            width: isMobile ? constraints.maxWidth : _searchWidth,
            onChanged: (_) => _scheduleSearch(viewModel),
            onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
            onClear: () {
              _searchController.clear();
              _scheduleSearch(viewModel, immediate: true);
            },
          );

          final actions = <Widget>[
            PageActionButton.outlined(
              onPressed: () => viewModel.loadDeliveryOrders(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.filled(
              onPressed: _salesOrdersLoading || _salesOrders.isEmpty
                  ? null
                  : () => _openFormDialog(viewModel),
              icon: const Icon(Icons.add, size: 16),
              label: '新建发货单',
            ),
            PageActionButton.outlined(
              onPressed: openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: activeFilters > 0 ? '筛选 $activeFilters' : '筛选',
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

  Widget _buildFilterPanel(
    BuildContext context,
    DeliveryOrderViewModel viewModel, {
    required double bottomSpacing,
  }) {
    final statusValue =
        viewModel.statusFilter.isEmpty ? '' : viewModel.statusFilter;
    final customerValue = viewModel.customerId;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchableDropdownFormField<String>(
          key: ValueKey<String>(statusValue),
          initialValue: statusValue,
          isExpanded: true,
          decoration: const InputDecoration(labelText: _statusFilterLabel),
          items: const [
            DropdownMenuItem(value: '', child: Text('全部状态')),
            DropdownMenuItem(value: 'pending', child: Text('待发货')),
            DropdownMenuItem(value: 'shipped', child: Text('已发货')),
            DropdownMenuItem(value: 'in_transit', child: Text('运输中')),
            DropdownMenuItem(value: 'received', child: Text('已签收')),
            DropdownMenuItem(value: 'rejected', child: Text('拒收')),
          ],
          onChanged: (value) => viewModel.setStatusFilter(value ?? ''),
        ),
        const SizedBox(height: _spacingSm),
        SearchableDropdownFormField<int>(
          key: ValueKey<int>(customerValue),
          initialValue: customerValue,
          isExpanded: true,
          decoration: const InputDecoration(labelText: _customerFilterLabel),
          items: [
            const DropdownMenuItem<int>(
              value: 0,
              child: Text('全部客户'),
            ),
            ..._customers.map(
              (customer) => DropdownMenuItem<int>(
                value: customer.id,
                child: Text(customer.name),
              ),
            ),
          ],
          onChanged: _customersLoading
              ? null
              : (value) => viewModel.setCustomerId(value ?? 0),
        ),
        SizedBox(height: bottomSpacing),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => _resetFilters(viewModel),
              icon: const Icon(Icons.restart_alt),
              label: const Text(_resetButtonText),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('完成'),
            ),
          ],
        ),
      ],
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [content],
    );
  }

  int _activeFilterCount(DeliveryOrderViewModel viewModel) {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (viewModel.statusFilter.isNotEmpty) count += 1;
    if (viewModel.customerId > 0) count += 1;
    return count;
  }

  void _resetFilters(DeliveryOrderViewModel viewModel) {
    _searchController.clear();
    viewModel.setSearchText('');
    var needsReload = false;
    if (viewModel.statusFilter.isNotEmpty) {
      needsReload = true;
      viewModel.setStatusFilter('');
    }
    if (viewModel.customerId > 0) {
      needsReload = true;
      viewModel.setCustomerId(0);
    }
    if (!needsReload) {
      viewModel.loadDeliveryOrders(resetPage: true);
    }
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatAmount(double? value) {
    if (value == null) return _emptyCellText;
    return value.toStringAsFixed(2);
  }

  Widget _buildSummaryCard(
    BuildContext context,
    DeliveryOrderViewModel viewModel,
    DeliveryOrder order,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number =
        order.orderNumber.isEmpty ? '发货单 #${order.id}' : order.orderNumber;
    final customer = _displayText(order.customerName);
    final salesOrder = _displayText(order.salesOrderNumber);
    final deliveryDate = _formatDate(order.deliveryDate);
    final status = order.statusDisplay ?? order.status ?? _emptyCellText;
    final itemsCount = order.itemsCount?.toString() ?? _emptyCellText;
    final totalQuantity = _formatAmount(order.totalQuantity);
    final logistics = _displayText(order.logisticsCompany);
    final trackingNumber = _displayText(order.trackingNumber);
    final statusCode = order.status ?? '';
    final canShip = statusCode == 'pending';
    final canReceive = statusCode == 'shipped' || statusCode == 'in_transit';
    final canReject = canReceive;
    final canEdit = statusCode == 'pending';
    final canDelete = statusCode == 'pending';

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
                    customer,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '状态', value: status),
                      _SummaryChip(label: '发货数量', value: totalQuantity),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  deliveryDate,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors?.subtleText ?? theme.hintColor,
                  ),
                ),
                SizedBox(height: sectionSpacing),
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
              _SummaryField(label: '发货单号', value: number),
              _SummaryField(label: '客户', value: customer),
              _SummaryField(label: '销售订单', value: salesOrder),
              _SummaryField(label: '发货日期', value: deliveryDate),
              _SummaryField(label: '状态', value: status),
              _SummaryField(label: '明细数', value: itemsCount),
              _SummaryField(label: '发货数量', value: totalQuantity),
              _SummaryField(label: '物流公司', value: logistics),
              _SummaryField(label: '运单号', value: trackingNumber),
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
              if (canShip)
                OutlinedButton.icon(
                  onPressed: () => _openShipDialog(context, viewModel, order),
                  icon: const Icon(Icons.local_shipping_outlined, size: 16),
                  label: const Text(_shipTitle),
                ),
              if (canReceive)
                OutlinedButton.icon(
                  onPressed: () =>
                      _openReceiveDialog(context, viewModel, order),
                  icon: const Icon(Icons.fact_check_outlined, size: 16),
                  label: const Text(_receiveTitle),
                ),
              if (canReject)
                OutlinedButton.icon(
                  onPressed: () => _openRejectDialog(context, viewModel, order),
                  icon: const Icon(Icons.cancel_outlined, size: 16),
                  label: const Text(_rejectTitle),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
              if (canDelete)
                OutlinedButton.icon(
                  onPressed: () => _confirmDelete(viewModel, order),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('删除'),
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

class _DeliveryItemDraft {
  _DeliveryItemDraft({
    required this.productId,
    required this.productName,
    required this.maxQuantity,
    required double initialQuantity,
    double unitPrice = 0,
    String unit = '',
    String stockBatch = '',
  })  : quantityController =
            TextEditingController(text: initialQuantity.toStringAsFixed(2)),
        unitPriceController =
            TextEditingController(text: unitPrice.toStringAsFixed(2)),
        unitController = TextEditingController(text: unit),
        stockBatchController = TextEditingController(text: stockBatch);

  int productId;
  String productName;
  final double maxQuantity;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;
  final TextEditingController unitController;
  final TextEditingController stockBatchController;

  double get quantity => double.tryParse(quantityController.text.trim()) ?? 0;
  double get unitPrice => double.tryParse(unitPriceController.text.trim()) ?? 0;
  String get unit => unitController.text.trim();
  String get stockBatch => stockBatchController.text.trim();

  void dispose() {
    quantityController.dispose();
    unitPriceController.dispose();
    unitController.dispose();
    stockBatchController.dispose();
  }
}

class _DeliveryItemRow extends StatelessWidget {
  const _DeliveryItemRow({
    required this.item,
    required this.enabled,
    required this.products,
    required this.onRemove,
    required this.onProductChanged,
  });

  final _DeliveryItemDraft item;
  final bool enabled;
  final List<ProductOption> products;
  final VoidCallback onRemove;
  final ValueChanged<ProductOption> onProductChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: SearchableDropdownFormField<int>(
              key: ValueKey<int?>(item.productId),
              initialValue: item.productId == 0 ? null : item.productId,
              decoration: const InputDecoration(
                labelText: '产品',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              items: products
                  .map(
                    (product) => DropdownMenuItem<int>(
                      value: product.id,
                      child: Text(product.displayLabel),
                    ),
                  )
                  .toList(),
              onChanged: enabled
                  ? (value) {
                      if (value == null) return;
                      final selected =
                          products.firstWhere((p) => p.id == value);
                      onProductChanged(selected);
                    }
                  : null,
              validator: (value) {
                if (value == null || value == 0) return '请选择产品';
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
              validator: (value) {
                final parsed = double.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed <= 0) {
                  return '无效';
                }
                if (item.maxQuantity > 0 && parsed > item.maxQuantity) {
                  return '最多${item.maxQuantity.toStringAsFixed(2)}';
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
              enabled: enabled,
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
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: TextFormField(
              controller: item.stockBatchController,
              enabled: enabled,
              decoration: const InputDecoration(
                labelText: '批次',
                isDense: true,
                border: OutlineInputBorder(),
              ),
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

class _FilterDrawerContent extends StatelessWidget {
  const _FilterDrawerContent({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: '关闭',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}
