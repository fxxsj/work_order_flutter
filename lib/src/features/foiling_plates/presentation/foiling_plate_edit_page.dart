import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
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
import 'package:work_order_app/src/features/foiling_plates/application/foiling_plate_view_model.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/presentation/widgets/quick_product_create_dialog.dart';

Future<bool> showFoilingPlateEditDrawer(
  BuildContext context, {
  required FoilingPlateViewModel viewModel,
  FoilingPlate? plate,
}) async {
  var saved = false;
  await showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: plate == null ? '新建烫金版' : '编辑烫金版',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: ChangeNotifierProvider<FoilingPlateViewModel>.value(
      value: viewModel,
      child: FoilingPlateEditPage(plate: plate, onSaved: () => saved = true),
    ),
  );
  return saved;
}

class FoilingPlateEditPage extends StatefulWidget {
  const FoilingPlateEditPage({super.key, this.plate, this.onSaved});

  final FoilingPlate? plate;
  final VoidCallback? onSaved;

  @override
  State<FoilingPlateEditPage> createState() => _FoilingPlateEditPageState();
}

class _FoilingPlateEditPageState extends State<FoilingPlateEditPage> {
  static const String _codeLabel = '烫金版编码';
  static const String _nameLabel = '烫金版名称';
  static const String _typeLabel = '类型';
  static const String _sizeLabel = '尺寸';
  static const String _materialLabel = '材质';
  static const String _thicknessLabel = '厚度';
  static const String _notesLabel = '备注';
  static const String _productSectionTitle = '包含产品及数量';
  static const String _addProductText = '添加产品';
  static const String _productLabel = '产品名称';
  static const String _quantityLabel = '数量';
  static const String _imageSectionTitle = '图片管理';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _nameRequiredText = '请输入烫金版名称';
  static const String _nameLengthText = '烫金版名称不能超过200个字符';
  static const String _codeLengthText = '烫金版编码不能超过50个字符';
  static const String _sizeLengthText = '尺寸不能超过100个字符';
  static const String _materialLengthText = '材质不能超过100个字符';
  static const String _thicknessLengthText = '厚度不能超过50个字符';
  static const String _quantityInvalidText = '数量必须大于0';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _sizeController;
  late final TextEditingController _materialController;
  late final TextEditingController _thicknessController;
  late final TextEditingController _notesController;

  String _foilingType = 'gold';
  ProductApiService? _productApi;
  bool _loadingProducts = false;
  final List<ProductOption> _productOptions = [];
  final List<_PlateProductItem> _productItems = [];
  final List<FoilingPlateImage> _images = [];
  bool _uploadingImage = false;
  FoilingPlate? _savedPlate;

  FoilingPlate? get _plate => _savedPlate ?? widget.plate;

