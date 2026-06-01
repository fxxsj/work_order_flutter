import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_drawer_edit_panel.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/image_gallery_upload_section.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/image_upload_config.dart';
import 'package:work_order_app/src/core/utils/image_upload_flow.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/materials/presentation/widgets/quick_material_create_dialog.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_api_service.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';
import 'package:work_order_app/src/features/product_materials/data/product_material_api_service.dart';
import 'package:work_order_app/src/features/products/application/product_view_model.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

Future<bool> showProductEditDrawer(
  BuildContext context, {
  required ProductViewModel viewModel,
  Product? product,
}) async {
  var saved = false;
  await showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: product == null ? '新建产品' : '编辑产品',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: ChangeNotifierProvider<ProductViewModel>.value(
      value: viewModel,
      child: ProductEditPage(product: product, onSaved: () => saved = true),
    ),
  );
  return saved;
}

class ProductEditPage extends StatefulWidget {
  const ProductEditPage({super.key, this.product, this.onSaved});

  final Product? product;
  final VoidCallback? onSaved;

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
  static const String _addMaterialText = '添加物料';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
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
  bool _uploadingImage = false;
  Product? _savedProduct;
  final List<ProductImage> _images = [];

  bool get _isLoading => _loadingOptions || _loadingDetail;
  Product? get _product => _savedProduct ?? widget.product;

  @override
  void initState() {
    super.initState();
    final apiClient = context.read<ApiClient>();
    _productApi = ProductApiService(apiClient);
    _productGroupApi = ProductGroupApiService(apiClient);
    _processApi = ProcessApiService(apiClient);
    _materialApi = MaterialApiService(apiClient);
    _productMaterialApi = ProductMaterialApiService(apiClient);

    final product = _product;
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
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _productType = product?.productType ?? 'single';
    _productGroupId = product?.productGroupId;
    _processIds = List<int>.from(product?.defaultProcessIds ?? const []);
    _materialDrafts.addAll(
      (product?.defaultMaterials ?? const []).map(
        (item) => _MaterialDraft.fromItem(item),
      ),
    );
    _images.addAll(product?.images ?? const []);
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
        pageSize: 50,
        isActive: true,
      );
      final processFuture = _processApi.fetchProcesses(page: 1, pageSize: 50);
      final materialFuture = _materialApi.fetchMaterials(page: 1, pageSize: 50);
      final groupPage = await productGroupFuture;
      final processPage = await processFuture;
      final materialPage = await materialFuture;
      if (!mounted) return;
      setState(() {
        _productGroups = groupPage.items
            .map((item) => item.toEntity())
            .toList();
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
    _images
      ..clear()
      ..addAll(detail.images);
    _isActive = detail.isActive ?? _isActive;
    _savedProduct = detail;
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

  void _toggleProcess(int processId) {
    setState(() {
      if (_processIds.contains(processId)) {
        _processIds.remove(processId);
      } else {
        _processIds.add(processId);
      }
    });
  }

  Future<MaterialItem?> _handleCreateMaterial() async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.add_material')) {
      ToastUtil.showError('当前账号无权新增物料');
      return null;
    }

    final created = await showQuickMaterialCreateDialog(
      context: context,
      materialApi: _materialApi,
    );
    if (created == null || !mounted) {
      return null;
    }

    setState(() {
      _materials = List<MaterialItem>.from(_materials)
        ..removeWhere((item) => item.id == created.id)
        ..add(created)
        ..sort((left, right) {
          final leftLabel = '${left.code} ${left.name}';
          final rightLabel = '${right.code} ${right.name}';
          return leftLabel.compareTo(rightLabel);
        });
    });
    ToastUtil.showSuccess('物料已新增');
    return created;
  }

