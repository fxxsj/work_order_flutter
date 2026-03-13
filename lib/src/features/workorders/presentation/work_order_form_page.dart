import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_api_service.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_dto.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/dies/data/die_api_service.dart';
import 'package:work_order_app/src/features/dies/data/die_dto.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_api_service.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_dto.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_api_service.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_dto.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_dto.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';

enum WorkOrderFormMode { create, edit }

class WorkOrderFormEntry extends StatefulWidget {
  const WorkOrderFormEntry({super.key, required this.mode, this.workOrderId});

  final WorkOrderFormMode mode;
  final int? workOrderId;

  @override
  State<WorkOrderFormEntry> createState() => _WorkOrderFormEntryState();
}

class _WorkOrderFormEntryState extends State<WorkOrderFormEntry> {
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
      child:
          WorkOrderFormPage(mode: widget.mode, workOrderId: widget.workOrderId),
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

  final List<_ProductDraft> _productDrafts = [];
  final List<_MaterialDraft> _materialDrafts = [];
  final Set<int> _processIds = {};
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
      _productDrafts.add(_ProductDraft());
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
    final apiClient = context.read<ApiClient>();
    final customerApi = CustomerApiService(apiClient);
    final productApi = ProductApiService(apiClient);
    final materialApi = MaterialApiService(apiClient);
    final processApi = ProcessApiService(apiClient);
    final artworkApi = ArtworkApiService(apiClient);
    final dieApi = DieApiService(apiClient);
    final foilingApi = FoilingPlateApiService(apiClient);
    final embossingApi = EmbossingPlateApiService(apiClient);

