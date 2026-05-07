import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_loading_indicator.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';

Future<void> showPurchaseInspectionDialog(
  BuildContext context, {
  required Future<List<Map<String, dynamic>>> Function() loadRecords,
  required Future<void> Function(int recordId, Map<String, dynamic> payload)
      confirmInspection,
  required Future<void> Function(int recordId) stockIn,
  String title = '质检确认',
  String cancelText = '取消',
}) async {
  List<Map<String, dynamic>> records = [];
  bool loading = true;

  Future<void> reload(StateSetter setState) async {
    setState(() => loading = true);
    try {
      records = await loadRecords();
    } catch (err) {
      ToastUtil.showError('加载收货记录失败: $err');
    } finally {
      setState(() => loading = false);
    }
  }

  await showAdaptiveFilterDrawer(
    context,
    isMobile: BreakpointsUtil.isMobile(context),
    title: title,
    desktopWidth: LayoutTokens.dialogWidthLg,
    child: StatefulBuilder(
      builder: (context, setState) {
        if (loading && records.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              reload(setState);
            }
          });
        }

        final pendingCount = records
            .where((record) =>
                record['inspection_status']?.toString() == 'pending')
            .length;

        return Column(
          children: [
            Expanded(
              child: loading
                  ? const AppLoadingIndicator()
                  : records.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(LayoutTokens.gapLg),
                          child: EmptyStateCard(
                            icon: Icons.verified_outlined,
                            text: '暂无收货记录',
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(LayoutTokens.gapLg),
                          children: [
                            AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '收货记录质检',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: LayoutTokens.gapXxs),
                                  Text(
                                    '在当前上下文里完成质检确认，避免弹窗叠弹窗。',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: LayoutTokens.gapMd),
                                  Wrap(
                                    spacing: LayoutTokens.gapMd,
                                    runSpacing: LayoutTokens.gapSm,
                                    children: [
                                      _InspectionSummaryItem(
                                        label: '收货记录',
                                        value: records.length.toString(),
                                      ),
                                      _InspectionSummaryItem(
                                        label: '待质检',
                                        value: pendingCount.toString(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: LayoutTokens.gapLg),
                            ...records.map((record) {
                              final status =
                                  record['inspection_status']?.toString() ?? '';
                              final statusDisplay =
                                  record['inspection_status_display']
                                          ?.toString() ??
                                      '-';
                              final qualified =
                                  _toDouble(record['qualified_quantity']) ?? 0;
                              final isStocked = record['is_stocked'] == true;
                              final canInspect = status == 'pending';
                              final canStockIn = (status == 'qualified' ||
                                      status == 'partial_qualified') &&
                                  !isStocked &&
                                  qualified > 0;

                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: LayoutTokens.gapSm,
                                ),
                                child: AppCard(
                                  padding: const EdgeInsets.all(
                                    LayoutTokens.cardPaddingSm,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${record['material_code'] ?? '-'} ${record['material_name'] ?? '-'}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(
                                        height: LayoutTokens.gapXxs,
                                      ),
                                      Wrap(
                                        spacing: LayoutTokens.gapMd,
                                        runSpacing: LayoutTokens.gapXs,
                                        children: [
                                          _InlineMeta(
                                            label: '收货数量',
                                            value: record['received_quantity']
                                                    ?.toString() ??
                                                '-',
                                          ),
                                          _InlineMeta(
                                            label: '状态',
                                            value: statusDisplay,
                                          ),
                                          _InlineMeta(
                                            label: '收货日期',
                                            value: record['received_date']
                                                    ?.toString() ??
                                                '-',
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: LayoutTokens.gapSm,
                                      ),
                                      Wrap(
                                        spacing: LayoutTokens.gapSm,
                                        children: [
                                          if (canInspect)
                                            OutlinedButton(
                                              onPressed: () async {
                                                await showPurchaseInspectionAppFormDialog(
                                                  context,
                                                  record: record,
                                                  confirmInspection:
                                                      confirmInspection,
                                                );
                                                if (!context.mounted) {
                                                  return;
                                                }
                                                await reload(setState);
                                              },
                                              child: const Text('质检'),
                                            ),
                                          if (canStockIn)
                                            OutlinedButton(
                                              onPressed: () async {
                                                final confirmed =
                                                    await showDialog<bool>(
                                                  context: context,
                                                  builder: (confirmContext) =>
                                                      AppDialog(
                                                    title: '确认入库',
                                                    maxWidth: LayoutTokens
                                                        .dialogWidthXs,
                                                    scrollable: false,
                                                    content: Text(
                                                      '确定将 $qualified 件物料入库吗？',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                          confirmContext,
                                                        ).pop(false),
                                                        child: const Text('取消'),
                                                      ),
                                                      FilledButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                          confirmContext,
                                                        ).pop(true),
                                                        child: const Text('确认'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                if (confirmed != true) return;
                                                try {
                                                  await stockIn(
                                                    record['id'] as int,
                                                  );
                                                  ToastUtil.showSuccess(
                                                    '入库成功',
                                                  );
                                                  if (!context.mounted) {
                                                    return;
                                                  }
                                                  await reload(setState);
                                                } catch (err) {
                                                  ToastUtil.showError(
                                                    '入库失败: $err',
                                                  );
                                                }
                                              },
                                              child: const Text('入库'),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LayoutTokens.gapLg,
                LayoutTokens.gapMd,
                LayoutTokens.gapLg,
                LayoutTokens.gapLg,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text(cancelText),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _InspectionSummaryItem extends StatelessWidget {
  const _InspectionSummaryItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: LayoutTokens.gapXxxs),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

Future<void> showPurchaseInspectionAppFormDialog(
  BuildContext context, {
  required Map<String, dynamic> record,
  required Future<void> Function(int recordId, Map<String, dynamic> payload)
      confirmInspection,
}) async {
  final formKey = GlobalKey<FormState>();
  final received = _toDouble(record['received_quantity']) ?? 0;
  final qualifiedController =
      TextEditingController(text: received.toStringAsFixed(2));
  final unqualifiedController = TextEditingController(text: '0');
  final reasonController = TextEditingController();
  bool submitting = false;

  Future<void> submit(StateSetter setState) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final qualified = double.tryParse(qualifiedController.text.trim()) ?? 0;
    final unqualified = double.tryParse(unqualifiedController.text.trim()) ?? 0;
    if ((qualified + unqualified - received).abs() > 0.01) {
      ToastUtil.showError('合格数量 + 不合格数量 必须等于收货数量');
      return;
    }
    setState(() => submitting = true);
    try {
      await confirmInspection(
        record['id'] as int,
        {
          'qualified_quantity': qualified,
          'unqualified_quantity': unqualified,
          'unqualified_reason': reasonController.text.trim(),
        },
      );
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ToastUtil.showSuccess('质检确认成功');
    } catch (err) {
      if (!context.mounted) return;
      setState(() => submitting = false);
      ToastUtil.showError('质检确认失败: $err');
    }
  }

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AppFormDialog(
            title: '填写质检结果',
            formKey: formKey,
            submitText: '确认',
            submitting: submitting,
            maxWidth: LayoutTokens.dialogWidthSm,
            onSubmit: () => submit(setState),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DetailRow(
                  label: '收货数量',
                  value: received.toStringAsFixed(2),
                ),
                CrudFieldConfig.number(
                  label: '合格数量',
                  controller: qualifiedController,
                  decimal: true,
                  validator: (value) {
                    final parsed = double.tryParse(value?.trim() ?? '');
                    if (parsed == null || parsed < 0) return '请输入有效数量';
                    return null;
                  },
                ).build(dialogContext),
                SizedBox(height: LayoutTokens.gapMd),
                CrudFieldConfig.number(
                  label: '不合格数量',
                  controller: unqualifiedController,
                  decimal: true,
                  validator: (value) {
                    final parsed = double.tryParse(value?.trim() ?? '');
                    if (parsed == null || parsed < 0) return '请输入有效数量';
                    return null;
                  },
                ).build(dialogContext),
                SizedBox(height: LayoutTokens.gapMd),
                CrudFieldConfig.textarea(
                  label: '不合格原因',
                  controller: reasonController,
                  maxLines: 3,
                  validator: (value) {
                    final unqualified = double.tryParse(
                          unqualifiedController.text.trim(),
                        ) ??
                        0;
                    if (unqualified > 0 && (value?.trim().isEmpty ?? true)) {
                      return '请填写不合格原因';
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

  qualifiedController.dispose();
  unqualifiedController.dispose();
  reasonController.dispose();
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              '$label：',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _InlineMeta extends StatelessWidget {
  const _InlineMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
