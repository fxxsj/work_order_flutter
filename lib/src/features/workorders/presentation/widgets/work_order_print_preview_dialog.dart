import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/utils/html_print.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
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
    final title = '施工单打印预览';
    final mediaSize = MediaQuery.sizeOf(context);
    final dialogWidth =
        math.min(980.0, mediaSize.width - LayoutTokens.gapMd * 2);
    final dialogHeight =
        math.min(760.0, mediaSize.height - LayoutTokens.gapMd * 2);
    return Dialog(
      insetPadding: const EdgeInsets.all(LayoutTokens.gapMd),
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
                      title,
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final sheetWidth =
                      (constraints.maxWidth - 48).clamp(320.0, 720.0);
                  return ColoredBox(
                    color: const Color(0xffeef0ea),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: WorkOrderPrintSheet(
                          detail: widget.detail,
                          width: sheetWidth,
                        ),
                      ),
                    ),
                  );
                },
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
    this.width = 720,
  });

  final WorkOrderDetail detail;
  final double width;

  static const _line = Color(0xff414b35);
  static const _paper = Color(0xfffbf6b8);

  @override
  Widget build(BuildContext context) {
    final data = _PrintData(detail);
    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 22),
      decoration: BoxDecoration(
        color: _paper,
        border: Border.all(color: _line, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Color(0xff1f281d),
          fontSize: 14,
          height: 1.25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(
                  child: Text(
                    '新西彩包装有限公司',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Text(
                  'No:${data.orderNumber}',
                  style: const TextStyle(
                    color: Color(0xffa44331),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                    child: _InlineField(label: '委印日期', value: data.orderDate)),
                const SizedBox(width: 28),
                Expanded(
                    child:
                        _InlineField(label: '交货日期', value: data.deliveryDate)),
              ],
            ),
            const SizedBox(height: 8),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 11, child: _LeftBlock(data: data)),
                  const SizedBox(width: 0),
                  Expanded(flex: 9, child: _ProcessBlock(data: data)),
                ],
              ),
            ),
            const SizedBox(height: 0),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 9,
                    child: _Box(
                      title: '开 大 纸 图',
                      child: SizedBox(
                        height: 128,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            data.productSpec,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: _Box(
                      title: '印 刷 用 纸',
                      child: SizedBox(
                        height: 128,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            data.paperInfo,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: _CutPaperBlock(data: data),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: const [
                Expanded(child: _Signature(label: '制表')),
                Expanded(child: _Signature(label: '施工员')),
                Expanded(child: _Signature(label: '审核')),
                Expanded(child: _Signature(label: '业务员')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftBlock extends StatelessWidget {
  const _LeftBlock({required this.data});

  final _PrintData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GridRow(label: '委印单位', value: data.customer),
        _GridRow(label: '印件名称', value: data.productName, minHeight: 48),
        _GridRow(label: '数量', value: data.quantity),
        Row(
          children: const [
            Expanded(child: _GridCell(label: '单价', value: '')),
            Expanded(child: _GridCell(label: '总价', value: '')),
          ],
        ),
        _MachineRow(),
        _GridRow(label: '色数', value: data.colors),
        _GridRow(
            label: '说明', value: data.notes, minHeight: 164, alignTop: true),
      ],
    );
  }
}

class _ProcessBlock extends StatelessWidget {
  const _ProcessBlock({required this.data});

  final _PrintData data;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('印刷', data.hasPrinting, data.printingMachines),
      ('上油', data.hasProcess('上油'), ''),
      ('磨光', data.hasProcess('磨光'), ''),
      ('过胶', data.hasProcess('过胶') || data.hasProcess('覆膜'), ''),
      ('表坑', data.hasProcess('表坑'), ''),
      ('压凸', data.hasResource(data.embossingText), data.embossingText),
      ('烫金银', data.hasResource(data.foilingText), data.foilingText),
      (
        '模切',
        data.hasResource(data.dieText) || data.hasProcess('模切'),
        data.dieText
      ),
      ('糊盒', data.hasProcess('糊盒'), ''),
      ('糊窗口', data.hasProcess('糊窗口'), ''),
      ('切成品', data.hasProcess('切成品'), ''),
      ('包装', data.hasProcess('包装'), ''),
    ];
    return Column(
      children: [
        const _GridHeader(left: '施工内容', middle: '', right: '机头数'),
        for (final row in rows)
          _ProcessRow(label: row.$1, checked: row.$2, remark: row.$3),
      ],
    );
  }
}

class _CutPaperBlock extends StatelessWidget {
  const _CutPaperBlock({required this.data});

  final _PrintData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _BoxTitle('切 纸 令 数'),
        _GridRow(label: '纸类', value: data.paperName),
        _GridRow(label: '克重', value: data.paperWeight),
        _GridRow(label: '大纸数量', value: ''),
        _GridRow(label: '印纸数量', value: data.quantity),
      ],
    );
  }
}

