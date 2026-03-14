import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/edit_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
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
  final _formKey = GlobalKey<FormState>();

  static const double _inlineSpacing = 8;

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
  static const String _cancelText = '返回';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _durationController;
  late final TextEditingController _sortController;

  bool _isActive = true;
  bool _submitting = false;

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
    _sortController = TextEditingController(text: (process?.sortOrder ?? 0).toString());
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
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

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

    try {
      if (widget.process == null) {
        await viewModel.createProcess(payload);
      } else {
        await viewModel.updateProcess(payload);
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
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProcessViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final contentPadding = LayoutTokens.pagePadding(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final actionSpacing = LayoutTokens.formActionSpacing(context);
    final pageSpacing = LayoutTokens.formPageSpacing(context);
    final columnSpacing = LayoutTokens.formColumnSpacing(context);

    final codeField = TextFormField(
      controller: _codeController,
      decoration: const InputDecoration(labelText: _codeLabel),
      enabled: widget.process == null,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) {
          return _codeRequiredText;
        }
        return null;
      },
    );

    final nameField = TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: _nameLabel),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) {
          return _nameRequiredText;
        }
        return null;
      },
    );

    final descField = TextFormField(
      controller: _descController,
      decoration: const InputDecoration(labelText: _descLabel),
      maxLines: 3,
    );

    final durationField = TextFormField(
      controller: _durationController,
      decoration: const InputDecoration(labelText: _durationLabel),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );

    final sortField = TextFormField(
      controller: _sortController,
      decoration: const InputDecoration(labelText: _sortLabel),
      keyboardType: TextInputType.number,
    );

    final statusField = InputDecorator(
      decoration: const InputDecoration(labelText: _statusLabel),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Switch(
          value: _isActive,
          onChanged: (value) {
            setState(() {
              _isActive = value;
            });
          },
        ),
      ),
    );

    final mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile) ...[
          _sectionTitle(theme, _basicSectionTitle),
          SizedBox(height: sectionSpacing),
          codeField,
          SizedBox(height: sectionSpacing),
          nameField,
          SizedBox(height: sectionSpacing),
          descField,
          SizedBox(height: sectionSpacing),
          _sectionTitle(theme, _extraSectionTitle),
          SizedBox(height: sectionSpacing),
          durationField,
          SizedBox(height: sectionSpacing),
          sortField,
          SizedBox(height: sectionSpacing),
          statusField,
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionTitle(theme, _basicSectionTitle),
                    SizedBox(height: sectionSpacing),
                    codeField,
                    SizedBox(height: sectionSpacing),
                    nameField,
                    SizedBox(height: sectionSpacing),
                    descField,
                  ],
                ),
              ),
              SizedBox(width: columnSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionTitle(theme, _extraSectionTitle),
                    SizedBox(height: sectionSpacing),
                    durationField,
                    SizedBox(height: sectionSpacing),
                    sortField,
                    SizedBox(height: sectionSpacing),
                    statusField,
                  ],
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: actionSpacing),
      ],
    );

    return SafeArea(
      child: Form(
        key: _formKey,
        child: EditPageScaffold(
          spacing: pageSpacing,
          contentPadding: contentPadding,
          header: PageHeaderBar(
            breadcrumb: null,
            useSurface: false,
            showDivider: false,
            padding: EdgeInsets.zero,
            actions: Wrap(
              spacing: _inlineSpacing,
              runSpacing: 8,
              children: [
                PageActionButton.outlined(
                  onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: _cancelText,
                ),
                PageActionButton.filled(
                  onPressed: _submitting ? null : () => _handleSubmit(viewModel),
                  icon: const Icon(Icons.save, size: 16),
                  label: _submitting ? '保存中' : _submitText,
                ),
              ],
            ),
          ),
          body: mainContent,
        ),
      ),
    );
  }
}
