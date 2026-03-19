import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/inventory_delivery/application/delivery_order_view_model.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_repository_impl.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_support_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_repository.dart';
import 'package:work_order_app/src/features/inventory_delivery/presentation/widgets/delivery_order_action_dialogs.dart';
import 'package:work_order_app/src/features/inventory_delivery/presentation/widgets/delivery_order_detail_dialog.dart';
import 'package:work_order_app/src/features/inventory_delivery/presentation/widgets/delivery_order_form_dialog.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';

/// 发货单列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class DeliveryOrderListEntry extends StatelessWidget {
  const DeliveryOrderListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<DeliveryOrderApiService, DeliveryOrderRepository,
        DeliveryOrderViewModel>(
      createService: (context) =>
          DeliveryOrderApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          DeliveryOrderRepositoryImpl(context.read<DeliveryOrderApiService>()),
      createViewModel: (context) =>
          DeliveryOrderViewModel(context.read<DeliveryOrderRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
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
  bool _salesOrdersLoaded = false;
  List<ProductOption> _products = [];
  bool _productsLoading = false;
  bool _prefillHandled = false;
  bool _pendingPrefill = false;
  int? _prefillSalesOrderId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFormOptions();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prefillHandled) return;
    final uri = GoRouterState.of(context).uri;
    final createFlag = uri.queryParameters['create'];
    final salesOrderId =
        int.tryParse(uri.queryParameters['sales_order_id'] ?? '');
    if (salesOrderId != null && (createFlag == '1' || createFlag == 'true')) {
      _prefillSalesOrderId = salesOrderId;
      _pendingPrefill = true;
    }
    _prefillHandled = true;
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

  Future<void> _loadFormOptions() async {
    setState(() {
      _customersLoading = true;
      _salesOrdersLoading = true;
      _salesOrdersLoaded = false;
      _productsLoading = true;
    });
    try {
      final data = await DeliveryOrderSupportService(context.read<ApiClient>())
          .loadFormOptions();
      if (!mounted) return;
      setState(() {
        _customers = data.customers;
        _salesOrders = data.salesOrders;
        _products = data.products;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _customers = [];
        _salesOrders = [];
        _products = [];
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _customersLoading = false;
        _salesOrdersLoading = false;
        _salesOrdersLoaded = true;
        _productsLoading = false;
      });
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
    await showDeliveryOrderDetailDialog(
      context,
      detail: detail,
      title: _detailTitle,
      closeText: _cancelText,
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
    int? prefillSalesOrderId,
  }) async {
    final apiService = context.read<DeliveryOrderApiService>();
    final supportService =
        DeliveryOrderSupportService(context.read<ApiClient>());
    final isEdit = order != null;
    DeliveryOrderDetail? detail;
    if (isEdit) {
      detail = await _fetchDetail(order);
      if (detail == null) {
        return;
      }
    }

    int? selectedSalesOrderId = detail?.salesOrderId ?? prefillSalesOrderId;
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

    List<DeliveryItemDraft> items = [];
    if (detail != null && detail.items.isNotEmpty) {
      items = detail.items
          .map((item) => DeliveryItemDraft(
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

    Future<void> applySalesOrder(
      int id, {
      StateSetter? setState,
    }) async {
      try {
        final detailDto = await supportService.fetchSalesOrderDetail(id);
        final salesDetail = detailDto.toEntity();
        final customerId = salesDetail.customerId ?? 0;
        for (final item in items) {
          item.dispose();
        }
        void update() {
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
            return DeliveryItemDraft(
              productId: item.productId ?? 0,
              productName: item.productName ?? '-',
              maxQuantity: remaining,
              initialQuantity: remaining,
              unitPrice: item.unitPrice ?? 0,
              unit: item.unit ?? '',
            );
          }).toList();
        }

        if (setState != null) {
          setState(update);
        } else {
          update();
        }
      } catch (err) {
        ToastUtil.showError('获取销售订单失败: $err');
      }
    }

    if (!isEdit && prefillSalesOrderId != null) {
      await applySalesOrder(prefillSalesOrderId);
    }

    Future<void> submit(StateSetter setState) async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      if (items.isEmpty) {
        ToastUtil.showError('请添加发货明细');
        return;
      }
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
        ToastUtil.showError('提交失败: $err');
      }
    }

    await showDeliveryOrderFormDialog(
      context,
      isEdit: isEdit,
      title: isEdit ? _editTitle : _createTitle,
      cancelText: _cancelText,
      submitText: _submitText,
      productsLoading: _productsLoading,
      formKey: formKey,
      salesOrders: _salesOrders,
      products: _products,
      selectedSalesOrderId: selectedSalesOrderId,
      deliveryDate: deliveryDate,
      receiverNameController: receiverNameController,
      receiverPhoneController: receiverPhoneController,
      addressController: addressController,
      logisticsController: logisticsController,
      trackingController: trackingController,
      freightController: freightController,
      packageCountController: packageCountController,
      packageWeightController: packageWeightController,
      notesController: notesController,
      items: items,
      onSalesOrderChanged: applySalesOrder,
      onDatePicked: (picked) => deliveryDate = picked,
      onSubmit: submit,
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
    await showDeliveryShipDialog(
      context,
      cancelText: _cancelText,
      submitText: _submitText,
      title: _shipTitle,
      initialLogisticsCompany: order.logisticsCompany ?? '',
      initialTrackingNumber: order.trackingNumber ?? '',
      onSubmit: (logistics, tracking) async {
        try {
          final payload = <String, dynamic>{};
          if (logistics.isNotEmpty) {
            payload['logistics_company'] = logistics;
          }
          if (tracking.isNotEmpty) {
            payload['tracking_number'] = tracking;
          }
          await apiService.ship(order.id, payload);
          if (!mounted) return;
          ToastUtil.showSuccess(_shipSuccessText);
          await viewModel.loadDeliveryOrders(resetPage: false);
        } catch (err) {
          ToastUtil.showError('$_shipErrorText$err');
          rethrow;
        }
      },
    );
  }

  Future<void> _openReceiveDialog(
    BuildContext context,
    DeliveryOrderViewModel viewModel,
    DeliveryOrder order,
  ) async {
    final apiService = context.read<DeliveryOrderApiService>();
    await showDeliveryReceiveDialog(
      context,
      cancelText: _cancelText,
      submitText: _submitText,
      title: _receiveTitle,
      onSubmit: (notes) async {
        try {
          final payload = <String, dynamic>{};
          if (notes.isNotEmpty) {
            payload['received_notes'] = notes;
          }
          await apiService.receive(order.id, payload);
          if (!mounted) return;
          ToastUtil.showSuccess(_receiveSuccessText);
          await viewModel.loadDeliveryOrders(resetPage: false);
        } catch (err) {
          ToastUtil.showError('$_receiveErrorText$err');
          rethrow;
        }
      },
    );
  }

  Future<void> _openRejectDialog(
    BuildContext context,
    DeliveryOrderViewModel viewModel,
    DeliveryOrder order,
  ) async {
    final apiService = context.read<DeliveryOrderApiService>();
    await showDeliveryRejectDialog(
      context,
      cancelText: _cancelText,
      submitText: _submitText,
      title: _rejectTitle,
      onSubmit: (reason) async {
        try {
          await apiService.reject(order.id, {'reject_reason': reason});
          if (!mounted) return;
          ToastUtil.showSuccess(_rejectSuccessText);
          await viewModel.loadDeliveryOrders(resetPage: false);
        } catch (err) {
          ToastUtil.showError('$_rejectErrorText$err');
          rethrow;
        }
      },
    );
  }

  static String _pageInfoText(DeliveryOrderViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  void _maybeOpenPrefillDialog(DeliveryOrderViewModel viewModel) {
    if (!_pendingPrefill) return;
    if (_salesOrdersLoading || !_salesOrdersLoaded) return;
    final salesOrderId = _prefillSalesOrderId;
    if (salesOrderId == null) return;
    _pendingPrefill = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _openFormDialog(viewModel, prefillSalesOrderId: salesOrderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<DeliveryOrderViewModel>(
      builder: (context, viewModel, _) {
        _maybeOpenPrefillDialog(viewModel);
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
    final spacing = LayoutTokens.formSectionSpacing(context);
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
        SizedBox(height: spacing),
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
        SizedBox(height: bottomSpacing < spacing ? spacing : bottomSpacing),
        Row(
          children: [
            PageActionButton.outlined(
              onPressed: () => _resetFilters(viewModel),
              icon: const Icon(Icons.restart_alt, size: 16),
              label: _resetButtonText,
            ),
            SizedBox(width: spacing),
            PageActionButton.filled(
              onPressed: () => Navigator.of(context).maybePop(),
              label: '完成',
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