class _InlineField extends StatelessWidget {
  const _InlineField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label：'),
        Expanded(child: _Underline(value: value)),
      ],
    );
  }
}

class _Underline extends StatelessWidget {
  const _Underline({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: WorkOrderPrintSheet._line)),
      ),
      child: Text(value, overflow: TextOverflow.ellipsis),
    );
  }
}

class _GridHeader extends StatelessWidget {
  const _GridHeader(
      {required this.left, required this.middle, required this.right});

  final String left;
  final String middle;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 4, child: _HeaderCell(left)),
        Expanded(flex: 2, child: _HeaderCell(middle)),
        Expanded(flex: 4, child: _HeaderCell(right)),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      alignment: Alignment.center,
      decoration: _cellBorder(),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _GridRow extends StatelessWidget {
  const _GridRow({
    required this.label,
    required this.value,
    this.minHeight = 36,
    this.alignTop = false,
  });

  final String label;
  final String value;
  final double minHeight;
  final bool alignTop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: minHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 76,
            child: Container(
              alignment: alignTop ? Alignment.topCenter : Alignment.center,
              padding: const EdgeInsets.all(6),
              decoration: _cellBorder(),
              child: Text(label, textAlign: TextAlign.center),
            ),
          ),
          Expanded(
            child: Container(
              alignment: alignTop ? Alignment.topLeft : Alignment.centerLeft,
              padding: const EdgeInsets.all(8),
              decoration: _cellBorder(),
              child: Text(value),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: _cellBorder(),
      child: Row(
        children: [
          SizedBox(width: 54, child: Text(label, textAlign: TextAlign.center)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _MachineRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = ['四色机', '双色机', '单色机', '六开机'];
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: _cellBorder(),
      child: Row(
        children: [
          const SizedBox(width: 54, child: Text('机种')),
          Expanded(
            child: Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                for (final item in items)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _CheckBoxMark(checked: false),
                      const SizedBox(width: 4),
                      Text(item),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessRow extends StatelessWidget {
  const _ProcessRow({
    required this.label,
    required this.checked,
    required this.remark,
  });

  final String label;
  final bool checked;
  final String remark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 4, child: _RowCell(label, centered: true)),
        Expanded(flex: 2, child: _RowCell(checked ? '✓' : '', centered: true)),
        Expanded(flex: 4, child: _RowCell(remark)),
      ],
    );
  }
}

class _RowCell extends StatelessWidget {
  const _RowCell(this.text, {this.centered = false});

  final String text;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: centered ? Alignment.center : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: _cellBorder(),
      child: Text(text, overflow: TextOverflow.ellipsis),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cellBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BoxTitle(title),
          child,
        ],
      ),
    );
  }
}

class _BoxTitle extends StatelessWidget {
  const _BoxTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: WorkOrderPrintSheet._line)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _CheckBoxMark extends StatelessWidget {
  const _CheckBoxMark({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13,
      height: 13,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(border: Border.all(color: WorkOrderPrintSheet._line)),
      child: checked ? const Text('✓', style: TextStyle(fontSize: 11)) : null,
    );
  }
}

class _Signature extends StatelessWidget {
  const _Signature({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text('$label：');
  }
}

BoxDecoration _cellBorder() {
  return BoxDecoration(border: Border.all(color: WorkOrderPrintSheet._line));
}

class _PrintData {
  _PrintData(this.detail);

  final WorkOrderDetail detail;

