import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/utils/html_print.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';

Future<void> showWorkOrderPrintPreviewDialog(
  BuildContext context, {
  required WorkOrderDetail detail,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _WorkOrderPrintPreviewDialog(detail: detail),
  );
}

class _WorkOrderPrintPreviewDialog extends StatefulWidget {
  const _WorkOrderPrintPreviewDialog({required this.detail});

  final WorkOrderDetail detail;

  @override
  State<_WorkOrderPrintPreviewDialog> createState() =>
      _WorkOrderPrintPreviewDialogState();
}

class _WorkOrderPrintPreviewDialogState
    extends State<_WorkOrderPrintPreviewDialog> {
  bool _printing = false;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);
    final dialogWidth = math.max(320.0, math.min(1080.0, mediaSize.width - 32));
    final dialogHeight =
        math.max(360.0, math.min(780.0, mediaSize.height - 32));
    final sheetWidth = math.min(900.0, dialogWidth - 48);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '施工单打印预览',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _printing ? null : _print,
                    icon: _printing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.print_outlined, size: 18),
                    label: const Text('打印'),
                  ),
                  const SizedBox(width: LayoutTokens.gapSm),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: '关闭',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ColoredBox(
                color: const Color(0xfff0f2f5),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: dialogWidth - 48,
                    child: WorkOrderPrintSheet(
                      detail: widget.detail,
                      width: sheetWidth,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _print() async {
    setState(() => _printing = true);
    try {
      await printHtmlDocument(
        title: '施工单-${widget.detail.orderNumber}',
        html: buildWorkOrderPrintHtml(widget.detail),
      );
    } catch (err) {
      ToastUtil.showError(
          err.toString().replaceFirst('UnsupportedError: ', ''));
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }
}

class WorkOrderPrintSheet extends StatelessWidget {
  const WorkOrderPrintSheet({
    super.key,
    required this.detail,
    required this.width,
  });

  final WorkOrderDetail detail;
  final double width;

  @override
  Widget build(BuildContext context) {
    final data = _PrintData(detail);
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffd7dde5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Color(0xff172033),
          fontSize: 13,
          height: 1.35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PrintHeader(data: data),
            const SizedBox(height: 18),
            _InfoGrid(items: data.basicItems),
            const SizedBox(height: 18),
            _Section(
              title: '产品清单',
              child: _SimpleTable(
                headers: const ['产品', '编码', '数量', '单位', '规格', '拼版数'],
                rows: data.productRows,
                emptyText: '暂无产品信息',
              ),
            ),
            const SizedBox(height: 14),
            _Section(
              title: '物料需求',
              child: _SimpleTable(
                headers: const ['物料', '编码', '尺寸', '用量', '需开料', '采购状态'],
                rows: data.materialRows,
                emptyText: '暂无物料需求',
              ),
            ),
            const SizedBox(height: 14),
            _Section(
              title: '工序与任务',
              child: _ProcessList(data: data),
            ),
            const SizedBox(height: 14),
            _Section(
              title: '图稿与版材',
              child: _InfoGrid(items: data.resourceItems, compact: true),
            ),
            const SizedBox(height: 14),
            _Section(
              title: '备注与审批',
              child: _InfoGrid(items: data.noteItems, compact: true),
            ),
            const SizedBox(height: 22),
            const _SignatureRow(),
          ],
        ),
      ),
    );
  }
}

class _PrintHeader extends StatelessWidget {
  const _PrintHeader({required this.data});

  final _PrintData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Text(
                '施工单',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.orderNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text('打印时间：${data.printedAt}'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _Badge(label: '状态', value: data.status),
            _Badge(label: '审核', value: data.approvalStatus),
            _Badge(label: '优先级', value: data.priority),
            _Badge(label: '进度', value: data.progress),
          ],
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xffeef4ff),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xffcddaf0)),
      ),
      child: Text('$label：$value'),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffd7dde5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xfff4f7fb),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.items, this.compact = false});

  final List<_InfoItem> items;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: [
        for (final item in items)
          SizedBox(
            width: item.fullWidth ? double.infinity : (compact ? 360 : 270),
            child: _InfoCell(item: item),
          ),
      ],
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({required this.item});

  final _InfoItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffd7dde5)),
      ),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '${item.label}：',
              style: const TextStyle(color: Color(0xff607086)),
            ),
            TextSpan(text: item.value),
          ],
        ),
      ),
    );
  }
}

