import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_decision_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
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
  static const String _deleteSuccessText = '发货单已删除';
  static const String _deleteErrorText = '删除失败: ';
  static const String _statusFilterLabel = '发货状态';
  static const String _customerFilterLabel = '客户';
  static const String _resetButtonText = '重置筛选';
  static const String _submitText = '提交';
  static const String _cancelText = '取消';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';
  static const List<String> _signatureExtensions = [
    'pdf',
    'png',
    'jpg',
    'jpeg',
  ];
  static const CrudDeleteConfig<DeliveryOrder> _deleteConfig = CrudDeleteConfig(
    title: _deleteTitle,
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    successMessageBuilder: _buildDeleteSuccessMessage,
    errorMessagePrefix: _deleteErrorText,
  );

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  List<CustomerDto> _customers = [];
  bool _customersLoading = false;
  List<SalesOrderDto> _salesOrders = [];
  bool _salesOrdersLoading = false;
  bool _salesOrdersLoaded = false;
  List<ProductOption> _products = [];
  bool _productsLoading = false;
  bool _pendingPrefill = false;
  int? _prefillSalesOrderId;
  int? _uploadingDeliveryId;
  String? _routeSignature;

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
    final uri = GoRouterState.of(context).uri;
    final createFlag = uri.queryParameters['create'];
    final routeSearch = uri.queryParameters['search']?.trim() ?? '';
    final routeStatus = uri.queryParameters['status']?.trim() ?? '';
    final routeTodo = uri.queryParameters['todo']?.trim() ?? '';
    final routeCustomerId =
        int.tryParse(uri.queryParameters['customer_id'] ?? '');
    final routeDepartmentId =
        int.tryParse(uri.queryParameters['department_id'] ?? '');
    final salesOrderId =
        int.tryParse(uri.queryParameters['sales_order_id'] ?? '');
    final signature = [
      createFlag ?? '',
      routeSearch,
      routeStatus,
      routeTodo,
      routeCustomerId?.toString() ?? '',
      routeDepartmentId?.toString() ?? '',
      salesOrderId?.toString() ?? '',
    ].join('|');
    if (_routeSignature == signature) return;
    _routeSignature = signature;

    if (salesOrderId != null && (createFlag == '1' || createFlag == 'true')) {
      _prefillSalesOrderId = salesOrderId;
      _pendingPrefill = true;
    }
    _searchController.text = routeSearch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DeliveryOrderViewModel>().applyRoutePrefill(
            search: routeSearch,
            status: routeStatus,
            customerId: routeCustomerId,
            departmentId: routeDepartmentId,
            todo: routeTodo,
          );
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

  void _openCreateInvoiceForDelivery(DeliveryOrder order) {
    final salesOrderId = order.salesOrderId;
    if (salesOrderId == null || salesOrderId <= 0) {
      ToastUtil.showError('当前发货单缺少客户订单，无法预填开票');
      return;
    }
    final customerQuery = order.customerId != null && order.customerId! > 0
        ? '&customer_id=${order.customerId}'
        : '';
    context.go(
      '/finance/invoices?create=1&sales_order_id=$salesOrderId$customerQuery',
    );
  }

  Future<void> _uploadReceiverSignature(
    DeliveryOrderViewModel viewModel,
    DeliveryOrder order,
  ) async {
    if (_uploadingDeliveryId == order.id) {
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _signatureExtensions,
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }

    final picked = result.files.single;
    final fileName =
        picked.name.trim().isEmpty ? 'receiver-signature' : picked.name;
    MultipartFile receiverSignature;
    final bytes = picked.bytes;

    if (bytes != null && bytes.isNotEmpty) {
      receiverSignature = MultipartFile.fromBytes(bytes, filename: fileName);
    } else if ((picked.path ?? '').trim().isNotEmpty) {
      receiverSignature = await MultipartFile.fromFile(
        picked.path!.trim(),
        filename: fileName,
      );
    } else {
      ToastUtil.showError('无法读取所选文件');
      return;
    }

    setState(() => _uploadingDeliveryId = order.id);
    try {
      final apiService = context.read<DeliveryOrderApiService>();
      await apiService.uploadReceiverSignature(order.id, receiverSignature);
      if (!mounted) return;
      ToastUtil.showSuccess('签收附件已上传');
      await viewModel.loadDeliveryOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('上传签收附件失败: $err');
    } finally {
      if (mounted && _uploadingDeliveryId == order.id) {
        setState(() => _uploadingDeliveryId = null);
      }
    }
  }

  static String _deliveryLabel(DeliveryOrder order) {
    final number = order.orderNumber.trim();
    if (number.isNotEmpty) {
      return number;
    }
    return '发货单 #${order.id}';
  }

  static String _buildDeleteSummary(DeliveryOrder order) {
    return '即将删除发货单 ${_deliveryLabel(order)}。删除后，当前发货记录及后续签收追踪将一并失效。';
  }

  static List<String> _buildDeleteImpacts(DeliveryOrder order) {
    return [
      '客户：${CrudValueFormatter.text(order.customerName)}',
      '状态：${CrudValueFormatter.text(order.statusDisplay ?? order.status)}',
      if ((order.salesOrderNumber ?? '').trim().isNotEmpty)
        '客户订单：${order.salesOrderNumber!.trim()}',
      if ((order.logisticsCompany ?? '').trim().isNotEmpty)
        '物流公司：${order.logisticsCompany!.trim()}',
    ];
  }

  static String _buildDeleteAuditHint(DeliveryOrder order) {
    return '如果该发货单已发货或已签收，建议优先保留记录并通过异常处理或作废流程纠正。';
  }

  static String _buildDeleteSuccessMessage(DeliveryOrder order) {
    return _deleteSuccessText;
  }

  Future<void> _confirmDelete(
    DeliveryOrderViewModel viewModel,
    DeliveryOrder order,
  ) async {
    final apiService = context.read<DeliveryOrderApiService>();
    await confirmCrudDeletion(
      context,
      item: order,
      onDelete: (item) async {
        await apiService.deleteDeliveryOrder(item.id);
        await viewModel.loadDeliveryOrders(resetPage: false);
      },
      config: _deleteConfig,
    );
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
        ToastUtil.showError('获取客户订单失败: $err');
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
            ToastUtil.showError('请选择客户订单');
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

  Future<void> _openResolveExceptionDialog(
    DeliveryOrderViewModel viewModel,
    DeliveryOrder order,
  ) async {
    final apiService = context.read<DeliveryOrderApiService>();
    final decision = await showActionDecisionDialog<String>(
      context,
      title: _hasResolvedRejectedException(order) ? '更新拒收处理' : '登记拒收处理',
      summary: '请登记当前发货单的拒收处理方案，处理记录会直接影响后续补发、终止交付和客户沟通跟进。',
      impacts: [
        '客户：${CrudValueFormatter.text(order.customerName)}',
        '发货单号：${_deliveryLabel(order)}',
        if ((order.salesOrderNumber ?? '').trim().isNotEmpty)
          '客户订单：${order.salesOrderNumber!.trim()}',
      ],
      auditHint: '请填写明确的处理结论和执行说明，便于后续追踪责任与闭环。',
      selectionLabel: '处理结论',
      options: const [
        ActionDecisionOption(value: 'reship', label: '安排补发'),
        ActionDecisionOption(value: 'terminate', label: '终止交付'),
      ],
      initialSelection: (order.exceptionResolution ?? '').trim().isEmpty
          ? null
          : order.exceptionResolution!.trim(),
      requireSelection: true,
      selectionErrorText: '请选择处理结论',
      notesLabel: '处理说明',
      notesHint: '填写补发计划、终止原因、客户沟通结果等',
      initialNotes: order.exceptionResolutionNotes ?? '',
      requireNotes: true,
      notesErrorText: '请填写处理说明',
      submitText: '保存处理',
    );
    if (decision == null || decision.selection == null) {
      return;
    }
    try {
      await apiService.resolveException(order.id, {
        'resolution': decision.selection,
        'resolution_notes': decision.notes,
      });
      if (!mounted) return;
      ToastUtil.showSuccess('拒收处理已登记');
      await viewModel.loadDeliveryOrders(resetPage: false);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('登记拒收处理失败: $err');
    }
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
        DataColumn(label: Text('客户订单')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('发货日期')),
        DataColumn(label: Text('明细数')),
        DataColumn(label: Text('发货数量')),
        DataColumn(label: Text('物流公司')),
        DataColumn(label: Text('运单号')),
        DataColumn(label: Text('开票')),
        DataColumn(label: Text('下一步')),
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
              DataCell(Text(_invoiceFollowUpText(order), style: textStyle)),
              DataCell(Text(_deliveryFollowUpText(order), style: textStyle)),
              DataCell(RowActionGroup(
                actions: [
                  if (_shouldPromptInvoice(order))
                    RowAction(
                      label: '去开票',
                      icon: Icons.receipt_long_outlined,
                      onPressed: () => _openCreateInvoiceForDelivery(order),
                    ),
                  if ((order.status ?? '') == 'rejected')
                    RowAction(
                      label: _hasResolvedRejectedException(order)
                          ? '更新处理'
                          : '处理拒收',
                      icon: Icons.assignment_turned_in_outlined,
                      onPressed: () =>
                          _openResolveExceptionDialog(viewModel, order),
                    ),
                  RowAction(
                    label: '上传签收附件',
                    icon: Icons.upload_file_outlined,
                    onPressed: () => _uploadReceiverSignature(viewModel, order),
                  ),
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
      showAdaptiveFilterDrawer(
        context,
        isMobile: isMobile,
        child: _buildFilterPanel(
          context,
          viewModel,
          bottomSpacing: isMobile ? 16 : 20,
        ),
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
          final rejectedCount =
              _summaryCount(viewModel.summary, 'rejected_followup_count');
          final pendingReceiveCount =
              _summaryCount(viewModel.summary, 'pending_receive_count');
          final pendingInvoiceCount =
              _summaryCount(viewModel.summary, 'pending_invoice_count');
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
            if (rejectedCount > 0)
              StatusHintChip(
                label: '待处理拒收',
                count: rejectedCount,
                selected: viewModel.todoFilter == 'rejected_followup',
                onTap: () =>
                    _openQuickFilter(viewModel, todo: 'rejected_followup'),
              ),
            if (pendingReceiveCount > 0)
              StatusHintChip(
                label: '待签收交付',
                count: pendingReceiveCount,
                icon: Icons.local_shipping_outlined,
                selected: viewModel.todoFilter == 'pending_receive',
                onTap: () =>
                    _openQuickFilter(viewModel, todo: 'pending_receive'),
              ),
            if (pendingInvoiceCount > 0)
              StatusHintChip(
                label: '待开票交付',
                count: pendingInvoiceCount,
                icon: Icons.receipt_long_outlined,
                selected: viewModel.todoFilter == 'pending_invoice',
                onTap: () =>
                    _openQuickFilter(viewModel, todo: 'pending_invoice'),
              ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadDeliveryOrders(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            if (viewModel.todoFilter.isNotEmpty)
              PageActionButton.outlined(
                onPressed: () => _clearQuickFilter(viewModel),
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: '清除待办',
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
    return FilterPanelBody(
      bottomSpacing: bottomSpacing,
      resetLabel: _resetButtonText,
      onReset: () => _resetFilters(viewModel),
      fields: [
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
      ],
    );
  }

  int _activeFilterCount(DeliveryOrderViewModel viewModel) {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (viewModel.statusFilter.isNotEmpty) count += 1;
    if (viewModel.customerId > 0) count += 1;
    if (viewModel.todoFilter.isNotEmpty) count += 1;
    if (viewModel.departmentId > 0) count += 1;
    return count;
  }

  void _resetFilters(DeliveryOrderViewModel viewModel) {
    _searchController.clear();
    context.go('/delivery-orders');
  }

  void _clearQuickFilter(DeliveryOrderViewModel viewModel) {
    _openQuickFilter(
      viewModel,
      status: viewModel.statusFilter,
      customerId: viewModel.customerId > 0 ? viewModel.customerId : null,
      departmentId: viewModel.departmentId > 0 ? viewModel.departmentId : null,
    );
  }

  void _openQuickFilter(
    DeliveryOrderViewModel viewModel, {
    String? status,
    int? customerId,
    int? departmentId,
    String? todo,
  }) {
    final query = <String, String>{};
    final search = _searchController.text.trim();
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    if ((status ?? '').trim().isNotEmpty) {
      query['status'] = status!.trim();
    }
    if ((customerId ?? 0) > 0) {
      query['customer_id'] = customerId!.toString();
    }
    if ((departmentId ?? 0) > 0) {
      query['department_id'] = departmentId!.toString();
    }
    if ((todo ?? '').trim().isNotEmpty) {
      query['todo'] = todo!.trim();
    }
    context
        .go(Uri(path: '/delivery-orders', queryParameters: query).toString());
  }

  int _summaryCount(Map<String, dynamic> payload, String key) {
    final summary = payload['summary'];
    if (summary is Map<String, dynamic>) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }
    if (summary is Map) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }
    return 0;
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
    final invoiceFollowUp = _invoiceFollowUpText(order);
    final statusCode = order.status ?? '';
    final canShip = statusCode == 'pending';
    final canReceive = statusCode == 'shipped' || statusCode == 'in_transit';
    final canReject = canReceive;
    final canEdit = statusCode == 'pending';
    final canDelete = statusCode == 'pending';
    final followUp = _deliveryFollowUpText(order);

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
                      _SummaryChip(label: '下一步', value: followUp),
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
              _SummaryField(label: '客户订单', value: salesOrder),
              _SummaryField(label: '发货日期', value: deliveryDate),
              _SummaryField(label: '状态', value: status),
              _SummaryField(label: '明细数', value: itemsCount),
              _SummaryField(label: '发货数量', value: totalQuantity),
              _SummaryField(label: '物流公司', value: logistics),
              _SummaryField(label: '运单号', value: trackingNumber),
              _SummaryField(label: '开票跟进', value: invoiceFollowUp),
              _SummaryField(label: '下一步', value: followUp),
              if (_hasResolvedRejectedException(order))
                _SummaryField(
                  label: '拒收处理',
                  value: _displayText(order.exceptionResolutionDisplay),
                ),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_shouldPromptInvoice(order))
                FilledButton.icon(
                  onPressed: () => _openCreateInvoiceForDelivery(order),
                  icon: const Icon(Icons.receipt_long_outlined, size: 16),
                  label: const Text('去开票'),
                ),
              if ((order.status ?? '') == 'rejected')
                OutlinedButton.icon(
                  onPressed: () =>
                      _openResolveExceptionDialog(viewModel, order),
                  icon:
                      const Icon(Icons.assignment_turned_in_outlined, size: 16),
                  label: Text(
                    _hasResolvedRejectedException(order) ? '更新处理' : '处理拒收',
                  ),
                ),
              OutlinedButton.icon(
                onPressed: () => _uploadReceiverSignature(viewModel, order),
                icon: const Icon(Icons.upload_file_outlined, size: 16),
                label: const Text('上传签收附件'),
              ),
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

  bool _shouldPromptInvoice(DeliveryOrder order) {
    final status = order.status ?? '';
    final readyForInvoice =
        status == 'shipped' || status == 'in_transit' || status == 'received';
    final invoiceCount = order.invoiceCount ?? 0;
    return readyForInvoice &&
        invoiceCount <= 0 &&
        (order.salesOrderId ?? 0) > 0;
  }

  String _invoiceFollowUpText(DeliveryOrder order) {
    final count = order.invoiceCount ?? 0;
    if (count > 0) {
      return '已关联 $count 张发票';
    }
    return _shouldPromptInvoice(order) ? '推进开票处理' : _emptyCellText;
  }

  String _deliveryFollowUpText(DeliveryOrder order) {
    switch (order.status ?? '') {
      case 'pending':
        return '待发货执行';
      case 'shipped':
      case 'in_transit':
        return '待签收确认';
      case 'received':
        return _shouldPromptInvoice(order) ? '已签收，推进开票' : '交付已完成';
      case 'rejected':
        if (_hasResolvedRejectedException(order)) {
          return order.exceptionResolutionDisplay ?? '已登记拒收处理';
        }
        return '库存已回退，待补发或终止';
      default:
        return _emptyCellText;
    }
  }

  bool _hasResolvedRejectedException(DeliveryOrder order) {
    return order.exceptionClosed == true ||
        (order.exceptionResolution ?? '').trim().isNotEmpty ||
        (order.exceptionResolutionNotes ?? '').trim().isNotEmpty;
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