  String get orderNumber => detail.orderNumber;
  String get orderDate => _date(detail.orderDate);
  String get deliveryDate => _date(detail.deliveryDate);
  String get customer => _text(detail.customerName);
  String get notes => _text(detail.notes);
  String get productName {
    final names = detail.products
        .map((item) => _text(item.productName))
        .where((item) => item != '-')
        .toList();
    return names.isEmpty ? '-' : names.join('、');
  }

  String get productSpec {
    final specs = detail.products
        .map((item) => _text(item.specification))
        .where((item) => item != '-')
        .toList();
    return specs.isEmpty ? '-' : specs.join('、');
  }

  String get quantity {
    final productQuantity = detail.products
        .map((item) => _formatNumber(item.quantity))
        .where((item) => item.isNotEmpty)
        .join('、');
    if (productQuantity.isNotEmpty) return productQuantity;
    return detail.productionQuantity?.toString() ?? '-';
  }

  String get colors {
    final parts = [
      detail.printingColorsDisplay,
      if (detail.printingOtherColors.isNotEmpty)
        detail.printingOtherColors.join('、'),
    ].where((item) => item != null && item.trim().isNotEmpty).join(' ');
    return parts.isEmpty ? '-' : parts;
  }

  String get paperName {
    final material = _paperMaterial;
    return _text(material?.materialName ?? material?.materialCode);
  }

  String get paperWeight {
    final material = _paperMaterial;
    final source = [
      material?.materialName,
      material?.materialSize,
      material?.notes,
    ].whereType<String>().join(' ');
    final match =
        RegExp(r'(\d{2,4})\s*g', caseSensitive: false).firstMatch(source);
    return match?.group(1) ?? '-';
  }

  String get paperInfo {
    final material = _paperMaterial;
    if (material == null) return '-';
    return [
      material.materialName,
      material.materialSize,
      material.materialUsage,
    ].where((item) => item != null && item.trim().isNotEmpty).join('\n');
  }

  String get dieText => _join(detail.dieCodes, detail.dieNames);
  String get foilingText =>
      _join(detail.foilingPlateCodes, detail.foilingPlateNames);
  String get embossingText =>
      _join(detail.embossingPlateCodes, detail.embossingPlateNames);

  bool get hasPrinting =>
      detail.printingType != null && detail.printingType != 'none';
  String get printingMachines =>
      detail.printingTypeDisplay ?? detail.printingType ?? '';

  WorkOrderMaterialItem? get _paperMaterial {
    for (final item in detail.materials) {
      final text = '${item.materialName ?? ''}${item.materialCode ?? ''}';
      if (text.contains('纸') || item.needCutting == true) return item;
    }
    return detail.materials.isEmpty ? null : detail.materials.first;
  }

  bool hasProcess(String keyword) {
    return detail.processes.any((item) {
      final name = '${item.processName ?? ''}${item.processCode ?? ''}';
      return name.contains(keyword);
    });
  }

  bool hasResource(String value) => value.trim().isNotEmpty && value != '-';

  static String _date(DateTime? value) {
    if (value == null) return '-';
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }

  static String _text(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? '-' : trimmed;
  }

