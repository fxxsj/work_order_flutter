import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/attachment_open_button.dart';
import 'package:work_order_app/src/core/utils/file_link_util.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/detail_sections/work_order_detail_types.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/detail_sections/work_order_description_cell.dart';

/// Summary content widget for work order details.
class SummaryContent extends StatelessWidget {
  const SummaryContent({
    required this.detail,
    required this.sectionSpacing,
    required this.emptyText,
    required this.actionLoading,
    required this.onUploadDesignFile,
  });

  final WorkOrderDetail detail;
  final double sectionSpacing;
  final String emptyText;
  final bool actionLoading;
  final VoidCallback? onUploadDesignFile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final dividerColor = colors?.borderColor.withValues(
      alpha: OpacityTokens.heavy,
    );
    final showPrinting =
        detail.printingType != null && detail.printingType != 'none';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 基本信息描述列表
        _buildDescriptionGrid(context, [
          DescItem('客户', detail.customerName ?? emptyText),
          DescItem('业务员', detail.salespersonName ?? emptyText),
          DescItem('负责人', detail.managerName ?? emptyText),
          DescItem('创建人', detail.createdByName ?? emptyText),
          DescItem('审核人', detail.approvedByName ?? emptyText),
          DescItem(
            '状态',
            detail.statusDisplay ?? detail.status ?? emptyText,
            isStatus: true,
            statusType: 'status',
            statusValue: detail.status,
          ),
          DescItem(
            '审核状态',
            detail.approvalStatusDisplay ?? detail.approvalStatus ?? emptyText,
            isStatus: true,
            statusType: 'approval',
            statusValue: detail.approvalStatus,
          ),
          DescItem(
            '优先级',
            detail.priorityDisplay ?? detail.priority ?? emptyText,
            isStatus: true,
            statusType: 'priority',
            statusValue: detail.priority,
          ),
          DescItem(
            '进度',
            '${detail.progressPercentage ?? 0}%',
            isProgress: true,
            progressValue: (detail.progressPercentage ?? 0).toDouble(),
          ),
          DescItem('下单日期', _formatDate(detail.orderDate)),
          DescItem('交货日期', _formatDate(detail.deliveryDate)),
          DescItem('实际交货', _formatDate(detail.actualDeliveryDate)),
          DescItem('生产数量', detail.productionQuantity?.toString() ?? emptyText),
          DescItem('不良数量', detail.defectiveQuantity?.toString() ?? emptyText),
          DescItem(
            '总金额',
            detail.totalAmount == null
                ? emptyText
                : '¥${detail.totalAmount!.toStringAsFixed(2)}',
          ),
          DescItem('任务数', detail.totalTaskCount?.toString() ?? emptyText),
          DescItem(
            '印刷形式',
            detail.printingTypeDisplay ?? detail.printingType ?? emptyText,
          ),
          DescItem('印刷色数', detail.printingColorsDisplay ?? emptyText),
          DescItem('审批说明', detail.approvalComment ?? emptyText, spanFull: true),
        ]),
        SizedBox(height: sectionSpacing),
        Divider(height: sectionSpacing, color: dividerColor),
        SizedBox(height: sectionSpacing),

        // 图稿和版信息
        Text(
          '图稿和版信息',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors?.sidebarText,
          ),
        ),
        SizedBox(height: SpacingTokens.sm),
        _buildDescriptionGrid(context, [
          DescItem(
            '图稿（CTP版）',
            _joinResourceItems(detail.artworkCodes, detail.artworkNames),
          ),
          if (showPrinting)
            DescItem(
              '印刷要求',
              [
                detail.printingColorsDisplay,
                detail.printingTypeDisplay ?? detail.printingType,
              ].where((s) => s != null && s.isNotEmpty).join(' '),
            ),
          DescItem('刀模', _joinResourceItems(detail.dieCodes, detail.dieNames)),
          DescItem(
            '烫金版',
            _joinResourceItems(
              detail.foilingPlateCodes,
              detail.foilingPlateNames,
            ),
          ),
          DescItem(
            '压凸版',
            _joinResourceItems(
              detail.embossingPlateCodes,
              detail.embossingPlateNames,
            ),
          ),
        ]),
        SizedBox(height: sectionSpacing),
        Divider(height: sectionSpacing, color: dividerColor),
        SizedBox(height: sectionSpacing),

        // 设计文件
        if (_hasDesignFile) ...[
          Wrap(
            spacing: SpacingTokens.sm,
            runSpacing: SpacingTokens.sm,
            children: [
              AttachmentOpenButton(
                fileUrl: detail.designFileUrl,
                label: '查看设计文件',
                errorPrefix: '打开设计文件失败',
              ),
              if (onUploadDesignFile != null)
                OutlinedButton.icon(
                  onPressed: actionLoading ? null : onUploadDesignFile,
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
                  label: const Text('重新上传'),
                ),
            ],
          ),
          SizedBox(height: sectionSpacing),
        ] else if (onUploadDesignFile != null) ...[
          OutlinedButton.icon(
            onPressed: actionLoading ? null : onUploadDesignFile,
            icon: const Icon(Icons.upload_file_outlined, size: 18),
            label: const Text('上传设计文件'),
          ),
          SizedBox(height: sectionSpacing),
        ],

        // 备注
        _buildDescriptionGrid(context, [
          DescItem('备注', detail.notes ?? emptyText, spanFull: true),
        ]),
      ],
    );
  }

  Widget _buildDescriptionGrid(BuildContext context, List<DescItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final columns = maxWidth < Breakpoints.sm
            ? 1
            : maxWidth < Breakpoints.lg
            ? 2
            : 3;
        final rows = <Widget>[];
        for (var i = 0; i < items.length;) {
          final rowItems = <DescItem>[];
          var rowSpan = 0;
          while (i < items.length && rowSpan < columns) {
            final item = items[i];
            if (item.spanFull && rowSpan > 0) break;
            rowItems.add(item);
            rowSpan += item.spanFull ? columns : 1;
            i++;
          }
          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rowItems.map((item) {
                final flex = item.spanFull ? columns : 1;
                return Expanded(
                  flex: flex,
                  child: DescriptionCell(
                    label: item.label,
                    value: item.value,
                    isStatus: item.isStatus,
                    statusType: item.statusType,
                    statusValue: item.statusValue,
                    isProgress: item.isProgress,
                    progressValue: item.progressValue,
                  ),
                );
              }).toList(),
            ),
          );
        }
        return Column(children: rows);
      },
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) return emptyText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  bool get _hasDesignFile {
    return FileLinkUtil.hasLink(detail.designFileUrl);
  }

  String _joinResourceItems(List<String> codes, List<String> names) {
    if (codes.isEmpty && names.isEmpty) return emptyText;
    if (codes.isEmpty) return names.join('、');
    if (names.isEmpty) return codes.join('、');
    final parts = <String>[];
    for (var i = 0; i < codes.length; i++) {
      final name = i < names.length ? names[i] : '';
      parts.add(name.isNotEmpty ? '${codes[i]} - $name' : codes[i]);
    }
    return parts.join('、');
  }
}
