import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/foiling_plates/application/foiling_plate_view_model.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

class FoilingPlateEditPage extends StatefulWidget {
  const FoilingPlateEditPage({super.key, this.plate});

  final FoilingPlate? plate;

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

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _nameRequiredText = '请输入烫金版名称';
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

  @override
  void initState() {
    super.initState();
    final plate = widget.plate;
    _codeController = TextEditingController(text: plate?.code ?? '');
    _nameController = TextEditingController(text: plate?.name ?? '');
    _sizeController = TextEditingController(text: plate?.size ?? '');
    _materialController = TextEditingController(text: plate?.material ?? '');
    _thicknessController = TextEditingController(text: plate?.thickness ?? '');
    _notesController = TextEditingController(text: plate?.notes ?? '');
    _foilingType = plate?.foilingType ?? 'gold';
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
    setState(() => _productItems.add(_PlateProductItem(quantity: 1)));
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

  Future<void> _handleSubmit(FoilingPlateViewModel viewModel) async {
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

    final payload = FoilingPlate(
      id: widget.plate?.id ?? 0,
      code: _codeController.text.trim().isEmpty
          ? null
          : _codeController.text.trim(),
      name: _nameController.text.trim(),
      foilingType: _foilingType,
      size: _sizeController.text.trim(),
      material: _materialController.text.trim(),
      thickness: _thicknessController.text.trim(),
      notes: _notesController.text.trim(),
      confirmed: widget.plate?.confirmed ?? false,
      products: products,
      createdAt: widget.plate?.createdAt,
    );

    if (widget.plate == null) {
      await viewModel.createFoilingPlate(payload);
    } else {
      await viewModel.updateFoilingPlate(payload);
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
                        options: _productOptions
                            .map(
                              (product) => DropdownOption<int>(
                                value: product.id,
                                label: product.displayLabel,
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => item.productId = value);
                        },
                      ),
                    ),
                    SizedBox(width: LayoutTokens.gapMd),
                    Expanded(
                      child: TextFormField(
                        controller: item.quantityController,
                        decoration:
                            const InputDecoration(labelText: _quantityLabel),
                        keyboardType: TextInputType.number,
                      ),
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

  @override
  Widget build(BuildContext context) {
    final isConfirmed = widget.plate?.confirmed == true;

    return CrudEditPage<FoilingPlate, FoilingPlateViewModel>(
      item: widget.plate,
      config: CrudEditConfig<FoilingPlate, FoilingPlateViewModel>(
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
                value: _foilingType,
                options: const [
                  CrudFieldOption(value: 'gold', label: '烫金'),
                  CrudFieldOption(value: 'silver', label: '烫银'),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _foilingType = value as String);
                },
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