  static String _formatNumber(double? value) {
    if (value == null) return '';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  static String _join(List<String> codes, List<String> names) {
    final values = <String>[
      ...codes.where((item) => item.trim().isNotEmpty),
      ...names.where((item) => item.trim().isNotEmpty),
    ];
    return values.isEmpty ? '-' : values.join('、');
  }
}

String buildWorkOrderPrintHtml(WorkOrderDetail detail) {
  final data = _PrintData(detail);
  String e(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
  String checked(bool value) => value ? '✓' : '';
  String row(String label, bool value, String remark) =>
      '<tr><td>$label</td><td class="mark">${checked(value)}</td><td>${e(remark)}</td></tr>';

  return '''
<style>
@page { size: A4 portrait; margin: 10mm; }
body { margin: 0; background: #fff; color: #1f281d; font-family: "Noto Sans SC", "Microsoft YaHei", sans-serif; }
.sheet { width: 188mm; margin: 0 auto; background: #fbf6b8; border: 1px solid #414b35; padding: 8mm; box-sizing: border-box; }
.top { display: flex; align-items: end; gap: 12px; margin-bottom: 5mm; }
.title { flex: 1; text-align: center; font-size: 22px; font-weight: 700; letter-spacing: 4px; }
.no { color: #a44331; font-weight: 700; }
.line { display: flex; gap: 12mm; margin-bottom: 2mm; }
.field { flex: 1; border-bottom: 1px solid #414b35; min-height: 8mm; }
.field b { font-weight: 400; margin-right: 2mm; }
.grid { display: grid; grid-template-columns: 1.12fr .88fr; }
table { border-collapse: collapse; width: 100%; table-layout: fixed; }
td, th { border: 1px solid #414b35; padding: 2mm; min-height: 8mm; vertical-align: middle; font-size: 12px; }
th { text-align: center; font-weight: 700; }
.label { width: 24mm; text-align: center; }
.notes { height: 42mm; vertical-align: top; }
.mark { width: 14mm; text-align: center; font-size: 16px; }
.bottom { display: grid; grid-template-columns: .9fr .62fr .48fr; }
.boxTitle { text-align: center; font-weight: 700; letter-spacing: 4px; height: 11mm; }
.boxBody { height: 32mm; text-align: center; white-space: pre-line; }
.sign { display: grid; grid-template-columns: repeat(4, 1fr); margin-top: 7mm; font-size: 13px; }
</style>
<main class="sheet">
  <div class="top"><div class="title">新西彩包装有限公司</div><div class="no">No:${e(data.orderNumber)}</div></div>
  <div class="line"><div class="field"><b>委印日期：</b>${e(data.orderDate)}</div><div class="field"><b>交货日期：</b>${e(data.deliveryDate)}</div></div>
  <div class="grid">
    <table>
      <tr><td class="label">委印单位</td><td>${e(data.customer)}</td></tr>
      <tr><td class="label">印件名称</td><td>${e(data.productName)}</td></tr>
      <tr><td class="label">数量</td><td>${e(data.quantity)}</td></tr>
      <tr><td class="label">单价</td><td>总价</td></tr>
      <tr><td class="label">机种</td><td>□ 四色机　□ 双色机　□ 单色机　□ 六开机</td></tr>
      <tr><td class="label">色数</td><td>${e(data.colors)}</td></tr>
      <tr><td class="label">说明</td><td class="notes">${e(data.notes)}</td></tr>
    </table>
    <table>
      <tr><th>施工内容</th><th class="mark"></th><th>机头数</th></tr>
      ${row('印刷', data.hasPrinting, data.printingMachines)}
      ${row('上油', data.hasProcess('上油'), '')}
      ${row('磨光', data.hasProcess('磨光'), '')}
      ${row('过胶', data.hasProcess('过胶') || data.hasProcess('覆膜'), '')}
      ${row('表坑', data.hasProcess('表坑'), '')}
      ${row('压凸', data.hasResource(data.embossingText), data.embossingText)}
      ${row('烫金银', data.hasResource(data.foilingText), data.foilingText)}
      ${row('模切', data.hasResource(data.dieText) || data.hasProcess('模切'), data.dieText)}
      ${row('糊盒', data.hasProcess('糊盒'), '')}
      ${row('糊窗口', data.hasProcess('糊窗口'), '')}
      ${row('切成品', data.hasProcess('切成品'), '')}
      ${row('包装', data.hasProcess('包装'), '')}
    </table>
  </div>
  <div class="bottom">
    <table><tr><td class="boxTitle">开 大 纸 图</td></tr><tr><td class="boxBody">${e(data.productSpec)}</td></tr></table>
    <table><tr><td class="boxTitle">印 刷 用 纸</td></tr><tr><td class="boxBody">${e(data.paperInfo)}</td></tr></table>
    <table>
      <tr><th colspan="2">切 纸 令 数</th></tr>
      <tr><td>纸类</td><td>${e(data.paperName)}</td></tr>
      <tr><td>克重</td><td>${e(data.paperWeight)}</td></tr>
      <tr><td>大纸数量</td><td></td></tr>
      <tr><td>印纸数量</td><td>${e(data.quantity)}</td></tr>
    </table>
  </div>
  <div class="sign"><span>制表：</span><span>施工员：</span><span>审核：</span><span>业务员：</span></div>
</main>
''';
}
