import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_date_picker.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
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
      await _ensureCustomerLoaded();
      if (mounted) {
        setState(() {});
      }
    } catch (err) {
      ToastUtil.showError('加载施工单失败: $err');
    } finally {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  Future<void> _ensureCustomerLoaded() async {
    final customerId = _draft.customerId;
    if (customerId == null) return;
    final exists = _customers.any((c) => c.id == customerId);
    if (exists) return;
    final dto = await CustomerApiService(context.read<ApiClient>())
        .fetchCustomerById(customerId);
    if (dto == null || !mounted) return;
    setState(() {
      _customers = [..._customers, dto.toEntity()];
    });
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

  Future<List<AppDropdownOption<int>>> _handleSearchCustomer(String query) async {
    final page = await CustomerApiService(context.read<ApiClient>())
        .fetchCustomers(search: query, pageSize: 50);
    return page.items
        .map((dto) => AppDropdownOption<int>(value: dto.id, label: dto.name))
        .toList();
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
    final picked = await showAppDatePicker(
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
    final picked = await showAppDatePicker(
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
      // Re-sync processes/materials and cleanup when sales order changes products
      if (previousSalesOrderId != salesOrderId) {
        _draft.autoFillFromProducts(_fullProducts);
        _draft.autoFillFromArtworks(
          _artworks
              .where((a) => _draft.artworkIds.contains(a.id))
              .toList(),
          _fullProducts,
        );
        _draft.recalcProductQuantities();
        _cleanupPrepressSelections();
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

  /// Compute which prepress resources are required based on selected processes.
  Set<String> get _requiredResources {
    final required = <String>{};
    for (final processId in _draft.processIds) {
      final process = _processes.cast<Process?>().firstWhere(
            (p) => p?.id == processId,
            orElse: () => null,
          );
      if (process != null) {
        if (process.requiresDie) required.add('die');
        if (process.requiresFoilingPlate) required.add('foiling');
        if (process.requiresEmbossingPlate) required.add('embossing');
      }
    }
    return required;
  }

  /// Get selected product IDs from product drafts.
  Set<int> get _selectedProductIds {
    return _draft.productDrafts
        .map((d) => d.productId)
        .whereType<int>()
        .toSet();
  }

  /// Filter artworks by selected products.
  /// If no products selected, return all artworks.
  List<Artwork> get _filteredArtworks {
    final productIds = _selectedProductIds;
    if (productIds.isEmpty) return _artworks;
    return _artworks.where((artwork) {
      if (artwork.products.isEmpty) return true; // Show artworks without product linkage
      return artwork.products.any((ap) => productIds.contains(ap.productId));
    }).toList();
  }

  /// Filter dies by selected products.
  List<Die> get _filteredDies {
    final productIds = _selectedProductIds;
    if (productIds.isEmpty) return _dies;
    return _dies.where((die) {
      if (die.products.isEmpty) return true;
      return die.products.any((dp) => productIds.contains(dp.productId));
    }).toList();
  }

  /// Filter foiling plates by selected products.
  List<FoilingPlate> get _filteredFoilingPlates {
    final productIds = _selectedProductIds;
    if (productIds.isEmpty) return _foilingPlates;
    return _foilingPlates.where((plate) {
      if (plate.products.isEmpty) return true;
      return plate.products.any((pp) => productIds.contains(pp.productId));
    }).toList();
  }

  /// Filter embossing plates by selected products.
  List<EmbossingPlate> get _filteredEmbossingPlates {
    final productIds = _selectedProductIds;
    if (productIds.isEmpty) return _embossingPlates;
    return _embossingPlates.where((plate) {
      if (plate.products.isEmpty) return true;
      return plate.products.any((ep) => productIds.contains(ep.productId));
    }).toList();
  }

  /// Filter sales orders by selected customer.
  /// If no customer selected, return all sales orders.
  List<WorkOrderSalesOrderCandidate> get _filteredSalesOrders {
    final customerId = _draft.customerId;
    if (customerId == null) return _salesOrders;
    return _salesOrders
        .where((so) => so.customerId == customerId)
        .toList();
  }

  /// Clean up prepress selections (artwork, die, foiling plate, embossing plate)
  /// that no longer match any selected product.
  void _cleanupPrepressSelections() {
    final productIds = _selectedProductIds;
    if (productIds.isEmpty) return;

    // Clean up artwork IDs - only keep artworks that match selected products
    _draft.artworkIds.removeWhere((artworkId) {
      final artwork = _artworks.cast<Artwork?>().firstWhere(
            (a) => a?.id == artworkId,
            orElse: () => null,
          );
      if (artwork == null) return true;
      if (artwork.products.isEmpty) return false;
      return !artwork.products
          .any((ap) => productIds.contains(ap.productId));
    });

    // Clean up die IDs
    _draft.dieIds.removeWhere((dieId) {
      final die = _dies.cast<Die?>().firstWhere(
            (d) => d?.id == dieId,
            orElse: () => null,
          );
      if (die == null) return true;
      if (die.products.isEmpty) return false;
      return !die.products.any((dp) => productIds.contains(dp.productId));
    });

    // Clean up foiling plate IDs
    _draft.foilingPlateIds.removeWhere((plateId) {
      final plate = _foilingPlates.cast<FoilingPlate?>().firstWhere(
            (p) => p?.id == plateId,
            orElse: () => null,
          );
      if (plate == null) return true;
      if (plate.products.isEmpty) return false;
      return !plate.products.any((pp) => productIds.contains(pp.productId));
    });

    // Clean up embossing plate IDs
    _draft.embossingPlateIds.removeWhere((plateId) {
      final plate = _embossingPlates.cast<EmbossingPlate?>().firstWhere(
            (p) => p?.id == plateId,
            orElse: () => null,
          );
      if (plate == null) return true;
      if (plate.products.isEmpty) return false;
      return !plate.products.any((ep) => productIds.contains(ep.productId));
    });
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

  Future<void> _handleSubmit([bool autoApprove = false]) async {
    final requiredPermission = widget.mode == WorkOrderFormMode.create
        ? 'workorder.add_workorder'
        : 'workorder.change_workorder';
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has(requiredPermission)) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
    }

    // Check if selected processes differ from product defaults
    final selectedProductIds = _selectedProductIds;
    final defaultProcessIds = <int>{};
    for (final pid in selectedProductIds) {
      final product = _fullProducts.cast<Product?>().firstWhere(
            (p) => p?.id == pid,
            orElse: () => null,
          );
      if (product != null) {
        defaultProcessIds.addAll(product.defaultProcessIds);
      }
    }
    final selectedProcessIds = _draft.processIds;
    final diff = selectedProcessIds.difference(defaultProcessIds);
    final missing = defaultProcessIds.difference(selectedProcessIds);
    if (diff.isNotEmpty || missing.isNotEmpty) {
      final confirmed = await _showProcessDiffDialog(diff, missing);
      if (confirmed != true) return;
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
    final payload = WorkOrderFormSubmission.buildPayload(
      submissionInput,
      isCreate: widget.mode == WorkOrderFormMode.create,
    );
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
      
      if (autoApprove && workOrderId != null) {
        await viewModel.submitApproval(workOrderId, payload: {'auto_approve': true});
        if (!mounted) return;
        ToastUtil.showSuccess('已发布成功');
      } else {
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
        } else {
          ToastUtil.showSuccess('保存成功');
        }
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

  /// Show dialog when selected processes differ from product defaults.
  Future<bool?> _showProcessDiffDialog(Set<int> extra, Set<int> missing) async {
    // Get process names for display
    final extraNames = extra.map((id) {
      final process = _processes.cast<Process?>().firstWhere(
            (p) => p?.id == id,
            orElse: () => null,
          );
      return process?.name ?? 'ID:$id';
    }).join(', ');
    final missingNames = missing.map((id) {
      final process = _processes.cast<Process?>().firstWhere(
            (p) => p?.id == id,
            orElse: () => null,
          );
      return process?.name ?? 'ID:$id';
    }).join(', ');

    final messages = <String>[];
    if (extra.isNotEmpty) {
      messages.add('已选但不在产品默认工序中：$extraNames');
    }
    if (missing.isNotEmpty) {
      messages.add('产品默认工序但未选择：$missingNames');
    }

    return showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        title: '工序确认',
        maxWidth: LayoutTokens.dialogWidthMd,
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('当前选择的工序与产品默认工序不一致：'),
            const SizedBox(height: 8),
            ...messages.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(m, style: const TextStyle(fontSize: 13)),
                )),
            const SizedBox(height: 8),
            const Text('是否确认继续？'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确认'),
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
            PageActionButton.outlined(
              onPressed: _submitting || !canSubmit ? null : () => _handleSubmit(false),
              icon: const Icon(Icons.save, size: 16),
              label: _submitting ? '保存中' : (widget.mode == WorkOrderFormMode.edit ? '保存草稿' : '存为草稿'),
            ),
            PageActionButton.filled(
              onPressed: _submitting || !canSubmit ? null : () => _handleSubmit(true),
              icon: const Icon(Icons.send, size: 16),
              label: _submitting ? '发布中' : (widget.mode == WorkOrderFormMode.edit ? '保存并发布' : '直接发布'),
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
                salesOrders: _filteredSalesOrders,
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
                artworks: _filteredArtworks,
                artworkIds: _draft.artworkIds,
                dies: _filteredDies,
                dieIds: _draft.dieIds,
                foilingPlates: _filteredFoilingPlates,
                foilingPlateIds: _draft.foilingPlateIds,
                embossingPlates: _filteredEmbossingPlates,
                embossingPlateIds: _draft.embossingPlateIds,
                requiredResources: _requiredResources,
                onSalesOrderChanged: _handleSalesOrderChanged,
                onCustomerChanged: _handleCustomerChanged,
                onCreateCustomer: _handleCreateCustomer,
                onSearchCustomer: _handleSearchCustomer,
                onStatusChanged: (value) =>
                    setState(() => _draft.status = value ?? 'pending'),
                onPriorityChanged: (value) =>
                    setState(() => _draft.priority = value ?? 'normal'),
                onPickOrderDate: () => _pickDate(isOrderDate: true),
                onPickDeliveryDate: () => _pickDate(isOrderDate: false),
                onPickActualDeliveryDate: _pickActualDeliveryDate,
                onAddProduct: _handleAddProduct,
                onRemoveProduct: (index) {
                  setState(() {
                    _draft.removeProductDraftAt(index);
                    _cleanupPrepressSelections();
                    _draft.recalcProductQuantities();
                  });
                },
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
                    _draft.autoFillUnitsFromProducts(_fullProducts);
                    _draft.autoFillFromArtworks(
                      _artworks
                          .where((a) => _draft.artworkIds.contains(a.id))
                          .toList(),
                      _fullProducts,
                    );
                    _draft.recalcProductQuantities();
                    _cleanupPrepressSelections();
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
