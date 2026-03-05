import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
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

  static const double _padding = 16;
  static const double _sectionSpacing = 16;
  static const double _pageSpacing = 8;
  static const double _inlineSpacing = 8;
  static const double _columnSpacing = 24;

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
  static const String _backText = '返回';
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _breadcrumbSeparator = ' / ';

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
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DepartmentViewModel>();
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPath('/departments');
    final availableParents = _availableParents(viewModel.departmentOptions);
    final disableParent = widget.department != null && (widget.department?.childrenCount ?? 0) > 0;

    final codeField = TextFormField(
      controller: _codeController,
      decoration: const InputDecoration(
        labelText: _codeLabel,
        border: OutlineInputBorder(),
      ),
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

    final parentField = DropdownButtonFormField<int?>(
      value: _parentId,
      decoration: const InputDecoration(
        labelText: _parentLabel,
        border: OutlineInputBorder(),
      ),
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
      decoration: const InputDecoration(
        labelText: _sortLabel,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );

    final processChips = viewModel.processOptions.isEmpty
        ? Text('暂无工序数据', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor))
        : Wrap(
            spacing: 8,
            runSpacing: 8,
            children: viewModel.processOptions.map((process) {
              final selected = _processIds.contains(process.id);
              return FilterChip(
                label: Text(process.name),
                selected: selected,
                onSelected: process.isActive
                    ? (value) {
                        setState(() {
                          if (value) {
                            _processIds = [..._processIds, process.id];
                          } else {
                            _processIds = _processIds.where((id) => id != process.id).toList();
                          }
                        });
                      }
                    : null,
              );
            }).toList(),
          );

    final statusField = SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(_statusLabel),
      value: _isActive,
      onChanged: (value) {
        setState(() {
          _isActive = value;
        });
      },
    );

    final mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, _basicSectionTitle),
        const SizedBox(height: _sectionSpacing),
        if (isMobile) ...[
          codeField,
          const SizedBox(height: _sectionSpacing),
          nameField,
          const SizedBox(height: _sectionSpacing),
          parentField,
        ] else
          Row(
            children: [
              Expanded(child: codeField),
              const SizedBox(width: _columnSpacing),
              Expanded(child: nameField),
              const SizedBox(width: _columnSpacing),
              Expanded(child: parentField),
            ],
          ),
        const SizedBox(height: _sectionSpacing),
        _sectionTitle(theme, _extraSectionTitle),
        const SizedBox(height: _sectionSpacing),
        if (isMobile) ...[
          sortField,
          const SizedBox(height: _sectionSpacing),
          processChips,
          const SizedBox(height: _sectionSpacing),
          statusField,
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: sortField),
              const SizedBox(width: _columnSpacing),
              Expanded(child: processChips),
              const SizedBox(width: _columnSpacing),
              Expanded(child: statusField),
            ],
          ),
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
            Padding(
              padding: const EdgeInsets.only(left: _padding, right: _padding, bottom: _padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!isMobile)
                    OutlinedButton(
                      onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
                      child: const Text('取消'),
                    ),
                  if (!isMobile) const SizedBox(width: _inlineSpacing),
                  FilledButton(
                    onPressed: _submitting ? null : () => _handleSubmit(viewModel),
                    child: _submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(_submitText),
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
