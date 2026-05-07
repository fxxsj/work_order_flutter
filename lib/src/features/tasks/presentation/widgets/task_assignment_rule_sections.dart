import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_dto.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';

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
          padding: EdgeInsets.fromLTRB(
            LayoutTokens.gapLg,
            LayoutTokens.gapMd,
            LayoutTokens.gapSm,
            LayoutTokens.gapSm,
          ),
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
    builder: (context) => AppDialog(
      title: '确认删除',
      maxWidth: LayoutTokens.dialogWidthSm,
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
  final List<TaskDepartmentOption> departments;
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
    return AppFormDialog(
      title: isEdit ? '编辑分派规则' : '新建分派规则',
      formKey: _formKey,
      submitText: '保存',
      submitting: _submitting,
      maxWidth: LayoutTokens.dialogWidthSm,
      onSubmit: _submit,
      content: Column(
        children: [
          AppSelect<int>(
            key: ValueKey<int>(_processId),
            value: _processId,
            decoration: const InputDecoration(labelText: '工序'),
            options: widget.processes
                .map(
                  (p) => AppDropdownOption(
                    value: p.id,
                    label: '${p.code} ${p.name}',
                  ),
                )
                .toList(),
            onChanged: isEdit
                ? null
                : (value) => setState(() => _processId = value ?? _processId),
          ),
          SizedBox(height: LayoutTokens.gapMd),
          AppSelect<int>(
            key: ValueKey<int>(_departmentId),
            value: _departmentId,
            decoration: const InputDecoration(labelText: '分派部门'),
            options: widget.departments
                .map(
                  (d) => AppDropdownOption(value: d.id, label: d.name),
                )
                .toList(),
            onChanged: isEdit
                ? null
                : (value) =>
                    setState(() => _departmentId = value ?? _departmentId),
          ),
          SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.number(
            label: '优先级 (0-100)',
            initialValue: _priority.toString(),
            validator: (value) {
              final parsed = int.tryParse(value ?? '');
              if (parsed == null || parsed < 0 || parsed > 100) {
                return '请输入 0-100 的整数';
              }
              return null;
            },
            onChanged: (value) => _priority = int.tryParse(value) ?? _priority,
          ).build(context),
          SizedBox(height: LayoutTokens.gapMd),
          AppSelect<String>(
            key: ValueKey<String>(_strategy),
            value: _strategy,
            decoration: const InputDecoration(labelText: '操作员选择策略'),
            options: const [
              AppDropdownOption(value: 'least_tasks', label: '任务最少'),
              AppDropdownOption(value: 'random', label: '随机选择'),
              AppDropdownOption(value: 'round_robin', label: '轮询分配'),
              AppDropdownOption(value: 'first_available', label: '第一个可用'),
            ],
            onChanged: (value) =>
                setState(() => _strategy = value ?? _strategy),
          ),
          SizedBox(height: LayoutTokens.gapMd),
          SwitchListTile(
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
            title: const Text('启用规则'),
            contentPadding: EdgeInsets.zero,
          ),
          CrudFormField.text(
            label: '备注（可选）',
            initialValue: _notes,
            onChanged: (value) => _notes = value,
          ).build(context),
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
            const SizedBox(width: LayoutTokens.gapXs),
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
          SizedBox(height: LayoutTokens.gapSm),
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
