import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/edit_page_scaffold.dart';
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

  static const double _submitIndicatorSize = 20;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;

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
  static const String _diePlaceholder = '请选择刀模（可多选）';
  static const String _foilingPlaceholder = '请选择烫金版（可多选）';
  static const String _embossingPlaceholder = '请选择压凸版（可多选）';
  static const String _searchHint = '搜索名称或编码';
  static const String _emptyMatchText = '无匹配项';

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
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildChipSection(
    ThemeData theme, {
    required String title,
    required List<_OptionItem> options,
    required Set<int> selectedIds,
    required String placeholder,
    required double sectionSpacing,
  }) {
    final colors = theme.extension<AppColors>();
    final subtleText = colors?.subtleText ?? theme.hintColor;
    final selectedItems = options.where((item) => selectedIds.contains(item.id)).toList();

    final content = options.isEmpty
        ? Text('暂无可选项', style: theme.textTheme.bodySmall?.copyWith(color: subtleText))
        : InkWell(
            onTap: () => _openMultiSelectDialog(
              title: title,
              options: options,
              selectedIds: selectedIds,
            ),
            borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              child: selectedItems.isEmpty
                  ? Text(placeholder, style: theme.textTheme.bodyMedium?.copyWith(color: subtleText))
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedItems
                          .map(
                            (item) => InputChip(
                              label: Text(item.label),
                              onDeleted: () {
                                setState(() {
                                  selectedIds.remove(item.id);
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, title),
        SizedBox(height: sectionSpacing),
        if (_loadingPicklists)
          const LinearProgressIndicator(minHeight: 2)
        else
          content,
      ],
    );
  }

  Future<void> _openMultiSelectDialog({
    required String title,
    required List<_OptionItem> options,
    required Set<int> selectedIds,
  }) async {
    if (options.isEmpty) return;
    final original = Set<int>.from(selectedIds);
    String query = '';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filtered = options
                .where((item) => item.label.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: 520,
                height: 420,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: _searchHint,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => setDialogState(() => query = value.trim()),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(child: Text(_emptyMatchText, style: Theme.of(context).textTheme.bodySmall))
                          : Scrollbar(
                              child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final item = filtered[index];
                                  final selected = selectedIds.contains(item.id);
                                  return CheckboxListTile(
                                    value: selected,
                                    dense: true,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text(item.label),
                                    onChanged: (value) {
                                      setDialogState(() {
                                        if (value == true) {
                                          selectedIds.add(item.id);
                                        } else {
                                          selectedIds.remove(item.id);
                                        }
                                      });
                                      setState(() {});
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
                    setState(() {
                      selectedIds
                        ..clear()
                        ..addAll(original);
                    });
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    setDialogState(() => selectedIds.clear());
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

  Widget _buildProductSection(ThemeData theme, double sectionSpacing) {
    final colors = theme.extension<AppColors>();
    final subtleText = colors?.subtleText ?? theme.hintColor;
    final content = _productItems.isEmpty
        ? Text('暂无产品项', style: theme.textTheme.bodySmall?.copyWith(color: subtleText))
        : Column(
            children: List.generate(_productItems.length, (index) {
              final item = _productItems[index];
              return Padding(
                padding: EdgeInsets.only(bottom: sectionSpacing),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<int>(
                        initialValue: item.productId,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: _productLabel),
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
                        decoration: const InputDecoration(labelText: _quantityLabel),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ArtworkViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPath('/artworks');
    final contentPadding = LayoutTokens.pagePadding(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final actionSpacing = LayoutTokens.formActionSpacing(context);
    final pageSpacing = LayoutTokens.formPageSpacing(context);
    final columnSpacing = LayoutTokens.formColumnSpacing(context);

    final baseCodeField = TextFormField(
      controller: _baseCodeController,
      decoration: const InputDecoration(
        labelText: _baseCodeLabel,
        hintText: '留空则系统自动生成',
      ),
      enabled: widget.artwork == null,
    );

    final versionField = widget.artwork == null
        ? const SizedBox.shrink()
        : TextFormField(
            initialValue: widget.artwork?.version?.toString() ?? '1',
            decoration: const InputDecoration(labelText: _versionLabel),
            enabled: false,
          );

    final nameField = TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: _nameLabel),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) {
          return _nameRequiredText;
        }
        return null;
      },
    );

    final cmykField = InputDecorator(
      decoration: const InputDecoration(labelText: _cmykLabel),
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
        hintText: '多个颜色用逗号或顿号分隔',
      ),
    );

    final impositionField = TextFormField(
      controller: _impositionController,
      decoration: const InputDecoration(labelText: _impositionLabel),
    );

    final notesField = TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(labelText: _notesLabel),
      maxLines: 3,
    );

    final dieSection = _buildChipSection(
      theme,
      title: _dieLabel,
      options: _dieOptions
          .map((die) => _OptionItem(die.id, _optionLabel(die.name, die.code)))
          .toList(),
      selectedIds: _selectedDieIds,
      placeholder: _diePlaceholder,
      sectionSpacing: sectionSpacing,
    );
    final foilingSection = _buildChipSection(
      theme,
      title: _foilingLabel,
      options: _foilingOptions
          .map((plate) => _OptionItem(plate.id, _optionLabel(plate.name, plate.code)))
          .toList(),
      selectedIds: _selectedFoilingIds,
      placeholder: _foilingPlaceholder,
      sectionSpacing: sectionSpacing,
    );
    final embossingSection = _buildChipSection(
      theme,
      title: _embossingLabel,
      options: _embossingOptions
          .map((plate) => _OptionItem(plate.id, _optionLabel(plate.name, plate.code)))
          .toList(),
      selectedIds: _selectedEmbossingIds,
      placeholder: _embossingPlaceholder,
      sectionSpacing: sectionSpacing,
    );
    final productSection = _buildProductSection(theme, sectionSpacing);

    final mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile) ...[
          _sectionTitle(theme, _basicSectionTitle),
          SizedBox(height: sectionSpacing),
          baseCodeField,
          if (widget.artwork != null) ...[
            SizedBox(height: sectionSpacing),
            versionField,
          ],
          SizedBox(height: sectionSpacing),
          nameField,
          SizedBox(height: sectionSpacing),
          cmykField,
          SizedBox(height: sectionSpacing),
          otherColorsField,
          SizedBox(height: sectionSpacing),
          _sectionTitle(theme, _extraSectionTitle),
          SizedBox(height: sectionSpacing),
          impositionField,
          SizedBox(height: sectionSpacing),
          dieSection,
          SizedBox(height: sectionSpacing),
          foilingSection,
          SizedBox(height: sectionSpacing),
          embossingSection,
          SizedBox(height: sectionSpacing),
          productSection,
          SizedBox(height: sectionSpacing),
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
                    SizedBox(height: sectionSpacing),
                    baseCodeField,
                    if (widget.artwork != null) ...[
                      SizedBox(height: sectionSpacing),
                      versionField,
                    ],
                    SizedBox(height: sectionSpacing),
                    nameField,
                    SizedBox(height: sectionSpacing),
                    cmykField,
                    SizedBox(height: sectionSpacing),
                    otherColorsField,
                    SizedBox(height: sectionSpacing),
                    impositionField,
                  ],
                ),
              ),
              SizedBox(width: columnSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionTitle(theme, _extraSectionTitle),
                    SizedBox(height: sectionSpacing),
                    dieSection,
                    SizedBox(height: sectionSpacing),
                    foilingSection,
                    SizedBox(height: sectionSpacing),
                    embossingSection,
                    SizedBox(height: sectionSpacing),
                    productSection,
                    SizedBox(height: sectionSpacing),
                    notesField,
                  ],
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: actionSpacing),
      ],
    );

    return SafeArea(
      child: Form(
        key: _formKey,
        child: EditPageScaffold(
          spacing: pageSpacing,
          contentPadding: contentPadding,
          header: PageHeaderBar(
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
          body: mainContent,
          footer: EditPageFooterBar(
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
