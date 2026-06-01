import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';

/// Action panel for work order status updates.
class WorkOrderActionPanel extends StatelessWidget {
  const WorkOrderActionPanel({
    super.key,
    required this.statusOptions,
    required this.statusSelection,
    required this.actionLoading,
    required this.onStatusChanged,
    required this.onUpdateStatus,
  });

  final List<AppDropdownOption<String>> statusOptions;
  final String? statusSelection;
  final bool actionLoading;
  final ValueChanged<String?>? onStatusChanged;
  final VoidCallback? onUpdateStatus;

  @override
  Widget build(BuildContext context) {
    final spacing = SpacingTokens.sm;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSelect<String>(
              value: statusSelection,
              decoration: const InputDecoration(labelText: '状态'),
              options: statusOptions,
              onChanged: actionLoading || onStatusChanged == null
                  ? null
                  : onStatusChanged,
            ),
            SizedBox(height: spacing),
            FilledButton(
              onPressed: actionLoading || onUpdateStatus == null
                  ? null
                  : onUpdateStatus,
              child: const Text('更新状态'),
            ),
          ],
        );
      },
    );
  }
}