    try {
      final results = await Future.wait([
        customerApi.fetchCustomers(page: 1, pageSize: 200),
        productApi.fetchProducts(pageSize: 200, isActive: true),
        materialApi.fetchMaterials(page: 1, pageSize: 200),
        processApi.fetchProcesses(page: 1, pageSize: 200),
        artworkApi.fetchArtworks(page: 1, pageSize: 200),
        dieApi.fetchDies(page: 1, pageSize: 200),
        foilingApi.fetchFoilingPlates(page: 1, pageSize: 200),
        embossingApi.fetchEmbossingPlates(page: 1, pageSize: 200),
      ]);
      final customerPage = results[0] as CustomerPageDto;
      final productOptions = results[1] as List<ProductOption>;
      final materialPage = results[2] as MaterialPageDto;
      final processPage = results[3] as ProcessPageDto;
      final artworkPage = results[4] as ArtworkPageDto;
      final diePage = results[5] as DiePageDto;
      final foilingPage = results[6] as FoilingPlatePageDto;
      final embossingPage = results[7] as EmbossingPlatePageDto;

      setState(() {
        _customers = customerPage.items
            .map<Customer>((item) => item.toEntity())
            .toList();
        _products = productOptions;
        _materials = materialPage.items
            .map<MaterialItem>((item) => item.toEntity())
            .toList();
        _processes =
            processPage.items.map<Process>((item) => item.toEntity()).toList();
        _artworks =
            artworkPage.items.map<Artwork>((item) => item.toEntity()).toList();
        _dies = diePage.items.map<Die>((item) => item.toEntity()).toList();
        _foilingPlates = foilingPage.items
            .map<FoilingPlate>((item) => item.toEntity())
            .toList();
        _embossingPlates = embossingPage.items
            .map<EmbossingPlate>((item) => item.toEntity())
            .toList();
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
      _productDrafts.add(_ProductDraft.fromDetail(item));
    }
    if (_productDrafts.isEmpty) {
      _productDrafts.add(_ProductDraft());
    }

    _materialDrafts.clear();
    for (final item in detail.materials) {
      _materialDrafts.add(_MaterialDraft.fromDetail(item));
    }

    _processIds
      ..clear()
      ..addAll(detail.processes.map((e) => e.processId).whereType<int>());
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

  Map<String, dynamic> _buildPayload() {
    final products = _productDrafts
        .where((draft) => draft.productId != null)
        .map(
          (draft) => {
            'product': draft.productId,
            'quantity': draft.quantityValue,
            'unit': draft.unitValue,
            'specification': draft.specificationValue,
            'sort_order': draft.sortOrderValue,
          },
        )
        .toList();

    final materials = _materialDrafts
        .where((draft) => draft.materialId != null)
        .map(
          (draft) => {
            'material': draft.materialId,
            'material_size': draft.sizeValue,
            'material_usage': draft.usageValue,
            'need_cutting': draft.needCutting,
            'notes': draft.notesValue,
          },
        )
        .toList();

    final otherColors = _printingOtherColorsController.text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    final orderDate = _formatDate(_orderDate);
    final deliveryDate = _formatDate(_deliveryDate);
    final actualDeliveryDate = _formatDate(_actualDeliveryDate);
    final productionQuantity =
        int.tryParse(_productionQuantityController.text.trim());
    final defectiveQuantity =
        int.tryParse(_defectiveQuantityController.text.trim());
    return {
      'customer': _customerId,
      'status': _status,
      'priority': _priority,
      'order_date': orderDate.isEmpty ? null : orderDate,
      'delivery_date': deliveryDate.isEmpty ? null : deliveryDate,
      'actual_delivery_date':
          actualDeliveryDate.isEmpty ? null : actualDeliveryDate,
      'production_quantity': productionQuantity,
      'defective_quantity': defectiveQuantity,
      'notes': _notesController.text.trim(),
      'printing_type': _printingType,
      'printing_cmyk_colors': _printingCmyk.toList(),
      'printing_other_colors': otherColors,
      'products_data': products,
      'materials_data': materials,
      'processes': _processIds.toList(),
      'artworks': _artworkIds.toList(),
      'dies': _dieIds.toList(),
      'foiling_plates': _foilingPlateIds.toList(),
      'embossing_plates': _embossingPlateIds.toList(),
    };
  }

  Future<void> _handleSubmit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    if (_customerId == null) {
      ToastUtil.showError('请选择客户');
      return;
    }
    if (_deliveryDate == null) {
      ToastUtil.showError('请选择交货日期');
      return;
    }
    if (_productDrafts.every((draft) => draft.productId == null)) {
      ToastUtil.showError('请至少填写一个产品');
      return;
    }

    setState(() => _submitting = true);
    final payload = _buildPayload();
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      if (widget.mode == WorkOrderFormMode.create) {
        await viewModel.createWorkOrder(payload);
      } else if (widget.workOrderId != null) {
        await viewModel.updateWorkOrder(widget.workOrderId!, payload);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (err) {
      ToastUtil.showError('保存失败: $err');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _buildSection(String title, Widget child) {
    return DetailSectionCard(title: title, child: child);
  }

  Widget _buildSubsectionTitle(String title) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: colors?.sidebarText,
      ),
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
                  _buildSection(
                    '基本信息',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<int>(
                          initialValue: _customerId,
                          decoration: const InputDecoration(
                              labelText: '客户'),
                          items: _customers
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _customerId = value),
                          validator: (value) => value == null ? '请选择客户' : null,
                        ),
                        const SizedBox(height: 12),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final maxWidth = constraints.maxWidth;
                            final fieldSpacing = LayoutTokens.gapLg;
                            final fieldWidth = maxWidth < Breakpoints.sm
                                ? maxWidth
                                : (maxWidth - fieldSpacing) / 2;
                            return Wrap(
                              spacing: fieldSpacing,
                              runSpacing: LayoutTokens.gapMd,
                              children: [
                                SizedBox(
                                  width: fieldWidth,
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _status,
                                    decoration: const InputDecoration(
                                        labelText: '状态',
                                        ),
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'pending', child: Text('待开始')),
                                      DropdownMenuItem(
                                          value: 'in_progress',
                                          child: Text('进行中')),
                                      DropdownMenuItem(
                                          value: 'paused', child: Text('已暂停')),
                                      DropdownMenuItem(
                                          value: 'completed',
                                          child: Text('已完成')),
                                      DropdownMenuItem(
                                          value: 'cancelled',
                                          child: Text('已取消')),
                                    ],
                                    onChanged: (value) => setState(
                                        () => _status = value ?? 'pending'),
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _priority,
                                    decoration: const InputDecoration(
                                        labelText: '优先级',
                                        ),
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'low', child: Text('低')),
                                      DropdownMenuItem(
                                          value: 'normal', child: Text('普通')),
                                      DropdownMenuItem(
                                          value: 'high', child: Text('高')),
                                      DropdownMenuItem(
                                          value: 'urgent', child: Text('紧急')),
                                    ],
                                    onChanged: (value) => setState(
                                        () => _priority = value ?? 'normal'),
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                        labelText: '下单日期',
                                        ),
                                    controller: _orderDateController,
                                    onTap: () => _pickDate(isOrderDate: true),
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                        labelText: '交货日期',
                                        ),
                                    controller: _deliveryDateController,
                                    onTap: () => _pickDate(isOrderDate: false),
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? '请选择交货日期'
                                            : null,
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _productionQuantityController,
                                    decoration: const InputDecoration(
                                        labelText: '生产数量',
                                        ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      final text = value?.trim() ?? '';
                                      if (text.isEmpty) return null;
                                      final parsed = int.tryParse(text);
                                      if (parsed == null || parsed <= 0) {
                                        return '请输入有效数量';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _defectiveQuantityController,
                                    decoration: const InputDecoration(
                                        labelText: '预损数量',
                                        ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      final text = value?.trim() ?? '';
                                      if (text.isEmpty) return null;
                                      final parsed = int.tryParse(text);
                                      if (parsed == null || parsed < 0) {
                                        return '请输入有效数量';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                if (widget.mode == WorkOrderFormMode.edit)
                                  SizedBox(
                                    width: fieldWidth,
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                          labelText: '实际交货日期',
                                          ),
                                      controller: _actualDeliveryDateController,
                                      onTap: _pickActualDeliveryDate,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: LayoutTokens.gapMd),
                        TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                              labelText: '备注'),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: _sectionSpacing),
                  _buildSection(
                    '产品清单',
                    Column(
                      children: [
                        for (int index = 0;
                            index < _productDrafts.length;
                            index++)
                          _ProductRow(
                            draft: _productDrafts[index],
                            products: _products,
                            onRemove: _productDrafts.length > 1
                                ? () => setState(
                                    () => _productDrafts.removeAt(index))
                                : null,
                          ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => setState(
                                () => _productDrafts.add(_ProductDraft())),
                            icon: const Icon(Icons.add),
                            label: const Text('新增产品'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: _sectionSpacing),
                  _buildSection(
                    '工序选择',
                    _MultiSelectChips(
                      items: _processes
                          .map((item) => _OptionItem(item.id, item.name))
                          .toList(),
                      selected: _processIds,
                      emptyText: '暂无工序数据',
                      title: '工序选择',
                      placeholder: '请选择工序（可多选）',
                      onChanged: () => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: _sectionSpacing),
                  _buildSection(
                    '物料清单',
                    Column(
                      children: [
                        for (int index = 0;
                            index < _materialDrafts.length;
                            index++)
                          _MaterialRow(
                            draft: _materialDrafts[index],
                            materials: _materials,
                            onRemove: () =>
                                setState(() => _materialDrafts.removeAt(index)),
                          ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => setState(
                                () => _materialDrafts.add(_MaterialDraft())),
                            icon: const Icon(Icons.add),
                            label: const Text('新增物料'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: _sectionSpacing),
                  _buildSection(
                    '印刷与版信息',
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < Breakpoints.lg;
                        final columnSpacing = LayoutTokens.gapLg;
                        final leftColumn = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              initialValue: _printingType,
                              decoration: const InputDecoration(
                                  labelText: '印刷形式'),
                              items: const [
                                DropdownMenuItem(
                                    value: 'none', child: Text('不需要印刷')),
                                DropdownMenuItem(
                                    value: 'front', child: Text('正面印刷')),
                                DropdownMenuItem(
                                    value: 'back', child: Text('背面印刷')),
                                DropdownMenuItem(
                                    value: 'self_reverse', child: Text('自反印刷')),
                                DropdownMenuItem(
                                    value: 'reverse_gripper',
                                    child: Text('反咬口印刷')),
                                DropdownMenuItem(
                                    value: 'register', child: Text('套版印刷')),
                              ],
                              onChanged: (value) => setState(
                                  () => _printingType = value ?? 'none'),
                            ),
                            SizedBox(height: LayoutTokens.gapMd),
                            _buildSubsectionTitle('CMYK 颜色'),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: ['C', 'M', 'Y', 'K']
                                  .map(
                                    (color) => FilterChip(
                                      label: Text(color),
                                      selected: _printingCmyk.contains(color),
                                      onSelected: (selected) {
                                        setState(() {
                                          if (selected) {
                                            _printingCmyk.add(color);
                                          } else {
                                            _printingCmyk.remove(color);
                                          }
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                            SizedBox(height: LayoutTokens.gapMd),
                            TextFormField(
                              controller: _printingOtherColorsController,
                              decoration: const InputDecoration(
                                labelText: '其他颜色（逗号分隔）',
                              ),
                            ),
                          ],
                        );

                        final rightColumn = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSubsectionTitle('图稿'),
                            const SizedBox(height: 8),
                            _MultiSelectChips(
                              items: _artworks
                                  .map(
                                    (item) => _OptionItem(
                                        item.id,
                                        item.fullCode.isNotEmpty
                                            ? item.fullCode
                                            : item.name),
                                  )
                                  .toList(),
                              selected: _artworkIds,
                              emptyText: '暂无图稿数据',
                              title: '图稿',
                              placeholder: '请选择图稿（可多选）',
                              onChanged: () => setState(() {}),
                            ),
                            SizedBox(height: LayoutTokens.gapMd),
                            _buildSubsectionTitle('刀模'),
                            const SizedBox(height: 8),
                            _MultiSelectChips(
                              items: _dies
                                  .map(
                                    (item) => _OptionItem(
                                        item.id,
                                        item.code?.isNotEmpty == true
                                            ? '${item.name} (${item.code})'
                                            : item.name),
                                  )
                                  .toList(),
                              selected: _dieIds,
                              emptyText: '暂无刀模数据',
                              title: '刀模',
                              placeholder: '请选择刀模（可多选）',
                              onChanged: () => setState(() {}),
                            ),
                            SizedBox(height: LayoutTokens.gapMd),
                            _buildSubsectionTitle('烫金版'),
                            const SizedBox(height: 8),
                            _MultiSelectChips(
                              items: _foilingPlates
                                  .map(
                                    (item) => _OptionItem(
                                        item.id,
                                        item.code?.isNotEmpty == true
                                            ? '${item.name} (${item.code})'
                                            : item.name),
                                  )
                                  .toList(),
                              selected: _foilingPlateIds,
                              emptyText: '暂无烫金版数据',
                              title: '烫金版',
                              placeholder: '请选择烫金版（可多选）',
                              onChanged: () => setState(() {}),
                            ),
                            SizedBox(height: LayoutTokens.gapMd),
                            _buildSubsectionTitle('压凸版'),
                            const SizedBox(height: 8),
                            _MultiSelectChips(
                              items: _embossingPlates
                                  .map(
                                    (item) => _OptionItem(
                                        item.id,
                                        item.code?.isNotEmpty == true
                                            ? '${item.name} (${item.code})'
                                            : item.name),
                                  )
                                  .toList(),
                              selected: _embossingPlateIds,
                              emptyText: '暂无压凸版数据',
                              title: '压凸版',
                              placeholder: '请选择压凸版（可多选）',
                              onChanged: () => setState(() {}),
                            ),
                          ],
                        );

                        if (isNarrow) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              leftColumn,
                              SizedBox(height: columnSpacing),
                              rightColumn,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: leftColumn),
                            SizedBox(width: columnSpacing),
                            Expanded(child: rightColumn),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _OptionItem {
  const _OptionItem(this.id, this.label);

  final int id;
  final String label;
}

class _MultiSelectChips extends StatefulWidget {
  const _MultiSelectChips({
    required this.items,
    required this.selected,
    required this.emptyText,
    required this.title,
    required this.placeholder,
    required this.onChanged,
  });

  final List<_OptionItem> items;
  final Set<int> selected;
  final String emptyText;
  final String title;
  final String placeholder;
  final VoidCallback onChanged;

  @override
  State<_MultiSelectChips> createState() => _MultiSelectChipsState();
}

class _MultiSelectChipsState extends State<_MultiSelectChips> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = false;
  }

  @override
  void didUpdateWidget(covariant _MultiSelectChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected.isEmpty && _expanded) {
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    if (widget.items.isEmpty) {
      return Text(
        widget.emptyText,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colors?.subtleText ?? theme.hintColor,
        ),
      );
    }
    final resolvedColors = colors!;
    final selectedItems = widget.items
        .where((item) => widget.selected.contains(item.id))
        .toList();
    final hasSelected = selectedItems.isNotEmpty;
    final summaryText = hasSelected
        ? '已选 ${selectedItems.length} 项'
        : widget.placeholder;

    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.primary.withValues(alpha: 0.03),
        contentPadding: const EdgeInsets.all(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  summaryText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: hasSelected
                        ? resolvedColors.sidebarText
                        : resolvedColors.subtleText,
                  ),
                ),
              ),
              if (hasSelected)
                IconButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  icon: Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more),
                  tooltip: _expanded ? '收起' : '展开',
                  visualDensity: VisualDensity.compact,
                ),
              IconButton(
                onPressed: () => _openDialog(context),
                icon: const Icon(Icons.edit_outlined),
                tooltip: '选择',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          if (_expanded && hasSelected) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedItems
                  .map(
                    (item) => InputChip(
                      label: Text(item.label),
                      visualDensity: VisualDensity.compact,
                      onDeleted: () {
                        widget.selected.remove(item.id);
                        widget.onChanged();
                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openDialog(BuildContext context) async {
    final original = Set<int>.from(widget.selected);
    String query = '';
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final media = MediaQuery.of(context).size;
            final filtered = widget.items
                .where((item) =>
                    item.label.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: media.width < Breakpoints.md ? 16 : 40,
                vertical: 24,
              ),
              title: Text(widget.title),
              content: SizedBox(
                width: media.width < Breakpoints.md ? media.width - 64 : 520,
                height: media.height < 720 ? media.height * 0.62 : 420,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: '搜索名称或编码',
                        prefixIcon: Icon(Icons.search),
                        
                      ),
                      onChanged: (value) =>
                          setDialogState(() => query = value.trim()),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text('无匹配项',
                                  style: Theme.of(context).textTheme.bodySmall))
                          : Scrollbar(
                              child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final item = filtered[index];
                                  final isSelected =
                                      widget.selected.contains(item.id);
                                  return CheckboxListTile(
                                    value: isSelected,
                                    dense: true,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(item.label),
                                    onChanged: (value) {
                                      setDialogState(() {
                                        if (value == true) {
                                          widget.selected.add(item.id);
                                        } else {
                                          widget.selected.remove(item.id);
                                        }
                                      });
                                      widget.onChanged();
                                    },
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    widget.selected
                      ..clear()
                      ..addAll(original);
                    widget.onChanged();
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    widget.selected.clear();
                    widget.onChanged();
                    setDialogState(() {});
                  },
                  child: const Text('清空'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('确定'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ProductDraft {
  _ProductDraft()
      : quantityController = TextEditingController(text: '1'),
        unitController = TextEditingController(text: '件'),
        specController = TextEditingController(),
        sortOrderController = TextEditingController(text: '0');

  _ProductDraft.fromDetail(WorkOrderProductItem item)
      : productId = item.productId,
        quantityController =
            TextEditingController(text: item.quantity?.toString() ?? '1'),
        unitController = TextEditingController(text: item.unit ?? '件'),
        specController = TextEditingController(text: item.specification ?? ''),
        sortOrderController =
            TextEditingController(text: item.sortOrder?.toString() ?? '0');

  int? productId;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final TextEditingController specController;
  final TextEditingController sortOrderController;

  int get quantityValue => int.tryParse(quantityController.text.trim()) ?? 1;
  String get unitValue =>
      unitController.text.trim().isEmpty ? '件' : unitController.text.trim();
  String get specificationValue => specController.text.trim();
  int get sortOrderValue => int.tryParse(sortOrderController.text.trim()) ?? 0;

  void dispose() {
    quantityController.dispose();
    unitController.dispose();
    specController.dispose();
    sortOrderController.dispose();
  }
}

class _MaterialDraft {
  _MaterialDraft()
      : sizeController = TextEditingController(),
        usageController = TextEditingController(),
        notesController = TextEditingController();

  _MaterialDraft.fromDetail(WorkOrderMaterialItem item)
      : materialId = item.materialId,
        sizeController = TextEditingController(text: item.materialSize ?? ''),
        usageController = TextEditingController(text: item.materialUsage ?? ''),
        notesController = TextEditingController(text: item.notes ?? ''),
        needCutting = item.needCutting ?? false;

  int? materialId;
  final TextEditingController sizeController;
  final TextEditingController usageController;
  final TextEditingController notesController;
  bool needCutting = false;

  String get sizeValue => sizeController.text.trim();
  String get usageValue => usageController.text.trim();
  String get notesValue => notesController.text.trim();

  void dispose() {
    sizeController.dispose();
    usageController.dispose();
    notesController.dispose();
  }
}

class _ProductRow extends StatefulWidget {
  const _ProductRow({
    required this.draft,
    required this.products,
    this.onRemove,
  });

  final _ProductDraft draft;
  final List<ProductOption> products;
  final VoidCallback? onRemove;

  @override
  State<_ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<_ProductRow> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final useFullWidth = maxWidth < Breakpoints.sm;
        final productWidth = useFullWidth ? maxWidth : 220.0;
        final smallWidth = useFullWidth ? maxWidth : 120.0;
        final specWidth = useFullWidth ? maxWidth : 200.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _FormRowCard(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: productWidth,
                  child: DropdownButtonFormField<int>(
                    initialValue: widget.draft.productId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                        labelText: '产品'),
                    items: widget.products
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.id,
                            child: Text(item.displayLabel,
                                overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => widget.draft.productId = value),
                    validator: (value) => value == null ? '请选择产品' : null,
                  ),
                ),
                SizedBox(
                  width: smallWidth,
                  child: TextFormField(
                    controller: widget.draft.quantityController,
                    decoration: const InputDecoration(
                        labelText: '数量'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: smallWidth,
                  child: TextFormField(
                    controller: widget.draft.unitController,
                    decoration: const InputDecoration(
                        labelText: '单位'),
                  ),
                ),
                SizedBox(
                  width: specWidth,
                  child: TextFormField(
                    controller: widget.draft.specController,
                    decoration: const InputDecoration(
                        labelText: '规格'),
                  ),
                ),
                SizedBox(
                  width: smallWidth,
                  child: TextFormField(
                    controller: widget.draft.sortOrderController,
                    decoration: const InputDecoration(
                        labelText: '排序'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                if (widget.onRemove != null)
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: const Icon(Icons.remove_circle_outline),
                    tooltip: '移除',
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MaterialRow extends StatefulWidget {
  const _MaterialRow({
    required this.draft,
    required this.materials,
    required this.onRemove,
  });

  final _MaterialDraft draft;
  final List<MaterialItem> materials;
  final VoidCallback onRemove;

  @override
  State<_MaterialRow> createState() => _MaterialRowState();
}

class _MaterialRowState extends State<_MaterialRow> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final useFullWidth = maxWidth < Breakpoints.sm;
        final productWidth = useFullWidth ? maxWidth : 220.0;
        final mediumWidth = useFullWidth ? maxWidth : 160.0;
        final notesWidth = useFullWidth ? maxWidth : 200.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _FormRowCard(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: productWidth,
                  child: DropdownButtonFormField<int>(
                    initialValue: widget.draft.materialId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                        labelText: '物料'),
                    items: widget.materials
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.id,
                            child: Text('${item.name} (${item.code})',
                                overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => widget.draft.materialId = value),
                  ),
                ),
                SizedBox(
                  width: mediumWidth,
                  child: TextFormField(
                    controller: widget.draft.sizeController,
                    decoration: const InputDecoration(
                        labelText: '规格'),
                  ),
                ),
                SizedBox(
                  width: mediumWidth,
                  child: TextFormField(
                    controller: widget.draft.usageController,
                    decoration: const InputDecoration(
                        labelText: '用量'),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: widget.draft.needCutting,
                      onChanged: (value) => setState(
                          () => widget.draft.needCutting = value ?? false),
                    ),
                    const Text('需要开料'),
                  ],
                ),
                SizedBox(
                  width: notesWidth,
                  child: TextFormField(
                    controller: widget.draft.notesController,
                    decoration: const InputDecoration(
                        labelText: '备注'),
                  ),
                ),
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.remove_circle_outline),
                  tooltip: '移除',
                ),
              ],
            ),
          ),
        );
      },
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

class _FormRowCard extends StatelessWidget {
  const _FormRowCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return AppCard(
      padding: LayoutTokens.cardPadding(context),
      background: theme.colorScheme.primary.withValues(alpha: 0.03),
      borderColor: colors.borderColor,
      radius: LayoutTokens.radiusLg,
      child: child,
    );
  }
}