class _SimpleTable extends StatelessWidget {
  const _SimpleTable({
    required this.headers,
    required this.rows,
    required this.emptyText,
  });

  final List<String> headers;
  final List<List<String>> rows;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return Text(emptyText);
    return Table(
      border: TableBorder.all(color: const Color(0xffd7dde5)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xfff7f9fc)),
          children: headers.map(_tableHeader).toList(),
        ),
        for (final row in rows)
          TableRow(
            children: [
              for (final cell in row) _tableCell(cell),
            ],
          ),
      ],
    );
  }

  Widget _tableHeader(String value) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }

  Widget _tableCell(String value) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Text(value),
    );
  }
}

class _ProcessList extends StatelessWidget {
  const _ProcessList({required this.data});

  final _PrintData data;

  @override
  Widget build(BuildContext context) {
    if (data.detail.processes.isEmpty) return const Text('暂无工序信息');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final process in data.detail.processes) ...[
          _ProcessCard(process: process),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ProcessCard extends StatelessWidget {
  const _ProcessCard({required this.process});

  final WorkOrderProcessItem process;

  @override
  Widget build(BuildContext context) {
    final tasks = process.tasks;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffd7dde5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                Text(
                  _text(process.processName),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text('编码：${_text(process.processCode)}'),
                Text('状态：${_text(process.statusDisplay ?? process.status)}'),
                Text('部门：${_text(process.departmentName)}'),
                Text('操作员：${_text(process.operatorName)}'),
              ],
            ),
            if (tasks.isNotEmpty) ...[
              const SizedBox(height: 8),
              _SimpleTable(
                headers: const ['任务内容', '类型', '部门', '操作员', '进度', '状态'],
                rows: tasks.map(_taskRow).toList(),
                emptyText: '暂无任务',
              ),
            ],
          ],
        ),
      ),
    );
  }

  static List<String> _taskRow(Task task) {
    final total = task.productionQuantity;
    final done = task.quantityCompleted;
    final progress = total == null
        ? _text(done?.toString())
        : '${_num(done)}/${_num(total)}';
    return [
      _text(task.workContent),
      _text(task.taskTypeDisplay ?? task.taskType),
      _text(task.assignedDepartmentName),
      _text(task.assignedOperatorName),
      progress,
      _text(task.statusDisplay ?? task.status),
    ];
  }
}

class _SignatureRow extends StatelessWidget {
  const _SignatureRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Text('制表：')),
        Expanded(child: Text('生产负责人：')),
        Expanded(child: Text('审核：')),
        Expanded(child: Text('业务员：')),
      ],
    );
  }
}

class _InfoItem {
  const _InfoItem(this.label, this.value, {this.fullWidth = false});

  final String label;
  final String value;
  final bool fullWidth;
}

class _PrintData {
  _PrintData(this.detail);

  final WorkOrderDetail detail;

  String get orderNumber => detail.orderNumber;
  String get status => _text(detail.statusDisplay ?? detail.status);
  String get approvalStatus =>
      _text(detail.approvalStatusDisplay ?? detail.approvalStatus);
  String get priority => _text(detail.priorityDisplay ?? detail.priority);
  String get progress => '${detail.progressPercentage ?? 0}%';
  String get printedAt => _dateTime(DateTime.now());

  List<_InfoItem> get basicItems => [
        _InfoItem('客户', _text(detail.customerName)),
        _InfoItem('来源销售单', _join(detail.salesOrderNumbers)),
        _InfoItem('业务员', _text(detail.salespersonName)),
        _InfoItem('负责人', _text(detail.managerName)),
        _InfoItem('创建人', _text(detail.createdByName)),
        _InfoItem('审核人', _text(detail.approvedByName)),
        _InfoItem('下单日期', _date(detail.orderDate)),
        _InfoItem('交货日期', _date(detail.deliveryDate)),
        _InfoItem('实际交货', _date(detail.actualDeliveryDate)),
        _InfoItem('生产数量', _text(detail.productionQuantity?.toString())),
        _InfoItem('不良数量', _text(detail.defectiveQuantity?.toString())),
        _InfoItem('任务数', _text(detail.totalTaskCount?.toString())),
        _InfoItem('总金额', _amount(detail.totalAmount)),
        _InfoItem(
            '印刷形式', _text(detail.printingTypeDisplay ?? detail.printingType)),
        _InfoItem('印刷色数', _text(detail.printingColorsDisplay)),
        _InfoItem('其他色', _join(detail.printingOtherColors)),
      ];

