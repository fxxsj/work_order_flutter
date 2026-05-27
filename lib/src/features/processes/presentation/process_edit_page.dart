import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_drawer_edit_panel.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/features/processes/application/process_view_model.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';

Future<bool> showProcessEditDrawer(
  BuildContext context, {
  required ProcessViewModel viewModel,
  Process? process,
}) async {
  var saved = false;
  await showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: process == null ? '新建工序' : '编辑工序',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: ChangeNotifierProvider<ProcessViewModel>.value(
      value: viewModel,
      child: ProcessEditPage(process: process, onSaved: () => saved = true),
    ),
  );
  return saved;
}

/// 工序编辑页，支持新增与编辑。
class ProcessEditPage extends StatefulWidget {
  const ProcessEditPage({super.key, this.process, this.onSaved});

  final Process? process;
  final VoidCallback? onSaved;

  @override
  State<ProcessEditPage> createState() => _ProcessEditPageState();
}

class _ProcessEditPageState extends State<ProcessEditPage> {
  static const String _codeLabel = '工序编码';
  static const String _nameLabel = '工序名称';
  static const String _descLabel = '描述';
  static const String _durationLabel = '标准工时(小时)';
  static const String _sortLabel = '排序';
  static const String _taskRuleLabel = '任务生成规则';
  static const String _statusLabel = '是否启用';
  static const String _requiresArtworkLabel = '需要图稿';
  static const String _requiresDieLabel = '需要刀模';
  static const String _requiresFoilingPlateLabel = '需要烫金版';
  static const String _requiresEmbossingPlateLabel = '需要压凸版';
  static const String _artworkRequiredLabel = '图稿必选';
  static const String _dieRequiredLabel = '刀模必选';
  static const String _foilingPlateRequiredLabel = '烫金版必选';
  static const String _embossingPlateRequiredLabel = '压凸版必选';
  static const String _parallelLabel = '可并行执行';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _codeRequiredText = '请输入工序编码';
  static const String _codeLengthText = '工序编码长度必须在2-50个字符之间';
  static const String _codeInvalidText = '工序编码只能包含字母、数字、连字符和下划线';
  static const String _nameRequiredText = '请输入工序名称';
  static const String _durationInvalidText = '标准工时必须在0-9999之间';
  static const String _sortInvalidText = '排序值必须在0-99999之间';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _durationController;
  late final TextEditingController _sortController;

  bool _isActive = true;
  bool _requiresArtwork = false;
  bool _requiresDie = false;
  bool _requiresFoilingPlate = false;
  bool _requiresEmbossingPlate = false;
  bool _artworkRequired = true;
  bool _dieRequired = true;
  bool _foilingPlateRequired = true;
  bool _embossingPlateRequired = true;
  bool _isParallel = false;
  String _taskGenerationRule = 'general';

