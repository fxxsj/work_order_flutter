import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/edit_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_api_service.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';
import 'package:work_order_app/src/features/products/application/product_view_model.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/product_materials/data/product_material_api_service.dart';

class ProductEditPage extends StatefulWidget {
  const ProductEditPage({super.key, this.product});

  final Product? product;

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final _formKey = GlobalKey<FormState>();

  static const double _inlineSpacing = 8;

  static const String _codeLabel = '产品编码';
  static const String _nameLabel = '产品名称';
  static const String _specLabel = '规格';
  static const String _unitLabel = '单位';
  static const String _unitPriceLabel = '单价';
  static const String _stockLabel = '库存数量';
  static const String _minStockLabel = '最小库存';
  static const String _productTypeLabel = '产品类型';
  static const String _productGroupLabel = '所属产品组';
  static const String _statusLabel = '启用状态';
  static const String _descriptionLabel = '产品描述';
  static const String _defaultProcessTitle = '默认工序';
  static const String _defaultMaterialTitle = '默认物料';
  static const String _materialEmptyText = '暂无物料配置';
  static const String _processPlaceholder = '请选择默认工序';
  static const String _processSearchHint = '搜索工序名称';
  static const String _emptyMatchText = '没有匹配的工序';
  static const String _addMaterialText = '添加物料';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _codeRequiredText = '请输入产品编码';
  static const String _codeLengthText = '编码长度在2-50个字符之间';
  static const String _codeInvalidText = '编码只能包含字母、数字和连字符';
  static const String _nameRequiredText = '请输入产品名称';
  static const String _cancelText = '返回';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _configSectionTitle = '工序与物料';

  static const Map<String, String> _productTypeLabels = {
    'single': '单品',
    'group_main': '套装主产品',
    'group_item': '套装子产品',
  };

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _specController;
  late final TextEditingController _unitController;
  late final TextEditingController _unitPriceController;
  late final TextEditingController _stockController;
  late final TextEditingController _minStockController;
  late final TextEditingController _descriptionController;

  late final ProductApiService _productApi;
  late final ProductGroupApiService _productGroupApi;
  late final ProcessApiService _processApi;
  late final MaterialApiService _materialApi;
  late final ProductMaterialApiService _productMaterialApi;

  String _productType = 'single';
  int? _productGroupId;
  List<int> _processIds = [];
  List<ProductGroup> _productGroups = [];
  List<Process> _processes = [];
  List<MaterialItem> _materials = [];
  final List<_MaterialDraft> _materialDrafts = [];

  bool _isActive = true;
  bool _submitting = false;
  bool _loadingOptions = false;
  bool _loadingDetail = false;

