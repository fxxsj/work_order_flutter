import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/detail_sections/work_order_summary_content.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/detail_sections/work_order_action_panel.dart';

/// Overview section for work order details.
class WorkOrderDetailOverviewSection extends StatelessWidget {
  const WorkOrderDetailOverviewSection({
    super.key,
    required this.detail,
    required this.statusOptions,
    required this.statusSelection,
    required this.actionLoading,
    required this.onUploadDesignFile,
    required this.onStatusChanged,
    required this.onUpdateStatus,
    required this.buildSection,
    required this.emptyText,
  });

  final WorkOrderDetail detail;
  final List<AppDropdownOption<String>> statusOptions;
  final String? statusSelection;
  final bool actionLoading;
  final VoidCallback? onUploadDesignFile;
  final ValueChanged<String?>? onStatusChanged;
  final VoidCallback? onUpdateStatus;
  final Widget Function(String title, Widget child) buildSection;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final summary = buildSection(
      '施工单信息',
      SummaryContent(
        detail: detail,
        sectionSpacing: sectionSpacing,
        emptyText: emptyText,
        actionLoading: actionLoading,
        onUploadDesignFile: onUploadDesignFile,
      ),
    );
    final actions = buildSection(
      '流程操作',
      WorkOrderActionPanel(
        statusOptions: statusOptions,
        statusSelection: statusSelection,
        actionLoading: actionLoading,
        onStatusChanged: onStatusChanged,
        onUpdateStatus: onUpdateStatus,
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < Breakpoints.lg;
        if (isNarrow) {
          return Column(
            children: [
              summary,
              SizedBox(height: sectionSpacing),
              actions,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: summary),
            SizedBox(height: sectionSpacing),
            SizedBox(width: 300, child: actions),
          ],
        );
      },
    );
  }
}