  List<List<String>> get productRows {
    return detail.products
        .map(
          (item) => [
            _text(item.productName),
            _text(item.productCode),
            _num(item.quantity),
            _text(item.unit),
            _text(item.specification),
            _text(item.impositionQuantity?.toString()),
          ],
        )
        .toList();
  }

  List<List<String>> get materialRows {
    return detail.materials
        .map(
          (item) => [
            _text(item.materialName),
            _text(item.materialCode),
            _text(item.materialSize),
            _text(item.materialUsage),
            item.needCutting == true ? '是' : '否',
            _text(item.purchaseStatusDisplay ?? item.purchaseStatus),
          ],
        )
        .toList();
  }

  List<_InfoItem> get resourceItems => [
        _InfoItem('图稿', _joinPair(detail.artworkCodes, detail.artworkNames)),
        _InfoItem('刀模', _joinPair(detail.dieCodes, detail.dieNames)),
        _InfoItem('烫金版',
            _joinPair(detail.foilingPlateCodes, detail.foilingPlateNames)),
        _InfoItem(
          '压凸版',
          _joinPair(detail.embossingPlateCodes, detail.embossingPlateNames),
        ),
      ];

  List<_InfoItem> get noteItems => [
        _InfoItem('备注', _text(detail.notes), fullWidth: true),
        _InfoItem('审批说明', _text(detail.approvalComment), fullWidth: true),
        _InfoItem('驳回原因', _text(detail.rejectionReason), fullWidth: true),
      ];
}

String buildWorkOrderPrintHtml(WorkOrderDetail detail) {
  final data = _PrintData(detail);
  final processHtml = detail.processes.isEmpty
      ? '<p>暂无工序信息</p>'
      : detail.processes.map(_processHtml).join();
  return '''
<style>
@page { size: A4 portrait; margin: 10mm; }
body { margin: 0; color: #172033; font-family: "Noto Sans SC", "Microsoft YaHei", sans-serif; font-size: 12px; }
.sheet { width: 190mm; margin: 0 auto; }
.header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 6mm; }
h1 { margin: 0; font-size: 26px; }
.orderNo { font-size: 16px; font-weight: 700; text-align: right; }
.badges { display: flex; flex-wrap: wrap; gap: 6px; margin: 4mm 0; }
.badge { border: 1px solid #cddaf0; background: #eef4ff; padding: 4px 8px; }
.grid { display: grid; grid-template-columns: repeat(3, 1fr); border-left: 1px solid #d7dde5; border-top: 1px solid #d7dde5; }
.cell { border-right: 1px solid #d7dde5; border-bottom: 1px solid #d7dde5; padding: 6px; min-height: 18px; }
.full { grid-column: 1 / -1; }
.label { color: #607086; }
.section { border: 1px solid #d7dde5; margin-top: 5mm; page-break-inside: avoid; }
.sectionTitle { background: #f4f7fb; padding: 7px 9px; font-weight: 700; border-bottom: 1px solid #d7dde5; }
.sectionBody { padding: 9px; }
table { width: 100%; border-collapse: collapse; table-layout: fixed; }
th, td { border: 1px solid #d7dde5; padding: 5px; vertical-align: top; word-break: break-word; }
th { background: #f7f9fc; text-align: left; }
.process { border: 1px solid #d7dde5; padding: 7px; margin-bottom: 6px; page-break-inside: avoid; }
.processMeta { display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 6px; }
.sign { display: grid; grid-template-columns: repeat(4, 1fr); margin-top: 8mm; }
</style>
<main class="sheet">
  <div class="header"><h1>施工单</h1><div><div class="orderNo">${_e(data.orderNumber)}</div><div>打印时间：${_e(data.printedAt)}</div></div></div>
  <div class="badges">
    <span class="badge">状态：${_e(data.status)}</span>
    <span class="badge">审核：${_e(data.approvalStatus)}</span>
    <span class="badge">优先级：${_e(data.priority)}</span>
    <span class="badge">进度：${_e(data.progress)}</span>
  </div>
  ${_infoGridHtml(data.basicItems)}
  ${_sectionHtml('产品清单', _tableHtml(const [
                '产品',
                '编码',
                '数量',
                '单位',
                '规格',
                '拼版数'
              ], data.productRows, '暂无产品信息'))}
  ${_sectionHtml('物料需求', _tableHtml(const [
                '物料',
                '编码',
                '尺寸',
                '用量',
                '需开料',
                '采购状态'
              ], data.materialRows, '暂无物料需求'))}
  ${_sectionHtml('工序与任务', processHtml)}
  ${_sectionHtml('图稿与版材', _infoGridHtml(data.resourceItems))}
  ${_sectionHtml('备注与审批', _infoGridHtml(data.noteItems))}
  <div class="sign"><span>制表：</span><span>生产负责人：</span><span>审核：</span><span>业务员：</span></div>
</main>
''';
}

