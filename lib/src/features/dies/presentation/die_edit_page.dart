import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_drawer_edit_panel.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/file_upload_picker.dart';
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
    isMobile: BreakpointsUtil.isMobile(context),
    title: die == null ? '新建刀模' : '编辑刀模',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: ChangeNotifierProvider<DieViewModel>.value(
      value: viewModel,
      child: DieEditPage(
        die: die,
        onSaved: () => saved = true,
      ),
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

  @override
  void initState() {
    super.initState();
    final die = widget.die;
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
    if (!_canAddMoreProducts) {
      ToastUtil.showError('专用刀模只能添加1个产品');
      return;
    }
    setState(() => _productItems.add(_DieProductItem(quantity: 1)));
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

  Future<void> _handleDieTypeChange(String? value) async {
    if (value == null) return;
    if (value == 'dedicated' && _productItems.length > 1) {
      final keepFirst = await showDialog<bool>(
        context: context,
        builder: (context) => BaseDialog(
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

    final payload = Die(
      id: widget.die?.id ?? 0,
      code: _codeController.text.trim().isEmpty
          ? null
          : _codeController.text.trim(),
      name: _nameController.text.trim(),
      dieType: _dieType,
      size: _sizeController.text.trim(),
      material: _materialController.text.trim(),
      thickness: _thicknessController.text.trim(),
      notes: _notesController.text.trim(),
      confirmed: widget.die?.confirmed ?? false,
      dieTypeDisplay: widget.die?.dieTypeDisplay,
      products: products,
      images: _images,
      createdAt: widget.die?.createdAt,
    );

    if (widget.die == null) {
      await viewModel.createDie(payload);
    } else {
      await viewModel.updateDie(payload);
    }
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
                    (product) => DropdownOption<int>(
                      value: product.id,
                      label: product.displayLabel,
                    ),
                  )
                  .toList()
                ..add(
                  DropdownOption<int>(
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
                      child: UnifiedDropdown<int>(
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
                      child: CrudFormField.number(
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
            onPressed: _addProductItem,
            icon: const Icon(Icons.add, size: 16),
            label: _addProductText,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final theme = Theme.of(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final colors = theme.extension<AppColors>();
    final subtleText = colors?.subtleText ?? theme.hintColor;

    if (widget.die == null) {
      return Text(
        '请先保存刀模后再上传图片',
        style: theme.textTheme.bodySmall?.copyWith(color: subtleText),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_images.isEmpty)
          Text(
            '暂无图片，点击下方按钮上传',
            style: theme.textTheme.bodySmall?.copyWith(color: subtleText),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _images.map((img) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      img.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.broken_image, color: subtleText),
                      ),
                    ),
                  ),
                  if (img.description != null && img.description!.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        color: Colors.black54,
                        child: Text(
                          img.description!,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () =>
                          _removeImage(context.read<DieViewModel>(), img),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(2),
                        child: Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        SizedBox(height: sectionSpacing),
        if (_uploadingImage)
          const Center(child: CircularProgressIndicator())
        else
          Align(
            alignment: Alignment.centerLeft,
            child: PageActionButton.outlined(
              onPressed: () =>
                  _pickAndUploadImage(context.read<DieViewModel>()),
              icon: const Icon(Icons.add_photo_alternate, size: 16),
              label: '上传图片',
            ),
          ),
      ],
    );
  }

  Future<void> _pickAndUploadImage(DieViewModel viewModel) async {
    if (widget.die == null) return;
    setState(() => _uploadingImage = true);
    try {
      final multipartFile = await pickMultipartFile(
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif'],
        fallbackFilename: 'die_image.jpg',
      );
      if (multipartFile == null) {
        if (mounted) setState(() => _uploadingImage = false);
        return;
      }
      final image = await viewModel.uploadDieImage(
        widget.die!.id,
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

  Future<void> _removeImage(DieViewModel viewModel, DieImage image) async {
    if (widget.die == null) return;
    try {
      await viewModel.deleteDieImage(widget.die!.id, image.id);
      if (mounted) {
        setState(() => _images.remove(image));
        ToastUtil.showSuccess('图片已删除');
      }
    } catch (err) {
      if (mounted) ToastUtil.showError('删除失败: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConfirmed = widget.die?.confirmed == true;

    return CrudDrawerEditPanel<Die, DieViewModel>(
      item: widget.die,
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
              CrudFormField.text(
                label: _codeLabel,
                controller: _codeController,
                enabled: !isConfirmed,
                hintText: '留空则系统自动生成',
              ),
              CrudFormField.text(
                label: _nameLabel,
                controller: _nameController,
                enabled: !isConfirmed,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return _nameRequiredText;
                  }
                  return null;
                },
              ),
              CrudFormField.dropdown(
                label: _typeLabel,
                value: _dieType,
                enabled: !isConfirmed,
                options: _dieTypeLabels.entries
                    .map(
                      (entry) => CrudFieldOption(
                        value: entry.key,
                        label: entry.value,
                      ),
                    )
                    .toList(),
                onChanged: isConfirmed
                    ? null
                    : (value) => _handleDieTypeChange(value as String?),
              ),
              CrudFormField.text(
                label: _sizeLabel,
                controller: _sizeController,
                enabled: !isConfirmed,
              ),
            ],
          ),
          CrudFormSection(
            title: _extraSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFormField.text(
                label: _materialLabel,
                controller: _materialController,
                enabled: !isConfirmed,
              ),
              CrudFormField.text(
                label: _thicknessLabel,
                controller: _thicknessController,
                enabled: !isConfirmed,
              ),
              CrudFormField.textarea(
                label: _notesLabel,
                controller: _notesController,
                maxLines: 3,
              ),
            ],
          ),
          CrudFormSection(
            title: _productSectionTitle,
            column: 0,
            fields: [
              CrudFormField.custom(
                builder: _buildProductSection,
              ),
            ],
          ),
          CrudFormSection(
            title: _imageSectionTitle,
            column: 0,
            fields: [
              CrudFormField.custom(
                builder: _buildImageSection,
              ),
            ],
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
