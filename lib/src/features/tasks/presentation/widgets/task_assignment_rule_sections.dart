import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
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
            SpacingTokens.lg,
            SpacingTokens.md,
            SpacingTokens.sm,
            SpacingTokens.sm,
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

Future<bool> showTaskAssignmentRuleEditDrawer(
  BuildContext context, {
  required TaskAssignmentRule? rule,
  required List<Process> processes,
  required List<TaskDepartmentOption> departments,
  required Future<void> Function(TaskAssignmentRule payload) onSubmit,
}) async {
  var saved = false;
  await showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: rule == null ? '新增默认部门' : '编辑默认部门',
    desktopWidth: LayoutTokens.dialogWidthMd,
    child: TaskAssignmentRuleEditPanel(
      rule: rule,
      processes: processes,
      departments: departments,
      onSubmit: onSubmit,
      onSaved: () => saved = true,
    ),
  );
  return saved;
}

class TaskAssignmentRuleEditPanel extends StatefulWidget {
  const TaskAssignmentRuleEditPanel({
    super.key,
    required this.rule,
    required this.processes,
    required this.departments,
    required this.onSubmit,
    this.onSaved,
  });

  final TaskAssignmentRule? rule;
  final List<Process> processes;
  final List<TaskDepartmentOption> departments;
  final Future<void> Function(TaskAssignmentRule payload) onSubmit;
  final VoidCallback? onSaved;

  @override
  State<TaskAssignmentRuleEditPanel> createState() =>
      _TaskAssignmentRuleEditPanelState();
}

class _TaskAssignmentRuleEditPanelState
    extends State<TaskAssignmentRuleEditPanel> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _notesController;
  late int _processId;
  late int _departmentId;
  late int _priority;
  late bool _isActive;
  late String _strategy;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final rule = widget.rule;
    final defaults = kTaskAssignmentRuleDefaults;
    _processId = rule?.processId ?? widget.processes.first.id;
    _departmentId = rule?.departmentId ?? widget.departments.first.id;
    _priority = rule?.priority ?? defaults.priority;
    _isActive = rule?.isActive ?? true;
    _strategy = rule?.operatorSelectionStrategy ?? defaults.strategy;
    _notesController = TextEditingController(text: rule?.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.rule != null;
    return AdaptiveFormPanel(
      formKey: _formKey,
      submitText: '保存',
      cancelText: '取消',
      submitting: _submitting,
      submitEnabled: !_submitting,
      onSubmit: _submit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RuleFormSection(
            title: '基础信息',
            child: _RuleFieldList(
              children: [
                if (isEdit)
                  _ReadOnlyRuleField(
                    label: '工序',
                    value: _processLabel(_processId),
                  )
                else
                  AppSelect<int>(
                    key: ValueKey<String>(
                      'assignment-rule-process-$_processId',
                    ),
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
                    onChanged: (value) =>
                        setState(() => _processId = value ?? _processId),
                  ),
                if (isEdit)
                  _ReadOnlyRuleField(
                    label: '默认部门',
                    value: _departmentLabel(_departmentId),
                  )
                else
                  AppSelect<int>(
                    key: ValueKey<String>(
                      'assignment-rule-department-$_departmentId',
                    ),
                    value: _departmentId,
                    decoration: const InputDecoration(labelText: '默认部门'),
                    options: widget.departments
                        .map(
                          (d) => AppDropdownOption(value: d.id, label: d.name),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _departmentId = value ?? _departmentId),
                  ),
                SwitchListTile(
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                  title: const Text('启用'),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),
          CrudFieldConfig.textarea(
            label: '备注（可选）',
            controller: _notesController,
            maxLines: 3,
          ).build(context),
        ],
      ),
    );
  }

  String _processLabel(int id) {
    for (final process in widget.processes) {
      if (process.id == id) {
        return '${process.code} ${process.name}';
      }
    }
    return widget.rule?.processName ?? '工序 #$id';
  }

  String _departmentLabel(int id) {
    for (final department in widget.departments) {
      if (department.id == id) {
        return department.name;
      }
    }
    return widget.rule?.departmentName ?? '部门 #$id';
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    final payload = TaskAssignmentRule(
      id: widget.rule?.id ?? 0,
      processId: _processId,
      departmentId: _departmentId,
      priority: _priority,
      operatorSelectionStrategy: _strategy,
      isActive: _isActive,
      notes: _notesController.text,
    );
    try {
      await widget.onSubmit(payload);
      if (!mounted) return;
      widget.onSaved?.call();
      Navigator.of(context).pop(true);
    } catch (_) {
      // keep dialog open on failure
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _RuleFormSection extends StatelessWidget {
  const _RuleFormSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: SpacingTokens.md),
          child,
        ],
      ),
    );
  }
}

class _RuleFieldList extends StatelessWidget {
  const _RuleFieldList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: SpacingTokens.md),
          children[index],
        ],
      ],
    );
  }
}

class _ReadOnlyRuleField extends StatelessWidget {
  const _ReadOnlyRuleField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
      ).applyDefaults(theme.inputDecorationTheme).copyWith(enabled: false),
      child: Text(value, style: theme.textTheme.bodyMedium),
    );
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
            const SizedBox(width: SpacingTokens.xs),
          ],
          Switch(value: rule.isActive, onChanged: onToggle),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          SizedBox(height: SpacingTokens.sm),
          SummaryFieldWrap(
            isMobile: ResponsiveLayout.isMobile(context),
            children: [
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

class TaskAssignmentRulePreviewContent extends StatelessWidget {
  const TaskAssignmentRulePreviewContent({super.key, required this.items});

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text('暂无预览数据');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(height: SpacingTokens.md),
          _TaskAssignmentRulePreviewCard(item: items[index]),
        ],
      ],
    );
  }
}

class _TaskAssignmentRulePreviewCard extends StatelessWidget {
  const _TaskAssignmentRulePreviewCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final process = item['process_name']?.toString() ?? '-';
    final target = item['target_department_name']?.toString() ?? '-';
    final load = item['current_load']?.toString() ?? '0';

    return DetailSectionCard(
      title: process,
      child: SummaryFieldWrap(
        isMobile: ResponsiveLayout.isMobile(context),
        children: [
          SummaryField(label: '目标部门', value: target),
          SummaryField(label: '当前负载', value: load),
        ],
      ),
    );
  }
}
