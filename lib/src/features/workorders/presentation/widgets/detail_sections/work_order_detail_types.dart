/// Info item for work order details.
class WorkOrderInfoItem {
  const WorkOrderInfoItem(this.label, this.value);

  final String label;
  final String value;
}

/// Description item for detail grids.
class DescItem {
  const DescItem(
    this.label,
    this.value, {
    this.isStatus = false,
    this.statusType,
    this.statusValue,
    this.isProgress = false,
    this.progressValue,
    this.spanFull = false,
  });

  final String label;
  final String value;
  final bool isStatus;
  final String? statusType;
  final String? statusValue;
  final bool isProgress;
  final double? progressValue;
  final bool spanFull;
}
