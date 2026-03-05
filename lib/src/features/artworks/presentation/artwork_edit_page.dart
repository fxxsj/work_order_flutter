import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
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

class ArtworkEditPage extends StatefulWidget {
  const ArtworkEditPage({super.key, this.artwork});

  final Artwork? artwork;

  @override
  State<ArtworkEditPage> createState() => _ArtworkEditPageState();
}

class _ArtworkEditPageState extends State<ArtworkEditPage> {
  final _formKey = GlobalKey<FormState>();

  static const double _padding = 16;
  static const double _sectionSpacing = 16;
  static const double _actionSpacing = 24;
  static const double _pageSpacing = 8;
  static const double _submitIndicatorSize = 20;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;
  static const double _columnSpacing = 24;

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
  static const String _backText = '返回';
  static const String _cancelText = '取消';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _breadcrumbSeparator = ' / ';

  late final TextEditingController _baseCodeController;
  late final TextEditingController _nameController;
  late final TextEditingController _otherColorsController;
  late final TextEditingController _impositionController;
  late final TextEditingController _notesController;

  final Set<String> _cmykColors = {'C', 'M', 'Y', 'K'};
  final Set<String> _selectedCmyk = {};
  bool _submitting = false;
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

  @override
  void initState() {
    super.initState();
    final artwork = widget.artwork;
    _baseCodeController = TextEditingController(text: artwork?.baseCode ?? '');
    _nameController = TextEditingController(text: artwork?.name ?? '');
    _otherColorsController = TextEditingController(text: artwork?.otherColors.join('、') ?? '');
    _impositionController = TextEditingController(text: artwork?.impositionSize ?? '');
    _notesController = TextEditingController(text: artwork?.notes ?? '');
    _selectedCmyk.addAll(artwork?.cmykColors ?? const []);
    _selectedDieIds.addAll(artwork?.dieIds ?? const []);
    _selectedFoilingIds.addAll(artwork?.foilingPlateIds ?? const []);
    _selectedEmbossingIds.addAll(artwork?.embossingPlateIds ?? const []);
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
    _otherColorsController.dispose();
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
      final dies = await _dieApi!.fetchDies(pageSize: 100);
      final foiling = await _foilingApi!.fetchFoilingPlates(pageSize: 100);
      final embossing = await _embossingApi!.fetchEmbossingPlates(pageSize: 100);
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
    setState(() {
      _productItems.add(_ArtworkProductItem(quantity: 1));
    });
  }

  void _removeProductItem(int index) {
    setState(() {
      _productItems[index].dispose();
      _productItems.removeAt(index);
    });
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
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

    final otherColors = _otherColorsController.text
        .split(RegExp(r'[、,，\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

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
      id: widget.artwork?.id ?? 0,
      baseCode: _baseCodeController.text.trim().isEmpty ? null : _baseCodeController.text.trim(),
      version: widget.artwork?.version,
      name: _nameController.text.trim(),
      cmykColors: _selectedCmyk.toList(),
      otherColors: otherColors,
      impositionSize: _impositionController.text.trim(),
      notes: _notesController.text.trim(),
      confirmed: widget.artwork?.confirmed ?? false,
      confirmedByName: widget.artwork?.confirmedByName,
      confirmedAt: widget.artwork?.confirmedAt,
      dieIds: _selectedDieIds.toList(),
      foilingPlateIds: _selectedFoilingIds.toList(),
      embossingPlateIds: _selectedEmbossingIds.toList(),
      code: widget.artwork?.code,
      colorDisplay: widget.artwork?.colorDisplay,
      dieCodes: widget.artwork?.dieCodes ?? const [],
      dieNames: widget.artwork?.dieNames ?? const [],
      foilingPlateCodes: widget.artwork?.foilingPlateCodes ?? const [],
      foilingPlateNames: widget.artwork?.foilingPlateNames ?? const [],
      embossingPlateCodes: widget.artwork?.embossingPlateCodes ?? const [],
      embossingPlateNames: widget.artwork?.embossingPlateNames ?? const [],
      products: products,
      createdAt: widget.artwork?.createdAt,
    );

    try {
      if (widget.artwork == null) {
        await viewModel.createArtwork(payload);
      } else {
        await viewModel.updateArtwork(payload);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_submitErrorText$err');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Widget _sectionTitle(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }

  Widget _buildChipSection(
    ThemeData theme, {
    required String title,
    required List<_OptionItem> options,
    required Set<int> selectedIds,
  }) {
    final content = options.isEmpty
        ? Text('暂无可选项', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor))
        : Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((item) {
              final selected = selectedIds.contains(item.id);
              return FilterChip(
                label: Text(item.label),
                selected: selected,
                onSelected: (value) {
                  setState(() {
                    if (value) {
                      selectedIds.add(item.id);
                    } else {
                      selectedIds.remove(item.id);
                    }
                  });
                },
              );
            }).toList(),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, title),
        const SizedBox(height: _sectionSpacing),
        if (_loadingPicklists)
          const LinearProgressIndicator(minHeight: 2)
        else
          content,
      ],
    );
  }

