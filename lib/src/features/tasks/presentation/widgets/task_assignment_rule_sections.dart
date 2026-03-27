import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_dto.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule.dart';

class TaskAssignmentRuleFilterDrawerContent extends StatelessWidget {
  const TaskAssignmentRuleFilterDrawerContent({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: '关闭',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}

Future<bool> showTaskAssignmentRuleDeleteDialog(
  BuildContext context, {
  required String content,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => BaseDialog(
      title: '确认删除',
      maxWidth: 420,
      scrollable: false,
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('删除'),
        ),
      ],
    ),
  );
  return confirmed == true;
}

class TaskAssignmentRuleDialog extends StatefulWidget {
  const TaskAssignmentRuleDialog({
    super.key,
    required this.rule,
    required this.processes,
    required this.departments,
    required this.onSubmit,
  });

  final TaskAssignmentRule? rule;
  final List<Process> processes;
  final List<Department> departments;
  final Future<void> Function(TaskAssignmentRuleDto payload) onSubmit;

  @override
  State<TaskAssignmentRuleDialog> createState() =>
      _TaskAssignmentRuleDialogState();
}

class _TaskAssignmentRuleDialogState extends State<TaskAssignmentRuleDialog> {
  final _formKey = GlobalKey<FormState>();
  late int _processId;
  late int _departmentId;
  int _priority = 50;
  bool _isActive = true;
  String _strategy = 'least_tasks';
  String _notes = '';
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final rule = widget.rule;
    _processId = rule?.processId ?? widget.processes.first.id;
    _departmentId = rule?.departmentId ?? widget.departments.first.id;
    _priority = rule?.priority ?? 50;
    _isActive = rule?.isActive ?? true;
    _strategy = rule?.operatorSelectionStrategy ?? 'least_tasks';
    _notes = rule?.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.rule != null;
    return FormDialog(
      title: isEdit ? '编辑分派规则' : '新建分派规则',
      formKey: _formKey,
      submitText: '保存',
      submitting: _submitting,
      maxWidth: 420,
      onSubmit: _submit,
      content: Column(
        children: [
          SearchableDropdownFormField<int>(
            key: ValueKey<int>(_processId),
            initialValue: _processId,
            decoration: const InputDecoration(labelText: '工序'),
            items: widget.processes
                .map(
                  (p) => DropdownMenuItem(
                    value: p.id,
                    child: Text('${p.code} ${p.name}'),
                  ),
                )
                .toList(),
            onChanged: isEdit
                ? null
                : (value) => setState(() => _processId = value ?? _processId),
          ),
          const SizedBox(height: 12),
          SearchableDropdownFormField<int>(
            key: ValueKey<int>(_departmentId),
            initialValue: _departmentId,
            decoration: const InputDecoration(labelText: '分派部门'),
            items: widget.departments
                .map(
                  (d) => DropdownMenuItem(value: d.id, child: Text(d.name)),
                )
                .toList(),
            onChanged: isEdit
                ? null
                : (value) =>
                    setState(() => _departmentId = value ?? _departmentId),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: _priority.toString(),
            decoration: const InputDecoration(labelText: '优先级 (0-100)'),
            keyboardType: TextInputType.number,
            validator: (value) {
              final parsed = int.tryParse(value ?? '');
              if (parsed == null || parsed < 0 || parsed > 100) {
                return '请输入 0-100 的整数';
              }
              return null;
            },
            onChanged: (value) => _priority = int.tryParse(value) ?? _priority,
          ),
          const SizedBox(height: 12),
          SearchableDropdownFormField<String>(
            key: ValueKey<String>(_strategy),
            initialValue: _strategy,
            decoration: const InputDecoration(labelText: '操作员选择策略'),
            items: const [
              DropdownMenuItem(value: 'least_tasks', child: Text('任务最少')),
              DropdownMenuItem(value: 'random', child: Text('随机选择')),
              DropdownMenuItem(value: 'round_robin', child: Text('轮询分配')),
              DropdownMenuItem(value: 'first_available', child: Text('第一个可用')),
            ],
            onChanged: (value) =>
                setState(() => _strategy = value ?? _strategy),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
            title: const Text('启用规则'),
            contentPadding: EdgeInsets.zero,
          ),
          TextFormField(
            initialValue: _notes,
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
    final payload = TaskAssignmentRuleDto(
      id: widget.rule?.id ?? 0,
      processId: _processId,
      departmentId: _departmentId,
      priority: _priority,
      operatorSelectionStrategy: _strategy,
      isActive: _isActive,
      notes: _notes,
    );
    try {
      await widget.onSubmit(payload);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      // keep dialog open on failure
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class TaskAssignmentRuleCard extends StatelessWidget {
  const TaskAssignmentRuleCard({
    super.key,
    required this.rule,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    this.dragHandle,
  });

  final TaskAssignmentRule rule;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onToggle;
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final subtitle = '${rule.processCode ?? ''} · ${rule.departmentName ?? ''}';
    return DetailSectionCard(
      title: rule.processName ?? '未命名工序',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dragHandle != null) ...[
            dragHandle!,
            const SizedBox(width: 4),
          ],
          Switch(value: rule.isActive, onChanged: onToggle),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: onDelete, icon: const Icon(Icons.delete_outline)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 8),
          SummaryFieldWrap(
            isMobile: BreakpointsUtil.isMobile(context),
            children: [
              SummaryField(label: '优先级', value: rule.priority.toString()),
              SummaryField(
                label: '操作员策略',
                value: rule.operatorSelectionStrategyDisplay ??
                    rule.operatorSelectionStrategy,
              ),
              SummaryField(label: '部门编码', value: rule.departmentCode ?? '-'),
              SummaryField(
                label: '备注',
                value: rule.notes?.isNotEmpty == true ? rule.notes! : '-',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
