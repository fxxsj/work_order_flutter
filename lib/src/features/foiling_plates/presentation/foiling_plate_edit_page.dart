import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/foiling_plates/application/foiling_plate_view_model.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';

class FoilingPlateEditPage extends StatefulWidget {
  const FoilingPlateEditPage({super.key, this.plate});

  final FoilingPlate? plate;

  @override
  State<FoilingPlateEditPage> createState() => _FoilingPlateEditPageState();
}

class _FoilingPlateEditPageState extends State<FoilingPlateEditPage> {
  final _formKey = GlobalKey<FormState>();

  static const double _padding = 16;
  static const double _sectionSpacing = 16;
  static const double _actionSpacing = 24;
  static const double _pageSpacing = 8;
  static const double _submitIndicatorSize = 20;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;
  static const double _columnSpacing = 24;

  static const String _codeLabel = '烫金版编码';
  static const String _nameLabel = '烫金版名称';
  static const String _typeLabel = '类型';
  static const String _sizeLabel = '尺寸';
  static const String _materialLabel = '材质';
  static const String _thicknessLabel = '厚度';
  static const String _notesLabel = '备注';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _nameRequiredText = '请输入烫金版名称';
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

  String _foilingType = 'gold';
  bool _submitting = false;

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
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _sizeController.dispose();
    _materialController.dispose();
    _thicknessController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(FoilingPlateViewModel viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

    final payload = FoilingPlate(
      id: widget.plate?.id ?? 0,
      code: _codeController.text.trim().isEmpty ? null : _codeController.text.trim(),
      name: _nameController.text.trim(),
      foilingType: _foilingType,
      size: _sizeController.text.trim(),
      material: _materialController.text.trim(),
      thickness: _thicknessController.text.trim(),
      notes: _notesController.text.trim(),
      confirmed: widget.plate?.confirmed ?? false,
      products: widget.plate?.products ?? const [],
      createdAt: widget.plate?.createdAt,
    );

    try {
      if (widget.plate == null) {
        await viewModel.createFoilingPlate(payload);
      } else {
        await viewModel.updateFoilingPlate(payload);
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FoilingPlateViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPath('/foiling-plates');

    final codeField = TextFormField(
      controller: _codeController,
      decoration: const InputDecoration(
        labelText: _codeLabel,
        border: OutlineInputBorder(),
        hintText: '留空则系统自动生成',
      ),
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

    final typeField = DropdownButtonFormField<String>(
      value: _foilingType,
      decoration: const InputDecoration(
        labelText: _typeLabel,
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'gold', child: Text('烫金')),
        DropdownMenuItem(value: 'silver', child: Text('烫银')),
      ],
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _foilingType = value;
        });
      },
    );

    final sizeField = TextFormField(
      controller: _sizeController,
      decoration: const InputDecoration(
        labelText: _sizeLabel,
        border: OutlineInputBorder(),
      ),
    );

    final materialField = TextFormField(
      controller: _materialController,
      decoration: const InputDecoration(
        labelText: _materialLabel,
        border: OutlineInputBorder(),
      ),
    );

    final thicknessField = TextFormField(
      controller: _thicknessController,
      decoration: const InputDecoration(
        labelText: _thicknessLabel,
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
