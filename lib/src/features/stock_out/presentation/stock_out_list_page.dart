import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/features/inventory_shared/presentation/widgets/inventory_document_form_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';
import 'package:work_order_app/src/features/stock_out/data/stock_out_support_service.dart';

class StockOutListEntry extends StatelessWidget {
  const StockOutListEntry({super.key});

  static const String _listRoute = '/inventory/stock-outs';

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'stock_outs',
        title: '出库单',
        endpoint: '/stock-outs/',
        searchHintText: '搜索出库单号/送货单号/客户',
        emptyText: '暂无出库单',
        emptyIcon: Icons.exit_to_app_outlined,
        enableSummary: true,
        openDetailsOnPrimaryTap: true,
        columns: const [
          GenericColumn(label: '出库单号', value: _orderNumber),
          GenericColumn(label: '客户', value: _customerName),
          GenericColumn(label: '出库类型', value: _outType),
          GenericColumn(label: '送货单号', value: _deliveryOrderNumber),
          GenericColumn(label: '状态', value: _status),
          GenericColumn(label: '下一步', value: _followUpText),
          GenericColumn(label: '操作员', value: _operator),
          GenericColumn(label: '创建时间', value: _createdAt),
        ],
        summaryFields: const [
          GenericSummaryField(label: '客户', value: _customerName),
          GenericSummaryField(label: '出库类型', value: _outType),
          GenericSummaryField(label: '送货单号', value: _deliveryOrderNumber),
          GenericSummaryField(label: '状态', value: _status),
          GenericSummaryField(label: '下一步', value: _followUpText),
          GenericSummaryField(label: '操作员', value: _operator),
        ],
        titleBuilder: _title,
        extraParamsBuilder: _extraParamsBuilder,
        headerActionsBuilder: _buildHeaderActions,
        rowActionsBuilder: (context, record, openDetails) {
          final status = record.getString('status');
          final actions = <RowAction>[
            RowAction(label: '查看', onPressed: openDetails),
          ];
          if (status == 'draft') {
            actions.add(
              RowAction(
                label: '编辑',
                icon: Icons.edit_outlined,
                onPressed: () => _openStockOutForm(context, record: record),
              ),
            );
            actions.add(
              RowAction(
                label: '提交',
                icon: Icons.send_outlined,
                onPressed: () => _submitStockOut(context, record.id),
              ),
            );
          }
          if (status == 'submitted') {
            actions.add(
              RowAction(
                label: '审核',
                icon: Icons.fact_check_outlined,
                onPressed: () => _approveStockOut(context, record.id),
              ),
            );
          }
          final deliveryOrderId =
              record.getNumber('delivery_order') ??
              int.tryParse(record.getString('delivery_order') ?? '');
          if (deliveryOrderId != null && deliveryOrderId.toInt() > 0) {
            actions.add(
              RowAction(
                label: '查看送货单',
                icon: Icons.local_shipping_outlined,
                onPressed: () =>
                    _openDeliveryOrderDialog(context, deliveryOrderId.toInt()),
              ),
            );
            actions.add(
              RowAction(
                label: '发货模块',
                icon: Icons.open_in_new_outlined,
                onPressed: () => _openDeliveryList(
                  context,
                  record.getString('customer_name'),
                ),
              ),
            );
          }
          return actions;
        },
      ),
    );
  }

  static String _orderNumber(GenericRecord record) {
    return AppValueFormatter.text(record.getString('order_number'));
  }

  static String _title(GenericRecord record) {
    final order = _orderNumber(record);
    final customer = _customerName(record);
    if (customer == AppValueFormatter.empty) return order;
    return '$order · $customer';
  }

  static String _customerName(GenericRecord record) {
    return AppValueFormatter.text(record.getString('customer_name'));
  }

  static String _outType(GenericRecord record) {
    return AppValueFormatter.text(record.getString('out_type_display'));
  }

  static String _deliveryOrderNumber(GenericRecord record) {
    return AppValueFormatter.text(record.getString('delivery_order_number'));
  }

  static String _status(GenericRecord record) {
    return AppValueFormatter.text(record.getString('status_display'));
  }

  static String _followUpText(GenericRecord record) {
    final status = record.getString('status') ?? '';
    final outType = record.getString('out_type') ?? '';
    if (status == 'draft') return '待提交/审核';
    if (status == 'submitted') return '待审核出库';
    if (status == 'completed' && outType == 'delivery') return '已出库，待发货/签收';
    if (status == 'completed') return '已完成出库';
    return AppValueFormatter.empty;
  }

  static String _operator(GenericRecord record) {
    return AppValueFormatter.text(record.getString('operator_name'));
  }

  static String _createdAt(GenericRecord record) {
    return AppValueFormatter.date(record.getString('created_at'));
  }

  static int _submittedCount(GenericListViewModel viewModel) {
    final summaryCount = _summaryCount(viewModel, 'submitted_count');
    if (summaryCount > 0) return summaryCount;
    return viewModel.records
        .where((record) => (record.getString('status') ?? '') == 'submitted')
        .length;
  }

  static int _draftCount(GenericListViewModel viewModel) {
    final summaryCount = _summaryCount(viewModel, 'draft_count');
    if (summaryCount > 0) return summaryCount;
    return viewModel.records
        .where((record) => (record.getString('status') ?? '') == 'draft')
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
          label: '待审核出库',
          count: _submittedCount(viewModel),
          icon: Icons.fact_check_outlined,
          selected: currentStatus == 'submitted',
          onTap: () =>
              _openQuickFilter(context, viewModel, status: 'submitted'),
        ),
      if (_draftCount(viewModel) > 0)
        StatusHintChip(
          label: '待处理出库',
          count: _draftCount(viewModel),
          icon: Icons.outbox_outlined,
          selected: currentStatus == 'draft',
          onTap: () => _openQuickFilter(context, viewModel, status: 'draft'),
        ),
      if (_hasActiveFilter(viewModel))
        OutlinedButton.icon(
          onPressed: () => context.go(_listRoute),
          icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
          label: const Text('清除筛选'),
        ),
      SizedBox(
        width: 150,
        child: AppSelect<String>(
          key: ValueKey<String>(_currentStatus(viewModel)),
          value: _currentStatus(viewModel).isEmpty
              ? null
              : _currentStatus(viewModel),
          selectHintText: '状态',
          options: const [
            AppDropdownOption<String>(value: '', label: '全部状态'),
            AppDropdownOption<String>(value: 'draft', label: '待提交'),
            AppDropdownOption<String>(value: 'submitted', label: '待审核'),
            AppDropdownOption<String>(value: 'completed', label: '已完成'),
          ],
          onChanged: (value) =>
              _openQuickFilter(context, viewModel, status: value ?? ''),
        ),
      ),
      SizedBox(
        width: 150,
        child: AppSelect<String>(
          key: ValueKey<String>(_currentOutType(viewModel)),
          value: _currentOutType(viewModel).isEmpty
              ? null
              : _currentOutType(viewModel),
          selectHintText: '出库类型',
          options: const [
            AppDropdownOption<String>(value: '', label: '全部类型'),
            AppDropdownOption<String>(value: 'delivery', label: '发货出库'),
            AppDropdownOption<String>(value: 'return', label: '退货出库'),
            AppDropdownOption<String>(value: 'transfer', label: '调拨出库'),
            AppDropdownOption<String>(value: 'defective', label: '次品出库'),
          ],
          onChanged: (value) =>
              _openQuickFilter(context, viewModel, outType: value ?? ''),
        ),
      ),
      SizedBox(
        width: 170,
        child: AppSelect<String>(
          key: ValueKey<String>(_currentOrdering(viewModel)),
          value: _currentOrdering(viewModel),
          selectHintText: '排序',
          options: const [
            AppDropdownOption<String>(value: '-created_at', label: '最新创建'),
            AppDropdownOption<String>(value: 'created_at', label: '最早创建'),
            AppDropdownOption<String>(value: '-stock_out_date', label: '最新出库'),
            AppDropdownOption<String>(value: 'stock_out_date', label: '最早出库'),
            AppDropdownOption<String>(value: 'order_number', label: '出库单号升序'),
            AppDropdownOption<String>(value: '-order_number', label: '出库单号降序'),
            AppDropdownOption<String>(
              value: 'delivery_order__order_number',
              label: '送货单号升序',
            ),
            AppDropdownOption<String>(
              value: '-delivery_order__order_number',
              label: '送货单号降序',
            ),
            AppDropdownOption<String>(
              value: 'delivery_order__customer__name',
              label: '客户名称升序',
            ),
            AppDropdownOption<String>(
              value: '-delivery_order__customer__name',
              label: '客户名称降序',
            ),
          ],
          onChanged: (value) => _openQuickFilter(
            context,
            viewModel,
            ordering: value ?? '-created_at',
          ),
        ),
      ),
      PageActionButton.filled(
        onPressed: () => _openStockOutForm(context),
        icon: const Icon(Icons.add),
        label: '新建出库单',
      ),
    ];
  }

  static Map<String, dynamic> _extraParamsBuilder(Uri uri) {
    final extraParams = <String, dynamic>{};
    final status = uri.queryParameters['status']?.trim() ?? '';
    if (status.isNotEmpty) {
      extraParams['status'] = status;
    }
    final outType = uri.queryParameters['out_type']?.trim() ?? '';
    if (outType.isNotEmpty) {
      extraParams['out_type'] = outType;
    }
    final startDate = uri.queryParameters['start_date']?.trim() ?? '';
    if (startDate.isNotEmpty) {
      extraParams['start_date'] = startDate;
    }
    final endDate = uri.queryParameters['end_date']?.trim() ?? '';
    if (endDate.isNotEmpty) {
      extraParams['end_date'] = endDate;
    }
    final ordering = uri.queryParameters['ordering']?.trim() ?? '';
    extraParams['ordering'] = ordering.isEmpty ? '-created_at' : ordering;
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

  static String _currentOutType(GenericListViewModel viewModel) {
    return viewModel.extraParams['out_type']?.toString().trim() ?? '';
  }

  static String _currentOrdering(GenericListViewModel viewModel) {
    final value = viewModel.extraParams['ordering']?.toString().trim() ?? '';
    return value.isEmpty ? '-created_at' : value;
  }

  static bool _hasActiveFilter(GenericListViewModel viewModel) {
    return _currentStatus(viewModel).isNotEmpty ||
        _currentOutType(viewModel).isNotEmpty ||
        (viewModel.extraParams['start_date']?.toString().trim() ?? '')
            .isNotEmpty ||
        (viewModel.extraParams['end_date']?.toString().trim() ?? '')
            .isNotEmpty ||
        _currentOrdering(viewModel) != '-created_at';
  }

  static void _openQuickFilter(
    BuildContext context,
    GenericListViewModel viewModel, {
    String? status,
    String? outType,
    String? ordering,
  }) {
    final query = <String, String>{};
    final search = viewModel.searchText.trim();
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    final nextStatus = status ?? _currentStatus(viewModel);
    if (nextStatus.trim().isNotEmpty) {
      query['status'] = nextStatus.trim();
    }
    final nextOutType = outType ?? _currentOutType(viewModel);
    if (nextOutType.trim().isNotEmpty) {
      query['out_type'] = nextOutType.trim();
    }
    final startDate =
        viewModel.extraParams['start_date']?.toString().trim() ?? '';
    if (startDate.isNotEmpty) {
      query['start_date'] = startDate;
    }
    final endDate = viewModel.extraParams['end_date']?.toString().trim() ?? '';
    if (endDate.isNotEmpty) {
      query['end_date'] = endDate;
    }
    final nextOrdering = ordering ?? _currentOrdering(viewModel);
    if (nextOrdering.trim().isNotEmpty && nextOrdering != '-created_at') {
      query['ordering'] = nextOrdering.trim();
    }
    context.go(Uri(path: _listRoute, queryParameters: query).toString());
  }

  static void _openDeliveryList(BuildContext context, String? keyword) {
    final trimmed = keyword?.trim() ?? '';
    final uri = trimmed.isEmpty
        ? Uri(path: '/inventory/delivery')
        : Uri(
            path: '/inventory/delivery',
            queryParameters: {'search': trimmed},
          );
    context.go(uri.toString());
  }

  static const List<_OutTypeOption> _outTypeOptions = [
    _OutTypeOption(value: 'delivery', label: '发货出库'),
    _OutTypeOption(value: 'return', label: '退货出库'),
    _OutTypeOption(value: 'transfer', label: '调拨出库'),
    _OutTypeOption(value: 'defective', label: '次品出库'),
  ];

  static Future<void> _openStockOutForm(
    BuildContext context, {
    GenericRecord? record,
  }) async {
    final supportService = StockOutSupportService(context.read<ApiClient>());
    final isEdit = record != null;
    final recordId = record?.id;
    final outTypeController = TextEditingController(
      text: record?.getString('out_type') ?? 'delivery',
    );
    final deliveryOrderController = TextEditingController(
      text:
          record?.getNumber('delivery_order')?.toString() ??
          record?.getString('delivery_order') ??
          '',
    );
    final dateController = TextEditingController(
      text: _normalizeDate(record?.getString('stock_out_date')) ?? _today(),
    );
    final notesController = TextEditingController(
      text: record?.getString('notes') ?? '',
    );

    await showInventoryDocumentFormDialog(
      context,
      title: isEdit ? '编辑出库单' : '新建出库单',
      dateLabel: '出库日期',
      dateController: dateController,
      notesController: notesController,
      fieldsBuilder: (context, refresh, submitting) => [
        AppSelect<String>(
          value: outTypeController.text,
          decoration: const InputDecoration(
            labelText: '出库类型',
            border: OutlineInputBorder(),
          ),
          options: _outTypeOptions
              .map(
                (option) =>
                    AppDropdownOption(value: option.value, label: option.label),
              )
              .toList(),
          onChanged: submitting
              ? null
              : (value) => outTypeController.text = value ?? 'delivery',
        ),
        TextField(
          controller: deliveryOrderController,
          enabled: !submitting,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '送货单ID（可选）',
            border: OutlineInputBorder(),
          ),
        ),
      ],
      onSubmit: () async {
        try {
          final payload = <String, dynamic>{
            'out_type': outTypeController.text.trim(),
            'stock_out_date': dateController.text.trim(),
            'notes': notesController.text.trim(),
            'delivery_order': null,
          };
          final deliveryOrderId = int.tryParse(
            deliveryOrderController.text.trim(),
          );
          if (deliveryOrderId != null) {
            payload['delivery_order'] = deliveryOrderId;
          }
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

    outTypeController.dispose();
    deliveryOrderController.dispose();
    dateController.dispose();
    notesController.dispose();
  }

  static Future<void> _submitStockOut(BuildContext context, int id) async {
    final supportService = StockOutSupportService(context.read<ApiClient>());
    try {
      await supportService.submit(id);
      if (!context.mounted) return;
      context.read<GenericListViewModel>().reload(resetPage: true);
      ToastUtil.showSuccess('已提交');
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    }
  }

  static Future<void> _approveStockOut(BuildContext context, int id) async {
    final supportService = StockOutSupportService(context.read<ApiClient>());
    try {
      await supportService.approve(id);
      if (!context.mounted) return;
      context.read<GenericListViewModel>().reload(resetPage: true);
      ToastUtil.showSuccess('已审核');
    } catch (err) {
      ToastUtil.showError('审核失败: $err');
    }
  }

  static Future<void> _openDeliveryOrderDialog(
    BuildContext context,
    int orderId,
  ) async {
    final supportService = StockOutSupportService(context.read<ApiClient>());
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: '送货单详情',
        maxWidth: 520,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('关闭'),
          ),
        ],
        content: FutureBuilder<DeliveryOrderDetail>(
          future: supportService.fetchDeliveryOrderDetail(orderId),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                width: 520,
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return SizedBox(
                width: 520,
                child: Text('加载失败: ${snapshot.error ?? '未知错误'}'),
              );
            }
            final detail = snapshot.data!;
            return SizedBox(
              width: 520,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(label: '送货单号', value: detail.orderNumber),
                  _DetailRow(label: '客户', value: detail.customerName ?? '-'),
                  _DetailRow(
                    label: '状态',
                    value: detail.statusDisplay ?? detail.status ?? '-',
                  ),
                  _DetailRow(
                    label: '客户订单号',
                    value: detail.salesOrderNumber ?? '-',
                  ),
                  _DetailRow(
                    label: '发货日期',
                    value: _formatDate(detail.deliveryDate),
                  ),
                  _DetailRow(label: '收货人', value: detail.receiverName ?? '-'),
                  _DetailRow(
                    label: '物流公司',
                    value: detail.logisticsCompany ?? '-',
                  ),
                  _DetailRow(label: '运单号', value: detail.trackingNumber ?? '-'),
                  if ((detail.notes ?? '').trim().isNotEmpty)
                    _DetailRow(label: '备注', value: detail.notes ?? ''),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static String _formatDate(DateTime? value) {
    if (value == null) return '-';
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String _today() {
    return _formatDate(DateTime.now());
  }

  static String? _normalizeDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return _formatDate(parsed);
  }
}

class _OutTypeOption {
  const _OutTypeOption({required this.value, required this.label});

  final String value;
  final String label;
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
            width: 90,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          SpacingTokens.hSm,
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