  Widget _buildProductSection(ThemeData theme) {
    final content = _productItems.isEmpty
        ? Text('暂无产品项', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor))
        : Column(
            children: List.generate(_productItems.length, (index) {
              final item = _productItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: _sectionSpacing),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<int>(
                        value: item.productId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: _productLabel,
                          border: OutlineInputBorder(),
                        ),
                        items: _productOptions
                            .map(
                              (product) => DropdownMenuItem<int>(
                                value: product.id,
                                child: Text(product.displayLabel),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            item.productId = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: item.quantityController,
                        decoration: const InputDecoration(
                          labelText: _quantityLabel,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: '移除',
                      icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
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
        _sectionTitle(theme, _productSectionTitle),
        const SizedBox(height: _sectionSpacing),
        if (_loadingPicklists)
          const LinearProgressIndicator(minHeight: 2)
        else
          content,
        const SizedBox(height: _sectionSpacing),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ArtworkViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPath('/artworks');

    final baseCodeField = TextFormField(
      controller: _baseCodeController,
      decoration: const InputDecoration(
        labelText: _baseCodeLabel,
        border: OutlineInputBorder(),
        hintText: '留空则系统自动生成',
      ),
      enabled: widget.artwork == null,
    );

    final versionField = widget.artwork == null
        ? const SizedBox.shrink()
        : TextFormField(
            initialValue: widget.artwork?.version?.toString() ?? '1',
            decoration: const InputDecoration(
              labelText: _versionLabel,
              border: OutlineInputBorder(),
            ),
            enabled: false,
          );

    final nameField = TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: _nameLabel,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) {
          return _nameRequiredText;
        }
        return null;
      },
    );

    final cmykField = InputDecorator(
      decoration: const InputDecoration(
        labelText: _cmykLabel,
        border: OutlineInputBorder(),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _cmykColors.map((color) {
          final selected = _selectedCmyk.contains(color);
          return FilterChip(
            label: Text(color),
            selected: selected,
            onSelected: (value) {
              setState(() {
                if (value) {
                  _selectedCmyk.add(color);
                } else {
                  _selectedCmyk.remove(color);
                }
              });
            },
          );
        }).toList(),
      ),
    );

    final otherColorsField = TextFormField(
      controller: _otherColorsController,
      decoration: const InputDecoration(
        labelText: _otherColorsLabel,
        border: OutlineInputBorder(),
        hintText: '多个颜色用逗号或顿号分隔',
      ),
    );

    final impositionField = TextFormField(
      controller: _impositionController,
      decoration: const InputDecoration(
        labelText: _impositionLabel,
        border: OutlineInputBorder(),
      ),
    );

    final notesField = TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: _notesLabel,
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );

    final dieSection = _buildChipSection(
      theme,
      title: _dieLabel,
      options: _dieOptions
          .map((die) => _OptionItem(die.id, _optionLabel(die.name, die.code)))
          .toList(),
      selectedIds: _selectedDieIds,
    );
    final foilingSection = _buildChipSection(
      theme,
      title: _foilingLabel,
      options: _foilingOptions
          .map((plate) => _OptionItem(plate.id, _optionLabel(plate.name, plate.code)))
          .toList(),
      selectedIds: _selectedFoilingIds,
    );
    final embossingSection = _buildChipSection(
      theme,
      title: _embossingLabel,
      options: _embossingOptions
          .map((plate) => _OptionItem(plate.id, _optionLabel(plate.name, plate.code)))
          .toList(),
      selectedIds: _selectedEmbossingIds,
    );
    final productSection = _buildProductSection(theme);

    final mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile) ...[
          _sectionTitle(theme, _basicSectionTitle),
          const SizedBox(height: _sectionSpacing),
          baseCodeField,
          if (widget.artwork != null) ...[
            const SizedBox(height: _sectionSpacing),
            versionField,
          ],
          const SizedBox(height: _sectionSpacing),
          nameField,
          const SizedBox(height: _sectionSpacing),
          cmykField,
          const SizedBox(height: _sectionSpacing),
          otherColorsField,
          const SizedBox(height: _sectionSpacing),
          _sectionTitle(theme, _extraSectionTitle),
          const SizedBox(height: _sectionSpacing),
          impositionField,
          const SizedBox(height: _sectionSpacing),
          dieSection,
          const SizedBox(height: _sectionSpacing),
          foilingSection,
          const SizedBox(height: _sectionSpacing),
          embossingSection,
          const SizedBox(height: _sectionSpacing),
          productSection,
          const SizedBox(height: _sectionSpacing),
          notesField,
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionTitle(theme, _basicSectionTitle),
                    const SizedBox(height: _sectionSpacing),
                    baseCodeField,
                    if (widget.artwork != null) ...[
                      const SizedBox(height: _sectionSpacing),
                      versionField,
                    ],
                    const SizedBox(height: _sectionSpacing),
                    nameField,
                    const SizedBox(height: _sectionSpacing),
                    cmykField,
                    const SizedBox(height: _sectionSpacing),
                    otherColorsField,
                    const SizedBox(height: _sectionSpacing),
                    impositionField,
                  ],
                ),
              ),
              const SizedBox(width: _columnSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionTitle(theme, _extraSectionTitle),
                    const SizedBox(height: _sectionSpacing),
                    dieSection,
                    const SizedBox(height: _sectionSpacing),
                    foilingSection,
                    const SizedBox(height: _sectionSpacing),
                    embossingSection,
                    const SizedBox(height: _sectionSpacing),
                    productSection,
                    const SizedBox(height: _sectionSpacing),
                    notesField,
                  ],
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: _actionSpacing),
      ],
    );

    return SafeArea(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeaderBar(
              breadcrumb: breadcrumb.join(_breadcrumbSeparator),
              useSurface: false,
              showDivider: false,
              padding: EdgeInsets.zero,
              actions: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PageActionButton.outlined(
                    onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: _backText,
                  ),
                ],
              ),
            ),
            const SizedBox(height: _pageSpacing),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(_padding),
                child: mainContent,
              ),
            ),
            const SizedBox(height: _pageSpacing),
            Container(
              padding: const EdgeInsets.fromLTRB(_padding, 12, _padding, _padding),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(color: theme.dividerColor.withOpacity(0.6)),
                ),
              ),
              child: Row(
                children: [
                  PageActionButton.outlined(
                    onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
                    label: _cancelText,
                  ),
                  const SizedBox(width: _inlineSpacing),
                  PageActionButton.filled(
                    onPressed: _submitting ? null : () => _handleSubmit(viewModel),
                    label: _submitText,
                    icon: _submitting
                        ? const SizedBox(
                            height: _submitIndicatorSize,
                            width: _submitIndicatorSize,
                            child: CircularProgressIndicator(strokeWidth: _indicatorStrokeWidth),
                          )
                        : null,
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
