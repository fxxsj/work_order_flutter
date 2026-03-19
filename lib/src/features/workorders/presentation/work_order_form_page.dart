import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_form_options_loader.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_form_submission.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_sections.dart';

enum WorkOrderFormMode { create, edit }

class WorkOrderFormEntry extends StatelessWidget {
  const WorkOrderFormEntry({super.key, required this.mode, this.workOrderId});

  final WorkOrderFormMode mode;
  final int? workOrderId;

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
      child: WorkOrderFormPage(mode: mode, workOrderId: workOrderId),
    );
  }
}

class WorkOrderFormPage extends StatefulWidget {
  const WorkOrderFormPage({super.key, required this.mode, this.workOrderId});

  final WorkOrderFormMode mode;
  final int? workOrderId;

  @override
  State<WorkOrderFormPage> createState() => _WorkOrderFormPageState();
}

class _WorkOrderFormPageState extends State<WorkOrderFormPage> {
  final _formKey = GlobalKey<FormState>();
  static const double _spacing = 12;
  static const double _sectionSpacing = 16;

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _printingOtherColorsController =
      TextEditingController();
  final TextEditingController _orderDateController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _productionQuantityController =
      TextEditingController();
  final TextEditingController _defectiveQuantityController =
      TextEditingController();
  final TextEditingController _actualDeliveryDateController =
      TextEditingController();

  DateTime? _orderDate;
  DateTime? _deliveryDate;
  DateTime? _actualDeliveryDate;

  int? _customerId;
  String _status = 'pending';
  String _priority = 'normal';
  String _printingType = 'none';
  final Set<String> _printingCmyk = {};

  final List<WorkOrderProductDraft> _productDrafts = [];
  final List<WorkOrderMaterialDraft> _materialDrafts = [];
  final Set<int> _processIds = {};
  final Set<int> _initialProcessIds = {};
  final Set<int> _artworkIds = {};
  final Set<int> _dieIds = {};
  final Set<int> _foilingPlateIds = {};
  final Set<int> _embossingPlateIds = {};

  List<Customer> _customers = [];
  List<ProductOption> _products = [];
  List<MaterialItem> _materials = [];
  List<Process> _processes = [];
  List<Artwork> _artworks = [];
  List<Die> _dies = [];
  List<FoilingPlate> _foilingPlates = [];
  List<EmbossingPlate> _embossingPlates = [];

  bool _loadingOptions = false;
  bool _loadingDetail = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _orderDate = DateTime.now();
    _orderDateController.text = _formatDate(_orderDate);
    _deliveryDateController.text = _formatDate(_deliveryDate);
    _loadOptions();
    if (widget.mode == WorkOrderFormMode.edit && widget.workOrderId != null) {
      _loadDetail(widget.workOrderId!);
    } else {
      _productDrafts.add(WorkOrderProductDraft());
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _printingOtherColorsController.dispose();
    _orderDateController.dispose();
    _deliveryDateController.dispose();
    _productionQuantityController.dispose();
    _defectiveQuantityController.dispose();
    _actualDeliveryDateController.dispose();
    for (final draft in _productDrafts) {
      draft.dispose();
    }
    for (final draft in _materialDrafts) {
      draft.dispose();
    }
    super.dispose();
  }

  Future<void> _loadOptions() async {
    setState(() => _loadingOptions = true);
    try {
      final options =
          await WorkOrderFormOptionsLoader(context.read<ApiClient>()).load();

      setState(() {
        _customers = options.customers;
        _products = options.products;
        _materials = options.materials;
        _processes = options.processes;
        _artworks = options.artworks;
        _dies = options.dies;
        _foilingPlates = options.foilingPlates;
        _embossingPlates = options.embossingPlates;
      });
    } catch (err) {
      ToastUtil.showError('加载基础数据失败: $err');
    } finally {
      if (mounted) setState(() => _loadingOptions = false);
    }
  }

