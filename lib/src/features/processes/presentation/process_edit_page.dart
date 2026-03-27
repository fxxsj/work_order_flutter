import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/features/processes/application/process_view_model.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';

/// 工序编辑页，支持新增与编辑。
class ProcessEditPage extends StatefulWidget {
  const ProcessEditPage({super.key, this.process});

  final Process? process;

  @override
  State<ProcessEditPage> createState() => _ProcessEditPageState();
}

class _ProcessEditPageState extends State<ProcessEditPage> {
  static const String _codeLabel = '工序编码';
  static const String _nameLabel = '工序名称';
  static const String _descLabel = '描述';
  static const String _durationLabel = '标准工时(小时)';
  static const String _sortLabel = '排序';
  static const String _statusLabel = '是否启用';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _codeRequiredText = '请输入工序编码';
  static const String _nameRequiredText = '请输入工序名称';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _durationController;
  late final TextEditingController _sortController;

  bool _isActive = true;

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
    final duration = double.tryParse(_durationController.text.trim()) ?? 0;
    final sortValue = int.tryParse(_sortController.text.trim()) ?? 0;

    final payload = Process(
      id: widget.process?.id ?? 0,
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      standardDuration: duration,
      sortOrder: sortValue,
      isActive: _isActive,
    );

    if (widget.process == null) {
      await viewModel.createProcess(payload);
    } else {
      await viewModel.updateProcess(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CrudEditPage<Process, ProcessViewModel>(
      item: widget.process,
      config: CrudEditConfig<Process, ProcessViewModel>(
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
                enabled: widget.process == null,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _codeRequiredText;
                  return null;
                },
              ),
              CrudFormField.text(
                label: _nameLabel,
                controller: _nameController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return _nameRequiredText;
                  return null;
                },
              ),
              CrudFormField.textarea(
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
              CrudFormField.number(
                label: _durationLabel,
                controller: _durationController,
                decimal: true,
              ),
              CrudFormField.number(
                label: _sortLabel,
                controller: _sortController,
              ),
              CrudFormField.toggle(
                label: _statusLabel,
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
          ),
        ],
        onSave: (context, viewModel, item) => _handleSubmit(viewModel),
      ),
    );
  }
}
