import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_api_service.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/dies/data/die_api_service.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_api_service.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_api_service.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
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
      child: WorkOrderFormPage(mode: widget.mode, workOrderId: widget.workOrderId),
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
  static const String _breadcrumbSeparator = ' / ';
  static const String _emptyText = '-';

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _printingOtherColorsController = TextEditingController();
  final TextEditingController _orderDateController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();

  DateTime? _orderDate;
  DateTime? _deliveryDate;

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
      final customerPage = results[0] as dynamic;
      final productOptions = results[1] as List<ProductOption>;
      final materialPage = results[2] as dynamic;
      final processPage = results[3] as dynamic;
      final artworkPage = results[4] as dynamic;
      final diePage = results[5] as dynamic;
      final foilingPage = results[6] as dynamic;
      final embossingPage = results[7] as dynamic;

      setState(() {
        _customers = customerPage.items.map<Customer>((item) => item.toEntity()).toList();
        _products = productOptions;
        _materials = materialPage.items.map<MaterialItem>((item) => item.toEntity()).toList();
        _processes = processPage.items.map<Process>((item) => item.toEntity()).toList();
        _artworks = artworkPage.items.map<Artwork>((item) => item.toEntity()).toList();
        _dies = diePage.items.map<Die>((item) => item.toEntity()).toList();
        _foilingPlates = foilingPage.items.map<FoilingPlate>((item) => item.toEntity()).toList();
        _embossingPlates = embossingPage.items.map<EmbossingPlate>((item) => item.toEntity()).toList();
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
    _orderDateController.text = _formatDate(_orderDate);
    _deliveryDateController.text = _formatDate(_deliveryDate);
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
    final initial = isOrderDate ? (_orderDate ?? DateTime.now()) : (_deliveryDate ?? DateTime.now());
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
    return {
      'customer': _customerId,
      'status': _status,
      'priority': _priority,
      'order_date': orderDate.isEmpty ? null : orderDate,
      'delivery_date': deliveryDate.isEmpty ? null : deliveryDate,
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.mode == WorkOrderFormMode.create ? '新建施工单' : '编辑施工单';
    final breadcrumb = [
      ...buildBreadcrumbForPathWith(
        GoRouterState.of(context).uri.path,
        buildPathToIdMap(),
      ),
      title,
    ];

    return ListPageScaffold(
      spacing: _spacing,
      header: PageHeaderBar(
        breadcrumb: breadcrumb.join(_breadcrumbSeparator),
        useSurface: false,
        showDivider: false,
        padding: EdgeInsets.zero,
        actions: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PageActionButton.outlined(
              onPressed: _submitting ? null : () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: '返回',
            ),
            const SizedBox(width: _spacing),
            PageActionButton.filled(
              onPressed: _submitting ? null : _handleSubmit,
              icon: const Icon(Icons.save, size: 16),
              label: _submitting ? '保存中' : '保存',
            ),
          ],
        ),
      ),
      body: _loadingOptions || _loadingDetail
          ? const Center(child: CircularProgressIndicator())
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
                          value: _customerId,
                          decoration: const InputDecoration(labelText: '客户', border: OutlineInputBorder()),
                          items: _customers
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => setState(() => _customerId = value),
                          validator: (value) => value == null ? '请选择客户' : null,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: 240,
                              child: DropdownButtonFormField<String>(
                                value: _status,
                                decoration: const InputDecoration(labelText: '状态', border: OutlineInputBorder()),
                                items: const [
                                  DropdownMenuItem(value: 'pending', child: Text('待开始')),
                                  DropdownMenuItem(value: 'in_progress', child: Text('进行中')),
                                  DropdownMenuItem(value: 'paused', child: Text('已暂停')),
                                  DropdownMenuItem(value: 'completed', child: Text('已完成')),
                                  DropdownMenuItem(value: 'cancelled', child: Text('已取消')),
                                ],
                                onChanged: (value) => setState(() => _status = value ?? 'pending'),
                              ),
                            ),
                            SizedBox(
                              width: 240,
                              child: DropdownButtonFormField<String>(
                                value: _priority,
                                decoration: const InputDecoration(labelText: '优先级', border: OutlineInputBorder()),
                                items: const [
                                  DropdownMenuItem(value: 'low', child: Text('低')),
                                  DropdownMenuItem(value: 'normal', child: Text('普通')),
                                  DropdownMenuItem(value: 'high', child: Text('高')),
                                  DropdownMenuItem(value: 'urgent', child: Text('紧急')),
                                ],
                                onChanged: (value) => setState(() => _priority = value ?? 'normal'),
                              ),
                            ),
                            SizedBox(
                              width: 240,
                              child: TextFormField(
                                readOnly: true,
                                decoration: const InputDecoration(labelText: '下单日期', border: OutlineInputBorder()),
                                controller: _orderDateController,
                                onTap: () => _pickDate(isOrderDate: true),
                              ),
                            ),
                            SizedBox(
                              width: 240,
                              child: TextFormField(
                                readOnly: true,
                                decoration: const InputDecoration(labelText: '交货日期', border: OutlineInputBorder()),
                                controller: _deliveryDateController,
                                onTap: () => _pickDate(isOrderDate: false),
                                validator: (value) => (value == null || value.isEmpty) ? '请选择交货日期' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(labelText: '备注', border: OutlineInputBorder()),
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
                        for (int index = 0; index < _productDrafts.length; index++)
                          _ProductRow(
                            draft: _productDrafts[index],
                            products: _products,
                            onRemove: _productDrafts.length > 1
                                ? () => setState(() => _productDrafts.removeAt(index))
                                : null,
                          ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => setState(() => _productDrafts.add(_ProductDraft())),
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
                      items: _processes.map((item) => _OptionItem(item.id, item.name)).toList(),
                      selected: _processIds,
                      emptyText: '暂无工序数据',
                      onChanged: () => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: _sectionSpacing),
                  _buildSection(
                    '物料清单',
                    Column(
                      children: [
                        for (int index = 0; index < _materialDrafts.length; index++)
                          _MaterialRow(
                            draft: _materialDrafts[index],
                            materials: _materials,
                            onRemove: () => setState(() => _materialDrafts.removeAt(index)),
                          ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => setState(() => _materialDrafts.add(_MaterialDraft())),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _printingType,
                          decoration: const InputDecoration(labelText: '印刷形式', border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(value: 'none', child: Text('不需要印刷')),
                            DropdownMenuItem(value: 'front', child: Text('正面印刷')),
                            DropdownMenuItem(value: 'back', child: Text('背面印刷')),
                            DropdownMenuItem(value: 'self_reverse', child: Text('自反印刷')),
                            DropdownMenuItem(value: 'reverse_gripper', child: Text('反咬口印刷')),
                            DropdownMenuItem(value: 'register', child: Text('套版印刷')),
                          ],
                          onChanged: (value) => setState(() => _printingType = value ?? 'none'),
                        ),
                        const SizedBox(height: 12),
                        Text('CMYK 颜色', style: Theme.of(context).textTheme.titleSmall),
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
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _printingOtherColorsController,
                          decoration: const InputDecoration(
                            labelText: '其他颜色 (逗号分隔)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text('图稿', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        _MultiSelectChips(
                          items: _artworks
                              .map(
                                (item) => _OptionItem(item.id, item.fullCode.isNotEmpty ? item.fullCode : item.name),
                              )
                              .toList(),
                          selected: _artworkIds,
                          emptyText: '暂无图稿数据',
                          onChanged: () => setState(() {}),
                        ),
                        const SizedBox(height: 12),
                        Text('刀模', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        _MultiSelectChips(
                          items: _dies
                              .map(
                                (item) => _OptionItem(item.id, item.code?.isNotEmpty == true ? '${item.name} (${item.code})' : item.name),
                              )
                              .toList(),
                          selected: _dieIds,
                          emptyText: '暂无刀模数据',
                          onChanged: () => setState(() {}),
                        ),
                        const SizedBox(height: 12),
                        Text('烫金版', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        _MultiSelectChips(
                          items: _foilingPlates
                              .map(
                                (item) => _OptionItem(item.id, item.code?.isNotEmpty == true ? '${item.name} (${item.code})' : item.name),
                              )
                              .toList(),
                          selected: _foilingPlateIds,
                          emptyText: '暂无烫金版数据',
                          onChanged: () => setState(() {}),
                        ),
                        const SizedBox(height: 12),
                        Text('压凸版', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        _MultiSelectChips(
                          items: _embossingPlates
                              .map(
                                (item) => _OptionItem(item.id, item.code?.isNotEmpty == true ? '${item.name} (${item.code})' : item.name),
                              )
                              .toList(),
                          selected: _embossingPlateIds,
                          emptyText: '暂无压凸版数据',
                          onChanged: () => setState(() {}),
                        ),
                      ],
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

class _MultiSelectChips extends StatelessWidget {
  const _MultiSelectChips({
    required this.items,
    required this.selected,
    required this.emptyText,
    required this.onChanged,
  });

  final List<_OptionItem> items;
  final Set<int> selected;
  final String emptyText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(emptyText, style: Theme.of(context).textTheme.bodyMedium);
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = selected.contains(item.id);
        return FilterChip(
          label: Text(item.label),
          selected: isSelected,
          onSelected: (value) {
            if (value) {
              selected.add(item.id);
            } else {
              selected.remove(item.id);
            }
            onChanged();
          },
        );
      }).toList(),
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
        quantityController = TextEditingController(text: item.quantity?.toString() ?? '1'),
        unitController = TextEditingController(text: item.unit ?? '件'),
        specController = TextEditingController(text: item.specification ?? ''),
        sortOrderController = TextEditingController(text: item.sortOrder?.toString() ?? '0');

  int? productId;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final TextEditingController specController;
  final TextEditingController sortOrderController;

  int get quantityValue => int.tryParse(quantityController.text.trim()) ?? 1;
  String get unitValue => unitController.text.trim().isEmpty ? '件' : unitController.text.trim();
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 220,
            child: DropdownButtonFormField<int>(
              value: widget.draft.productId,
              decoration: const InputDecoration(labelText: '产品', border: OutlineInputBorder()),
              items: widget.products
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text(item.displayLabel),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => widget.draft.productId = value),
              validator: (value) => value == null ? '请选择产品' : null,
            ),
          ),
          SizedBox(
            width: 120,
            child: TextFormField(
              controller: widget.draft.quantityController,
              decoration: const InputDecoration(labelText: '数量', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 120,
            child: TextFormField(
              controller: widget.draft.unitController,
              decoration: const InputDecoration(labelText: '单位', border: OutlineInputBorder()),
            ),
          ),
          SizedBox(
            width: 200,
            child: TextFormField(
              controller: widget.draft.specController,
              decoration: const InputDecoration(labelText: '规格', border: OutlineInputBorder()),
            ),
          ),
          SizedBox(
            width: 120,
            child: TextFormField(
              controller: widget.draft.sortOrderController,
              decoration: const InputDecoration(labelText: '排序', border: OutlineInputBorder()),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 220,
            child: DropdownButtonFormField<int>(
              value: widget.draft.materialId,
              decoration: const InputDecoration(labelText: '物料', border: OutlineInputBorder()),
              items: widget.materials
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text('${item.name} (${item.code})'),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => widget.draft.materialId = value),
            ),
          ),
          SizedBox(
            width: 160,
            child: TextFormField(
              controller: widget.draft.sizeController,
              decoration: const InputDecoration(labelText: '规格', border: OutlineInputBorder()),
            ),
          ),
          SizedBox(
            width: 160,
            child: TextFormField(
              controller: widget.draft.usageController,
              decoration: const InputDecoration(labelText: '用量', border: OutlineInputBorder()),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: widget.draft.needCutting,
                onChanged: (value) => setState(() => widget.draft.needCutting = value ?? false),
              ),
              const Text('需要开料'),
            ],
          ),
          SizedBox(
            width: 200,
            child: TextFormField(
              controller: widget.draft.notesController,
              decoration: const InputDecoration(labelText: '备注', border: OutlineInputBorder()),
            ),
          ),
          IconButton(
            onPressed: widget.onRemove,
            icon: const Icon(Icons.remove_circle_outline),
            tooltip: '移除',
          ),
        ],
      ),
    );
  }
}
