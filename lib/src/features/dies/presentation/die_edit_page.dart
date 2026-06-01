import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_drawer_edit_panel.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/image_gallery_upload_section.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/image_upload_config.dart';
import 'package:work_order_app/src/core/utils/image_upload_flow.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/dies/application/die_view_model.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/presentation/widgets/quick_product_create_dialog.dart';

Future<bool> showDieEditDrawer(
  BuildContext context, {
  required DieViewModel viewModel,
  Die? die,
}) async {
  var saved = false;
  await showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: die == null ? '新建刀模' : '编辑刀模',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: ChangeNotifierProvider<DieViewModel>.value(
      value: viewModel,
      child: DieEditPage(die: die, onSaved: () => saved = true),
    ),
  );
  return saved;
}

class DieEditPage extends StatefulWidget {
  const DieEditPage({super.key, this.die, this.onSaved});

  final Die? die;
  final VoidCallback? onSaved;

  @override
  State<DieEditPage> createState() => _DieEditPageState();
}

class _DieEditPageState extends State<DieEditPage> {
  static const String _codeLabel = '刀模编码';
  static const String _nameLabel = '刀模名称';
  static const String _typeLabel = '刀模类型';
  static const String _sizeLabel = '尺寸';
  static const String _materialLabel = '材质';
  static const String _thicknessLabel = '厚度';
  static const String _notesLabel = '备注';
  static const String _productSectionTitle = '包含产品及数量';
  static const String _addProductText = '添加产品';
  static const String _productLabel = '产品名称';
  static const String _quantityLabel = '拼版个数';
  static const String _imageSectionTitle = '图片管理';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _nameRequiredText = '请输入刀模名称';
  static const String _nameLengthText = '刀模名称不能超过200个字符';
  static const String _codeLengthText = '刀模编码不能超过50个字符';
  static const String _sizeLengthText = '尺寸不能超过100个字符';
  static const String _materialLengthText = '材质不能超过100个字符';
  static const String _thicknessLengthText = '厚度不能超过50个字符';
  static const String _quantityInvalidText = '拼版个数必须大于0';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';

  static const Map<String, String> _dieTypeLabels = {
    'combined': '拼版刀模',
    'dedicated': '专用刀模',
    'universal': '通用刀模',
  };

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _sizeController;
  late final TextEditingController _materialController;
  late final TextEditingController _thicknessController;
  late final TextEditingController _notesController;

  String _dieType = 'dedicated';
  ProductApiService? _productApi;
  bool _loadingProducts = false;
  final List<ProductOption> _productOptions = [];
  final List<_DieProductItem> _productItems = [];
  final List<DieImage> _images = [];
  bool _uploadingImage = false;
  Die? _savedDie;

  Die? get _die => _savedDie ?? widget.die;

  @override
  void initState() {
    super.initState();
    final die = _die;
    _codeController = TextEditingController(text: die?.code ?? '');
    _nameController = TextEditingController(text: die?.name ?? '');
    _sizeController = TextEditingController(text: die?.size ?? '');
    _materialController = TextEditingController(text: die?.material ?? '');
    _thicknessController = TextEditingController(text: die?.thickness ?? '');
    _notesController = TextEditingController(text: die?.notes ?? '');
    _dieType = die?.dieType ?? 'dedicated';
    _images.addAll(die?.images ?? const []);
    for (final product in die?.products ?? const <DieProduct>[]) {
      _productItems.add(
        _DieProductItem(
          productId: product.productId,
          quantity: product.quantity ?? 1,
        ),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _sizeController.dispose();
    _materialController.dispose();
    _thicknessController.dispose();
    _notesController.dispose();
    for (final item in _productItems) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_productApi != null) return;
    _productApi = ProductApiService(context.read<ApiClient>());
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loadingProducts = true);
    try {
      final products = await _productApi!.fetchProducts(isActive: true);
      if (!mounted) return;
      setState(() {
        _productOptions
          ..clear()
          ..addAll(products);
      });
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('加载产品列表失败: $err');
    } finally {
      if (mounted) {
        setState(() => _loadingProducts = false);
      }
    }
  }

  bool get _canAddMoreProducts {
    if (_dieType == 'dedicated') {
      return _productItems.length < 1;
    }
    return true;
  }

  void _addProductItem() {
    if (_die?.confirmed == true) {
      ToastUtil.showError('已确认的刀模不允许修改包含产品');
      return;
    }
    if (!_canAddMoreProducts) {
      ToastUtil.showError('专用刀模只能添加1个产品');
      return;
    }
    setState(() => _productItems.add(_DieProductItem(quantity: 1)));
  }

