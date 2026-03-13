import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/edit_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/departments/application/department_view_model.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';

/// 部门编辑页，支持新增与编辑。
class DepartmentEditPage extends StatefulWidget {
  const DepartmentEditPage({super.key, this.department});

  final Department? department;

  @override
  State<DepartmentEditPage> createState() => _DepartmentEditPageState();
}

class _DepartmentEditPageState extends State<DepartmentEditPage> {
  final _formKey = GlobalKey<FormState>();

  static const double _submitIndicatorSize = 20;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;

  static const String _codeLabel = '部门编码';
  static const String _nameLabel = '部门名称';
  static const String _parentLabel = '上级部门';
  static const String _sortLabel = '排序';
  static const String _processLabel = '工序';
  static const String _statusLabel = '是否启用';

  static const String _submitText = '保存';
  static const String _submitErrorText = '操作失败: ';
  static const String _codeRequiredText = '请输入部门编码';
  static const String _codeInvalidText = '部门编码只能包含小写字母、数字和下划线';
  static const String _nameRequiredText = '请输入部门名称';
  static const String _cancelText = '返回';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _processPlaceholder = '请选择工序（可多选）';
  static const String _processSearchHint = '搜索工序名称';
  static const String _emptyMatchText = '无匹配项';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _sortController;

  int? _parentId;
  bool _isActive = true;
  List<int> _processIds = [];
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final department = widget.department;
    _codeController = TextEditingController(text: department?.code ?? '');
    _nameController = TextEditingController(text: department?.name ?? '');
    _sortController = TextEditingController(text: (department?.sortOrder ?? 0).toString());
    _parentId = department?.parentId;
    _isActive = department?.isActive ?? true;
    _processIds = List<int>.from(department?.processIds ?? const []);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _sortController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(DepartmentViewModel viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

    final sortValue = int.tryParse(_sortController.text.trim()) ?? 0;

    final payload = Department(
      id: widget.department?.id ?? 0,
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      parentId: _parentId,
      sortOrder: sortValue,
      isActive: _isActive,
      processIds: _processIds,
      parentName: widget.department?.parentName,
      processNames: widget.department?.processNames ?? const [],
      childrenCount: widget.department?.childrenCount,
      createdAt: widget.department?.createdAt,
      level: widget.department?.level,
    );

    try {
      if (widget.department == null) {
        await viewModel.createDepartment(payload);
      } else {
        await viewModel.updateDepartment(payload);
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

  List<Department> _availableParents(List<Department> departments) {
    final current = widget.department;
    return departments.where((dept) {
      if (current != null && dept.id == current.id) return false;
      if (dept.level != null && dept.level! >= 2) return false;
      return true;
    }).toList();
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
    final viewModel = context.watch<DepartmentViewModel>();
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final subtleText = colors?.subtleText ?? theme.hintColor;
    final isMobile = BreakpointsUtil.isMobile(context);
    final availableParents = _availableParents(viewModel.departmentOptions);
    final disableParent = widget.department != null && (widget.department?.childrenCount ?? 0) > 0;
    final contentPadding = LayoutTokens.pagePadding(context);
    final sectionSpacing = LayoutTokens.formSectionSpacing(context);
    final actionSpacing = LayoutTokens.formActionSpacing(context);
    final pageSpacing = LayoutTokens.formPageSpacing(context);
    final columnSpacing = LayoutTokens.formColumnSpacing(context);

    final codeField = TextFormField(
      controller: _codeController,
      decoration: const InputDecoration(labelText: _codeLabel),
      enabled: widget.department == null,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) {
          return _codeRequiredText;
        }
        if (!RegExp(r'^[a-z0-9_]+$').hasMatch(text)) {
          return _codeInvalidText;
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

    final parentField = DropdownButtonFormField<int?>(
      initialValue: _parentId,
      decoration: const InputDecoration(labelText: _parentLabel),
      items: [
        const DropdownMenuItem<int?>(value: null, child: Text('不设置')),
        ...availableParents.map(
          (dept) => DropdownMenuItem<int?>(value: dept.id, child: Text(dept.name)),
        ),
      ],
      onChanged: disableParent
          ? null
          : (value) {
              setState(() {
                _parentId = value;
              });
            },
    );

    final sortField = TextFormField(
      controller: _sortController,
      decoration: const InputDecoration(labelText: _sortLabel),
      keyboardType: TextInputType.number,
    );

    final processField = InkWell(
      onTap: viewModel.processOptions.isEmpty ? null : () => _openProcessDialog(viewModel),
      borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: _processLabel,
          contentPadding: EdgeInsets.all(12),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: viewModel.processOptions.isEmpty
            ? Text('暂无工序数据', style: theme.textTheme.bodySmall?.copyWith(color: subtleText))
            : _processIds.isEmpty
                ? Text(_processPlaceholder, style: theme.textTheme.bodyMedium?.copyWith(color: subtleText))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: viewModel.processOptions
                        .where((process) => _processIds.contains(process.id))
                        .map(
                          (process) => InputChip(
                            label: Text(process.name),
                            onDeleted: () {
                              setState(() {
                                _processIds = _processIds.where((id) => id != process.id).toList();
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
      ),
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
          parentField,
          SizedBox(height: sectionSpacing),
          _sectionTitle(theme, _extraSectionTitle),
          SizedBox(height: sectionSpacing),
          sortField,
          SizedBox(height: sectionSpacing),
          processField,
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
                    parentField,
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
                    sortField,
                    SizedBox(height: sectionSpacing),
                    processField,
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
            actions: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PageActionButton.outlined(
                  onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.arrow_back, size: 16),
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
                      : const Icon(Icons.save, size: 16),
                ),
              ],
            ),
          ),
          body: mainContent,
        ),
      ),
    );
  }

  Future<void> _openProcessDialog(DepartmentViewModel viewModel) async {
    if (viewModel.processOptions.isEmpty) return;
    final original = List<int>.from(_processIds);
    String query = '';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filtered = viewModel.processOptions
                .where((process) => process.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return AlertDialog(
              title: const Text(_processLabel),
              content: SizedBox(
                width: 520,
                height: 420,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: _processSearchHint,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => setDialogState(() => query = value.trim()),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(child: Text(_emptyMatchText, style: Theme.of(context).textTheme.bodySmall))
                          : Scrollbar(
                              child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final process = filtered[index];
                                  final selected = _processIds.contains(process.id);
                                  return CheckboxListTile(
                                    value: selected,
                                    dense: true,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text(process.name),
                                    subtitle: process.isActive ? null : const Text('已停用'),
                                    onChanged: process.isActive
                                        ? (value) {
                                            setDialogState(() {
                                              if (value == true) {
                                                _processIds = [..._processIds, process.id];
                                              } else {
                                                _processIds = _processIds.where((id) => id != process.id).toList();
                                              }
                                            });
                                            setState(() {});
                                          }
                                        : null,
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() => _processIds = List<int>.from(original));
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    setDialogState(() => _processIds = []);
                    setState(() {});
                  },
                  child: const Text('清空'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('确定'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
