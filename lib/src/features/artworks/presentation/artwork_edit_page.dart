import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/artworks/application/artwork_view_model.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';

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
  }

  @override
  void dispose() {
    _baseCodeController.dispose();
    _nameController.dispose();
    _otherColorsController.dispose();
    _impositionController.dispose();
    _notesController.dispose();
    super.dispose();
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
      dieIds: widget.artwork?.dieIds ?? const [],
      foilingPlateIds: widget.artwork?.foilingPlateIds ?? const [],
      embossingPlateIds: widget.artwork?.embossingPlateIds ?? const [],
      code: widget.artwork?.code,
      colorDisplay: widget.artwork?.colorDisplay,
      dieCodes: widget.artwork?.dieCodes ?? const [],
      dieNames: widget.artwork?.dieNames ?? const [],
      foilingPlateCodes: widget.artwork?.foilingPlateCodes ?? const [],
      foilingPlateNames: widget.artwork?.foilingPlateNames ?? const [],
      embossingPlateCodes: widget.artwork?.embossingPlateCodes ?? const [],
      embossingPlateNames: widget.artwork?.embossingPlateNames ?? const [],
      products: widget.artwork?.products ?? const [],
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
                    impositionField,
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