  void _removeProductItem(int index) {
    if (_die?.confirmed == true) {
      ToastUtil.showError('已确认的刀模不允许修改包含产品');
      return;
    }
    setState(() {
      _productItems[index].dispose();
      _productItems.removeAt(index);
    });
  }

  Future<ProductOption?> _handleCreateProduct() async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.add_product')) {
      ToastUtil.showError('当前账号无权新增产品');
      return null;
    }

    final productApi = _productApi;
    if (productApi == null) {
      ToastUtil.showError('产品数据尚未初始化');
      return null;
    }

    final created = await showQuickProductCreateDialog(
      context: context,
      productApi: productApi,
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
      _productOptions
        ..removeWhere((item) => item.id == option.id)
        ..add(option)
        ..sort(
          (left, right) => left.displayLabel.compareTo(right.displayLabel),
        );
    });
    ToastUtil.showSuccess('产品已新增');
    return option;
  }

  String _productNameFor(int? productId) {
    if (productId == null) return '';
    for (final product in _productOptions) {
      if (product.id == productId) return product.name;
    }
    return '';
  }

  Future<void> _handleDieTypeChange(String? value) async {
    if (value == null) return;
    if (_die?.confirmed == true) return;
    if (value == 'dedicated' && _productItems.length > 1) {
      final keepFirst = await showDialog<bool>(
        context: context,
        builder: (context) => AppDialog(
          title: '提示',
          maxWidth: LayoutTokens.dialogWidthSm,
          scrollable: false,
          content: const Text('专用刀模只能关联1个产品，是否只保留第一个产品？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('确定'),
            ),
          ],
        ),
      );
      if (keepFirst == true) {
        setState(() {
          _dieType = value;
          if (_productItems.length > 1) {
            for (var i = _productItems.length - 1; i >= 1; i--) {
              _productItems[i].dispose();
              _productItems.removeAt(i);
            }
          }
        });
      }
      return;
    }
    setState(() => _dieType = value);
  }

  Future<void> _handleSubmit(DieViewModel viewModel) async {
    await _persistDie(viewModel);
  }

  Future<Die> _persistDie(DieViewModel viewModel) async {
    final currentDie = _die;
    final code = _codeController.text.trim();
    final name = _nameController.text.trim();
    final size = _sizeController.text.trim();
    final material = _materialController.text.trim();
    final thickness = _thicknessController.text.trim();
    final notes = _notesController.text.trim();

    if (name.isEmpty) {
      throw Exception(_nameRequiredText);
    }
    if (name.length > 200) {
      throw Exception(_nameLengthText);
    }
    if (code.length > 50) {
      throw Exception(_codeLengthText);
    }
    if (size.length > 100) {
      throw Exception(_sizeLengthText);
    }
    if (material.length > 100) {
      throw Exception(_materialLengthText);
    }
    if (thickness.length > 50) {
      throw Exception(_thicknessLengthText);
    }

    final relationType = _dieType == 'combined' ? 'imposition' : 'exclusive';
    final products = _productItems
        .where((item) => item.productId != null)
        .map(
          (item) => DieProduct(
            productId: item.productId!,
            productName: _productNameFor(item.productId),
            quantity: item.quantity,
            relationType: relationType,
          ),
        )
        .toList();
    if (products.any((item) => (item.quantity ?? 0) < 1)) {
      throw Exception(_quantityInvalidText);
    }

    final payload = Die(
      id: currentDie?.id ?? 0,
      code: code.isEmpty ? null : code,
      name: name,
      dieType: _dieType,
      size: size,
      material: material,
      thickness: thickness,
      notes: notes,
      confirmed: currentDie?.confirmed ?? false,
      confirmedByName: currentDie?.confirmedByName,
      confirmedAt: currentDie?.confirmedAt,
      dieTypeDisplay: currentDie?.dieTypeDisplay,
      products: products,
      images: _images,
      createdAt: currentDie?.createdAt,
      updatedAt: currentDie?.updatedAt,
    );

    final saved = currentDie == null
        ? await viewModel.createDie(payload)
        : await viewModel.updateDie(payload);
    if (mounted) {
      setState(() => _savedDie = saved);
    }
    return saved;
  }

  String _productHint() {
    switch (_dieType) {
      case 'combined':
        return '拼版刀模：可添加多个产品，一次模切同时产出所有产品';
      case 'dedicated':
        return '专用刀模：只能添加1个产品，此刀模专属该产品使用';
      case 'universal':
        return '通用刀模：可添加多个产品，每次模切只产出其中一种';
      default:
        return '';
    }
  }

  Widget _buildProductSection(BuildContext context) {
    final isConfirmed = _die?.confirmed == true;
    final theme = Theme.of(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final colors = theme.extension<AppColors>();
    final subtleText = colors?.subtleText ?? theme.hintColor;
    final content = _productItems.isEmpty
        ? Text(
            '暂无产品项',
            style: theme.textTheme.bodySmall?.copyWith(color: subtleText),
          )
        : Column(
            children: List.generate(_productItems.length, (index) {
              final item = _productItems[index];
              final productOptions =
                  _productOptions
                      .map(
                        (product) => AppDropdownOption<int>(
                          value: product.id,
                          label: product.displayLabel,
                        ),
                      )
                      .toList()
                    ..add(
                      AppDropdownOption<int>(
                        value: -1,
                        label: '新增产品',
                        icon: Icons.add,
                        onSelected: () async {
                          final created = await _handleCreateProduct();
                          if (created == null || !mounted) return;
                          setState(() => item.productId = created.id);
                        },
                      ),
                    );
              return Padding(
                padding: EdgeInsets.only(bottom: sectionSpacing),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppSelect<int>(
                        value: item.productId,
                        decoration: const InputDecoration(
                          labelText: _productLabel,
                        ),
                        options: productOptions,
                        selectHintText: _productOptions.isEmpty
                            ? '新增产品'
                            : '请选择',
                        onChanged: isConfirmed
                            ? null
                            : (value) {
                                setState(() => item.productId = value);
                              },
                      ),
                    ),
                    if (_productOptions.isEmpty && !isConfirmed)
                      Padding(
                        padding: EdgeInsets.only(left: SpacingTokens.sm),
                        child: TextButton.icon(
                          onPressed: () async {
                            final created = await _handleCreateProduct();
                            if (created == null || !mounted) return;
                            setState(() => item.productId = created.id);
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('新增产品'),
                        ),
                      ),
                    SizedBox(width: SpacingTokens.md),
                    Expanded(
                      child: CrudFieldConfig.number(
                        label: _quantityLabel,
                        controller: item.quantityController,
                        enabled: !isConfirmed,
                        validator: (value) {
                          final quantity = int.tryParse(value?.trim() ?? '');
                          if (quantity == null || quantity < 1) {
                            return _quantityInvalidText;
                          }
                          return null;
                        },
                      ).build(context),
                    ),
                    SizedBox(width: SpacingTokens.sm),
                    IconButton(
                      tooltip: '移除',
                      icon: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error,
                      ),
                      onPressed: isConfirmed
                          ? null
                          : () => _removeProductItem(index),
                    ),
                  ],
                ),
              );
            }),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _productHint(),
          style: theme.textTheme.bodySmall?.copyWith(color: subtleText),
        ),
        SizedBox(height: sectionSpacing),
        if (_loadingProducts)
          const LinearProgressIndicator(minHeight: 2)
        else
          content,
        SizedBox(height: sectionSpacing),
        Align(
          alignment: Alignment.centerLeft,
          child: PageActionButton.outlined(
            onPressed: isConfirmed ? null : _addProductItem,
            icon: const Icon(Icons.add, size: 16),
            label: _addProductText,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final isConfirmed = _die?.confirmed == true;
    return ImageGalleryUploadSection<DieImage>(
      images: _images,
      canUpload: !isConfirmed,
      uploading: _uploadingImage,
      maxCount: ImageUploadConfig.maxCount,
      limitHintText: ImageUploadConfig.limitHintText,
      unsavedHintText: '请先保存刀模后再上传图片',
      emptyText: '暂无图片，点击下方按钮上传',
      imageUrlBuilder: (image) => image.imageUrl,
      descriptionBuilder: (image) => image.description,
      onUpload: () => _pickAndUploadImage(context.read<DieViewModel>()),
      onDelete: (image) => _removeImage(context.read<DieViewModel>(), image),
    );
  }

  Future<void> _pickAndUploadImage(DieViewModel viewModel) async {
    await pickAndUploadImageForResource<Die, DieImage>(
      imageCount: _images.length,
      fallbackFilename: 'die_image.jpg',
      isMounted: () => mounted,
      setUploading: (value) => setState(() => _uploadingImage = value),
      persistResource: () => _persistDie(viewModel),
      resourceIdOf: (die) => die.id,
      uploadImage: (dieId, imageFile, sortOrder) =>
          viewModel.uploadDieImage(dieId, imageFile, sortOrder: sortOrder),
      addImage: (image) => setState(() => _images.add(image)),
      isModificationBlocked: () => _die?.confirmed == true,
      blockedMessage: '已确认的刀模不允许修改图片',
    );
  }

  Future<void> _removeImage(DieViewModel viewModel, DieImage image) async {
    await removeImageFromResource<Die, DieImage>(
      resource: _die,
      image: image,
      isMounted: () => mounted,
      resourceIdOf: (die) => die.id,
      imageIdOf: (item) => item.id,
      deleteImage: viewModel.deleteDieImage,
      removeImage: (item) => setState(() => _images.remove(item)),
      isModificationBlocked: (die) => die.confirmed,
      blockedMessage: '已确认的刀模不允许修改图片',
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDie = _die;
    final isConfirmed = currentDie?.confirmed == true;

    return CrudDrawerEditPanel<Die, DieViewModel>(
      item: currentDie,
      onSaved: widget.onSaved,
      config: CrudEditConfig<Die, DieViewModel>(
        submitText: _submitText,
        submittingText: '保存中',
        errorMessagePrefix: _submitErrorText,
        sectionsBuilder: (context, isMobile) => [
          CrudFormSection(
            title: _basicSectionTitle,
            column: 0,
            fields: [
              CrudFieldConfig.text(
                label: _codeLabel,
                controller: _codeController,
                enabled: !isConfirmed,
                hintText: '留空则系统自动生成',
                validator: (value) {
                  if ((value?.trim().length ?? 0) > 50) {
                    return _codeLengthText;
                  }
                  return null;
                },
              ),
              CrudFieldConfig.text(
                label: _nameLabel,
                controller: _nameController,
                enabled: !isConfirmed,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return _nameRequiredText;
                  }
                  if (text.length > 200) {
                    return _nameLengthText;
                  }
                  return null;
                },
              ),
              CrudFieldConfig.dropdown(
                label: _typeLabel,
                value: _dieType,
                enabled: !isConfirmed,
                options: _dieTypeLabels.entries
                    .map(
                      (entry) => AppDropdownOption(
                        value: entry.key,
                        label: entry.value,
                      ),
                    )
                    .toList(),
                onChanged: isConfirmed
                    ? null
                    : (value) => _handleDieTypeChange(value as String?),
              ),
              CrudFieldConfig.text(
                label: _sizeLabel,
                controller: _sizeController,
                enabled: !isConfirmed,
                validator: (value) {
                  if ((value?.trim().length ?? 0) > 100) {
                    return _sizeLengthText;
                  }
                  return null;
                },
              ),
            ],
          ),
          CrudFormSection(
            title: _extraSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFieldConfig.text(
                label: _materialLabel,
                controller: _materialController,
                enabled: !isConfirmed,
                validator: (value) {
                  if ((value?.trim().length ?? 0) > 100) {
                    return _materialLengthText;
                  }
                  return null;
                },
              ),
              CrudFieldConfig.text(
                label: _thicknessLabel,
                controller: _thicknessController,
                enabled: !isConfirmed,
                validator: (value) {
                  if ((value?.trim().length ?? 0) > 50) {
                    return _thicknessLengthText;
                  }
                  return null;
                },
              ),
              CrudFieldConfig.textarea(
                label: _notesLabel,
                controller: _notesController,
                maxLines: 3,
              ),
            ],
          ),
          CrudFormSection(
            title: _productSectionTitle,
            column: 0,
            fields: [CrudFieldConfig.custom(builder: _buildProductSection)],
          ),
          CrudFormSection(
            title: _imageSectionTitle,
            column: 0,
            fields: [CrudFieldConfig.custom(builder: _buildImageSection)],
          ),
        ],
        onSave: (context, viewModel, item) => _handleSubmit(viewModel),
      ),
    );
  }
}

class _DieProductItem {
  _DieProductItem({this.productId, int quantity = 1})
    : quantityController = TextEditingController(text: quantity.toString());

  int? productId;
  final TextEditingController quantityController;

  int get quantity => int.tryParse(quantityController.text.trim()) ?? 1;

  void dispose() {
    quantityController.dispose();
  }
}
