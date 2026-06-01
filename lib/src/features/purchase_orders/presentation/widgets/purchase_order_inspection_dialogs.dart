import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_loading_indicator.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
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
  await showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: title,
    desktopWidth: LayoutTokens.dialogWidthLg,
    child: _PurchaseInspectionPanel(
      loadRecords: loadRecords,
      confirmInspection: confirmInspection,
      stockIn: stockIn,
      cancelText: cancelText,
    ),
  );
}

class _PurchaseInspectionPanel extends StatefulWidget {
  const _PurchaseInspectionPanel({
    required this.loadRecords,
    required this.confirmInspection,
    required this.stockIn,
    required this.cancelText,
  });

  final Future<List<Map<String, dynamic>>> Function() loadRecords;
  final Future<void> Function(int recordId, Map<String, dynamic> payload)
  confirmInspection;
  final Future<void> Function(int recordId) stockIn;
  final String cancelText;

  @override
  State<_PurchaseInspectionPanel> createState() =>
      _PurchaseInspectionPanelState();
}

class _PurchaseInspectionPanelState extends State<_PurchaseInspectionPanel> {
  var _records = <Map<String, dynamic>>[];
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() => _loading = true);
    try {
      final records = await widget.loadRecords();
      if (!mounted) return;
      setState(() => _records = records);
    } catch (err) {
      ToastUtil.showError('加载收货记录失败: $err');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _confirmStockIn(Map<String, dynamic> record) async {
    final qualified = _toDouble(record['qualified_quantity']) ?? 0;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (confirmContext) => AppDialog(
        title: '确认入库',
        maxWidth: LayoutTokens.dialogWidthXs,
        scrollable: false,
        content: Text('确定将 $qualified 件物料入库吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(confirmContext).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(confirmContext).pop(true),
            child: const Text('确认'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await widget.stockIn(record['id'] as int);
      ToastUtil.showSuccess('入库成功');
      if (!mounted) return;
      await _reload();
    } catch (err) {
      ToastUtil.showError('入库失败: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _records
        .where((record) => record['inspection_status']?.toString() == 'pending')
        .length;

    return Column(
      children: [
        Expanded(
          child: _loading
              ? const AppLoadingIndicator()
              : _records.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(SpacingTokens.lg),
                  child: EmptyStateCard(
                    icon: Icons.verified_outlined,
                    text: '暂无收货记录',
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(SpacingTokens.lg),
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '收货记录质检',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: SpacingTokens.xxs),
                          Text(
                            '在当前上下文里完成质检确认，避免弹窗叠弹窗。',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: SpacingTokens.md),
                          Wrap(
                            spacing: SpacingTokens.md,
                            runSpacing: SpacingTokens.sm,
                            children: [
                              _InspectionSummaryItem(
                                label: '收货记录',
                                value: _records.length.toString(),
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
                    const SizedBox(height: SpacingTokens.lg),
                    ..._records.map(_buildRecordCard),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            SpacingTokens.lg,
            SpacingTokens.md,
            SpacingTokens.lg,
            SpacingTokens.lg,
          ),
          child: Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(widget.cancelText),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    final status = record['inspection_status']?.toString() ?? '';
    final statusDisplay =
        record['inspection_status_display']?.toString() ?? '-';
    final qualified = _toDouble(record['qualified_quantity']) ?? 0;
    final isStocked = record['is_stocked'] == true;
    final canInspect = status == 'pending';
    final canStockIn =
        (status == 'qualified' || status == 'partial_qualified') &&
        !isStocked &&
        qualified > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
      child: AppCard(
        padding: const EdgeInsets.all(LayoutTokens.cardPaddingSm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${record['material_code'] ?? '-'} ${record['material_name'] ?? '-'}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: SpacingTokens.xxs),
            Wrap(
              spacing: SpacingTokens.md,
              runSpacing: SpacingTokens.xs,
              children: [
                _InlineMeta(
                  label: '收货数量',
                  value: record['received_quantity']?.toString() ?? '-',
                ),
                _InlineMeta(label: '状态', value: statusDisplay),
                _InlineMeta(
                  label: '收货日期',
                  value: record['received_date']?.toString() ?? '-',
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.sm),
            Wrap(
              spacing: SpacingTokens.sm,
              children: [
                if (canInspect)
                  OutlinedButton(
                    onPressed: () async {
                      await showPurchaseInspectionAppFormDialog(
                        context,
                        record: record,
                        confirmInspection: widget.confirmInspection,
                      );
                      if (!mounted) return;
                      await _reload();
                    },
                    child: const Text('质检'),
                  ),
                if (canStockIn)
                  OutlinedButton(
                    onPressed: () => _confirmStockIn(record),
                    child: const Text('入库'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InspectionSummaryItem extends StatelessWidget {
  const _InspectionSummaryItem({required this.label, required this.value});

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
        const SizedBox(height: SpacingTokens.xxxs),
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
  await showDialog<void>(
    context: context,
    builder: (_) => _PurchaseInspectionFormDialog(
      record: record,
      confirmInspection: confirmInspection,
    ),
  );
}

class _PurchaseInspectionFormDialog extends StatefulWidget {
  const _PurchaseInspectionFormDialog({
    required this.record,
    required this.confirmInspection,
  });

  final Map<String, dynamic> record;
  final Future<void> Function(int recordId, Map<String, dynamic> payload)
  confirmInspection;

  @override
  State<_PurchaseInspectionFormDialog> createState() =>
      _PurchaseInspectionFormDialogState();
}

class _PurchaseInspectionFormDialogState
    extends State<_PurchaseInspectionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final double _received;
  late final TextEditingController _qualifiedController;
  late final TextEditingController _unqualifiedController;
  late final TextEditingController _reasonController;
  var _submitting = false;

  @override
  void initState() {
    super.initState();
    _received = _toDouble(widget.record['received_quantity']) ?? 0;
    _qualifiedController = TextEditingController(
      text: _received.toStringAsFixed(2),
    );
    _unqualifiedController = TextEditingController(text: '0');
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _qualifiedController.dispose();
    _unqualifiedController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final qualified = double.tryParse(_qualifiedController.text.trim()) ?? 0;
    final unqualified =
        double.tryParse(_unqualifiedController.text.trim()) ?? 0;
    if ((qualified + unqualified - _received).abs() > 0.01) {
      ToastUtil.showError('合格数量 + 不合格数量 必须等于收货数量');
      return;
    }

    setState(() => _submitting = true);
    try {
      await widget.confirmInspection(widget.record['id'] as int, {
        'qualified_quantity': qualified,
        'unqualified_quantity': unqualified,
        'unqualified_reason': _reasonController.text.trim(),
      });
      if (!mounted) return;
      Navigator.of(context).pop();
      ToastUtil.showSuccess('质检确认成功');
    } catch (err) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ToastUtil.showError('质检确认失败: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: '填写质检结果',
      formKey: _formKey,
      submitText: '确认',
      submitting: _submitting,
      maxWidth: LayoutTokens.dialogWidthSm,
      onSubmit: _submit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DetailRow(label: '收货数量', value: _received.toStringAsFixed(2)),
          CrudFieldConfig.number(
            label: '合格数量',
            controller: _qualifiedController,
            decimal: true,
            validator: (value) {
              final parsed = double.tryParse(value?.trim() ?? '');
              if (parsed == null || parsed < 0) return '请输入有效数量';
              return null;
            },
          ).build(context),
          SizedBox(height: SpacingTokens.md),
          CrudFieldConfig.number(
            label: '不合格数量',
            controller: _unqualifiedController,
            decimal: true,
            validator: (value) {
              final parsed = double.tryParse(value?.trim() ?? '');
              if (parsed == null || parsed < 0) return '请输入有效数量';
              return null;
            },
          ).build(context),
          SizedBox(height: SpacingTokens.md),
          CrudFieldConfig.textarea(
            label: '不合格原因',
            controller: _reasonController,
            maxLines: 3,
            validator: (value) {
              final unqualified =
                  double.tryParse(_unqualifiedController.text.trim()) ?? 0;
              if (unqualified > 0 && (value?.trim().isEmpty ?? true)) {
                return '请填写不合格原因';
              }
              return null;
            },
          ).build(context),
        ],
      ),
    );
  }
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