  Future<void> _loadDetail(int id) async {
    setState(() => _loadingDetail = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      final detail = await viewModel.fetchDetail(id);
      _applyDetail(detail);
    } catch (err) {
      ToastUtil.showError('加载施工单失败: $err');
    } finally {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  void _applyDetail(WorkOrderDetail detail) {
    _customerId = detail.customerId;
    _status = detail.status ?? _status;
    _priority = detail.priority ?? _priority;
    _orderDate = detail.orderDate;
    _deliveryDate = detail.deliveryDate;
    _actualDeliveryDate = detail.actualDeliveryDate;
    _orderDateController.text = _formatDate(_orderDate);
    _deliveryDateController.text = _formatDate(_deliveryDate);
    _actualDeliveryDateController.text = _formatDate(_actualDeliveryDate);
    _productionQuantityController.text =
        detail.productionQuantity?.toString() ?? '';
    _defectiveQuantityController.text =
        detail.defectiveQuantity?.toString() ?? '';
    _printingType = detail.printingType ?? _printingType;
    _printingCmyk
      ..clear()
      ..addAll(detail.printingCmykColors);
    _printingOtherColorsController.text = detail.printingOtherColors.join(', ');
    _notesController.text = detail.notes ?? '';

    _productDrafts.clear();
    for (final item in detail.products) {
      _productDrafts.add(WorkOrderProductDraft.fromDetail(item));
    }
    if (_productDrafts.isEmpty) {
      _productDrafts.add(WorkOrderProductDraft());
    }

    _materialDrafts.clear();
    for (final item in detail.materials) {
      _materialDrafts.add(WorkOrderMaterialDraft.fromDetail(item));
    }

    _processIds
      ..clear()
      ..addAll(detail.processes.map((e) => e.processId).whereType<int>());
    _initialProcessIds
      ..clear()
      ..addAll(_processIds);
    _artworkIds
      ..clear()
      ..addAll(detail.artworkIds);
    _dieIds
      ..clear()
      ..addAll(detail.dieIds);
    _foilingPlateIds
      ..clear()
      ..addAll(detail.foilingPlateIds);
    _embossingPlateIds
      ..clear()
      ..addAll(detail.embossingPlateIds);

    setState(() {});
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '';
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> _pickDate({required bool isOrderDate}) async {
    final initial = isOrderDate
        ? (_orderDate ?? DateTime.now())
        : (_deliveryDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isOrderDate) {
        _orderDate = picked;
        _orderDateController.text = _formatDate(picked);
      } else {
        _deliveryDate = picked;
        _deliveryDateController.text = _formatDate(picked);
      }
    });
  }

  Future<void> _pickActualDeliveryDate() async {
    final initial = _actualDeliveryDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      _actualDeliveryDate = picked;
      _actualDeliveryDateController.text = _formatDate(picked);
    });
  }

  WorkOrderFormSubmissionInput _submissionInput() {
    return WorkOrderFormSubmissionInput(
      customerId: _customerId,
      status: _status,
      priority: _priority,
      orderDate: _orderDate,
      deliveryDate: _deliveryDate,
      actualDeliveryDate: _actualDeliveryDate,
      productionQuantityText: _productionQuantityController.text,
      defectiveQuantityText: _defectiveQuantityController.text,
      notes: _notesController.text,
      printingType: _printingType,
      printingCmyk: _printingCmyk,
      printingOtherColorsText: _printingOtherColorsController.text,
      productDrafts: _productDrafts,
      materialDrafts: _materialDrafts,
      processIds: _processIds,
      artworkIds: _artworkIds,
      dieIds: _dieIds,
      foilingPlateIds: _foilingPlateIds,
      embossingPlateIds: _embossingPlateIds,
    );
  }

  Future<void> _handleSubmit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    final submissionInput = _submissionInput();
    final validationMessage = WorkOrderFormSubmission.validate(submissionInput);
    if (validationMessage != null) {
      ToastUtil.showError(validationMessage);
      return;
    }

    setState(() => _submitting = true);
    final payload = WorkOrderFormSubmission.buildPayload(submissionInput);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      WorkOrderDetail? updatedDetail;
      if (widget.mode == WorkOrderFormMode.create) {
        updatedDetail = await viewModel.createWorkOrder(payload);
      } else if (widget.workOrderId != null) {
        updatedDetail =
            await viewModel.updateWorkOrder(widget.workOrderId!, payload);
      }
      if (!mounted) return;
      if (widget.mode == WorkOrderFormMode.edit &&
          updatedDetail != null &&
          _hasProcessChanges()) {
        final canSync = updatedDetail.approvalStatus != 'approved';
        if (canSync) {
          final goPreview = await _showSyncPrompt(updatedDetail.id);
          if (!mounted) return;
          if (goPreview == true) {
            context.go('/workorders/${updatedDetail.id}');
            return;
          }
        }
      }
      Navigator.of(context).pop(true);
    } catch (err) {
      ToastUtil.showError('保存失败: $err');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  bool _hasProcessChanges() {
    if (_initialProcessIds.length != _processIds.length) return true;
    for (final id in _processIds) {
      if (!_initialProcessIds.contains(id)) return true;
    }
    return false;
  }

  Future<bool?> _showSyncPrompt(int workOrderId) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('工序已更新'),
          content: const Text('检测到工序选择已变更，是否前往任务同步预览？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('稍后处理'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('去预览'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: _submitting ? null : _handleSubmit,
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
              child: ListView(
                children: [
                  WorkOrderBasicInfoSection(
                    mode: widget.mode,
                    customerId: _customerId,
                    customers: _customers,
                    status: _status,
                    priority: _priority,
                    orderDateController: _orderDateController,
                    deliveryDateController: _deliveryDateController,
                    productionQuantityController: _productionQuantityController,
                    defectiveQuantityController: _defectiveQuantityController,
                    actualDeliveryDateController: _actualDeliveryDateController,
                    notesController: _notesController,
                    onCustomerChanged: (value) =>
                        setState(() => _customerId = value),
                    onStatusChanged: (value) =>
                        setState(() => _status = value ?? 'pending'),
                    onPriorityChanged: (value) =>
                        setState(() => _priority = value ?? 'normal'),
                    onPickOrderDate: () => _pickDate(isOrderDate: true),
                    onPickDeliveryDate: () => _pickDate(isOrderDate: false),
                    onPickActualDeliveryDate: _pickActualDeliveryDate,
                  ),
                  const SizedBox(height: _sectionSpacing),
                  WorkOrderProductListSection(
                    drafts: _productDrafts,
                    products: _products,
                    onAdd: () => setState(
                        () => _productDrafts.add(WorkOrderProductDraft())),
                    onRemove: (index) =>
                        setState(() => _productDrafts.removeAt(index)),
                  ),
                  const SizedBox(height: _sectionSpacing),
                  WorkOrderFormSectionCard(
                    title: '工序选择',
                    child: WorkOrderMultiSelectChips(
                      items: _processes
                          .map(
                              (item) => WorkOrderOptionItem(item.id, item.name))
                          .toList(),
                      selected: _processIds,
                      emptyText: '暂无工序数据',
                      title: '工序选择',
                      placeholder: '请选择工序（可多选）',
                      onChanged: () => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: _sectionSpacing),
                  WorkOrderMaterialListSection(
                    drafts: _materialDrafts,
                    materials: _materials,
                    onAdd: () => setState(
                      () => _materialDrafts.add(WorkOrderMaterialDraft()),
                    ),
                    onRemove: (index) =>
                        setState(() => _materialDrafts.removeAt(index)),
                  ),
                  const SizedBox(height: _sectionSpacing),
                  WorkOrderResourcesSection(
                    printingType: _printingType,
                    printingCmyk: _printingCmyk,
                    printingOtherColorsController:
                        _printingOtherColorsController,
                    artworks: _artworks,
                    artworkIds: _artworkIds,
                    dies: _dies,
                    dieIds: _dieIds,
                    foilingPlates: _foilingPlates,
                    foilingPlateIds: _foilingPlateIds,
                    embossingPlates: _embossingPlates,
                    embossingPlateIds: _embossingPlateIds,
                    onPrintingTypeChanged: (value) =>
                        setState(() => _printingType = value ?? 'none'),
                    onToggleCmyk: (color) {
                      setState(() {
                        if (_printingCmyk.contains(color)) {
                          _printingCmyk.remove(color);
                        } else {
                          _printingCmyk.add(color);
                        }
                      });
                    },
                    onSelectionChanged: () => setState(() {}),
                  ),
                ],
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
