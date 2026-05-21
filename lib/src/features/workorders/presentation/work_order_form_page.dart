import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/presentation/widgets/quick_customer_create_dialog.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/materials/presentation/widgets/quick_material_create_dialog.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/presentation/widgets/quick_product_create_dialog.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_form_options_loader.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_form_submission.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_sales_order_candidate.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_form_state.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_sections.dart';

enum WorkOrderFormMode { create, edit }

class WorkOrderFormEntry extends StatelessWidget {
  const WorkOrderFormEntry({
    super.key,
    required this.mode,
    this.workOrderId,
    this.initialSalesOrderId,
  });

  final WorkOrderFormMode mode;
  final int? workOrderId;
  final int? initialSalesOrderId;

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<WorkOrderApiService, WorkOrderRepository,
        WorkOrderViewModel>(
      createService: (context) =>
          WorkOrderApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          WorkOrderRepositoryImpl(context.read<WorkOrderApiService>()),
      createViewModel: (context) =>
          WorkOrderViewModel(context.read<WorkOrderRepository>()),
      child: WorkOrderFormPage(
        mode: mode,
        workOrderId: workOrderId,
        initialSalesOrderId: initialSalesOrderId,
      ),
    );
  }
}

class WorkOrderFormPage extends StatefulWidget {
  const WorkOrderFormPage({
    super.key,
    required this.mode,
    this.workOrderId,
    this.initialSalesOrderId,
  });

  final WorkOrderFormMode mode;
  final int? workOrderId;
  final int? initialSalesOrderId;

  @override
  State<WorkOrderFormPage> createState() => _WorkOrderFormPageState();
}

