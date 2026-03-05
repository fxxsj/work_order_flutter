import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/dies/application/die_view_model.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

class DieEditPage extends StatefulWidget {
  const DieEditPage({super.key, this.die});

  final Die? die;

  @override
  State<DieEditPage> createState() => _DieEditPageState();
}

class _DieEditPageState extends State<DieEditPage> {
  final _formKey = GlobalKey<FormState>();

  static const double _padding = 16;
  static const double _sectionSpacing = 16;
  static const double _actionSpacing = 24;
  static const double _pageSpacing = 8;
  static const double _submitIndicatorSize = 20;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;
  static const double _columnSpacing = 24;

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

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _nameRequiredText = '请输入刀模名称';
  static const String _backText = '返回';
  static const String _cancelText = '取消';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _breadcrumbSeparator = ' / ';

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
  bool _submitting = false;
  ProductApiService? _productApi;
  bool _loadingProducts = false;
  final List<ProductOption> _productOptions = [];
  final List<_DieProductItem> _productItems = [];

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
    setState(() {
      _productItems.add(_DieProductItem(quantity: 1));
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

  Future<void> _handleDieTypeChange(String? value) async {
    if (value == null) return;
    if (value == 'dedicated' && _productItems.length > 1) {
      final keepFirst = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('提示'),
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
    setState(() {
      _dieType = value;
    });
  }

  Future<void> _handleSubmit(DieViewModel viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

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
      code: _codeController.text.trim().isEmpty ? null : _codeController.text.trim(),
      name: _nameController.text.trim(),
      dieType: _dieType,
      size: _sizeController.text.trim(),
      material: _materialController.text.trim(),
      thickness: _thicknessController.text.trim(),
      notes: _notesController.text.trim(),
      confirmed: widget.die?.confirmed ?? false,
      dieTypeDisplay: widget.die?.dieTypeDisplay,
      products: products,
      createdAt: widget.die?.createdAt,
    );

    try {
      if (widget.die == null) {
        await viewModel.createDie(payload);
      } else {
        await viewModel.updateDie(payload);
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
        Text(
          _productHint(),
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
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
    final viewModel = context.watch<DieViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final isConfirmed = widget.die?.confirmed == true;
    final breadcrumb = buildBreadcrumbForPath('/dies');

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

    final typeField = DropdownButtonFormField<String>(
      value: _dieType,
      decoration: const InputDecoration(
        labelText: _typeLabel,
        border: OutlineInputBorder(),
      ),
      items: _dieTypeLabels.entries
          .map(
            (entry) => DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            ),
          )
          .toList(),
      onChanged: isConfirmed ? null : _handleDieTypeChange,
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
          typeField,
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
                    typeField,
                    const SizedBox(height: _sectionSpacing),
                    sizeField,
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
                    materialField,
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
