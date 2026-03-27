import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
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

  @override
  void initState() {
    super.initState();
    final artwork = widget.artwork;
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
      final dies = await _dieApi!.fetchDies(pageSize: 100);
      final foiling = await _foilingApi!.fetchFoilingPlates(pageSize: 100);
      final embossing =
          await _embossingApi!.fetchEmbossingPlates(pageSize: 100);
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
      baseCode: _baseCodeController.text.trim().isEmpty
          ? null
          : _baseCodeController.text.trim(),
      version: widget.artwork?.version,
      name: _nameController.text.trim(),
      cmykColors: _selectedCmyk.toList(),
      otherColors: List<String>.from(_otherColors),
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

    if (widget.artwork == null) {
      await viewModel.createArtwork(payload);
    } else {
      await viewModel.updateArtwork(payload);
    }
  }

  Widget _buildVersionField(BuildContext context) {
    return TextFormField(
      initialValue: widget.artwork?.version?.toString() ?? '1',
      decoration: const InputDecoration(labelText: _versionLabel),
      enabled: false,
    );
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
              return Padding(
                padding: EdgeInsets.only(bottom: sectionSpacing),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SearchableDropdownFormField<int>(
                        initialValue: item.productId,
                        isExpanded: true,
                        decoration:
                            const InputDecoration(labelText: _productLabel),
                        items: _productOptions
                            .map(
                              (product) => DropdownMenuItem<int>(
                                value: product.id,
                                child: Text(product.displayLabel),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => item.productId = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: item.quantityController,
                        decoration:
                            const InputDecoration(labelText: _quantityLabel),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
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
          child: TextButton.icon(
            onPressed: _addProductItem,
            icon: const Icon(Icons.add),
            label: const Text(_addProductText),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CrudEditPage<Artwork, ArtworkViewModel>(
      item: widget.artwork,
      config: CrudEditConfig<Artwork, ArtworkViewModel>(
        submitText: _submitText,
        submittingText: '保存中',
        errorMessagePrefix: _submitErrorText,
        sectionsBuilder: (context, isMobile) => [
          CrudFormSection(
            title: _basicSectionTitle,
            column: 0,
            fields: [
              CrudFormField.text(
                label: _baseCodeLabel,
                controller: _baseCodeController,
                hintText: '留空则系统自动生成',
                enabled: widget.artwork == null,
              ),
              if (widget.artwork != null)
                CrudFormField.custom(
                  builder: _buildVersionField,
                ),
              CrudFormField.text(
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
              CrudFormField.checkboxGroup(
                label: _cmykLabel,
                options: _cmykColors
                    .map((color) => CrudFieldOption<dynamic>(
                          value: color,
                          label: color,
                        ))
                    .toList(),
                values: _selectedCmyk,
                helperText: '可选择多个 CMYK 色值',
                onChanged: (values) {
                  setState(() {
                    _selectedCmyk
                      ..clear()
                      ..addAll(values.cast<String>());
                  });
                },
              ),
              CrudFormField.tags(
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
                CrudFormField.text(
                  label: _impositionLabel,
                  controller: _impositionController,
                ),
            ],
          ),
          CrudFormSection(
            title: _extraSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              if (isMobile)
                CrudFormField.text(
                  label: _impositionLabel,
                  controller: _impositionController,
                ),
              CrudFormField.multiSelect(
                label: _dieLabel,
                options: _dieOptions
                    .map(
                      (die) => CrudFieldOption<dynamic>(
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
              CrudFormField.multiSelect(
                label: _foilingLabel,
                options: _foilingOptions
                    .map(
                      (plate) => CrudFieldOption<dynamic>(
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
              CrudFormField.multiSelect(
                label: _embossingLabel,
                options: _embossingOptions
                    .map(
                      (plate) => CrudFieldOption<dynamic>(
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
                CrudFormField.custom(
                  builder: (_) => const LinearProgressIndicator(minHeight: 2),
                ),
              CrudFormField.custom(
                builder: _buildProductSection,
              ),
              CrudFormField.textarea(
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
