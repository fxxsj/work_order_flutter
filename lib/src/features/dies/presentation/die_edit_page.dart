import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/dies/application/die_view_model.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';

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

  Future<void> _handleSubmit(DieViewModel viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

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
      products: widget.die?.products ?? const [],
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DieViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPath('/dies');

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
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _dieType = value;
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