  @override
  void initState() {
    super.initState();
    final process = widget.process;
    _codeController = TextEditingController(text: process?.code ?? '');
    _nameController = TextEditingController(text: process?.name ?? '');
    _descController = TextEditingController(text: process?.description ?? '');
    _durationController = TextEditingController(
      text: process?.standardDuration?.toString() ?? '0',
    );
    _sortController = TextEditingController(
      text: (process?.sortOrder ?? 0).toString(),
    );
    _isActive = process?.isActive ?? true;
    _requiresArtwork = process?.requiresArtwork ?? false;
    _requiresDie = process?.requiresDie ?? false;
    _requiresFoilingPlate = process?.requiresFoilingPlate ?? false;
    _requiresEmbossingPlate = process?.requiresEmbossingPlate ?? false;
    _artworkRequired = process?.artworkRequired ?? true;
    _dieRequired = process?.dieRequired ?? true;
    _foilingPlateRequired = process?.foilingPlateRequired ?? true;
    _embossingPlateRequired = process?.embossingPlateRequired ?? true;
    _isParallel = process?.isParallel ?? false;
    _taskGenerationRule = process?.taskGenerationRule ?? 'general';
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descController.dispose();
    _durationController.dispose();
    _sortController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(ProcessViewModel viewModel) async {
    final duration = int.tryParse(_durationController.text.trim()) ?? 0;
    final sortValue = int.tryParse(_sortController.text.trim()) ?? 0;

    final payload = Process(
      id: widget.process?.id ?? 0,
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      standardDuration: duration,
      sortOrder: sortValue,
      isActive: _isActive,
      isBuiltin: widget.process?.isBuiltin ?? false,
      taskGenerationRule: _taskGenerationRule,
      requiresArtwork: _requiresArtwork,
      requiresDie: _requiresDie,
      requiresFoilingPlate: _requiresFoilingPlate,
      requiresEmbossingPlate: _requiresEmbossingPlate,
      artworkRequired: _artworkRequired,
      dieRequired: _dieRequired,
      foilingPlateRequired: _foilingPlateRequired,
      embossingPlateRequired: _embossingPlateRequired,
      isParallel: _isParallel,
      createdAt: widget.process?.createdAt,
    );

    if (widget.process == null) {
      await viewModel.createProcess(payload);
    } else {
      await viewModel.updateProcess(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CrudDrawerEditPanel<Process, ProcessViewModel>(
      item: widget.process,
      onSaved: widget.onSaved,
      config: CrudEditConfig<Process, ProcessViewModel>(
        submitText: _submitText,
        submittingText: '保存中',
        errorMessagePrefix: _submitErrorText,
        sectionsBuilder: (context, isMobile) => [
          CrudFormSection(
            title: _basicSectionTitle,
            column: 0,
            fields: [
              CrudFieldConfig.text(
                label: _codeLabel,
                controller: _codeController,
                enabled:
                    widget.process == null || widget.process?.isBuiltin != true,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _codeRequiredText;
                  if (text.length < 2 || text.length > 50) {
                    return _codeLengthText;
                  }
                  if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(text)) {
                    return _codeInvalidText;
                  }
                  return null;
                },
              ),
              CrudFieldConfig.text(
                label: _nameLabel,
                controller: _nameController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _nameRequiredText;
                  return null;
                },
              ),
              CrudFieldConfig.textarea(
                label: _descLabel,
                controller: _descController,
                minLines: 3,
                maxLines: 3,
              ),
            ],
          ),
          CrudFormSection(
            title: _extraSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFieldConfig.number(
                label: _durationLabel,
                controller: _durationController,
                validator: (value) {
                  final duration = int.tryParse(value?.trim() ?? '');
                  if (duration == null || duration < 0 || duration > 9999) {
                    return _durationInvalidText;
                  }
                  return null;
                },
              ),
              CrudFieldConfig.number(
                label: _sortLabel,
                controller: _sortController,
                validator: (value) {
                  final sortValue = int.tryParse(value?.trim() ?? '');
                  if (sortValue == null || sortValue < 0 || sortValue > 99999) {
                    return _sortInvalidText;
                  }
                  return null;
                },
              ),
              CrudFieldConfig.dropdown(
                label: _taskRuleLabel,
                value: _taskGenerationRule,
                options: const [
                  AppDropdownOption(value: 'general', label: '通用任务'),
                  AppDropdownOption(value: 'product', label: '按产品'),
                  AppDropdownOption(value: 'material', label: '按物料'),
                  AppDropdownOption(value: 'artwork', label: '按图稿'),
                  AppDropdownOption(value: 'die', label: '按刀模'),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _taskGenerationRule = value as String;
                    if (_taskGenerationRule == 'artwork') {
                      _requiresArtwork = true;
                      _artworkRequired = true;
                    }
                    if (_taskGenerationRule == 'die') {
                      _requiresDie = true;
                      _dieRequired = true;
                    }
                  });
                },
              ),
              CrudFieldConfig.toggle(
                label: _statusLabel,
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
              CrudFieldConfig.toggle(
                label: _requiresArtworkLabel,
                value: _requiresArtwork,
                onChanged: (value) => setState(() {
                  _requiresArtwork = value;
                  if (value) _artworkRequired = true;
                }),
              ),
              CrudFieldConfig.toggle(
                label: _artworkRequiredLabel,
                value: _artworkRequired,
                enabled: _requiresArtwork,
                onChanged: (value) => setState(() => _artworkRequired = value),
              ),
              CrudFieldConfig.toggle(
                label: _requiresDieLabel,
                value: _requiresDie,
                onChanged: (value) => setState(() {
                  _requiresDie = value;
                  if (value) _dieRequired = true;
                }),
              ),
              CrudFieldConfig.toggle(
                label: _dieRequiredLabel,
                value: _dieRequired,
                enabled: _requiresDie,
                onChanged: (value) => setState(() => _dieRequired = value),
              ),
              CrudFieldConfig.toggle(
                label: _requiresFoilingPlateLabel,
                value: _requiresFoilingPlate,
                onChanged: (value) => setState(() {
                  _requiresFoilingPlate = value;
                  if (value) _foilingPlateRequired = true;
                }),
              ),
              CrudFieldConfig.toggle(
                label: _foilingPlateRequiredLabel,
                value: _foilingPlateRequired,
                enabled: _requiresFoilingPlate,
                onChanged: (value) =>
                    setState(() => _foilingPlateRequired = value),
              ),
              CrudFieldConfig.toggle(
                label: _requiresEmbossingPlateLabel,
                value: _requiresEmbossingPlate,
                onChanged: (value) => setState(() {
                  _requiresEmbossingPlate = value;
                  if (value) _embossingPlateRequired = true;
                }),
              ),
              CrudFieldConfig.toggle(
                label: _embossingPlateRequiredLabel,
                value: _embossingPlateRequired,
                enabled: _requiresEmbossingPlate,
                onChanged: (value) =>
                    setState(() => _embossingPlateRequired = value),
              ),
              CrudFieldConfig.toggle(
                label: _parallelLabel,
                value: _isParallel,
                onChanged: (value) => setState(() => _isParallel = value),
              ),
            ],
          ),
        ],
        onSave: (context, viewModel, item) => _handleSubmit(viewModel),
      ),
    );
  }
}
