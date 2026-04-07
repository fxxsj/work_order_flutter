import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
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
  final formKey = GlobalKey<FormState>();
  final logisticsController =
      TextEditingController(text: initialLogisticsCompany);
  final trackingController = TextEditingController(text: initialTrackingNumber);
  bool submitting = false;

  Future<void> submit(StateSetter setState) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() => submitting = true);
    try {
      await onSubmit(
        logisticsController.text.trim(),
        trackingController.text.trim(),
      );
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!context.mounted) return;
      setState(() => submitting = false);
      rethrow;
    }
  }

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return FormDialog(
            title: title,
            formKey: formKey,
            submitText: submitText,
            submitting: submitting,
            maxWidth: LayoutTokens.dialogWidthSm,
            onSubmit: () => submit(setState),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CrudFormField.text(
                  label: '物流公司',
                  controller: logisticsController,
                ).build(dialogContext),
                SizedBox(height: LayoutTokens.gapMd),
                CrudFormField.text(
                  label: '运单号',
                  controller: trackingController,
                ).build(dialogContext),
              ],
            ),
          );
        },
      );
    },
  );

  logisticsController.dispose();
  trackingController.dispose();
}

Future<void> showDeliveryReceiveDialog(
  BuildContext context, {
  required String cancelText,
  required String submitText,
  required String title,
  required Future<void> Function(String notes) onSubmit,
}) async {
  final formKey = GlobalKey<FormState>();
  final notesController = TextEditingController();
  bool submitting = false;

  Future<void> submit(StateSetter setState) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() => submitting = true);
    try {
      await onSubmit(notesController.text.trim());
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!context.mounted) return;
      setState(() => submitting = false);
      rethrow;
    }
  }

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return FormDialog(
            title: title,
            formKey: formKey,
            submitText: submitText,
            submitting: submitting,
            maxWidth: LayoutTokens.dialogWidthSm,
            onSubmit: () => submit(setState),
            content: CrudFormField.textarea(
              label: '签收备注',
              controller: notesController,
              maxLines: 3,
            ).build(dialogContext),
          );
        },
      );
    },
  );

  notesController.dispose();
}

Future<void> showDeliveryRejectDialog(
  BuildContext context, {
  required String cancelText,
  required String submitText,
  required String title,
  required Future<void> Function(String reason) onSubmit,
}) async {
  final formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();
  bool submitting = false;

  Future<void> submit(StateSetter setState) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() => submitting = true);
    try {
      await onSubmit(reasonController.text.trim());
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!context.mounted) return;
      setState(() => submitting = false);
      rethrow;
    }
  }

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return FormDialog(
            title: title,
            formKey: formKey,
            submitText: '确认拒收并回退库存',
            submitting: submitting,
            maxWidth: LayoutTokens.dialogWidthSm,
            onSubmit: () => submit(setState),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '提交后会把发货数量回退到库存，并把发货单标记为拒收。',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: LayoutTokens.gapMd),
                CrudFormField.textarea(
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
                ).build(dialogContext),
              ],
            ),
          );
        },
      );
    },
  );

  reasonController.dispose();
}