  Future<bool> _saveProductMaterials(int productId) async {
    var hasError = false;
    try {
      final existing = await _productMaterialApi.fetchProductMaterials(
        page: 1,
        pageSize: 50,
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

  Product _buildPayload() {
    final currentProduct = _product;
    final description = _descriptionController.text.trim();
    return Product(
      id: currentProduct?.id ?? 0,
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
      stockQuantity: _parseInt(_stockController.text),
      minStockQuantity: _parseInt(_minStockController.text),
      description: description.isEmpty ? null : description,
      isActive: _isActive,
      defaultProcessIds: _processIds,
      productTypeDisplay: currentProduct?.productTypeDisplay,
      productGroupName: currentProduct?.productGroupName,
      productGroupCode: currentProduct?.productGroupCode,
      defaultMaterials: currentProduct?.defaultMaterials ?? const [],
      images: _images,
    );
  }

  Future<Product> _persistProduct(ProductViewModel viewModel) async {
    if (_productType != 'single' && _productGroupId == null) {
      throw StateError('请选择产品组');
    }
    // 前端验证
    final unitPrice = _parseDouble(_unitPriceController.text);
    if (unitPrice != null && (unitPrice < 0 || unitPrice > 99999999.99)) {
      throw StateError('单价需在0-99,999,999.99之间');
    }
    final stockQuantity = _parseInt(_stockController.text);
    if (stockQuantity != null && stockQuantity < 0) {
      throw StateError('库存数量不能为负数');
    }
    final minStockQuantity = _parseInt(_minStockController.text);
    if (minStockQuantity != null && minStockQuantity < 0) {
      throw StateError('最小库存不能为负数');
    }
    if (stockQuantity != null &&
        minStockQuantity != null &&
        minStockQuantity > stockQuantity) {
      throw StateError('最小库存不能大于库存数量');
    }
    final payload = _buildPayload();
    final savedProduct = _product == null
        ? await viewModel.createProduct(payload)
        : await viewModel.updateProduct(payload);
    final materialErrors = await _saveProductMaterials(savedProduct.id);
    if (materialErrors) {
      ToastUtil.showError('部分物料保存失败');
    }
    if (mounted) {
      setState(() => _savedProduct = savedProduct);
    }
    return savedProduct;
  }

  Future<void> _handleSubmit(ProductViewModel viewModel) async {
    try {
      await _persistProduct(viewModel);
    } on StateError catch (err) {
      ToastUtil.showError(err.toString().replaceFirst('Bad state: ', ''));
    }
  }

  Future<void> _pickAndUploadImage(ProductViewModel viewModel) async {
    await pickAndUploadImageForResource<Product, ProductImage>(
      imageCount: _images.length,
      fallbackFilename: 'product_image.jpg',
      isMounted: () => mounted,
      setUploading: (value) => setState(() => _uploadingImage = value),
      persistResource: () => _persistProduct(viewModel),
      resourceIdOf: (product) => product.id,
      uploadImage: (productId, imageFile, sortOrder) => viewModel
          .uploadProductImage(productId, imageFile, sortOrder: sortOrder),
      addImage: (image) => setState(() => _images.add(image)),
    );
  }

  Future<void> _removeImage(
    ProductViewModel viewModel,
    ProductImage image,
  ) async {
    await removeImageFromResource<Product, ProductImage>(
      resource: _product,
      image: image,
      isMounted: () => mounted,
      resourceIdOf: (product) => product.id,
      imageIdOf: (item) => item.id,
      deleteImage: viewModel.deleteProductImage,
      removeImage: (item) => setState(() => _images.remove(item)),
    );
  }

  double? _parseDouble(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  int? _parseInt(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  Widget _buildLoadingState(BuildContext context) {
    return const SizedBox(
      height: 240,
      child: Center(child: CircularProgressIndicator()),
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
                  onCreateMaterial: _handleCreateMaterial,
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

  Widget _buildProcessSection(BuildContext context) {
    final theme = Theme.of(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _defaultProcessTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: sectionSpacing),
        if (_processes.isEmpty)
          Text('暂无可选工序', style: theme.textTheme.bodySmall)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _processes
                .map(
                  (process) => FilterChip(
                    label: Text(
                      process.isActive ? process.name : '${process.name}（已停用）',
                    ),
                    selected: _processIds.contains(process.id),
                    onSelected: process.isActive
                        ? (_) => _toggleProcess(process.id)
                        : null,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildFieldPair(
    BuildContext context, {
    required Widget first,
    required Widget second,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: SpacingTokens.md),
        Expanded(child: second),
      ],
    );
  }

  Widget _buildBasicSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CrudFieldConfig.text(
          label: _codeLabel,
          controller: _codeController,
          enabled: widget.product == null,
          hintText: '请输入编码（留空自动生成）',
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return null;
            if (text.length < 2 || text.length > 50) {
              return _codeLengthText;
            }
            if (!RegExp(r'^[A-Za-z0-9-]+$').hasMatch(text)) {
              return _codeInvalidText;
            }
            return null;
          },
        ).build(context),
        const SizedBox(height: SpacingTokens.md),
        _buildFieldPair(
          context,
          first: CrudFieldConfig.text(
            label: _nameLabel,
            controller: _nameController,
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return _nameRequiredText;
              if (text.length > 200) return '产品名称最多200个字符';
              return null;
            },
          ).build(context),
          second: CrudFieldConfig.dropdown(
            fieldKey: ValueKey(_productType),
            label: _productTypeLabel,
            value: _productType,
            options: _productTypeLabels.entries
                .map(
                  (entry) =>
                      AppDropdownOption(value: entry.key, label: entry.value),
                )
                .toList(),
            onChanged: (value) => _handleProductTypeChange(value as String?),
          ).build(context),
        ),
        if (_productType != 'single') ...[
          const SizedBox(height: SpacingTokens.md),
          CrudFieldConfig.dropdown(
            fieldKey: ValueKey('${_productType}_${_productGroupId ?? ''}'),
            label: _productGroupLabel,
            value: _productGroupId,
            options: _productGroups
                .map(
                  (group) => AppDropdownOption(
                    value: group.id,
                    label: '${group.code} ${group.name}',
                  ),
                )
                .toList(),
            onChanged: (value) =>
                setState(() => _productGroupId = value as int?),
            validator: (value) =>
                _productType != 'single' && value == null ? '请选择产品组' : null,
          ).build(context),
        ],
        const SizedBox(height: SpacingTokens.md),
        CrudFieldConfig.text(
          label: _specLabel,
          controller: _specController,
        ).build(context),
      ],
    );
  }

  Widget _buildExtraSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFieldPair(
          context,
          first: CrudFieldConfig.text(
            label: _unitLabel,
            controller: _unitController,
          ).build(context),
          second: CrudFieldConfig.number(
            label: _unitPriceLabel,
            controller: _unitPriceController,
            decimal: true,
          ).build(context),
        ),
        const SizedBox(height: SpacingTokens.md),
        _buildFieldPair(
          context,
          first: CrudFieldConfig.number(
            label: _stockLabel,
            controller: _stockController,
            decimal: true,
          ).build(context),
          second: CrudFieldConfig.number(
            label: _minStockLabel,
            controller: _minStockController,
            decimal: true,
          ).build(context),
        ),
        const SizedBox(height: SpacingTokens.md),
        CrudFieldConfig.textarea(
          label: _descriptionLabel,
          controller: _descriptionController,
          maxLines: 3,
        ).build(context),
        const SizedBox(height: SpacingTokens.md),
        CrudFieldConfig.toggle(
          label: _statusLabel,
          value: _isActive,
          onChanged: (value) => setState(() => _isActive = value),
        ).build(context),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return ImageGalleryUploadSection<ProductImage>(
      images: _images,
      canUpload: true,
      uploading: _uploadingImage,
      maxCount: ImageUploadConfig.maxCount,
      limitHintText: ImageUploadConfig.limitHintText,
      unsavedHintText: '请先保存产品后再上传图片',
      emptyText: '暂无图片，点击下方按钮上传',
      imageUrlBuilder: (image) => image.imageUrl,
      descriptionBuilder: (image) => image.description,
      onUpload: () => _pickAndUploadImage(context.read<ProductViewModel>()),
      onDelete: (image) =>
          _removeImage(context.read<ProductViewModel>(), image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CrudDrawerEditPanel<Product, ProductViewModel>(
      item: _product,
      onSaved: widget.onSaved,
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
                fields: [CrudFieldConfig.custom(builder: _buildLoadingState)],
              ),
            ];
          }

          return [
            CrudFormSection(
              title: _basicSectionTitle,
              column: 0,
              fields: [CrudFieldConfig.custom(builder: _buildBasicSection)],
            ),
            CrudFormSection(
              title: _extraSectionTitle,
              column: isMobile ? 0 : 1,
              fields: [CrudFieldConfig.custom(builder: _buildExtraSection)],
            ),
            CrudFormSection(
              title: '图片管理',
              column: isMobile ? 0 : 1,
              fields: [CrudFieldConfig.custom(builder: _buildImageSection)],
            ),
            CrudFormSection(
              title: _configSectionTitle,
              column: 0,
              fields: [
                CrudFieldConfig.custom(builder: _buildProcessSection),
                CrudFieldConfig.custom(builder: _buildMaterialSection),
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
  }) : materialSizeController = TextEditingController(text: materialSize ?? ''),
       materialUsageController = TextEditingController(
         text: materialUsage ?? '',
       ),
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
    required this.onCreateMaterial,
    required this.onRemove,
  });

  final _MaterialDraft draft;
  final List<MaterialItem> materials;
  final Future<MaterialItem?> Function() onCreateMaterial;
  final VoidCallback onRemove;

  @override
  State<_MaterialCard> createState() => _MaterialCardState();
}

class _MaterialCardState extends State<_MaterialCard> {
  Future<void> _handleCreateMaterial() async {
    final created = await widget.onCreateMaterial();
    if (created == null || !mounted) {
      return;
    }
    setState(() => widget.draft.materialId = created.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final draft = widget.draft;
    final materialOptions = widget.materials
        .map(
          (material) => AppDropdownOption<int>(
            value: material.id,
            label: '${material.code} ${material.name}',
          ),
        )
        .toList();
    materialOptions.add(
      AppDropdownOption<int>(
        value: -1,
        label: '新增物料',
        icon: Icons.add,
        onSelected: _handleCreateMaterial,
      ),
    );

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
                  child: AppSelect<int>(
                    value: draft.materialId,
                    decoration: const InputDecoration(labelText: '物料'),
                    options: materialOptions,
                    selectHintText: widget.materials.isEmpty ? '新增物料' : '请选择',
                    minOptionsForSearch: 1,
                    onChanged: (value) =>
                        setState(() => draft.materialId = value),
                  ),
                ),
                if (widget.materials.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: SpacingTokens.sm),
                    child: TextButton.icon(
                      onPressed: _handleCreateMaterial,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('新增物料'),
                    ),
                  ),
                SizedBox(width: SpacingTokens.sm),
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
                  child: CrudFieldConfig.text(
                    label: '尺寸',
                    controller: draft.materialSizeController,
                  ).build(context),
                ),
                SizedBox(width: SpacingTokens.md),
                Expanded(
                  child: CrudFieldConfig.text(
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
            CrudFieldConfig.textarea(
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