String _processHtml(WorkOrderProcessItem process) {
  final taskRows = process.tasks.map(_taskHtmlRow).join();
  final tasks = process.tasks.isEmpty
      ? '<p>暂无任务</p>'
      : '<table><tr><th>任务内容</th><th>类型</th><th>部门</th><th>操作员</th><th>进度</th><th>状态</th></tr>$taskRows</table>';
  return '''
<div class="process">
  <div class="processMeta">
    <strong>${_e(_text(process.processName))}</strong>
    <span>编码：${_e(_text(process.processCode))}</span>
    <span>状态：${_e(_text(process.statusDisplay ?? process.status))}</span>
    <span>部门：${_e(_text(process.departmentName))}</span>
    <span>操作员：${_e(_text(process.operatorName))}</span>
  </div>
  $tasks
</div>
''';
}

String _taskHtmlRow(Task task) {
  final total = task.productionQuantity;
  final done = task.quantityCompleted;
  final progress =
      total == null ? _text(done?.toString()) : '${_num(done)}/${_num(total)}';
  final cells = [
    task.workContent,
    task.taskTypeDisplay ?? task.taskType,
    task.assignedDepartmentName,
    task.assignedOperatorName,
    progress,
    task.statusDisplay ?? task.status,
  ];
  return '<tr>${cells.map((item) => '<td>${_e(_text(item))}</td>').join()}</tr>';
}

String _sectionHtml(String title, String body) {
  return '<section class="section"><div class="sectionTitle">${_e(title)}</div><div class="sectionBody">$body</div></section>';
}

String _infoGridHtml(List<_InfoItem> items) {
  return '<div class="grid">${items.map((item) {
    final classes = item.fullWidth ? 'cell full' : 'cell';
    return '<div class="$classes"><span class="label">${_e(item.label)}：</span>${_e(item.value)}</div>';
  }).join()}</div>';
}

String _tableHtml(
    List<String> headers, List<List<String>> rows, String emptyText) {
  if (rows.isEmpty) return '<p>${_e(emptyText)}</p>';
  final head = headers.map((item) => '<th>${_e(item)}</th>').join();
  final body = rows
      .map((row) =>
          '<tr>${row.map((cell) => '<td>${_e(cell)}</td>').join()}</tr>')
      .join();
  return '<table><tr>$head</tr>$body</table>';
}

String _date(DateTime? value) {
  if (value == null) return '-';
  return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

String _dateTime(DateTime value) {
  return '${_date(value)} ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

String _amount(double? value) {
  return value == null ? '-' : '¥${value.toStringAsFixed(2)}';
}

String _num(num? value) {
  if (value == null) return '-';
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toString();
}

String _text(String? value) {
  final trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? '-' : trimmed;
}

String _join(List<String> values) {
  final cleaned =
      values.map((item) => item.trim()).where((item) => item.isNotEmpty);
  return cleaned.isEmpty ? '-' : cleaned.join('、');
}

String _joinPair(List<String> codes, List<String> names) {
  final values = <String>[
    ...codes.map((item) => item.trim()).where((item) => item.isNotEmpty),
    ...names.map((item) => item.trim()).where((item) => item.isNotEmpty),
  ];
  return values.isEmpty ? '-' : values.join('、');
}

String _e(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}
