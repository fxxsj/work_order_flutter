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
import 'package:work_order_app/src/core/utils/file_upload_picker.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/artworks/application/artwork_view_model.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/dies/data/die_api_service.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_api_service.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_api_service.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/presentation/widgets/quick_product_create_dialog.dart';

Future<bool> showArtworkEditDrawer(
  BuildContext context, {
  required ArtworkViewModel viewModel,
  Artwork? artwork,
}) async {
  var saved = false;
  await showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: artwork == null ? '新建图稿' : '编辑图稿',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: ChangeNotifierProvider<ArtworkViewModel>.value(
      value: viewModel,
      child: ArtworkEditPage(
        artwork: artwork,
        onSaved: () => saved = true,
      ),
    ),
  );
  return saved;
}

class ArtworkEditPage extends StatefulWidget {
  const ArtworkEditPage({super.key, this.artwork, this.onSaved});

  final Artwork? artwork;
  final VoidCallback? onSaved;

  @override
  State<ArtworkEditPage> createState() => _ArtworkEditPageState();
}

class _ArtworkEditPageState extends State<ArtworkEditPage> {
  static const int _maxImageCount = 12;
  static const int _maxImageBytes = 10 * 1024 * 1024;
  static const String _baseCodeLabel = '图稿主编码';
  static const String _versionLabel = '版本号';
  static const String _nameLabel = '图稿名称';
  static const String _cmykLabel = 'CMYK颜色';
  static const String _otherColorsLabel = '其他颜色';
  static const String _impositionLabel = '拼版尺寸';
  static const String _dieLabel = '关联刀模';
  static const String _foilingLabel = '关联烫金版';
  static const String _embossingLabel = '关联压凸版';
  static const String _productSectionTitle = '包含产品及拼版数量';
  static const String _addProductText = '添加产品';
  static const String _productLabel = '产品名称';
  static const String _quantityLabel = '拼版数量';
  static const String _notesLabel = '备注';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _nameRequiredText = '请输入图稿名称';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _diePlaceholder = '请选择刀模（可多选）';
  static const String _foilingPlaceholder = '请选择烫金版（可多选）';
  static const String _embossingPlaceholder = '请选择压凸版（可多选）';

  late final TextEditingController _baseCodeController;
  late final TextEditingController _nameController;
  late final TextEditingController _impositionController;
  late final TextEditingController _notesController;

  final Set<String> _cmykColors = {'C', 'M', 'Y', 'K'};
  final Set<String> _selectedCmyk = {};
  final List<String> _otherColors = [];
  ProductApiService? _productApi;
  DieApiService? _dieApi;
  FoilingPlateApiService? _foilingApi;
  EmbossingPlateApiService? _embossingApi;
  bool _loadingPicklists = false;
  final List<ProductOption> _productOptions = [];
  final List<Die> _dieOptions = [];
  final List<FoilingPlate> _foilingOptions = [];
  final List<EmbossingPlate> _embossingOptions = [];
  final Set<int> _selectedDieIds = {};
  final Set<int> _selectedFoilingIds = {};
  final Set<int> _selectedEmbossingIds = {};
  final List<_ArtworkProductItem> _productItems = [];
  final List<ArtworkImage> _images = [];
  bool _uploadingImage = false;
  Artwork? _savedArtwork;

  Artwork? get _artwork => _savedArtwork ?? widget.artwork;

  @override
  void initState() {
    super.initState();
    final artwork = _artwork;
    _baseCodeController = TextEditingController(text: artwork?.baseCode ?? '');
    _nameController = TextEditingController(text: artwork?.name ?? '');
    _impositionController =
        TextEditingController(text: artwork?.impositionSize ?? '');
    _notesController = TextEditingController(text: artwork?.notes ?? '');
    _selectedCmyk.addAll(artwork?.cmykColors ?? const []);
    _otherColors.addAll(artwork?.otherColors ?? const []);
    _selectedDieIds.addAll(artwork?.dieIds ?? const []);
    _selectedFoilingIds.addAll(artwork?.foilingPlateIds ?? const []);
    _selectedEmbossingIds.addAll(artwork?.embossingPlateIds ?? const []);
    _images.addAll(artwork?.images ?? const []);
    for (final product in artwork?.products ?? const <ArtworkProduct>[]) {
      _productItems.add(
        _ArtworkProductItem(
          productId: product.productId,
          quantity: product.impositionQuantity ?? 1,
        ),
      );
    }
  }

