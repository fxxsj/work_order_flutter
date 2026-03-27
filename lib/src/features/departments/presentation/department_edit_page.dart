import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_edit_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
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
  static const String _basicSectionTitle = '基本信息';
  static const String _extraSectionTitle = '补充信息';
  static const String _processPlaceholder = '请选择工序（可多选）';

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _sortController;

  int? _parentId;
  bool _isActive = true;
  List<int> _processIds = [];

  @override
  void initState() {
    super.initState();
    final department = widget.department;
    _codeController = TextEditingController(text: department?.code ?? '');
    _nameController = TextEditingController(text: department?.name ?? '');
    _sortController =
        TextEditingController(text: (department?.sortOrder ?? 0).toString());
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

    if (widget.department == null) {
      await viewModel.createDepartment(payload);
    } else {
      await viewModel.updateDepartment(payload);
    }
  }

  List<Department> _availableParents(List<Department> departments) {
    final current = widget.department;
    return departments.where((department) {
      if (current != null && department.id == current.id) {
        return false;
      }
      if (department.level != null && department.level! >= 2) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DepartmentViewModel>();
    final availableParents = _availableParents(viewModel.departmentOptions);
    final disableParent = widget.department != null &&
        (widget.department?.childrenCount ?? 0) > 0;

    return CrudEditPage<Department, DepartmentViewModel>(
      item: widget.department,
      config: CrudEditConfig<Department, DepartmentViewModel>(
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
              ),
              CrudFormField.text(
                label: _nameLabel,
                controller: _nameController,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return _nameRequiredText;
                  }
                  return null;
                },
              ),
              CrudFormField.dropdown(
                label: _parentLabel,
                value: _parentId,
                enabled: !disableParent,
                options: [
                  const CrudFieldOption<dynamic>(value: null, label: '不设置'),
                  ...availableParents.map(
                    (department) => CrudFieldOption<dynamic>(
                      value: department.id,
                      label: department.name,
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _parentId = value as int?),
              ),
            ],
          ),
          CrudFormSection(
            title: _extraSectionTitle,
            column: isMobile ? 0 : 1,
            fields: [
              CrudFormField.number(
                label: _sortLabel,
                controller: _sortController,
              ),
              CrudFormField.multiSelect(
                label: _processLabel,
                options: viewModel.processOptions
                    .map(
                      (process) => CrudFieldOption<dynamic>(
                        value: process.id,
                        label: process.isActive
                            ? process.name
                            : '${process.name}（已停用）',
                        enabled: process.isActive,
                      ),
                    )
                    .toList(),
                values: _processIds.toSet(),
                hintText: _processPlaceholder,
                searchHintText: '搜索工序名称',
                noResultsText: '无匹配项',
                onChanged: (values) {
                  setState(() {
                    _processIds = values.cast<int>().toList();
                  });
                },
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
