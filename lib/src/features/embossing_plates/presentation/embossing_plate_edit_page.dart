import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/embossing_plates/application/embossing_plate_view_model.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

class EmbossingPlateEditPage extends StatefulWidget {
  const EmbossingPlateEditPage({super.key, this.plate});

  final EmbossingPlate? plate;

  @override
  State<EmbossingPlateEditPage> createState() => _EmbossingPlateEditPageState();
}

class _EmbossingPlateEditPageState extends State<EmbossingPlateEditPage> {
  final _formKey = GlobalKey<FormState>();

  static const double _padding = 16;
  static const double _sectionSpacing = 16;
  static const double _actionSpacing = 24;
  static const double _pageSpacing = 8;
  static const double _submitIndicatorSize = 20;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;
  static const double _columnSpacing = 24;

  static const String _codeLabel = '压凸版编码';
  static const String _nameLabel = '压凸版名称';
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
  static const String _nameRequiredText = '请输入压凸版名称';
  static const String _backText = '返回';
  static const String _cancelText = '取消';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _breadcrumbSeparator = ' / ';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _sizeController;
  late final TextEditingController _materialController;
  late final TextEditingController _thicknessController;
  late final TextEditingController _notesController;

  bool _submitting = false;
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
    for (final product in plate?.products ?? const <EmbossingPlateProduct>[]) {
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
    setState(() {
      _productItems.add(_PlateProductItem(quantity: 1));
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

  Future<void> _handleSubmit(EmbossingPlateViewModel viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

    final products = _productItems
        .where((item) => item.productId != null)
        .map(
          (item) => EmbossingPlateProduct(
            productId: item.productId!,
            productName: _productNameFor(item.productId),
            quantity: item.quantity,
          ),
        )
        .toList();

    final payload = EmbossingPlate(
      id: widget.plate?.id ?? 0,
      code: _codeController.text.trim().isEmpty ? null : _codeController.text.trim(),
      name: _nameController.text.trim(),
      size: _sizeController.text.trim(),
      material: _materialController.text.trim(),
      thickness: _thicknessController.text.trim(),
      notes: _notesController.text.trim(),
      confirmed: widget.plate?.confirmed ?? false,
      products: products,
      createdAt: widget.plate?.createdAt,
    );

    try {
      if (widget.plate == null) {
        await viewModel.createEmbossingPlate(payload);
      } else {
        await viewModel.updateEmbossingPlate(payload);
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
        if (_loadingProducts)
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
    final viewModel = context.watch<EmbossingPlateViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final isConfirmed = widget.plate?.confirmed == true;
    final breadcrumb = buildBreadcrumbForPath('/embossing-plates');

    final codeField = TextFormField(
      controller: _codeController,
      decoration: const InputDecoration(
        labelText: _codeLabel,
        border: OutlineInputBorder(),
        hintText: '留空则系统自动生成',
      ),
      enabled: !isConfirmed,
    );

    final nameField = TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: _nameLabel,
        border: OutlineInputBorder(),
      ),
      enabled: !isConfirmed,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) {
          return _nameRequiredText;
        }
        return null;
      },
    );

    final sizeField = TextFormField(
      controller: _sizeController,
      decoration: const InputDecoration(
        labelText: _sizeLabel,
        border: OutlineInputBorder(),
      ),
      enabled: !isConfirmed,
    );

    final materialField = TextFormField(
      controller: _materialController,
      decoration: const InputDecoration(
        labelText: _materialLabel,
        border: OutlineInputBorder(),
      ),
      enabled: !isConfirmed,
    );

    final thicknessField = TextFormField(
      controller: _thicknessController,
      decoration: const InputDecoration(
        labelText: _thicknessLabel,
        border: OutlineInputBorder(),
      ),
      enabled: !isConfirmed,
    );

    final notesField = TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: _notesLabel,
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );

    final productSection = _buildProductSection(theme);

    final mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile) ...[
          _sectionTitle(theme, _basicSectionTitle),
          const SizedBox(height: _sectionSpacing),
          codeField,
          const SizedBox(height: _sectionSpacing),
          nameField,
          const SizedBox(height: _sectionSpacing),
          sizeField,
          const SizedBox(height: _sectionSpacing),
          materialField,
          const SizedBox(height: _sectionSpacing),
          thicknessField,
          const SizedBox(height: _sectionSpacing),
          productSection,
          const SizedBox(height: _sectionSpacing),
          _sectionTitle(theme, _extraSectionTitle),
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
                    codeField,
                    const SizedBox(height: _sectionSpacing),
                    nameField,
                    const SizedBox(height: _sectionSpacing),
                    sizeField,
                    const SizedBox(height: _sectionSpacing),
                    materialField,
                    const SizedBox(height: _sectionSpacing),
                    productSection,
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
                    thicknessField,
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