  @override
  void dispose() {
    _baseCodeController.dispose();
    _nameController.dispose();
    _impositionController.dispose();
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
    final apiClient = context.read<ApiClient>();
    _productApi = ProductApiService(apiClient);
    _dieApi = DieApiService(apiClient);
    _foilingApi = FoilingPlateApiService(apiClient);
    _embossingApi = EmbossingPlateApiService(apiClient);
    _loadPicklists();
  }

  Future<void> _loadPicklists() async {
    setState(() => _loadingPicklists = true);
    try {
      final products = await _productApi!.fetchProducts(isActive: true);
      final dies = await _dieApi!.fetchDies(pageSize: 50);
      final foiling = await _foilingApi!.fetchFoilingPlates(pageSize: 50);
      final embossing =
          await _embossingApi!.fetchEmbossingPlates(pageSize: 50);
      if (!mounted) return;
      setState(() {
        _productOptions
          ..clear()
          ..addAll(products);
        _dieOptions
          ..clear()
          ..addAll(dies.items.map((dto) => dto.toEntity()));
        _foilingOptions
          ..clear()
          ..addAll(foiling.items.map((dto) => dto.toEntity()));
        _embossingOptions
          ..clear()
          ..addAll(embossing.items.map((dto) => dto.toEntity()));
      });
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('加载下拉列表失败: $err');
    } finally {
      if (mounted) {
        setState(() => _loadingPicklists = false);
      }
    }
  }

  void _addProductItem() {
    setState(() => _productItems.add(_ArtworkProductItem(quantity: 1)));
  }

  void _removeProductItem(int index) {
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
            (left, right) => left.displayLabel.compareTo(right.displayLabel));
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

  String _optionLabel(String name, String? code) {
    final trimmed = code?.trim() ?? '';
    if (trimmed.isEmpty) return name;
    return '$name ($trimmed)';
  }

  Future<void> _handleSubmit(ArtworkViewModel viewModel) async {
    await _persistArtwork(viewModel);
  }

  Future<Artwork> _persistArtwork(ArtworkViewModel viewModel) async {
    final currentArtwork = _artwork;
    final products = _productItems
        .where((item) => item.productId != null)
        .map(
          (item) => ArtworkProduct(
            productId: item.productId!,
            productName: _productNameFor(item.productId),
            impositionQuantity: item.quantity,
          ),
        )
        .toList();

    final payload = Artwork(
      id: currentArtwork?.id ?? 0,
      baseCode: _baseCodeController.text.trim().isEmpty
          ? null
          : _baseCodeController.text.trim(),
      version: currentArtwork?.version,
      name: _nameController.text.trim(),
      cmykColors: _selectedCmyk.toList(),
      otherColors: List<String>.from(_otherColors),
      impositionSize: _impositionController.text.trim(),
      notes: _notesController.text.trim(),
      confirmed: currentArtwork?.confirmed ?? false,
      confirmedByName: currentArtwork?.confirmedByName,
      confirmedAt: currentArtwork?.confirmedAt,
      dieIds: _selectedDieIds.toList(),
      foilingPlateIds: _selectedFoilingIds.toList(),
      embossingPlateIds: _selectedEmbossingIds.toList(),
      code: currentArtwork?.code,
      colorDisplay: currentArtwork?.colorDisplay,
      dieCodes: currentArtwork?.dieCodes ?? const [],
      dieNames: currentArtwork?.dieNames ?? const [],
      foilingPlateCodes: currentArtwork?.foilingPlateCodes ?? const [],
      foilingPlateNames: currentArtwork?.foilingPlateNames ?? const [],
      embossingPlateCodes: currentArtwork?.embossingPlateCodes ?? const [],
      embossingPlateNames: currentArtwork?.embossingPlateNames ?? const [],
      products: products,
      createdAt: currentArtwork?.createdAt,
    );

    final saved = currentArtwork == null
        ? await viewModel.createArtwork(payload)
        : await viewModel.updateArtwork(payload);
    if (mounted) {
      setState(() => _savedArtwork = saved);
    }
    return saved;
  }

