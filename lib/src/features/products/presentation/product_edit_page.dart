import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_api_service.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';
import 'package:work_order_app/src/features/product_materials/data/product_material_api_service.dart';
import 'package:work_order_app/src/features/products/application/product_view_model.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

class ProductEditPage extends StatefulWidget {
  const ProductEditPage({super.key, this.product});

  final Product? product;

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
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
  bool _loadingOptions = false;
  bool _loadingDetail = false;

  bool get _isLoading => _loadingOptions || _loadingDetail;

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
      if (mounted) {
        setState(() => _loadingOptions = false);
      }
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
      if (mounted) {
        setState(() => _loadingDetail = false);
      }
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
    for (final draft in _materialDrafts) {
      draft.dispose();
    }
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
    if (_productType != 'single' && _productGroupId == null) {
      ToastUtil.showError('请选择产品组');
      return;
    }

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

    final savedProduct = widget.product == null
        ? await viewModel.createProduct(payload)
        : await viewModel.updateProduct(payload);
    final materialErrors = await _saveProductMaterials(savedProduct.id);
    if (materialErrors) {
      ToastUtil.showError('部分物料保存失败');
    }
  }

  double? _parseDouble(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  Widget _buildLoadingState(BuildContext context) {
    return const SizedBox(
      height: 240,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildMaterialSection(BuildContext context) {
    final theme = Theme.of(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _defaultMaterialTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
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
  }

  @override
  Widget build(BuildContext context) {
    return CrudEditPage<Product, ProductViewModel>(
      item: widget.product,
      config: CrudEditConfig<Product, ProductViewModel>(
        submitText: _submitText,
        submittingText: '保存中',
        errorMessagePrefix: _submitErrorText,
        canSave: (context, viewModel, item) => !_isLoading,
        sectionsBuilder: (context, isMobile) {
          if (_isLoading) {
            return [
              CrudFormSection(
                title: '',
                fields: [
                  CrudFormField.custom(
                    builder: _buildLoadingState,
                  ),
                ],
              ),
            ];
          }

          return [
            CrudFormSection(
              title: _basicSectionTitle,
              column: 0,
              fields: [
                CrudFormField.text(
                  label: _codeLabel,
                  controller: _codeController,
                  enabled: widget.product == null,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return _codeRequiredText;
                    if (text.length < 2 || text.length > 50) {
                      return _codeLengthText;
                    }
                    if (!RegExp(r'^[A-Za-z0-9-]+$').hasMatch(text)) {
                      return _codeInvalidText;
                    }
                    return null;
                  },
                ),
                CrudFormField.text(
                  label: _nameLabel,
                  controller: _nameController,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return _nameRequiredText;
                    return null;
                  },
                ),
                CrudFormField.dropdown(
                  fieldKey: ValueKey(_productType),
                  label: _productTypeLabel,
                  value: _productType,
                  options: _productTypeLabels.entries
                      .map(
                        (entry) => CrudFieldOption(
                          value: entry.key,
                          label: entry.value,
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      _handleProductTypeChange(value as String?),
                ),
                if (_productType != 'single')
                  CrudFormField.dropdown(
                    fieldKey:
                        ValueKey('${_productType}_${_productGroupId ?? ''}'),
                    label: _productGroupLabel,
                    value: _productGroupId,
                    options: _productGroups
                        .map(
                          (group) => CrudFieldOption(
                            value: group.id,
                            label: '${group.code} ${group.name}',
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _productGroupId = value as int?),
                    validator: (value) =>
                        _productType != 'single' && value == null
                            ? '请选择产品组'
                            : null,
                  ),
                CrudFormField.text(
                  label: _specLabel,
                  controller: _specController,
                ),
              ],
            ),
            CrudFormSection(
              title: _extraSectionTitle,
              column: isMobile ? 0 : 1,
              fields: [
                CrudFormField.text(
                  label: _unitLabel,
                  controller: _unitController,
                ),
                CrudFormField.number(
                  label: _unitPriceLabel,
                  controller: _unitPriceController,
                  decimal: true,
                ),
                CrudFormField.number(
                  label: _stockLabel,
                  controller: _stockController,
                  decimal: true,
                ),
                CrudFormField.number(
                  label: _minStockLabel,
                  controller: _minStockController,
                  decimal: true,
                ),
                CrudFormField.textarea(
                  label: _descriptionLabel,
                  controller: _descriptionController,
                  maxLines: 3,
                ),
                CrudFormField.toggle(
                  label: _statusLabel,
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                ),
              ],
            ),
            CrudFormSection(
              title: _configSectionTitle,
              column: 0,
              fields: [
                CrudFormField.multiSelect(
                  label: _defaultProcessTitle,
                  options: _processes
                      .map(
                        (process) => CrudFieldOption<dynamic>(
                          value: process.id,
                          label: process.isActive
                              ? process.name
                              : '${process.name}（已停用）',
                          enabled: process.isActive,
                        ),
                      )
                      .toList(),
                  values: _processIds.toSet(),
                  hintText: _processPlaceholder,
                  searchHintText: _processSearchHint,
                  noResultsText: _emptyMatchText,
                  onChanged: (values) {
                    setState(() {
                      _processIds = values.cast<int>().toList();
                    });
                  },
                ),
                CrudFormField.custom(
                  builder: _buildMaterialSection,
                ),
              ],
            ),
          ];
        },
        onSave: (context, viewModel, item) => _handleSubmit(viewModel),
      ),
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
                  child: UnifiedDropdown<int>(
                    value: draft.materialId,
                    decoration: const InputDecoration(labelText: '物料'),
                    options: widget.materials
                        .map(
                          (material) => DropdownOption(
                            value: material.id,
                            label: '${material.code} ${material.name}',
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => draft.materialId = value),
                  ),
                ),
                SizedBox(width: LayoutTokens.gapSm),
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
                  child: CrudFormField.text(
                    label: '尺寸',
                    controller: draft.materialSizeController,
                  ).build(context),
                ),
                SizedBox(width: LayoutTokens.gapMd),
                Expanded(
                  child: CrudFormField.text(
                    label: '用量',
                    controller: draft.materialUsageController,
                  ).build(context),
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
            CrudFormField.textarea(
              label: '备注',
              controller: draft.notesController,
              maxLines: 2,
            ).build(context),
          ],
        ),
      ),
    );
  }
}