  @override
  void initState() {
    super.initState();
    final plate = _plate;
    _codeController = TextEditingController(text: plate?.code ?? '');
    _nameController = TextEditingController(text: plate?.name ?? '');
    _sizeController = TextEditingController(text: plate?.size ?? '');
    _materialController = TextEditingController(text: plate?.material ?? '');
    _thicknessController = TextEditingController(text: plate?.thickness ?? '');
    _notesController = TextEditingController(text: plate?.notes ?? '');
    _foilingType = plate?.foilingType ?? 'gold';
    _images.addAll(plate?.images ?? const []);
    for (final product in plate?.products ?? const <FoilingPlateProduct>[]) {
      _productItems.add(
        _PlateProductItem(
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

  void _addProductItem() {
    if (_plate?.confirmed == true) {
      ToastUtil.showError('已确认的烫金版不允许修改包含产品');
      return;
    }
    setState(() => _productItems.add(_PlateProductItem(quantity: 1)));
  }

  void _removeProductItem(int index) {
    if (_plate?.confirmed == true) {
      ToastUtil.showError('已确认的烫金版不允许修改包含产品');
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

  Future<void> _handleSubmit(FoilingPlateViewModel viewModel) async {
    await _persistPlate(viewModel);
  }

  Future<FoilingPlate> _persistPlate(FoilingPlateViewModel viewModel) async {
    final currentPlate = _plate;
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

    final products = _productItems
        .where((item) => item.productId != null)
        .map(
          (item) => FoilingPlateProduct(
            productId: item.productId!,
            productName: _productNameFor(item.productId),
            quantity: item.quantity,
          ),
        )
        .toList();
    if (products.any((item) => (item.quantity ?? 0) < 1)) {
      throw Exception(_quantityInvalidText);
    }

    final payload = FoilingPlate(
      id: currentPlate?.id ?? 0,
      code: code.isEmpty ? null : code,
      name: name,
      foilingType: _foilingType,
      size: size,
      material: material,
      thickness: thickness,
      notes: notes,
      confirmed: currentPlate?.confirmed ?? false,
      confirmedByName: currentPlate?.confirmedByName,
      confirmedAt: currentPlate?.confirmedAt,
      products: products,
      images: _images,
      createdAt: currentPlate?.createdAt,
      updatedAt: currentPlate?.updatedAt,
    );

    final saved = currentPlate == null
        ? await viewModel.createFoilingPlate(payload)
        : await viewModel.updateFoilingPlate(payload);
    if (mounted) {
      setState(() => _savedPlate = saved);
    }
    return saved;
  }

  Widget _buildProductSection(BuildContext context) {
    final isConfirmed = _plate?.confirmed == true;
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
    final isConfirmed = _plate?.confirmed == true;
    return ImageGalleryUploadSection<FoilingPlateImage>(
      images: _images,
      canUpload: !isConfirmed,
      uploading: _uploadingImage,
      maxCount: ImageUploadConfig.maxCount,
      limitHintText: ImageUploadConfig.limitHintText,
      unsavedHintText: '请先保存烫金版后再上传图片',
      emptyText: '暂无图片，点击下方按钮上传',
      imageUrlBuilder: (image) => image.imageUrl,
      descriptionBuilder: (image) => image.description,
      onUpload: () =>
          _pickAndUploadImage(context.read<FoilingPlateViewModel>()),
      onDelete: (image) =>
          _removeImage(context.read<FoilingPlateViewModel>(), image),
    );
  }

  Future<void> _pickAndUploadImage(FoilingPlateViewModel viewModel) async {
    await pickAndUploadImageForResource<FoilingPlate, FoilingPlateImage>(
      imageCount: _images.length,
      fallbackFilename: 'foiling_plate_image.jpg',
      isMounted: () => mounted,
      setUploading: (value) => setState(() => _uploadingImage = value),
      persistResource: () => _persistPlate(viewModel),
      resourceIdOf: (plate) => plate.id,
      uploadImage: (plateId, imageFile, sortOrder) => viewModel
          .uploadFoilingPlateImage(plateId, imageFile, sortOrder: sortOrder),
      addImage: (image) => setState(() => _images.add(image)),
      isModificationBlocked: () => _plate?.confirmed == true,
      blockedMessage: '已确认的烫金版不允许修改图片',
    );
  }

  Future<void> _removeImage(
    FoilingPlateViewModel viewModel,
    FoilingPlateImage image,
  ) async {
    await removeImageFromResource<FoilingPlate, FoilingPlateImage>(
      resource: _plate,
      image: image,
      isMounted: () => mounted,
      resourceIdOf: (plate) => plate.id,
      imageIdOf: (item) => item.id,
      deleteImage: viewModel.deleteFoilingPlateImage,
      removeImage: (item) => setState(() => _images.remove(item)),
      isModificationBlocked: (plate) => plate.confirmed,
      blockedMessage: '已确认的烫金版不允许修改图片',
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPlate = _plate;
    final isConfirmed = currentPlate?.confirmed == true;

    return CrudDrawerEditPanel<FoilingPlate, FoilingPlateViewModel>(
      item: currentPlate,
      onSaved: widget.onSaved,
      config: CrudEditConfig<FoilingPlate, FoilingPlateViewModel>(
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
                value: _foilingType,
                options: const [
                  AppDropdownOption(value: 'gold', label: '烫金'),
                  AppDropdownOption(value: 'silver', label: '烫银'),
                ],
                enabled: !isConfirmed,
                onChanged: isConfirmed
                    ? null
                    : (value) {
                        if (value == null) return;
                        setState(() => _foilingType = value as String);
                      },
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

class _PlateProductItem {
  _PlateProductItem({this.productId, int quantity = 1})
    : quantityController = TextEditingController(text: quantity.toString());

  int? productId;
  final TextEditingController quantityController;

  int get quantity => int.tryParse(quantityController.text.trim()) ?? 1;

  void dispose() {
    quantityController.dispose();
  }
}