  Future<void> _pickAndUploadImage(ArtworkViewModel viewModel) async {
    if (_images.length >= _maxImageCount) {
      ToastUtil.showError('图片最多上传 $_maxImageCount 张');
      return;
    }
    setState(() => _uploadingImage = true);
    try {
      final multipartFile = await pickMultipartFile(
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif'],
        fallbackFilename: 'artwork_image.jpg',
        maxBytes: _maxImageBytes,
      );
      if (multipartFile == null) {
        if (mounted) setState(() => _uploadingImage = false);
        return;
      }
      final savedArtwork = await _persistArtwork(viewModel);
      final image = await viewModel.uploadArtworkImage(
        savedArtwork.id,
        multipartFile,
        sortOrder: _images.length,
      );
      if (mounted) {
        setState(() => _images.add(image));
        ToastUtil.showSuccess('图片上传成功');
      }
    } catch (err) {
      if (mounted) ToastUtil.showError('上传失败: $err');
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  Future<void> _removeImage(
      ArtworkViewModel viewModel, ArtworkImage image) async {
    final artwork = _artwork;
    if (artwork == null) return;
    try {
      await viewModel.deleteArtworkImage(artwork.id, image.id);
      if (mounted) {
        setState(() => _images.remove(image));
        ToastUtil.showSuccess('图片已删除');
      }
    } catch (err) {
      if (mounted) ToastUtil.showError('删除失败: $err');
    }
  }

  Widget _buildVersionField(BuildContext context) {
    return CrudFieldConfig.text(
      label: _versionLabel,
      initialValue: _artwork?.version?.toString() ?? '1',
      enabled: false,
    ).build(context);
  }

  Widget _buildProductSection(BuildContext context) {
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
              final productOptions = _productOptions
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
                        decoration:
                            const InputDecoration(labelText: _productLabel),
                        options: productOptions,
                        selectHintText:
                            _productOptions.isEmpty ? '新增产品' : '请选择',
                        onChanged: (value) {
                          setState(() => item.productId = value);
                        },
                      ),
                    ),
                    if (_productOptions.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: LayoutTokens.gapSm),
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
                    SizedBox(width: LayoutTokens.gapMd),
                    Expanded(
                      child: CrudFieldConfig.number(
                        label: _quantityLabel,
                        controller: item.quantityController,
                      ).build(context),
                    ),
                    SizedBox(width: LayoutTokens.gapSm),
                    IconButton(
                      tooltip: '移除',
                      icon: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error,
                      ),
                      onPressed: () => _removeProductItem(index),
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
          _productSectionTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: sectionSpacing),
        if (_loadingPicklists)
          const LinearProgressIndicator(minHeight: 2)
        else
          content,
        SizedBox(height: sectionSpacing),
        Align(
          alignment: Alignment.centerLeft,
          child: PageActionButton.outlined(
            onPressed: _addProductItem,
            icon: const Icon(Icons.add, size: 16),
            label: _addProductText,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return ImageGalleryUploadSection<ArtworkImage>(
      images: _images,
      canUpload: true,
      uploading: _uploadingImage,
      maxCount: _maxImageCount,
      limitHintText: '支持 JPG、PNG、WebP、GIF，单张不超过 10MB，最多 $_maxImageCount 张',
      unsavedHintText: '请先保存图稿后再上传图片',
      emptyText: '暂无图片，点击下方按钮上传',
      imageUrlBuilder: (image) => image.imageUrl,
      descriptionBuilder: (image) => image.description,
      onUpload: () => _pickAndUploadImage(context.read<ArtworkViewModel>()),
      onDelete: (image) =>
          _removeImage(context.read<ArtworkViewModel>(), image),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentArtwork = _artwork;
    return CrudDrawerEditPanel<Artwork, ArtworkViewModel>(
      item: currentArtwork,
      onSaved: widget.onSaved,
      config: CrudEditConfig<Artwork, ArtworkViewModel>(
        submitText: _submitText,
        submittingText: '保存中',
        errorMessagePrefix: _submitErrorText,
        sectionsBuilder: (context, isMobile) => [
          CrudFormSection(
            title: _basicSectionTitle,
            column: 0,
            fields: [
              CrudFieldConfig.text(
                label: _baseCodeLabel,
                controller: _baseCodeController,
                hintText: '留空则系统自动生成',
                enabled: currentArtwork == null,
              ),
              if (currentArtwork != null)
                CrudFieldConfig.custom(
                  builder: _buildVersionField,
                ),
              CrudFieldConfig.text(
                label: _nameLabel,
                controller: _nameController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return _nameRequiredText;
                  }
                  return null;
                },
              ),
              CrudFieldConfig.custom(
                builder: (context) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: _cmykLabel,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        bottom: LayoutTokens.gapSm,
                      ),
                    ),
                    child: Wrap(
                      spacing: 8,
                      children: _cmykColors
                          .map(
                            (color) => FilterChip(
                              label: Text(color),
                              selected: _selectedCmyk.contains(color),
                              onSelected: (_) {
                                setState(() {
                                  if (_selectedCmyk.contains(color)) {
                                    _selectedCmyk.remove(color);
                                  } else {
                                    _selectedCmyk.add(color);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
              CrudFieldConfig.tags(
                label: _otherColorsLabel,
                values: _otherColors,
                hintText: '输入后按回车、逗号或换行添加颜色',
                onChanged: (values) {
                  setState(() {
                    _otherColors
                      ..clear()
                      ..addAll(values);
                  });
                },
              ),
              if (!isMobile)
                CrudFieldConfig.text(
                  label: _impositionLabel,
                  controller: _impositionController,
                ),
            ],
          ),
          CrudFormSection(
            title: '图稿图片',
            column: 0,
            fields: [
              CrudFieldConfig.custom(
                builder: _buildImageSection,
              ),
            ],
          ),
          CrudFormSection(
            title: _extraSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              if (isMobile)
                CrudFieldConfig.text(
                  label: _impositionLabel,
                  controller: _impositionController,
                ),
              CrudFieldConfig.multiSelect(
                label: _dieLabel,
                options: _dieOptions
                    .map(
                      (die) => AppDropdownOption<dynamic>(
                        value: die.id,
                        label: _optionLabel(die.name, die.code),
                      ),
                    )
                    .toList(),
                values: _selectedDieIds,
                hintText: _diePlaceholder,
                onChanged: (values) {
                  setState(() {
                    _selectedDieIds
                      ..clear()
                      ..addAll(values.cast<int>());
                  });
                },
              ),
              CrudFieldConfig.multiSelect(
                label: _foilingLabel,
                options: _foilingOptions
                    .map(
                      (plate) => AppDropdownOption<dynamic>(
                        value: plate.id,
                        label: _optionLabel(plate.name, plate.code),
                      ),
                    )
                    .toList(),
                values: _selectedFoilingIds,
                hintText: _foilingPlaceholder,
                onChanged: (values) {
                  setState(() {
                    _selectedFoilingIds
                      ..clear()
                      ..addAll(values.cast<int>());
                  });
                },
              ),
              CrudFieldConfig.multiSelect(
                label: _embossingLabel,
                options: _embossingOptions
                    .map(
                      (plate) => AppDropdownOption<dynamic>(
                        value: plate.id,
                        label: _optionLabel(plate.name, plate.code),
                      ),
                    )
                    .toList(),
                values: _selectedEmbossingIds,
                hintText: _embossingPlaceholder,
                onChanged: (values) {
                  setState(() {
                    _selectedEmbossingIds
                      ..clear()
                      ..addAll(values.cast<int>());
                  });
                },
              ),
              if (_loadingPicklists)
                CrudFieldConfig.custom(
                  builder: (_) => const LinearProgressIndicator(minHeight: 2),
                ),
              CrudFieldConfig.custom(
                builder: _buildProductSection,
              ),
              CrudFieldConfig.textarea(
                label: _notesLabel,
                controller: _notesController,
                maxLines: 3,
              ),
            ],
          ),
        ],
        onSave: (context, viewModel, item) => _handleSubmit(viewModel),
      ),
    );
  }
}

class _ArtworkProductItem {
  _ArtworkProductItem({this.productId, int quantity = 1})
      : quantityController = TextEditingController(text: quantity.toString());

  int? productId;
  final TextEditingController quantityController;

  int get quantity => int.tryParse(quantityController.text.trim()) ?? 1;

  void dispose() {
    quantityController.dispose();
  }
}
