import 'package:flutter/material.dart';

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
          return AlertDialog(
            title: Text(title),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: logisticsController,
                        decoration: const InputDecoration(labelText: '物流公司'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: trackingController,
                        decoration: const InputDecoration(labelText: '运单号'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    submitting ? null : () => Navigator.of(dialogContext).pop(),
                child: Text(cancelText),
              ),
              FilledButton(
                onPressed: submitting ? null : () => submit(setState),
                child: Text(submitting ? '提交中...' : submitText),
              ),
            ],
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
          return AlertDialog(
            title: Text(title),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: '签收备注'),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    submitting ? null : () => Navigator.of(dialogContext).pop(),
                child: Text(cancelText),
              ),
              FilledButton(
                onPressed: submitting ? null : () => submit(setState),
                child: Text(submitting ? '提交中...' : submitText),
              ),
            ],
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
          return AlertDialog(
            title: Text(title),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '提交后会把发货数量回退到库存，并把发货单标记为拒收。',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: '拒收原因',
                          hintText: '例如：地址错误、包装破损、数量不符',
                        ),
                        validator: (value) {
                          if ((value?.trim() ?? '').isEmpty) {
                            return '请输入拒收原因';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    submitting ? null : () => Navigator.of(dialogContext).pop(),
                child: Text(cancelText),
              ),
              FilledButton(
                onPressed: submitting ? null : () => submit(setState),
                child: Text(submitting ? '提交中...' : '确认拒收并回退库存'),
              ),
            ],
          );
        },
      );
    },
  );

  reasonController.dispose();
}
