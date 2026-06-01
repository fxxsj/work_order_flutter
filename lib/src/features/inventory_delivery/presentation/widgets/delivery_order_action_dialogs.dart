import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';

Future<void> showDeliveryShipDialog(
  BuildContext context, {
  required String cancelText,
  required String submitText,
  required String title,
  required String initialLogisticsCompany,
  required String initialTrackingNumber,
  required Future<void> Function(String logisticsCompany, String trackingNumber)
  onSubmit,
}) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _DeliveryShipDialog(
      cancelText: cancelText,
      submitText: submitText,
      title: title,
      initialLogisticsCompany: initialLogisticsCompany,
      initialTrackingNumber: initialTrackingNumber,
      onSubmit: onSubmit,
    ),
  );
}

Future<void> showDeliveryReceiveDialog(
  BuildContext context, {
  required String cancelText,
  required String submitText,
  required String title,
  required Future<void> Function(String notes) onSubmit,
}) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _DeliveryReceiveDialog(
      cancelText: cancelText,
      submitText: submitText,
      title: title,
      onSubmit: onSubmit,
    ),
  );
}

Future<void> showDeliveryRejectDialog(
  BuildContext context, {
  required String cancelText,
  required String submitText,
  required String title,
  required Future<void> Function(String reason) onSubmit,
}) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _DeliveryRejectDialog(
      cancelText: cancelText,
      submitText: submitText,
      title: title,
      onSubmit: onSubmit,
    ),
  );
}

class _DeliveryShipDialog extends StatefulWidget {
  const _DeliveryShipDialog({
    required this.cancelText,
    required this.submitText,
    required this.title,
    required this.initialLogisticsCompany,
    required this.initialTrackingNumber,
    required this.onSubmit,
  });

  final String cancelText;
  final String submitText;
  final String title;
  final String initialLogisticsCompany;
  final String initialTrackingNumber;
  final Future<void> Function(String logisticsCompany, String trackingNumber)
  onSubmit;

  @override
  State<_DeliveryShipDialog> createState() => _DeliveryShipDialogState();
}

class _DeliveryShipDialogState extends State<_DeliveryShipDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController logisticsController = TextEditingController(
    text: widget.initialLogisticsCompany,
  );
  late final TextEditingController trackingController = TextEditingController(
    text: widget.initialTrackingNumber,
  );
  bool submitting = false;

  @override
  void dispose() {
    logisticsController.dispose();
    trackingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: widget.title,
      formKey: formKey,
      cancelText: widget.cancelText,
      submitText: widget.submitText,
      submitting: submitting,
      maxWidth: LayoutTokens.dialogWidthSm,
      onSubmit: _submit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CrudFieldConfig.text(
            label: '物流公司',
            controller: logisticsController,
          ).build(context),
          SizedBox(height: SpacingTokens.md),
          CrudFieldConfig.text(
            label: '运单号',
            controller: trackingController,
          ).build(context),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() => submitting = true);
    try {
      await widget.onSubmit(
        logisticsController.text.trim(),
        trackingController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => submitting = false);
      rethrow;
    }
  }
}

class _DeliveryReceiveDialog extends StatefulWidget {
  const _DeliveryReceiveDialog({
    required this.cancelText,
    required this.submitText,
    required this.title,
    required this.onSubmit,
  });

  final String cancelText;
  final String submitText;
  final String title;
  final Future<void> Function(String notes) onSubmit;

  @override
  State<_DeliveryReceiveDialog> createState() => _DeliveryReceiveDialogState();
}

class _DeliveryReceiveDialogState extends State<_DeliveryReceiveDialog> {
  final formKey = GlobalKey<FormState>();
  final notesController = TextEditingController();
  bool submitting = false;

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: widget.title,
      formKey: formKey,
      cancelText: widget.cancelText,
      submitText: widget.submitText,
      submitting: submitting,
      maxWidth: LayoutTokens.dialogWidthSm,
      onSubmit: _submit,
      content: CrudFieldConfig.textarea(
        label: '签收备注',
        controller: notesController,
        maxLines: 3,
      ).build(context),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() => submitting = true);
    try {
      await widget.onSubmit(notesController.text.trim());
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => submitting = false);
      rethrow;
    }
  }
}

class _DeliveryRejectDialog extends StatefulWidget {
  const _DeliveryRejectDialog({
    required this.cancelText,
    required this.submitText,
    required this.title,
    required this.onSubmit,
  });

  final String cancelText;
  final String submitText;
  final String title;
  final Future<void> Function(String reason) onSubmit;

  @override
  State<_DeliveryRejectDialog> createState() => _DeliveryRejectDialogState();
}

class _DeliveryRejectDialogState extends State<_DeliveryRejectDialog> {
  final formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();
  bool submitting = false;

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppActionFormDialog(
      title: widget.title,
      formKey: formKey,
      cancelText: widget.cancelText,
      submitText: widget.submitText,
      submitting: submitting,
      maxWidth: LayoutTokens.dialogWidthSm,
      destructive: true,
      summary: '提交后会把发货数量回退到库存，并把送货单标记为拒收。',
      impacts: const ['请确认拒收原因和实际收货情况一致', '拒收后库存与发货状态会同步回滚'],
      auditHint: '拒收原因会进入发货与库存流转记录。',
      onSubmit: _submit,
      content: CrudFieldConfig.textarea(
        label: '拒收原因',
        controller: reasonController,
        maxLines: 3,
        hintText: '例如：地址错误、包装破损、数量不符',
        validator: (value) {
          if ((value?.trim() ?? '').isEmpty) {
            return '请输入拒收原因';
          }
          return null;
        },
      ).build(context),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() => submitting = true);
    try {
      await widget.onSubmit(reasonController.text.trim());
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => submitting = false);
      rethrow;
    }
  }
}
