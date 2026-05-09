import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_card.dart';

/// Process configuration section for work order form.
class WorkOrderProcessConfigSection extends StatelessWidget {
  const WorkOrderProcessConfigSection({
    super.key,
    required this.processes,
    required this.processIds,
    required this.onToggleProcess,
  });

  final List<Process> processes;
  final Set<int> processIds;
  final ValueChanged<int> onToggleProcess;

  @override
  Widget build(BuildContext context) {
    return WorkOrderFormSectionCard(
      title: '工序配置',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: processes
            .map(
              (process) => FilterChip(
                label: Text(process.name),
                selected: processIds.contains(process.id),
                onSelected: (_) => onToggleProcess(process.id),
              ),
            )
            .toList(),
      ),
    );
  }
}