  @override
  void initState() {
    super.initState();
    final apiClient = context.read<ApiClient>();
    _productApi = ProductApiService(apiClient);
    _productGroupApi = ProductGroupApiService(apiClient);
    _processApi = ProcessApiService(apiClient);
    _materialApi = MaterialApiService(apiClient);
    _productMaterialApi = ProductMaterialApiService(apiClient);

    final product = widget.product;
    _codeController = TextEditingController(text: product?.code ?? '');
    _nameController = TextEditingController(text: product?.name ?? '');
    _specController = TextEditingController(text: product?.specification ?? '');
    _unitController = TextEditingController(text: product?.unit ?? '件');
    _unitPriceController = TextEditingController(
      text: product?.unitPrice?.toStringAsFixed(2) ?? '',
    );
    _stockController = TextEditingController(
      text: product?.stockQuantity?.toStringAsFixed(0) ?? '',
    );
    _minStockController = TextEditingController(
      text: product?.minStockQuantity?.toStringAsFixed(0) ?? '',
    );
    _descriptionController =
        TextEditingController(text: product?.description ?? '');
    _productType = product?.productType ?? 'single';
    _productGroupId = product?.productGroupId;
    _processIds = List<int>.from(product?.defaultProcessIds ?? const []);
    _materialDrafts.addAll(
      (product?.defaultMaterials ?? const [])
          .map((item) => _MaterialDraft.fromItem(item)),
    );
    _isActive = product?.isActive ?? true;
    _loadOptions();
    if (product != null) {
      _loadDetail(product.id);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _specController.dispose();
    _unitController.dispose();
    _unitPriceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _descriptionController.dispose();
    for (final draft in _materialDrafts) {
      draft.dispose();
    }
    super.dispose();
  }

  Future<void> _loadOptions() async {
    setState(() => _loadingOptions = true);
    try {
      final productGroupFuture = _productGroupApi.fetchProductGroups(
        page: 1,
        pageSize: 200,
        isActive: true,
      );
      final processFuture =
          _processApi.fetchProcesses(page: 1, pageSize: 200, isActive: true);
      final materialFuture =
          _materialApi.fetchMaterials(page: 1, pageSize: 200);
      final groupPage = await productGroupFuture;
      final processPage = await processFuture;
      final materialPage = await materialFuture;
      if (!mounted) return;
      setState(() {
        _productGroups =
            groupPage.items.map((item) => item.toEntity()).toList();
        _processes = processPage.items.map((item) => item.toEntity()).toList();
        _materials = materialPage.items.map((item) => item.toEntity()).toList();
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
      final dto = await _productApi.fetchProduct(id);
      _applyDetail(dto.toEntity());
    } catch (err) {
      ToastUtil.showError('加载产品详情失败: $err');
    } finally {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  void _applyDetail(Product detail) {
    _codeController.text = detail.code;
    _nameController.text = detail.name;
    _specController.text = detail.specification ?? '';
    _unitController.text = detail.unit ?? '件';
    _unitPriceController.text = detail.unitPrice?.toStringAsFixed(2) ?? '';
    _stockController.text = detail.stockQuantity?.toStringAsFixed(0) ?? '';
    _minStockController.text =
        detail.minStockQuantity?.toStringAsFixed(0) ?? '';
    _descriptionController.text = detail.description ?? '';
    _productType = detail.productType ?? _productType;
    _productGroupId = detail.productGroupId;
    _processIds = List<int>.from(detail.defaultProcessIds);
    _materialDrafts
      ..clear()
      ..addAll(
        detail.defaultMaterials.map((item) => _MaterialDraft.fromItem(item)),
      );
    _isActive = detail.isActive ?? _isActive;
    setState(() {});
  }

  void _handleProductTypeChange(String? value) {
    if (value == null) return;
    setState(() {
      _productType = value;
      if (_productType == 'single') {
        _productGroupId = null;
      }
    });
  }

  void _addMaterialDraft() {
    setState(() => _materialDrafts.add(_MaterialDraft()));
  }

  void _removeMaterialDraft(int index) {
    setState(() {
      final draft = _materialDrafts.removeAt(index);
      draft.dispose();
    });
  }

  Future<bool> _saveProductMaterials(int productId) async {
    var hasError = false;
    try {
      final existing = await _productMaterialApi.fetchProductMaterials(
        page: 1,
        pageSize: 200,
        params: {'product': productId},
      );
      for (final item in existing.items) {
        final rawId = item['id'];
        final id = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
        if (id != null) {
          await _productMaterialApi.deleteProductMaterial(id);
        }
      }
    } catch (_) {
      hasError = true;
    }

    for (var i = 0; i < _materialDrafts.length; i++) {
      final draft = _materialDrafts[i];
      if (draft.materialId == null || draft.materialId == 0) {
        continue;
      }
      try {
        await _productMaterialApi.createProductMaterial({
          'product': productId,
          'material': draft.materialId,
          'material_size': draft.materialSizeValue,
          'material_usage': draft.materialUsageValue,
          'need_cutting': draft.needCutting,
          'notes': draft.notesValue,
          'sort_order': i,
        });
      } catch (_) {
        hasError = true;
      }
    }
    return hasError;
  }

  Future<void> _handleSubmit(ProductViewModel viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    if (_productType != 'single' && _productGroupId == null) {
      ToastUtil.showError('请选择产品组');
      return;
    }
    setState(() => _submitting = true);

    final description = _descriptionController.text.trim();
    final payload = Product(
      id: widget.product?.id ?? 0,
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      productType: _productType,
      productGroupId: _productType == 'single' ? null : _productGroupId,
      specification: _specController.text.trim().isEmpty
          ? null
          : _specController.text.trim(),
      unit: _unitController.text.trim().isEmpty
          ? null
          : _unitController.text.trim(),
      unitPrice: _parseDouble(_unitPriceController.text),
      stockQuantity: _parseDouble(_stockController.text),
      minStockQuantity: _parseDouble(_minStockController.text),
      description: description.isEmpty ? null : description,
      isActive: _isActive,
      defaultProcessIds: _processIds,
      productTypeDisplay: widget.product?.productTypeDisplay,
      productGroupName: widget.product?.productGroupName,
    );

    try {
      final savedProduct = widget.product == null
          ? await viewModel.createProduct(payload)
          : await viewModel.updateProduct(payload);
      final materialErrors = await _saveProductMaterials(savedProduct.id);
      if (materialErrors) {
        ToastUtil.showError('部分物料保存失败');
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_submitErrorText$err');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  double? _parseDouble(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  Widget _sectionTitle(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _subsectionTitle(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final contentPadding = LayoutTokens.pagePadding(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final actionSpacing = LayoutTokens.formActionSpacing(context);
    final pageSpacing = LayoutTokens.formPageSpacing(context);
    final columnSpacing = LayoutTokens.formColumnSpacing(context);

    final basicFields = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, _basicSectionTitle),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _codeController,
          decoration: const InputDecoration(labelText: _codeLabel),
          enabled: widget.product == null,
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return _codeRequiredText;
            if (text.length < 2 || text.length > 50) return _codeLengthText;
            final regex = RegExp(r'^[A-Za-z0-9-]+$');
            if (!regex.hasMatch(text)) return _codeInvalidText;
            return null;
          },
        ),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: _nameLabel),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return _nameRequiredText;
            return null;
          },
        ),
        SizedBox(height: sectionSpacing),
        SearchableDropdownFormField<String>(
          key: ValueKey(_productType),
          initialValue: _productType,
          decoration: const InputDecoration(labelText: _productTypeLabel),
          items: _productTypeLabels.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                ),
              )
              .toList(),
          onChanged: _handleProductTypeChange,
        ),
        if (_productType != 'single') ...[
          SizedBox(height: sectionSpacing),
          SearchableDropdownFormField<int>(
            key: ValueKey(_productGroupId),
            initialValue: _productGroupId,
            decoration: const InputDecoration(labelText: _productGroupLabel),
            items: _productGroups
                .map(
                  (group) => DropdownMenuItem(
                    value: group.id,
                    child: Text('${group.code} ${group.name}'),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _productGroupId = value),
            validator: (value) =>
                _productType != 'single' && value == null ? '请选择产品组' : null,
          ),
        ],
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _specController,
          decoration: const InputDecoration(labelText: _specLabel),
        ),
      ],
    );

    final extraFields = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, _extraSectionTitle),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _unitController,
          decoration: const InputDecoration(labelText: _unitLabel),
        ),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _unitPriceController,
          decoration: const InputDecoration(labelText: _unitPriceLabel),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _stockController,
          decoration: const InputDecoration(labelText: _stockLabel),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _minStockController,
          decoration: const InputDecoration(labelText: _minStockLabel),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: _descriptionLabel),
          maxLines: 3,
        ),
        SizedBox(height: sectionSpacing),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text(_statusLabel),
          value: _isActive,
          onChanged: (value) => setState(() => _isActive = value),
        ),
      ],
    );

    final processField = InkWell(
      onTap: _processes.isEmpty ? null : () => _openProcessDialog(),
      borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: _defaultProcessTitle,
          contentPadding: EdgeInsets.all(12),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: _processes.isEmpty
            ? Text('暂无工序数据',
                style:
                    theme.textTheme.bodySmall?.copyWith(color: theme.hintColor))
            : _processIds.isEmpty
                ? Text(_processPlaceholder,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.hintColor))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _processes
                        .where((process) => _processIds.contains(process.id))
                        .map(
                          (process) => InputChip(
                            label: Text(process.name),
                            onDeleted: () {
                              setState(() {
                                _processIds = _processIds
                                    .where((id) => id != process.id)
                                    .toList();
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
      ),
    );

    final materialSection = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subsectionTitle(theme, _defaultMaterialTitle),
        SizedBox(height: sectionSpacing),
        if (_materialDrafts.isEmpty)
          Text(_materialEmptyText, style: theme.textTheme.bodySmall)
        else
          Column(
            children: [
              for (int index = 0; index < _materialDrafts.length; index++)
                _MaterialCard(
                  key: ValueKey(_materialDrafts[index]),
                  draft: _materialDrafts[index],
                  materials: _materials,
                  onRemove: () => _removeMaterialDraft(index),
                ),
            ],
          ),
        SizedBox(height: sectionSpacing),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addMaterialDraft,
            icon: const Icon(Icons.add),
            label: const Text(_addMaterialText),
          ),
        ),
      ],
    );

    final configSection = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, _configSectionTitle),
        SizedBox(height: sectionSpacing),
        processField,
        SizedBox(height: sectionSpacing),
        materialSection,
      ],
    );

    final formContent = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              basicFields,
              SizedBox(height: sectionSpacing),
              extraFields,
              SizedBox(height: sectionSpacing),
              configSection,
              SizedBox(height: actionSpacing),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: basicFields),
                  SizedBox(width: columnSpacing),
                  Expanded(child: extraFields),
                ],
              ),
              SizedBox(height: sectionSpacing),
              configSection,
              SizedBox(height: actionSpacing),
            ],
          );

    final body = (_loadingOptions || _loadingDetail)
        ? const Center(child: CircularProgressIndicator())
        : formContent;

    return SafeArea(
      child: Form(
        key: _formKey,
        child: EditPageScaffold(
          spacing: pageSpacing,
          contentPadding: contentPadding,
          header: PageHeaderBar(
            breadcrumb: null,
            useSurface: false,
            showDivider: false,
            padding: EdgeInsets.zero,
            actions: Wrap(
              spacing: _inlineSpacing,
              runSpacing: 8,
              children: [
                PageActionButton.outlined(
                  onPressed: _submitting
                      ? null
                      : () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: _cancelText,
                ),
                PageActionButton.filled(
                  onPressed:
                      _submitting ? null : () => _handleSubmit(viewModel),
                  icon: const Icon(Icons.save, size: 16),
                  label: _submitting ? '保存中' : _submitText,
                ),
              ],
            ),
          ),
          body: body,
        ),
      ),
    );
  }

  Future<void> _openProcessDialog() async {
    if (_processes.isEmpty) return;
    final original = List<int>.from(_processIds);
    String query = '';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filtered = _processes
                .where((process) =>
                    process.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return AlertDialog(
              title: const Text(_defaultProcessTitle),
              content: SizedBox(
                width: 520,
                height: 420,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: _processSearchHint,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) =>
                          setDialogState(() => query = value.trim()),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(_emptyMatchText,
                                  style: Theme.of(context).textTheme.bodySmall))
                          : Scrollbar(
                              child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final process = filtered[index];
                                  final selected =
                                      _processIds.contains(process.id);
                                  return CheckboxListTile(
                                    value: selected,
                                    dense: true,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(process.name),
                                    subtitle: process.isActive
                                        ? null
                                        : const Text('已停用'),
                                    onChanged: process.isActive
                                        ? (value) {
                                            setDialogState(() {
                                              if (value == true) {
                                                _processIds = [
                                                  ..._processIds,
                                                  process.id
                                                ];
                                              } else {
                                                _processIds = _processIds
                                                    .where((id) =>
                                                        id != process.id)
                                                    .toList();
                                              }
                                            });
                                            setState(() {});
                                          }
                                        : null,
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
                    setState(() => _processIds = List<int>.from(original));
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    setDialogState(() => _processIds = []);
                    setState(() {});
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

class _MaterialDraft {
  _MaterialDraft({
    this.materialId,
    String? materialSize,
    String? materialUsage,
    bool? needCutting,
    String? notes,
  })  : materialSizeController =
            TextEditingController(text: materialSize ?? ''),
        materialUsageController =
            TextEditingController(text: materialUsage ?? ''),
        notesController = TextEditingController(text: notes ?? ''),
        needCutting = needCutting ?? false;

  factory _MaterialDraft.fromItem(ProductMaterialItem item) {
    return _MaterialDraft(
      materialId: item.materialId,
      materialSize: item.materialSize,
      materialUsage: item.materialUsage,
      needCutting: item.needCutting ?? false,
      notes: item.notes,
    );
  }

  int? materialId;
  final TextEditingController materialSizeController;
  final TextEditingController materialUsageController;
  final TextEditingController notesController;
  bool needCutting;

  String get materialSizeValue => materialSizeController.text.trim();
  String get materialUsageValue => materialUsageController.text.trim();
  String get notesValue => notesController.text.trim();

  void dispose() {
    materialSizeController.dispose();
    materialUsageController.dispose();
    notesController.dispose();
  }
}

class _MaterialCard extends StatefulWidget {
  const _MaterialCard({
    super.key,
    required this.draft,
    required this.materials,
    required this.onRemove,
  });

  final _MaterialDraft draft;
  final List<MaterialItem> materials;
  final VoidCallback onRemove;

  @override
  State<_MaterialCard> createState() => _MaterialCardState();
}

class _MaterialCardState extends State<_MaterialCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final draft = widget.draft;
    return Card(
      margin: EdgeInsets.only(bottom: sectionSpacing),
      child: Padding(
        padding: EdgeInsets.all(sectionSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SearchableDropdownFormField<int>(
                    initialValue: draft.materialId,
                    decoration: const InputDecoration(labelText: '物料'),
                    items: widget.materials
                        .map(
                          (material) => DropdownMenuItem(
                            value: material.id,
                            child: Text('${material.code} ${material.name}'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => draft.materialId = value),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: '移除物料',
                  color: theme.colorScheme.error,
                ),
              ],
            ),
            SizedBox(height: sectionSpacing),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: draft.materialSizeController,
                    decoration: const InputDecoration(labelText: '尺寸'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: draft.materialUsageController,
                    decoration: const InputDecoration(labelText: '用量'),
                  ),
                ),
              ],
            ),
            SizedBox(height: sectionSpacing),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('需要开料'),
              value: draft.needCutting,
              onChanged: (value) => setState(() => draft.needCutting = value),
            ),
            SizedBox(height: sectionSpacing),
            TextFormField(
              controller: draft.notesController,
              decoration: const InputDecoration(labelText: '备注'),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
