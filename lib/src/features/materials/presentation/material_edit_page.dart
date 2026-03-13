import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/edit_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/materials/application/material_view_model.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';

class MaterialEditPage extends StatefulWidget {
  const MaterialEditPage({super.key, this.material});

  final MaterialItem? material;

  @override
  State<MaterialEditPage> createState() => _MaterialEditPageState();
}

class _MaterialEditPageState extends State<MaterialEditPage> {
  final _formKey = GlobalKey<FormState>();

  static const double _submitIndicatorSize = 20;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;

  static const String _codeLabel = '物料编码';
  static const String _nameLabel = '物料名称';
  static const String _unitLabel = '单位';
  static const String _unitPriceLabel = '单价';
  static const String _stockLabel = '库存数量';
  static const String _minStockLabel = '最小库存';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _codeRequiredText = '请输入物料编码';
  static const String _codeLengthText = '编码长度在2-50个字符之间';
  static const String _codeInvalidText = '编码只能包含字母、数字和连字符';
  static const String _nameRequiredText = '请输入物料名称';
  static const String _unitRequiredText = '请输入单位';
  static const String _backText = '返回';
  static const String _cancelText = '取消';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '库存信息';
  static const String _breadcrumbSeparator = ' / ';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _unitController;
  late final TextEditingController _unitPriceController;
  late final TextEditingController _stockController;
  late final TextEditingController _minStockController;

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final material = widget.material;
    _codeController = TextEditingController(text: material?.code ?? '');
    _nameController = TextEditingController(text: material?.name ?? '');
    _unitController = TextEditingController(text: material?.unit ?? '个');
    _unitPriceController = TextEditingController(
      text: material?.unitPrice?.toStringAsFixed(2) ?? '',
    );
    _stockController = TextEditingController(
      text: material?.stockQuantity?.toStringAsFixed(3) ?? '',
    );
    _minStockController = TextEditingController(
      text: material?.minStockQuantity?.toStringAsFixed(3) ?? '',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _unitController.dispose();
    _unitPriceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(MaterialViewModel viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

    final payload = MaterialItem(
      id: widget.material?.id ?? 0,
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      unit: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
      unitPrice: _parseDouble(_unitPriceController.text),
      stockQuantity: _parseDouble(_stockController.text),
      minStockQuantity: _parseDouble(_minStockController.text),
      isActive: widget.material?.isActive,
    );

    try {
      if (widget.material == null) {
        await viewModel.createMaterial(payload);
      } else {
        await viewModel.updateMaterial(payload);
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
    final viewModel = context.watch<MaterialViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPath('/materials');
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
          controller: _unitController,
          decoration: const InputDecoration(labelText: _unitLabel),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return _unitRequiredText;
            return null;
          },
        ),
      ],
    );

    final extraFields = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, _extraSectionTitle),
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
        TextFormField(
          controller: _minStockController,
          decoration: const InputDecoration(labelText: _minStockLabel),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
