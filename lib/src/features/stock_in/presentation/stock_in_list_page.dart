import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/inventory_shared/presentation/widgets/inventory_document_form_dialog.dart';
import 'package:work_order_app/src/features/stock_in/data/stock_in_support_service.dart';

class StockInListEntry extends StatelessWidget {
  const StockInListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'stock_ins',
        title: '入库单',
        endpoint: '/stock-ins/',
        searchHintText: '搜索入库单号/施工单/客户',
        emptyText: '暂无入库单',
        emptyIcon: Icons.inventory_2_outlined,
        enableSummary: true,
        openDetailsOnPrimaryTap: true,
        columns: const [
          GenericColumn(label: '入库单号', value: _orderNumber),
          GenericColumn(label: '客户', value: _customerName),
          GenericColumn(label: '施工单号', value: _workOrderNumber),
          GenericColumn(label: '入库日期', value: _stockInDate),
          GenericColumn(label: '状态', value: _status),
          GenericColumn(label: '下一步', value: _followUpText),
          GenericColumn(label: '操作员', value: _operator),
          GenericColumn(label: '创建时间', value: _createdAt),
        ],
        summaryFields: const [
          GenericSummaryField(label: '客户', value: _customerName),
          GenericSummaryField(label: '施工单号', value: _workOrderNumber),
          GenericSummaryField(label: '入库日期', value: _stockInDate),
          GenericSummaryField(label: '状态', value: _status),
          GenericSummaryField(label: '下一步', value: _followUpText),
          GenericSummaryField(label: '操作员', value: _operator),
        ],
        titleBuilder: _title,
        extraParamsBuilder: _extraParamsBuilder,
        headerActionsBuilder: _buildHeaderActions,
        rowActionsBuilder: (context, record, openDetails) {
          final actions = <RowAction>[
            RowAction(
              label: '编辑',
              icon: Icons.edit_outlined,
              onPressed: () => _openStockInForm(context, record: record),
            ),
          ];
          final workOrderId = record.getNumber('work_order') ??
              int.tryParse(record.getString('work_order') ?? '');
          if (workOrderId != null && workOrderId.toInt() > 0) {
            actions.add(RowAction(
              label: '查看施工单',
              icon: Icons.description_outlined,
              onPressed: () => context.go('/workorders/${workOrderId.toInt()}'),
            ));
          }
          final status = record.getString('status');
          if (status == 'draft') {
            actions.add(RowAction(
              label: '提交',
              icon: Icons.send_outlined,
              onPressed: () => _submitStockIn(context, record.id),
            ));
          }
          if (status == 'submitted') {
            actions.add(RowAction(
              label: '审核',
              icon: Icons.fact_check_outlined,
              onPressed: () => _approveStockIn(context, record.id),
            ));
          }
          return actions;
        },
      ),
    );
  }

  static String _orderNumber(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('order_number'));
  }

  static String _title(GenericRecord record) {
    final order = _orderNumber(record);
    final customer = _customerName(record);
    if (customer == GenericValueFormatter.empty) return order;
    return '$order · $customer';
  }

  static String _customerName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('customer_name'));
  }

  static String _workOrderNumber(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('work_order_number'));
  }

  static String _stockInDate(GenericRecord record) {
    return GenericValueFormatter.date(record.getString('stock_in_date'));
  }

  static String _status(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('status_display'));
  }

  static String _followUpText(GenericRecord record) {
    final status = record.getString('status') ?? '';
    switch (status) {
      case 'draft':
        return '待提交入库';
      case 'submitted':
        return '待审核入库';
      case 'completed':
        return '已入库，可继续备货/发货';
      default:
        return GenericValueFormatter.empty;
    }
  }

  static String _operator(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('operator_name'));
  }

  static String _createdAt(GenericRecord record) {
    return GenericValueFormatter.date(record.getString('created_at'));
  }

  static int _submittedCount(GenericListViewModel viewModel) {
    final summaryCount = _summaryCount(viewModel, 'submitted_count');
    if (summaryCount > 0) return summaryCount;
    return viewModel.records
        .where((record) => (record.getString('status') ?? '') == 'submitted')
        .length;
  }

  static int _completedCount(GenericListViewModel viewModel) {
    final summaryCount = _summaryCount(viewModel, 'completed_count');
    if (summaryCount > 0) return summaryCount;
    return viewModel.records
        .where((record) => (record.getString('status') ?? '') == 'completed')
        .length;
  }

  static List<Widget> _buildHeaderActions(
    BuildContext context,
    GenericListViewModel viewModel,
  ) {
    final currentStatus = _currentStatus(viewModel);
    return [
      if (_submittedCount(viewModel) > 0)
        StatusHintChip(
          label: '待审核入库',
          count: _submittedCount(viewModel),
          icon: Icons.fact_check_outlined,
          selected: currentStatus == 'submitted',
          onTap: () => _openQuickFilter(context, status: 'submitted'),
        ),
      if (_completedCount(viewModel) > 0)
        StatusHintChip(
          label: '已完成入库',
          count: _completedCount(viewModel),
          icon: Icons.inventory_2_outlined,
          selected: currentStatus == 'completed',
          onTap: () => _openQuickFilter(context, status: 'completed'),
        ),
      if (_hasActiveFilter(viewModel))
        OutlinedButton.icon(
          onPressed: () => context.go('/inventory/stock-ins'),
          icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
          label: const Text('清除筛选'),
        ),
      PageActionButton.filled(
        onPressed: () => _openStockInForm(context),
        icon: const Icon(Icons.add),
        label: '新建入库单',
      ),
    ];
  }

  static Map<String, dynamic> _extraParamsBuilder(Uri uri) {
    final extraParams = <String, dynamic>{};
    final status = uri.queryParameters['status']?.trim() ?? '';
    if (status.isNotEmpty) {
      extraParams['status'] = status;
    }
    return extraParams;
  }

  static int _summaryCount(GenericListViewModel viewModel, String key) {
    final summary = viewModel.summary['summary'];
    if (summary is Map<String, dynamic>) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }
    if (summary is Map) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }
    return 0;
  }

  static String _currentStatus(GenericListViewModel viewModel) {
    return viewModel.extraParams['status']?.toString().trim() ?? '';
  }

  static bool _hasActiveFilter(GenericListViewModel viewModel) {
    return _currentStatus(viewModel).isNotEmpty;
  }

  static void _openQuickFilter(
    BuildContext context, {
    required String status,
  }) {
    context.go(
      Uri(
        path: '/inventory/stock-ins',
        queryParameters: {'status': status},
      ).toString(),
    );
  }

  static Future<void> _openStockInForm(
    BuildContext context, {
    GenericRecord? record,
  }) async {
    final supportService = StockInSupportService(context.read<ApiClient>());
    final isEdit = record != null;
    final recordId = record?.id;
    final workOrderController = TextEditingController(
      text: record?.getNumber('work_order')?.toString() ??
          record?.getString('work_order') ??
          '',
    );
    final dateController = TextEditingController(
      text: _normalizeDate(record?.getString('stock_in_date')) ?? _today(),
    );
    final notesController = TextEditingController(
      text: record?.getString('notes') ?? '',
    );

    await showInventoryDocumentFormDialog(
      context,
      title: isEdit ? '编辑入库单' : '新建入库单',
      dateLabel: '入库日期',
      dateController: dateController,
      notesController: notesController,
      fieldsBuilder: (context, refresh, submitting) => [
        TextField(
          controller: workOrderController,
          enabled: !submitting,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '施工单ID',
            border: OutlineInputBorder(),
          ),
        ),
      ],
      onSubmit: () async {
        final workOrderId = int.tryParse(workOrderController.text.trim());
        if (workOrderId == null) {
          ToastUtil.showError('请输入有效的施工单ID');
          return;
        }
        try {
          final payload = {
            'work_order': workOrderId,
            'stock_in_date': dateController.text.trim(),
            'notes': notesController.text.trim(),
          };
          await supportService.save(
            id: isEdit ? recordId : null,
            payload: payload,
          );
          if (!context.mounted) return;
          context.read<GenericListViewModel>().reload(resetPage: true);
          Navigator.of(context).pop(true);
          ToastUtil.showSuccess(isEdit ? '已更新' : '已创建');
        } catch (err) {
          ToastUtil.showError('保存失败: $err');
        }
      },
    );

    workOrderController.dispose();
    dateController.dispose();
    notesController.dispose();
  }

  static Future<void> _submitStockIn(BuildContext context, int id) async {
    final supportService = StockInSupportService(context.read<ApiClient>());
    try {
      await supportService.submit(id);
      if (!context.mounted) return;
      context.read<GenericListViewModel>().reload(resetPage: true);
      ToastUtil.showSuccess('已提交');
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    }
  }

  static Future<void> _approveStockIn(BuildContext context, int id) async {
    final supportService = StockInSupportService(context.read<ApiClient>());
    try {
      await supportService.approve(id);
      if (!context.mounted) return;
      context.read<GenericListViewModel>().reload(resetPage: true);
      ToastUtil.showSuccess('已审核');
    } catch (err) {
      ToastUtil.showError('审核失败: $err');
    }
  }

  static String _today() {
    final now = DateTime.now();
    final year = now.year.toString().padLeft(4, '0');
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String? _normalizeDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    final year = parsed.year.toString().padLeft(4, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
