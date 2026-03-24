import 'package:work_order_app/src/core/utils/parse_utils.dart';

class DeliveryOrderDetail {
  const DeliveryOrderDetail({
    required this.id,
    required this.orderNumber,
    this.salesOrderId,
    this.salesOrderNumber,
    this.customerId,
    this.customerName,
    this.status,
    this.statusDisplay,
    this.deliveryDate,
    this.receiverName,
    this.receiverPhone,
    this.deliveryAddress,
    this.logisticsCompany,
    this.trackingNumber,
    this.freight,
    this.packageCount,
    this.packageWeight,
    this.receivedDate,
    this.receivedNotes,
    this.receiverSignatureUrl,
    this.notes,
    this.items = const [],
  });

  final int id;
  final String orderNumber;
  final int? salesOrderId;
  final String? salesOrderNumber;
  final int? customerId;
  final String? customerName;
  final String? status;
  final String? statusDisplay;
  final DateTime? deliveryDate;
  final String? receiverName;
  final String? receiverPhone;
  final String? deliveryAddress;
  final String? logisticsCompany;
  final String? trackingNumber;
  final double? freight;
  final int? packageCount;
  final double? packageWeight;
  final DateTime? receivedDate;
  final String? receivedNotes;
  final String? receiverSignatureUrl;
  final String? notes;
  final List<DeliveryOrderItem> items;

  factory DeliveryOrderDetail.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderDetail(
      id: toInt(json['id']) ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      salesOrderId: toInt(json['sales_order']),
      salesOrderNumber: toStringOrNull(json['sales_order_number']),
      customerId: toInt(json['customer']),
      customerName: toStringOrNull(json['customer_name']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      deliveryDate: toDateTime(json['delivery_date']),
      receiverName: toStringOrNull(json['receiver_name']),
      receiverPhone: toStringOrNull(json['receiver_phone']),
      deliveryAddress: toStringOrNull(json['delivery_address']),
      logisticsCompany: toStringOrNull(json['logistics_company']),
      trackingNumber: toStringOrNull(json['tracking_number']),
      freight: _toDouble(json['freight']),
      packageCount: toInt(json['package_count']),
      packageWeight: _toDouble(json['package_weight']),
      receivedDate: toDateTime(json['received_date']),
      receivedNotes: toStringOrNull(json['received_notes']),
      receiverSignatureUrl: toStringOrNull(json['receiver_signature']),
      notes: toStringOrNull(json['notes']),
      items: _parseItems(json['items']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static List<DeliveryOrderItem> _parseItems(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) =>
            DeliveryOrderItem.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}

class DeliveryOrderItem {
  const DeliveryOrderItem({
    required this.id,
    this.productId,
    this.productName,
    this.productCode,
    this.quantity,
    this.unit,
    this.unitPrice,
    this.subtotal,
    this.stockBatch,
    this.notes,
  });

  final int id;
  final int? productId;
  final String? productName;
  final String? productCode;
  final double? quantity;
  final String? unit;
  final double? unitPrice;
  final double? subtotal;
  final String? stockBatch;
  final String? notes;

  factory DeliveryOrderItem.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderItem(
      id: toInt(json['id']) ?? 0,
      productId: toInt(json['product']),
      productName: toStringOrNull(json['product_name']),
      productCode: toStringOrNull(json['product_code']),
      quantity: _toDouble(json['quantity']),
      unit: toStringOrNull(json['unit']),
      unitPrice: _toDouble(json['unit_price']),
      subtotal: _toDouble(json['subtotal']),
      stockBatch: toStringOrNull(json['stock_batch']),
      notes: toStringOrNull(json['notes']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
