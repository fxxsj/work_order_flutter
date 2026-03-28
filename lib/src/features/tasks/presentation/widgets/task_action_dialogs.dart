import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';

class TaskDepartmentOption {
  const TaskDepartmentOption({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;
}

Future<void> showTaskQuantityDialog(
  BuildContext context, {
  required Task task,
  required Future<void> Function(Map<String, dynamic> payload) onSubmit,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _TaskQuantityDialog(
      task: task,
      onSubmit: onSubmit,
    ),
  );
}

Future<void> showTaskCompleteDialog(
  BuildContext context, {
  required Task task,
  required Future<void> Function(Map<String, dynamic> payload) onSubmit,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _TaskCompleteDialog(
      task: task,
      onSubmit: onSubmit,
    ),
  );
}

Future<void> showTaskAssignDialog(
  BuildContext context, {
  required Task task,
  required List<TaskDepartmentOption> departments,
  required Future<List<Map<String, dynamic>>> Function(int departmentId)
      loadOperators,
  required Future<void> Function(int operatorId, String notes) onSubmit,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _TaskAssignDialog(
      task: task,
      departments: departments,
      loadOperators: loadOperators,
      onSubmit: onSubmit,
    ),
  );
}

class _TaskQuantityDialog extends StatefulWidget {
  const _TaskQuantityDialog({
    required this.task,
    required this.onSubmit,
  });

  final Task task;
  final Future<void> Function(Map<String, dynamic> payload) onSubmit;

  @override
  State<_TaskQuantityDialog> createState() => _TaskQuantityDialogState();
}

class _TaskQuantityDialogState extends State<_TaskQuantityDialog> {
  final _formKey = GlobalKey<FormState>();
  int _quantityIncrement = 1;
  int _quantityDefective = 0;
  String _notes = '';
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final total = task.productionQuantity ?? 0;
    final completed = task.quantityCompleted ?? 0;
    final remaining = (total - completed).clamp(0, double.infinity).toInt();

    return FormDialog(
      title: '更新进度',
      formKey: _formKey,
      submitText: '确认更新',
      submitting: _submitting,
      maxWidth: LayoutTokens.dialogWidthSm,
      onSubmit: _submit,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.workContent ?? '任务 #${task.id}'),
          SizedBox(height: LayoutTokens.gapSm),
          Text('已完成 $completed / $total · 剩余 $remaining'),
          SizedBox(height: LayoutTokens.gapMd),
          TextFormField(
            initialValue: _quantityIncrement.toString(),
            decoration: const InputDecoration(labelText: '本次完成数量'),
            keyboardType: TextInputType.number,
            validator: (value) {
              final parsed = int.tryParse(value ?? '');
              if (parsed == null || parsed <= 0) {
                return '请输入大于 0 的数量';
              }
              return null;
            },
            onChanged: (value) {
              _quantityIncrement = int.tryParse(value) ?? 0;
            },
          ),
          SizedBox(height: LayoutTokens.gapMd),
          TextFormField(
            initialValue: _quantityDefective.toString(),
            decoration: const InputDecoration(labelText: '不良品数量'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _quantityDefective = int.tryParse(value) ?? 0;
            },
          ),
          SizedBox(height: LayoutTokens.gapMd),
          TextFormField(
            decoration: const InputDecoration(labelText: '备注（可选）'),
            onChanged: (value) => _notes = value,
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    try {
      await widget.onSubmit({
        'quantity_increment': _quantityIncrement,
        'quantity_defective': _quantityDefective,
        'notes': _notes,
      });
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _TaskCompleteDialog extends StatefulWidget {
  const _TaskCompleteDialog({
    required this.task,
    required this.onSubmit,
  });

  final Task task;
  final Future<void> Function(Map<String, dynamic> payload) onSubmit;

  @override
  State<_TaskCompleteDialog> createState() => _TaskCompleteDialogState();
}

class _TaskCompleteDialogState extends State<_TaskCompleteDialog> {
  final _formKey = GlobalKey<FormState>();
  int _quantityDefective = 0;
  String _completionReason = '';
  String _notes = '';
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return FormDialog(
      title: '完成任务',
      formKey: _formKey,
      submitText: '确认完成',
      submitting: _submitting,
      maxWidth: LayoutTokens.dialogWidthSm,
      onSubmit: _submit,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.workContent ?? '任务 #${task.id}'),
          SizedBox(height: LayoutTokens.gapMd),
          TextFormField(
            initialValue: _quantityDefective.toString(),
            decoration: const InputDecoration(labelText: '不良品数量'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _quantityDefective = int.tryParse(value) ?? 0;
            },
          ),
          SizedBox(height: LayoutTokens.gapMd),
          TextFormField(
            decoration: const InputDecoration(labelText: '完成理由（可选）'),
            onChanged: (value) => _completionReason = value,
          ),
          SizedBox(height: LayoutTokens.gapMd),
          TextFormField(
            decoration: const InputDecoration(labelText: '备注（可选）'),
            onChanged: (value) => _notes = value,
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await widget.onSubmit({
        'quantity_defective': _quantityDefective,
        'completion_reason': _completionReason,
        'notes': _notes,
      });
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _TaskAssignDialog extends StatefulWidget {
  const _TaskAssignDialog({
    required this.task,
    required this.departments,
    required this.loadOperators,
    required this.onSubmit,
  });

  final Task task;
  final List<TaskDepartmentOption> departments;
  final Future<List<Map<String, dynamic>>> Function(int departmentId)
      loadOperators;
  final Future<void> Function(int operatorId, String notes) onSubmit;

  @override
  State<_TaskAssignDialog> createState() => _TaskAssignDialogState();
}

class _TaskAssignDialogState extends State<_TaskAssignDialog> {
  final _formKey = GlobalKey<FormState>();
  int? _departmentId;
  List<_OperatorOption> _operators = [];
  int? _operatorId;
  bool _loadingOperators = false;
  bool _submitting = false;
  String _notes = '';

  @override
  void initState() {
    super.initState();
    _departmentId = widget.task.assignedDepartmentId;
    if (_departmentId == null && widget.departments.isNotEmpty) {
      _departmentId = widget.departments.first.id;
    }
    if (_departmentId != null) {
      _loadOperators(_departmentId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      title: '分派操作员',
      formKey: _formKey,
      submitText: '确认分派',
      submitting: _submitting,
      maxWidth: LayoutTokens.dialogWidthSm,
      onSubmit: _submit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchableDropdownFormField<int?>(
            key: ValueKey<int?>(_departmentId),
            initialValue: _departmentId,
            decoration: const InputDecoration(labelText: '部门'),
            items: [
              for (final dept in widget.departments)
                DropdownMenuItem<int?>(
                  value: dept.id,
                  child: Text(dept.name),
                ),
            ],
            onChanged: (value) {
              setState(() {
                _departmentId = value;
                _operatorId = null;
                _operators = [];
              });
              if (value != null) {
                _loadOperators(value);
              }
            },
            validator: (value) => value == null ? '请选择部门' : null,
          ),
          SizedBox(height: LayoutTokens.gapMd),
          if (_loadingOperators) const LinearProgressIndicator(minHeight: 2),
          SearchableDropdownFormField<int?>(
            key: ValueKey<int?>(_operatorId),
            initialValue: _operatorId,
            decoration: const InputDecoration(labelText: '操作员'),
            items: _operators
                .map(
                  (op) => DropdownMenuItem<int?>(
                    value: op.id,
                    child: Text(op.name),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _operatorId = value),
            validator: (value) => value == null ? '请选择操作员' : null,
          ),
          SizedBox(height: LayoutTokens.gapMd),
          TextFormField(
            decoration: const InputDecoration(labelText: '备注（可选）'),
            onChanged: (value) => _notes = value,
          ),
          if (_operators.isEmpty && !_loadingOperators)
            Padding(
              padding: EdgeInsets.only(top: LayoutTokens.gapSm),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('当前部门暂无可分派操作员'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loadOperators(int departmentId) async {
    setState(() => _loadingOperators = true);
    try {
      final payload = await widget.loadOperators(departmentId);
      final ops = payload
          .map((item) => _OperatorOption.fromJson(item))
          .where((item) => item.id > 0)
          .toList();
      setState(() {
        _operators = ops;
        if (_operators.isNotEmpty) {
          _operatorId = _operators.first.id;
        }
      });
    } catch (_) {
      setState(() => _operators = []);
    } finally {
      if (mounted) setState(() => _loadingOperators = false);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false) || _operatorId == null) {
      return;
    }
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(_operatorId!, _notes);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _OperatorOption {
  const _OperatorOption({required this.id, required this.name});

  final int id;
  final String name;

  factory _OperatorOption.fromJson(Map<String, dynamic> json) {
    final id = _toInt(json['id']);
    final first = json['first_name']?.toString() ?? '';
    final last = json['last_name']?.toString() ?? '';
    final username = json['username']?.toString() ?? '';
    final fullName = '$first$last'.trim();
    final name = fullName.isNotEmpty
        ? fullName
        : (username.isNotEmpty ? username : '操作员 $id');
    return _OperatorOption(id: id, name: name);
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
