import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/edit_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/products/application/product_view_model.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

class ProductEditPage extends StatefulWidget {
  const ProductEditPage({super.key, this.product});

  final Product? product;

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final _formKey = GlobalKey<FormState>();

  static const double _submitIndicatorSize = 20;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;

  static const String _codeLabel = '产品编码';
  static const String _nameLabel = '产品名称';
  static const String _specLabel = '规格';
  static const String _unitLabel = '单位';
  static const String _unitPriceLabel = '单价';
  static const String _stockLabel = '库存数量';
  static const String _statusLabel = '启用状态';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _codeRequiredText = '请输入产品编码';
  static const String _codeLengthText = '编码长度在2-50个字符之间';
  static const String _codeInvalidText = '编码只能包含字母、数字和连字符';
  static const String _nameRequiredText = '请输入产品名称';
  static const String _backText = '返回';
  static const String _cancelText = '取消';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _breadcrumbSeparator = ' / ';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _specController;
  late final TextEditingController _unitController;
  late final TextEditingController _unitPriceController;
  late final TextEditingController _stockController;

  bool _isActive = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _codeController = TextEditingController(text: product?.code ?? '');
    _nameController = TextEditingController(text: product?.name ?? '');
    _specController = TextEditingController(text: product?.specification ?? '');
    _unitController = TextEditingController(text: product?.unit ?? '件');
    _unitPriceController = TextEditingController(
      text: product?.unitPrice?.toStringAsFixed(2) ?? '',
    );
    _stockController = TextEditingController(
      text: product?.stockQuantity?.toStringAsFixed(0) ?? '',
    );
    _isActive = product?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _specController.dispose();
    _unitController.dispose();
    _unitPriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(ProductViewModel viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

    final payload = Product(
      id: widget.product?.id ?? 0,
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      specification: _specController.text.trim().isEmpty ? null : _specController.text.trim(),
      unit: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
      unitPrice: _parseDouble(_unitPriceController.text),
      stockQuantity: _parseDouble(_stockController.text),
      isActive: _isActive,
      productTypeDisplay: widget.product?.productTypeDisplay,
      productGroupName: widget.product?.productGroupName,
    );

    try {
      if (widget.product == null) {
        await viewModel.createProduct(payload);
      } else {
        await viewModel.updateProduct(payload);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_submitErrorText$err');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  double? _parseDouble(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text);
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPath('/products');
    final contentPadding = LayoutTokens.pagePadding(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final actionSpacing = LayoutTokens.formActionSpacing(context);
    final pageSpacing = LayoutTokens.formPageSpacing(context);
    final columnSpacing = LayoutTokens.formColumnSpacing(context);

    final basicFields = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, _basicSectionTitle),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _codeController,
          decoration: const InputDecoration(labelText: _codeLabel),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return _codeRequiredText;
            if (text.length < 2 || text.length > 50) return _codeLengthText;
            final regex = RegExp(r'^[A-Za-z0-9-]+$');
            if (!regex.hasMatch(text)) return _codeInvalidText;
            return null;
          },
        ),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: _nameLabel),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return _nameRequiredText;
            return null;
          },
        ),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _specController,
          decoration: const InputDecoration(labelText: _specLabel),
        ),
      ],
    );

    final extraFields = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, _extraSectionTitle),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _unitController,
          decoration: const InputDecoration(labelText: _unitLabel),
        ),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _unitPriceController,
          decoration: const InputDecoration(labelText: _unitPriceLabel),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(height: sectionSpacing),
        TextFormField(
          controller: _stockController,
          decoration: const InputDecoration(labelText: _stockLabel),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(height: sectionSpacing),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text(_statusLabel),
          value: _isActive,
          onChanged: (value) => setState(() => _isActive = value),
        ),
      ],
    );

    final body = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              basicFields,
              SizedBox(height: sectionSpacing),
              extraFields,
              SizedBox(height: actionSpacing),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: basicFields),
              SizedBox(width: columnSpacing),
              Expanded(child: extraFields),
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
          body: body,
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