class _WorkOrderFormPageState extends State<WorkOrderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _draft = WorkOrderFormDraftState();
  static const double _spacing = 12;
  bool _routePrefillApplied = false;

  List<Customer> _customers = [];
  List<WorkOrderSalesOrderCandidate> _salesOrders = [];
  List<ProductOption> _products = [];
  List<Product> _fullProducts = [];
  List<MaterialItem> _materials = [];
  List<Process> _processes = [];
  List<Artwork> _artworks = [];
  List<Die> _dies = [];
  List<FoilingPlate> _foilingPlates = [];
  List<EmbossingPlate> _embossingPlates = [];

  bool _loadingOptions = false;
  bool _loadingDetail = false;
  bool _submitting = false;
  String? _approvalStatus;

  @override
  void initState() {
    super.initState();
    _loadOptions();
    if (widget.mode == WorkOrderFormMode.edit && widget.workOrderId != null) {
      _loadDetail(widget.workOrderId!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applyRoutePrefillIfNeeded();
  }

  @override
  void didUpdateWidget(covariant WorkOrderFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSalesOrderId != widget.initialSalesOrderId) {
      _routePrefillApplied = false;
      _applyRoutePrefillIfNeeded();
    }
  }

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    setState(() => _loadingOptions = true);
    try {
      final options = await WorkOrderFormOptionsLoader(
        context.read<ApiClient>(),
        excludeWorkOrderId: widget.workOrderId,
      ).load();

      setState(() {
        _salesOrders = options.salesOrders;
        _customers = options.customers;
        _products = options.products;
        _fullProducts = options.fullProducts;
        _materials = options.materials;
        _processes = options.processes;
        _artworks = options.artworks;
        _dies = options.dies;
        _foilingPlates = options.foilingPlates;
        _embossingPlates = options.embossingPlates;
      });
      _applyRoutePrefillIfNeeded();
    } catch (err) {
      ToastUtil.showError('加载基础数据失败: $err');
    } finally {
      if (mounted) setState(() => _loadingOptions = false);
    }
  }

  void _applyRoutePrefillIfNeeded() {
    if (_routePrefillApplied ||
        widget.mode != WorkOrderFormMode.create ||
        _salesOrders.isEmpty) {
      return;
    }
    final salesOrderId = widget.initialSalesOrderId;
    if (salesOrderId == null || salesOrderId <= 0) {
      _routePrefillApplied = true;
      return;
    }
    final exists = _salesOrders.any((item) => item.id == salesOrderId);
    _routePrefillApplied = true;
    if (!exists) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ToastUtil.showError('该客户订单已无可生成施工单的产品，请检查是否已全部开单。');
      });
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handleSalesOrderChanged(salesOrderId);
    });
  }

  Future<void> _loadDetail(int id) async {
    setState(() => _loadingDetail = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      final detail = await viewModel.fetchDetail(id);
      _draft.applyDetail(detail);
      _approvalStatus = detail.approvalStatus;
      if (mounted) {
        setState(() {});
      }
    } catch (err) {
      ToastUtil.showError('加载施工单失败: $err');
    } finally {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  Future<void> _handleCreateCustomer() async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.add_customer')) {
      ToastUtil.showError('当前账号无权新增客户');
      return;
    }

    final created = await showQuickCustomerCreateDialog(
      context: context,
      customerApi: CustomerApiService(context.read<ApiClient>()),
    );
    if (created == null || !mounted) {
      return;
    }

    setState(() {
      _customers = List<Customer>.from(_customers)
        ..removeWhere((item) => item.id == created.id)
        ..add(created)
        ..sort((left, right) => left.name.compareTo(right.name));
      _draft.customerId = created.id;
    });
    ToastUtil.showSuccess('客户已新增');
  }

  Future<ProductOption?> _handleCreateProduct() async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.add_product')) {
      ToastUtil.showError('当前账号无权新增产品');
      return null;
    }

    final created = await showQuickProductCreateDialog(
      context: context,
      productApi: ProductApiService(context.read<ApiClient>()),
    );
    if (created == null || !mounted) {
      return null;
    }

    final option = ProductOption(
      id: created.id,
      name: created.name,
      code: created.code,
    );
    setState(() {
      _products = List<ProductOption>.from(_products)
        ..removeWhere((item) => item.id == option.id)
        ..add(option)
        ..sort(
            (left, right) => left.displayLabel.compareTo(right.displayLabel));
      _fullProducts = List<Product>.from(_fullProducts)
        ..removeWhere((item) => item.id == created.id)
        ..add(created);
    });
    ToastUtil.showSuccess('产品已新增');
    return option;
  }

  Future<MaterialItem?> _handleCreateMaterial() async {
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

    setState(() {
      _materials = List<MaterialItem>.from(_materials)
        ..removeWhere((item) => item.id == created.id)
        ..add(created)
        ..sort((left, right) {
          final leftLabel = '${left.name} (${left.code})';
          final rightLabel = '${right.name} (${right.code})';
          return leftLabel.compareTo(rightLabel);
        });
    });
    ToastUtil.showSuccess('物料已新增');
    return created;
  }

  Future<void> _pickDate({required bool isOrderDate}) async {
    final initial = isOrderDate
        ? (_draft.orderDate ?? DateTime.now())
        : (_draft.deliveryDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isOrderDate) {
        _draft.setOrderDate(picked);
      } else {
        _draft.setDeliveryDate(picked);
      }
    });
  }

  Future<void> _pickActualDeliveryDate() async {
    final initial = _draft.actualDeliveryDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      _draft.setActualDeliveryDate(picked);
    });
  }

  Future<void> _handleSalesOrderChanged(int? value) async {
    final previousSalesOrderId = _draft.salesOrderId;
    final salesOrderId = value != null && value > 0 ? value : null;
    final selected = salesOrderId == null
        ? null
        : _salesOrders.cast<WorkOrderSalesOrderCandidate?>().firstWhere(
              (item) => item?.id == salesOrderId,
              orElse: () => null,
            );

    setState(() {
      _draft.salesOrderId = salesOrderId;
      if (selected?.customerId != null) {
        _draft.customerId = selected!.customerId;
      }
      if (selected?.orderDate != null) {
        _draft.setOrderDate(selected!.orderDate);
      }
      if (selected?.deliveryDate != null) {
        _draft.setDeliveryDate(selected!.deliveryDate);
      }
      for (final draft in _draft.productDrafts) {
        if (draft.sourceType != 'sales_order') {
          continue;
        }
        final followsHeaderOrder = draft.sourceSalesOrderId == null ||
            draft.sourceSalesOrderId == previousSalesOrderId;
        if (followsHeaderOrder) {
          draft.sourceSalesOrderId = salesOrderId;
          draft.salesOrderItemId = null;
          if (salesOrderId != null) {
            draft.productId = null;
          }
        }
      }
    });
  }

  void _handleCustomerChanged(int? value) {
    setState(() {
      _draft.customerId = value;
      final selectedSalesOrder = _selectedSalesOrder;
      if (_draft.salesOrderId != null &&
          selectedSalesOrder?.customerId != value) {
        _draft.salesOrderId = null;
      }
    });
  }

  WorkOrderSalesOrderCandidate? get _selectedSalesOrder {
    final salesOrderId = _draft.salesOrderId;
    if (salesOrderId == null) {
      return null;
    }
    return _salesOrders.cast<WorkOrderSalesOrderCandidate?>().firstWhere(
          (item) => item?.id == salesOrderId,
          orElse: () => null,
        );
  }

  void _handleAddProduct() {
    setState(() {
      _draft.addProductDraft();
      final lastDraft =
          _draft.productDrafts.isNotEmpty ? _draft.productDrafts.last : null;
      if (lastDraft != null && _draft.salesOrderId != null) {
        lastDraft.sourceType = 'sales_order';
        lastDraft.sourceSalesOrderId = _draft.salesOrderId;
      }
    });
  }

  Future<void> _handleSubmit() async {
    final requiredPermission = widget.mode == WorkOrderFormMode.create
        ? 'workorder.add_workorder'
        : 'workorder.change_workorder';
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has(requiredPermission)) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
    }
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    final submissionInput = _draft.submissionInput();
    final validationMessage = WorkOrderFormSubmission.validate(submissionInput);
    if (validationMessage != null) {
      ToastUtil.showError(validationMessage);
      return;
    }

    setState(() => _submitting = true);
    final payload = WorkOrderFormSubmission.buildPayload(submissionInput);
    int? workOrderId;
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      if (widget.mode == WorkOrderFormMode.create) {
        final result = await viewModel.createWorkOrder(payload);
        workOrderId = result.id;
      } else if (widget.workOrderId != null) {
        await viewModel.updateWorkOrder(widget.workOrderId!, payload);
        workOrderId = widget.workOrderId;
      }
      if (!mounted) return;
      // 只对草稿/退回状态（新创建或编辑时）引导提交审核
      final canSubmitApproval = widget.mode == WorkOrderFormMode.create ||
          _approvalStatus == 'draft' ||
          _approvalStatus == 'rejected';
      if (!canSubmitApproval) {
        ToastUtil.showSuccess('保存成功');
        if (!mounted) return;
        Navigator.of(context).pop(true);
        return;
      }
      final shouldSubmit = await _showSubmitApprovalDialog();
      if (shouldSubmit == true && workOrderId != null) {
        await viewModel.submitApproval(workOrderId);
        if (!mounted) return;
        ToastUtil.showSuccess('已保存并提交审核');
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (err) {
      ToastUtil.showError('保存失败: $err');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<bool?> _showSubmitApprovalDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        title: '保存成功',
        maxWidth: LayoutTokens.dialogWidthSm,
        scrollable: false,
        content: const Text('是否立即提交审核？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('稍后处理'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('立即提交'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final permissions = PermissionUtil.snapshot(context);
    final canSubmit = permissions.has(
      widget.mode == WorkOrderFormMode.create
          ? 'workorder.add_workorder'
          : 'workorder.change_workorder',
    );
    return ListPageScaffold(
      spacing: _spacing,
      header: PageHeaderBar(
        breadcrumb: null,
        useSurface: false,
        showDivider: false,
        padding: EdgeInsets.zero,
        actions: Wrap(
          spacing: _spacing,
          runSpacing: 8,
          children: [
            PageActionButton.outlined(
              onPressed: _submitting ? null : () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: '返回',
            ),
            PageActionButton.filled(
              onPressed: _submitting || !canSubmit ? null : _handleSubmit,
              icon: const Icon(Icons.save, size: 16),
              label: _submitting ? '保存中' : '保存',
            ),
          ],
        ),
      ),
      body: _loadingOptions || _loadingDetail
          ? const _FormCard(
              child: SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          : Form(
              key: _formKey,
              child: WorkOrderFormContent(
                mode: widget.mode,
                salesOrderId: _draft.salesOrderId,
                salesOrders: _salesOrders,
                customerId: _draft.customerId,
                customers: _customers,
                status: _draft.status,
                priority: _draft.priority,
                orderDateController: _draft.orderDateController,
                deliveryDateController: _draft.deliveryDateController,
                productionQuantityController:
                    _draft.productionQuantityController,
                defectiveQuantityController: _draft.defectiveQuantityController,
                actualDeliveryDateController:
                    _draft.actualDeliveryDateController,
                notesController: _draft.notesController,
                productDrafts: _draft.productDrafts,
                products: _products,
                processes: _processes,
                processIds: _draft.processIds,
                materialDrafts: _draft.materialDrafts,
                materials: _materials,
                printingType: _draft.printingType,
                printingCmyk: _draft.printingCmyk,
                printingOtherColorsController:
                    _draft.printingOtherColorsController,
                artworks: _artworks,
                artworkIds: _draft.artworkIds,
                dies: _dies,
                dieIds: _draft.dieIds,
                foilingPlates: _foilingPlates,
                foilingPlateIds: _draft.foilingPlateIds,
                embossingPlates: _embossingPlates,
                embossingPlateIds: _draft.embossingPlateIds,
                onSalesOrderChanged: _handleSalesOrderChanged,
                onCustomerChanged: _handleCustomerChanged,
                onCreateCustomer: _handleCreateCustomer,
                onStatusChanged: (value) =>
                    setState(() => _draft.status = value ?? 'pending'),
                onPriorityChanged: (value) =>
                    setState(() => _draft.priority = value ?? 'normal'),
                onPickOrderDate: () => _pickDate(isOrderDate: true),
                onPickDeliveryDate: () => _pickDate(isOrderDate: false),
                onPickActualDeliveryDate: _pickActualDeliveryDate,
                onAddProduct: _handleAddProduct,
                onRemoveProduct: (index) =>
                    setState(() => _draft.removeProductDraftAt(index)),
                onProcessSelectionChanged: (processId) {
                  setState(() {
                    if (_draft.processIds.contains(processId)) {
                      _draft.processIds.remove(processId);
                    } else {
                      _draft.processIds.add(processId);
                    }
                  });
                },
                onAddMaterial: () => setState(_draft.addMaterialDraft),
                onRemoveMaterial: (index) =>
                    setState(() => _draft.removeMaterialDraftAt(index)),
                onPrintingTypeChanged: (value) =>
                    setState(() => _draft.printingType = value ?? 'none'),
                onToggleCmyk: (color) {
                  setState(() {
                    if (_draft.printingCmyk.contains(color)) {
                      _draft.printingCmyk.remove(color);
                    } else {
                      _draft.printingCmyk.add(color);
                    }
                  });
                },
                onResourceSelectionChanged: () {
                  setState(() {
                    _draft.autoFillFromArtworks(
                      _artworks
                          .where((a) => _draft.artworkIds.contains(a.id))
                          .toList(),
                      _fullProducts,
                    );
                  });
                },
                onProductSelectionChanged: () {
                  setState(() {
                    _draft.autoFillFromProducts(_fullProducts);
                  });
                },
                onCreateProduct: _handleCreateProduct,
                onCreateMaterial: _handleCreateMaterial,
              ),
            ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DetailSurfaceCard(child: child);
  }
}
