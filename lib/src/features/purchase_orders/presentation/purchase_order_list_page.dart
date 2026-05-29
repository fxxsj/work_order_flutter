import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/application/purchase_order_view_model.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_repository_impl.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_support_service.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_repository.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/widgets/purchase_order_action_dialogs.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/widgets/purchase_order_detail_dialog.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/widgets/purchase_order_form_dialog.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/widgets/purchase_order_inspection_dialogs.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/widgets/purchase_order_receive_dialog.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/widgets/purchase_low_stock_dialog.dart';
import 'package:work_order_app/src/features/materials/presentation/widgets/quick_material_create_dialog.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_dto.dart';
import 'package:work_order_app/src/features/suppliers/presentation/widgets/quick_supplier_create_dialog.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';
import 'package:work_order_app/src/core/utils/debounce_controller.dart';

/// 采购单列表入口。
class PurchaseOrderListEntry extends StatelessWidget {
  const PurchaseOrderListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      PurchaseOrderApiService,
      PurchaseOrderRepository,
      PurchaseOrderViewModel
    >(
      createService: (context) =>
          PurchaseOrderApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          PurchaseOrderRepositoryImpl(context.read<PurchaseOrderApiService>()),
      createViewModel: (context) =>
          PurchaseOrderViewModel(context.read<PurchaseOrderRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
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
  static const String _orderingLabel = '排序';
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
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';
  static const CrudActionConfig<PurchaseOrder> _cancelOrderConfig =
      CrudActionConfig(
        title: _cancelOrderText,
        summaryBuilder: _buildCancelSummary,
        impactsBuilder: _buildCancelImpacts,
        auditHintBuilder: _buildCancelAuditHint,
        confirmText: '确认取消',
        successMessageBuilder: _buildCancelSuccessMessage,
        errorMessagePrefix: '取消失败: ',
        destructive: true,
      );

  final TextEditingController _searchController = TextEditingController();
  final _debounce = DebounceController();
  List<SupplierDto> _suppliers = [];
  bool _suppliersLoading = false;
  List<MaterialDto> _materials = [];
  bool _materialsLoading = false;
  List<WorkOrderDto> _workOrders = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFormOptions();
    });
  }

  @override
  void dispose() {
    _debounce.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(
    PurchaseOrderViewModel viewModel, {
    bool immediate = false,
  }) {
    if (immediate) {
      _debounce.cancel();
      viewModel.setSearchTextAndReload(_searchController.text.trim());
      return;
    }
    _debounce.run(() {
      viewModel.setSearchTextAndReload(_searchController.text.trim());
    });
  }

  Future<void> _loadFormOptions() async {
    setState(() {
      _suppliersLoading = true;
      _materialsLoading = true;
    });
    try {
      final data = await PurchaseOrderSupportService(
        context.read<ApiClient>(),
      ).loadFormOptions();
      if (!mounted) return;
      setState(() {
        _suppliers = data.suppliers;
        _materials = data.materials;
        _workOrders = data.workOrders;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _suppliers = [];
        _materials = [];
        _workOrders = [];
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _suppliersLoading = false;
        _materialsLoading = false;
      });
    }
  }

  void _resetFilters(PurchaseOrderViewModel viewModel) {
    _searchController.clear();
    viewModel.resetFilters();
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

  static String _orderLabel(PurchaseOrder order) {
    final number = order.orderNumber.trim();
    if (number.isNotEmpty) {
      return number;
    }
    return '采购单 #${order.id}';
  }

  static String _buildCancelSummary(PurchaseOrder order) {
    return '即将取消采购单 ${_orderLabel(order)}。取消后，该采购流程会停止推进，相关收货与质检动作将无法继续。';
  }

  static List<String> _buildCancelImpacts(PurchaseOrder order) {
    return [
      '供应商：${CrudValueFormatter.text(order.supplierName)}',
      '状态：${CrudValueFormatter.text(order.statusDisplay ?? order.status)}',
      '金额：${CrudValueFormatter.amount(order.totalAmount)}',
      if ((order.workOrderNumber ?? '').trim().isNotEmpty)
        '关联施工单：${order.workOrderNumber!.trim()}',
    ];
  }

  static String _buildCancelAuditHint(PurchaseOrder order) {
    return '若该采购单已进入下单或收货阶段，建议先确认业务影响，再执行取消。';
  }

  static String _buildCancelSuccessMessage(PurchaseOrder order) {
    return '取消成功';
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
    final resolved =
        detail ??
        PurchaseOrderDetail(
          id: order.id,
          orderNumber: order.orderNumber,
          supplierName: order.supplierName,
          status: order.status,
          statusDisplay: order.statusDisplay,
          totalAmount: order.totalAmount,
          workOrderNumber: order.workOrderNumber,
        );
    await showPurchaseOrderDetailDialog(
      context,
      detail: resolved,
      title: _detailTitle,
      closeText: _cancelText,
      onWorkOrderTap: (woId) {
        Navigator.of(context).pop(); // close dialog first
        context.go('/workorders/$woId');
      },
    );
  }

  Future<void> _openLowStockDialog(PurchaseOrderViewModel viewModel) async {
    final supportService = PurchaseOrderSupportService(
      context.read<ApiClient>(),
    );
    List<Map<String, dynamic>> materials = [];
    try {
      materials = await supportService.loadLowStockMaterials();
    } catch (err) {
      ToastUtil.showError('获取库存预警失败: $err');
    }

    if (!mounted) return;
    await showPurchaseLowStockDialog(
      context,
      materials: materials,
      title: _lowStockTitle,
      closeText: _cancelText,
      onCreateOrder: () =>
          _openFormDialog(viewModel, prefillMaterials: materials),
    );
  }

  void _navigateToWorkOrderByNumber(
    BuildContext context,
    String workOrderNumber,
  ) {
    // 从采购单列表跳转到施工单，需要先查询施工单 ID
    final api = context.read<WorkOrderApiService>();
    api
        .fetchWorkOrders(search: workOrderNumber, approvalStatus: '')
        .then((result) {
          if (!mounted) return;
          final matched = result.items.where(
            (wo) => wo.orderNumber == workOrderNumber,
          );
          if (matched.isNotEmpty) {
            context.go('/workorders/${matched.first.id}');
          } else {
            ToastUtil.showError('未找到施工单 $workOrderNumber');
          }
        })
        .catchError((err) {
          ToastUtil.showError('跳转失败: $err');
        });
  }

  Future<void> _openFormDialog(
    PurchaseOrderViewModel viewModel, {
    PurchaseOrder? order,
    List<Map<String, dynamic>>? prefillMaterials,
  }) async {
    final isEdit = order != null;
    final requiredPermission = isEdit
        ? 'workorder.change_purchaseorder'
        : 'workorder.add_purchaseorder';
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has(requiredPermission)) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
    }

    final apiService = context.read<PurchaseOrderApiService>();
    PurchaseOrderDetail? detail;
    if (isEdit) {
      detail = await _fetchDetail(order.id);
      if (detail == null) return;
    }

    int? supplierId = detail?.supplierId;
    int? workOrderId = detail?.workOrderId;
    final notesController = TextEditingController(text: detail?.notes ?? '');
    List<PurchaseItemDraft> items = [];

    if (detail != null && detail.items.isNotEmpty) {
      items = detail.items
          .map(
            (item) => PurchaseItemDraft(
              materialId: item.materialId ?? 0,
              materialName: item.materialName ?? '-',
              materialCode: item.materialCode ?? '',
              unit: item.materialUnit ?? '',
              unitPrice: item.unitPrice ?? 0,
              quantity: item.quantity ?? 0,
            ),
          )
          .toList();
    }

    if (!isEdit && (prefillMaterials?.isNotEmpty ?? false)) {
      items = prefillMaterials!.map((item) {
        final materialId = toInt(item['id']) ?? 0;
        final materialName = item['name']?.toString() ?? '-';
        final materialCode = item['code']?.toString() ?? '';
        final needed = _toDouble(item['needed_quantity']) ?? 0;
        final match = _materials.cast<MaterialDto?>().firstWhere(
          (m) => m?.id == materialId,
          orElse: () => null,
        );
        return PurchaseItemDraft(
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

    Future<void> submit(VoidCallback refresh) async {
      if (!PermissionUtil.snapshot(context).has(requiredPermission)) {
        ToastUtil.showError('当前账号无权执行该操作');
        return;
      }
      if (!(formKey.currentState?.validate() ?? false)) return;
      if (supplierId == null || supplierId == 0) {
        ToastUtil.showError('请选择供应商');
        return;
      }
      if (items.isEmpty) {
        ToastUtil.showError('请添加采购明细');
        return;
      }
      try {
        final payload = <String, dynamic>{
          'supplier': supplierId,
          'work_order': workOrderId,
          'notes': notesController.text.trim(),
          'items_data': items
              .map(
                (item) => {
                  'material': item.materialId,
                  'quantity': item.quantity,
                  'unit_price': item.unitPrice,
                },
              )
              .toList(),
        };

        if (isEdit) {
          await apiService.updatePurchaseOrder(order.id, payload);
        } else {
          await apiService.createPurchaseOrder(payload);
        }
        if (!mounted) return;
        ToastUtil.showSuccess(isEdit ? '采购单已更新' : '采购单已创建');
        await viewModel.loadPurchaseOrders(resetPage: false);
      } catch (err) {
        if (!mounted) return;
        ToastUtil.showError('提交失败: $err');
      }
    }

    Future<MaterialDto?> createMaterial() async {
      final permissions = PermissionUtil.snapshot(context);
      if (!permissions.has('workorder.add_material')) {
        ToastUtil.showError('当前账号无权新增物料');
        return null;
      }

      final created = await showQuickMaterialCreateDialog(
        context: context,
        materialApi: MaterialApiService(context.read<ApiClient>()),
      );
      if (created == null || !mounted) {
        return null;
      }

      final dto = created.toDto();
      setState(() {
        _materials = List<MaterialDto>.from(_materials)
          ..removeWhere((item) => item.id == dto.id)
          ..add(dto)
          ..sort((left, right) {
            final leftLabel = '${left.code} ${left.name}';
            final rightLabel = '${right.code} ${right.name}';
            return leftLabel.compareTo(rightLabel);
          });
      });
      ToastUtil.showSuccess('物料已新增');
      return dto;
    }

    Future<SupplierDto?> createSupplier() async {
      final permissions = PermissionUtil.snapshot(context);
      if (!permissions.has('workorder.add_supplier')) {
        ToastUtil.showError('当前账号无权新增供应商');
        return null;
      }

      final created = await showQuickSupplierCreateDialog(
        context: context,
        supplierApi: SupplierApiService(context.read<ApiClient>()),
      );
      if (created == null || !mounted) {
        return null;
      }

      final dto = SupplierDto.fromEntity(created);
      setState(() {
        _suppliers = List<SupplierDto>.from(_suppliers)
          ..removeWhere((item) => item.id == dto.id)
          ..add(dto)
          ..sort((left, right) => left.name.compareTo(right.name));
      });
      ToastUtil.showSuccess('供应商已新增');
      return dto;
    }

    await showPurchaseOrderFormDialog(
      context,
      isEdit: isEdit,
      title: isEdit ? _editTitle : _createTitle,
      cancelText: _cancelText,
      submitText: _submitText,
      materialsLoading: _materialsLoading,
      formKey: formKey,
      suppliers: _suppliers,
      workOrders: _workOrders,
      selectedSupplierId: supplierId,
      selectedWorkOrderId: workOrderId,
      fallbackWorkOrderNumber: detail?.workOrderNumber,
      notesController: notesController,
      materials: _materials,
      items: items,
      onCreateSupplier: createSupplier,
      onCreateMaterial: createMaterial,
      onSupplierChanged: (value) => supplierId = value,
      onWorkOrderChanged: (value) => workOrderId = value == 0 ? null : value,
      onSubmit: submit,
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
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.change_purchasereceiverecord')) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
    }
    final apiService = context.read<PurchaseOrderApiService>();
    final detail = await _fetchDetail(order.id);
    if (detail == null) return;
    try {
      final confirmed = await showPurchaseReceiveDialog(
        context,
        detail: detail,
        title: _receiveTitle,
        cancelText: _cancelText,
        onSubmit: (submission) {
          return apiService.receive(order.id, {
            'items': submission.items
                .map(
                  (item) => {
                    'item_id': item.itemId,
                    'received_quantity': item.receivedQuantity,
                    'delivery_note_number': submission.deliveryNoteNumber,
                    'notes': item.notes,
                  },
                )
                .toList(),
            'received_date': _formatDate(submission.receivedDate),
          });
        },
      );
      if (!mounted || confirmed != true) return;
      ToastUtil.showSuccess('收货成功，请进行质检');
      await viewModel.loadPurchaseOrders(resetPage: false);
      await _openInspectionDialog(order);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('收货失败: $err');
    }
  }

  Future<void> _openInspectionDialog(PurchaseOrder order) async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.change_purchasereceiverecord')) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
    }
    final supportService = PurchaseOrderSupportService(
      context.read<ApiClient>(),
    );
    if (!mounted) return;
    await showPurchaseInspectionDialog(
      context,
      title: _inspectionTitle,
      cancelText: _cancelText,
      loadRecords: () => supportService.loadInspectionRecords(order.id),
      confirmInspection: supportService.confirmInspection,
      stockIn: supportService.stockIn,
    );
  }

  Future<void> _handleStatusAction(
    PurchaseOrderViewModel viewModel,
    PurchaseOrder order,
    String action,
  ) async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.change_purchaseorder')) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
    }
    final apiService = context.read<PurchaseOrderApiService>();
    try {
      if (action == 'submit') {
        await apiService.submit(order.id);
        ToastUtil.showSuccess('提交成功');
      } else if (action == 'approve') {
        await apiService.approve(order.id);
        ToastUtil.showSuccess('批准成功');
      } else if (action == 'reject') {
        final reason = await showPurchaseReasonDialog(
          context,
          title: '拒绝原因',
          cancelText: _cancelText,
        );
        if (reason == null) return;
        await apiService.reject(order.id, {'rejection_reason': reason});
        ToastUtil.showSuccess('已拒绝，采购单已退回草稿');
      } else if (action == 'place') {
        final date = await showPurchaseDateDialog(context, title: '下单日期');
        final payload = <String, dynamic>{};
        if (date != null) {
          payload['ordered_date'] = _formatDate(date);
        }
        await apiService.placeOrder(order.id, payload);
        ToastUtil.showSuccess('下单成功');
      } else if (action == 'cancel') {
        await confirmCrudAction(
          context,
          item: order,
          onConfirm: (item) => apiService.cancel(item.id),
          config: _cancelOrderConfig,
        );
      } else {
        return;
      }
      await viewModel.loadPurchaseOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('操作失败: $err');
    }
  }

  static String _pageInfoText(PurchaseOrderViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Consumer<PurchaseOrderViewModel>(
      builder: (context, viewModel, _) {
        final orders = viewModel.purchaseOrders;
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

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, orders);
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

  Widget _buildDesktopTable(
    BuildContext context,
    PurchaseOrderViewModel viewModel,
    List<PurchaseOrder> orders,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    final permissions = PermissionUtil.snapshot(context);
    final canChangePurchaseOrder = permissions.has(
      'workorder.change_purchaseorder',
    );
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('采购单号')),
        DataColumn(label: Text('供应商')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('金额')),
        DataColumn(label: Text('明细数')),
        DataColumn(label: Text('收货进度')),
        DataColumn(label: Text('关联施工单')),
        DataColumn(label: Text('下单日期')),
        DataColumn(label: Text('预计到货')),
        DataColumn(label: Text('实际到货')),
        DataColumn(label: Text('操作')),
      ],
      rows: orders
          .map(
            (order) => DataRow(
              cells: [
                DataCell(
                  InkWell(
                    onTap: () => _openDetailDialog(order),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        order.orderNumber.isEmpty
                            ? '采购单 #${order.id}'
                            : order.orderNumber,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(_displayText(order.supplierName), style: textStyle),
                ),
                DataCell(
                  Text(
                    _displayText(order.statusDisplay ?? order.status),
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(_formatAmount(order.totalAmount), style: textStyle),
                ),
                DataCell(
                  Text(
                    order.itemsCount?.toString() ?? _emptyCellText,
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(
                    order.receivedProgress == null
                        ? _emptyCellText
                        : '${order.receivedProgress!.toStringAsFixed(0)}%',
                    style: textStyle,
                  ),
                ),
                DataCell(
                  InkWell(
                    onTap: order.workOrderNumber?.isNotEmpty == true
                        ? () => _navigateToWorkOrderByNumber(
                            context,
                            order.workOrderNumber!,
                          )
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            _displayText(order.workOrderNumber),
                            style: textStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (order.workOrderNumber?.isNotEmpty == true)
                          Icon(
                            Icons.arrow_outward,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                ),
                DataCell(
                  Text(_formatDate(order.orderedDate), style: textStyle),
                ),
                DataCell(
                  Text(_formatDate(order.expectedDate), style: textStyle),
                ),
                DataCell(
                  Text(_formatDate(order.actualReceivedDate), style: textStyle),
                ),
                DataCell(
                  RowActionGroup(
                    actions: [
                      if ((order.status ?? '') == 'draft' &&
                          canChangePurchaseOrder)
                        RowAction(
                          label: '编辑',
                          onPressed: () =>
                              _openFormDialog(viewModel, order: order),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    PurchaseOrderViewModel viewModel,
    bool isMobile,
  ) {
    final permissions = PermissionUtil.snapshot(context);
    final canCreatePurchaseOrder = permissions.has(
      'workorder.add_purchaseorder',
    );
    return PageHeaderBar(
      breadcrumb: null,
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

          final statusValue = viewModel.statusFilter.isEmpty
              ? ''
              : viewModel.statusFilter;
          final statusField = SizedBox(
            width: isMobile ? constraints.maxWidth : 150,
            child: AppSelect<String>(
              key: ValueKey<String>(statusValue),
              value: statusValue,
              decoration: const InputDecoration(
                labelText: _statusFilterLabel,
                isDense: true,
                border: OutlineInputBorder(),
              ),
              options: const [
                AppDropdownOption(value: '', label: '全部状态'),
                AppDropdownOption(value: 'draft', label: '草稿'),
                AppDropdownOption(value: 'submitted', label: '已提交'),
                AppDropdownOption(value: 'approved', label: '已批准'),
                AppDropdownOption(value: 'ordered', label: '已下单'),
                AppDropdownOption(value: 'received', label: '已收货'),
                AppDropdownOption(value: 'cancelled', label: '已取消'),
              ],
              onChanged: (value) => viewModel.setStatusFilter(value ?? ''),
            ),
          );

          final supplierValue = viewModel.supplierId;
          final supplierField = SizedBox(
            width: isMobile ? constraints.maxWidth : 180,
            child: AppSelect<int>(
              key: ValueKey<int>(supplierValue),
              value: supplierValue,
              decoration: const InputDecoration(
                labelText: _supplierFilterLabel,
                isDense: true,
                border: OutlineInputBorder(),
              ),
              options: [
                const AppDropdownOption<int>(value: 0, label: '全部供应商'),
                ..._suppliers.map(
                  (supplier) => AppDropdownOption<int>(
                    value: supplier.id,
                    label: supplier.name,
                  ),
                ),
              ],
              onChanged: _suppliersLoading
                  ? null
                  : (value) => viewModel.setSupplierId(value ?? 0),
            ),
          );

          final orderingField = SizedBox(
            width: isMobile ? constraints.maxWidth : 160,
            child: AppSelect<String>(
              key: ValueKey<String>(viewModel.ordering),
              value: viewModel.ordering,
              decoration: const InputDecoration(
                labelText: _orderingLabel,
                isDense: true,
                border: OutlineInputBorder(),
              ),
              options: const [
                AppDropdownOption(value: '-created_at', label: '最新创建'),
                AppDropdownOption(value: 'created_at', label: '最早创建'),
                AppDropdownOption(value: 'order_number', label: '单号升序'),
                AppDropdownOption(value: '-order_number', label: '单号降序'),
                AppDropdownOption(value: 'supplier__name', label: '供应商升序'),
                AppDropdownOption(value: '-supplier__name', label: '供应商降序'),
                AppDropdownOption(value: 'total_amount', label: '金额升序'),
                AppDropdownOption(value: '-total_amount', label: '金额降序'),
                AppDropdownOption(value: 'expected_date', label: '预计到货升序'),
                AppDropdownOption(value: '-expected_date', label: '预计到货降序'),
              ],
              onChanged: (value) {
                if (value != null) viewModel.setOrdering(value);
              },
            ),
          );

          final actions = <Widget>[
            statusField,
            supplierField,
            orderingField,
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
            if (canCreatePurchaseOrder)
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

  Widget _mobileRow(
    BuildContext context,
    TextStyle? labelStyle,
    String label,
    String value, {
    bool last = false,
  }) {
    final theme = Theme.of(context);
    final spacing = LayoutTokens.sectionSpacing(context) * 0.6;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : spacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 72, child: Text(label, style: labelStyle)),
          Expanded(
            child: Text(
              value.isEmpty ? _emptyCellText : value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFields(
    BuildContext context,
    TextStyle? labelStyle, {
    required String number,
    required String supplier,
    required String status,
    required String totalAmount,
    required String itemsCount,
    required String receivedProgress,
    required String workOrder,
    required String orderedDate,
    required String expectedDate,
    required String actualReceivedDate,
    required String submittedBy,
    required String approvedBy,
    required String createdAt,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mobileRow(context, labelStyle, '采购单号', number),
        _mobileRow(context, labelStyle, '供应商', supplier),
        _mobileRow(context, labelStyle, '状态', status),
        _mobileRow(context, labelStyle, '金额', totalAmount),
        _mobileRow(context, labelStyle, '明细数', itemsCount),
        _mobileRow(context, labelStyle, '收货进度', receivedProgress),
        _mobileRow(context, labelStyle, '关联施工单', workOrder),
        _mobileRow(context, labelStyle, '下单日期', orderedDate),
        _mobileRow(context, labelStyle, '预计到货', expectedDate),
        _mobileRow(context, labelStyle, '实际到货', actualReceivedDate),
        _mobileRow(context, labelStyle, '提交人', submittedBy),
        _mobileRow(context, labelStyle, '审核人', approvedBy),
        _mobileRow(context, labelStyle, '创建时间', createdAt, last: true),
      ],
    );
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
    final number = order.orderNumber.isEmpty
        ? '采购单 #${order.id}'
        : order.orderNumber;
    final supplier = _displayText(order.supplierName);
    final status = order.statusDisplay ?? order.status ?? _emptyCellText;
    final totalAmount = _formatAmount(order.totalAmount);
    final itemsCount = order.itemsCount?.toString() ?? _emptyCellText;
    final receivedProgress = order.receivedProgress == null
        ? _emptyCellText
        : '${order.receivedProgress!.toStringAsFixed(0)}%';
    final workOrder = _displayText(order.workOrderNumber);
    final orderedDate = _formatDate(order.orderedDate);
    final expectedDate = _formatDate(order.expectedDate);
    final actualReceivedDate = _formatDate(order.actualReceivedDate);
    final submittedBy = _displayText(order.submittedByName);
    final approvedBy = _displayText(order.approvedByName);
    final createdAt = _formatDateTime(order.createdAt);
    final statusCode = order.status ?? '';
    final permissions = PermissionUtil.snapshot(context);
    final canChangePurchaseOrder = permissions.has(
      'workorder.change_purchaseorder',
    );
    final canChangeReceiveRecord = permissions.has(
      'workorder.change_purchasereceiverecord',
    );
    final canEdit = statusCode == 'draft' && canChangePurchaseOrder;
    final canSubmit = statusCode == 'draft' && canChangePurchaseOrder;
    final canApprove = statusCode == 'submitted' && canChangePurchaseOrder;
    final canReject = statusCode == 'submitted' && canChangePurchaseOrder;
    final canPlaceOrder = statusCode == 'approved' && canChangePurchaseOrder;
    final canReceive = statusCode == 'ordered' && canChangeReceiveRecord;
    final canInspect = statusCode == 'ordered' && canChangeReceiveRecord;
    final canCancel =
        canChangePurchaseOrder &&
        (statusCode == 'draft' ||
            statusCode == 'submitted' ||
            statusCode == 'approved');

    return ExpandableSummaryCard(
      headerBuilder: (context, expanded) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _openDetailDialog(order),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        number,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
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
              duration: AnimationTokens.expandDuration,
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
          _buildMobileFields(
            context,
            theme.textTheme.labelSmall?.copyWith(
              color: colors?.subtleText ?? theme.hintColor,
            ),
            number: number,
            supplier: supplier,
            status: status,
            totalAmount: totalAmount,
            itemsCount: itemsCount,
            receivedProgress: receivedProgress,
            workOrder: workOrder,
            orderedDate: orderedDate,
            expectedDate: expectedDate,
            actualReceivedDate: actualReceivedDate,
            submittedBy: submittedBy,
            approvedBy: approvedBy,
            createdAt: createdAt,
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
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

typedef _SummaryChip = SummaryChip;

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
