import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
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
import 'package:work_order_app/src/features/workorders/presentation/work_order_form_state.dart';
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
  final _draft = WorkOrderFormDraftState();
  static const double _spacing = 12;

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
    _loadOptions();
    if (widget.mode == WorkOrderFormMode.edit && widget.workOrderId != null) {
      _loadDetail(widget.workOrderId!);
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
      _draft.applyDetail(detail);
      if (mounted) {
        setState(() {});
      }
    } catch (err) {
      ToastUtil.showError('加载施工单失败: $err');
    } finally {
      if (mounted) setState(() => _loadingDetail = false);
    }
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
          _draft.hasProcessChanges()) {
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

  Future<bool?> _showSyncPrompt(int workOrderId) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return BaseDialog(
          title: '工序已更新',
          maxWidth: 420,
          scrollable: false,
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
                onCustomerChanged: (value) =>
                    setState(() => _draft.customerId = value),
                onStatusChanged: (value) =>
                    setState(() => _draft.status = value ?? 'pending'),
                onPriorityChanged: (value) =>
                    setState(() => _draft.priority = value ?? 'normal'),
                onPickOrderDate: () => _pickDate(isOrderDate: true),
                onPickDeliveryDate: () => _pickDate(isOrderDate: false),
                onPickActualDeliveryDate: _pickActualDeliveryDate,
                onAddProduct: () => setState(_draft.addProductDraft),
                onRemoveProduct: (index) =>
                    setState(() => _draft.removeProductDraftAt(index)),
                onProcessSelectionChanged: () => setState(() {}),
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
                onResourceSelectionChanged: () => setState(() {}),
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
