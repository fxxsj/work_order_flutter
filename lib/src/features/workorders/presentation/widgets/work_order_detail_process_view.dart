import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_data_sections.dart';

/// 工序进度视图：Processes + Gantt
class WorkOrderDetailProcessView extends StatelessWidget {
  const WorkOrderDetailProcessView({
    super.key,
    required this.detail,
    required this.buildSection,
    required this.emptyText,
    required this.formatDateTime,
    required this.onAssignTask,
    required this.onUpdateTask,
    required this.onCompleteTask,
    required this.canManageTask,
    required this.onSyncPreview,
  });

  final WorkOrderDetail detail;
  final Widget Function(String title, Widget child) buildSection;
  final String emptyText;
  final String Function(dynamic value) formatDateTime;
  final Future<void> Function(Task task) onAssignTask;
  final Future<void> Function(Task task) onUpdateTask;
  final Future<void> Function(Task task) onCompleteTask;
  final bool Function(Task task) canManageTask;
  final Future<void> Function(WorkOrderDetail detail) onSyncPreview;

  @override
  Widget build(BuildContext context) {
    final canSyncTasks = PermissionUtil.isSuperuser(context) &&
        detail.approvalStatus != 'approved' &&
        detail.approvalStatus != 'submitted';
    return SingleChildScrollView(
      padding: EdgeInsets.all(LayoutTokens.sectionSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailSectionCard(
            title: '工序进度',
            trailing: canSyncTasks
                ? OutlinedButton.icon(
                    onPressed: detail.processes.isEmpty
                        ? null
                        : () => onSyncPreview(detail),
                    icon: const Icon(Icons.sync_alt, size: 16),
                    label: const Text('同步工序任务'),
                  )
                : null,
            child: WorkOrderProcessesSection(
              items: detail.processes,
              emptyText: emptyText,
              onAssignTask: onAssignTask,
              onUpdateTask: onUpdateTask,
              onCompleteTask: onCompleteTask,
              canManageTask: canManageTask,
            ),
          ),
          SizedBox(height: LayoutTokens.sectionSpacing(context)),
          buildSection(
            '工序排程',
            WorkOrderProcessGanttSection(
              items: detail.processes,
              emptyText: emptyText,
              formatDateTime: formatDateTime,
            ),
          ),
        ],
      ),
    );
  }
}
