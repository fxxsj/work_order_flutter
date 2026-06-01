import 'package:work_order_app/src/core/utils/parse_utils.dart';

class TraceabilitySummaryItem {
  const TraceabilitySummaryItem({
    required this.number,
    this.id,
    this.statusDisplay,
    this.sourceLabel,
    this.batchNo,
  });

  final String number;
  final int? id;
  final String? statusDisplay;
  final String? sourceLabel;
  final String? batchNo;

  factory TraceabilitySummaryItem.fromJson(Map<String, dynamic> json) {
    return TraceabilitySummaryItem(
      number: toStringOrNull(json['number']) ?? '',
      id: toInt(json['id']),
      statusDisplay: toStringOrNull(json['status_display']),
      sourceLabel: toStringOrNull(json['source_label']),
      batchNo: toStringOrNull(json['batch_no']),
    );
  }

  static List<TraceabilitySummaryItem> parseList(dynamic value) {
    if (value is! List) return const [];
    final items = <TraceabilitySummaryItem>[];
    for (final item in value) {
      if (item is Map) {
        final summary = TraceabilitySummaryItem.fromJson(
          Map<String, dynamic>.from(item),
        );
        if (summary.number.trim().isNotEmpty) {
          items.add(summary);
        }
      }
    }
    return items;
  }
}
