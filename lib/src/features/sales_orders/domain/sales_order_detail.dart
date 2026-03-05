import 'package:work_order_app/src/core/utils/parse_utils.dart';

class SalesOrderDetail {
  const SalesOrderDetail({
    required this.id,
    required this.orderNumber,
    this.customerId,
    this.customerName,
    this.customerContact,
    this.customerPhone,
    this.customerAddress,
    this.status,
    this.statusDisplay,
    this.paymentStatus,
    this.paymentStatusDisplay,
    this.orderDate,
    this.deliveryDate,
    this.actualDeliveryDate,
    this.subtotal,
    this.taxRate,
    this.taxAmount,
    this.discountAmount,
    this.totalAmount,
    this.depositAmount,
    this.paidAmount,
    this.paymentDate,
    this.contactPerson,
    this.contactPhone,
    this.shippingAddress,
    this.notes,
    this.workOrderNumbers = const [],
    this.items = const [],
  });

  final int id;
  final String orderNumber;
  final int? customerId;
  final String? customerName;
  final String? customerContact;
  final String? customerPhone;
  final String? customerAddress;
  final String? status;
  final String? statusDisplay;
  final String? paymentStatus;
  final String? paymentStatusDisplay;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final DateTime? actualDeliveryDate;
  final double? subtotal;
  final double? taxRate;
  final double? taxAmount;
  final double? discountAmount;
  final double? totalAmount;
  final double? depositAmount;
  final double? paidAmount;
  final DateTime? paymentDate;
  final String? contactPerson;
  final String? contactPhone;
  final String? shippingAddress;
  final String? notes;
  final List<String> workOrderNumbers;
  final List<SalesOrderItem> items;

  factory SalesOrderDetail.fromJson(Map<String, dynamic> json) {
    return SalesOrderDetail(
      id: toInt(json['id']) ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      customerId: toInt(json['customer']),
      customerName: toStringOrNull(json['customer_name']),
      customerContact: toStringOrNull(json['customer_contact']),
      customerPhone: toStringOrNull(json['customer_phone']),
      customerAddress: toStringOrNull(json['customer_address']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      paymentStatus: toStringOrNull(json['payment_status']),
      paymentStatusDisplay: toStringOrNull(json['payment_status_display']),
      orderDate: toDateTime(json['order_date']),
      deliveryDate: toDateTime(json['delivery_date']),
      actualDeliveryDate: toDateTime(json['actual_delivery_date']),
      subtotal: _toDouble(json['subtotal']),
      taxRate: _toDouble(json['tax_rate']),
      taxAmount: _toDouble(json['tax_amount']),
      discountAmount: _toDouble(json['discount_amount']),
      totalAmount: _toDouble(json['total_amount']),
      depositAmount: _toDouble(json['deposit_amount']),
      paidAmount: _toDouble(json['paid_amount']),
      paymentDate: toDateTime(json['payment_date']),
      contactPerson: toStringOrNull(json['contact_person']),
      contactPhone: toStringOrNull(json['contact_phone']),
      shippingAddress: toStringOrNull(json['shipping_address']),
      notes: toStringOrNull(json['notes']),
      workOrderNumbers: _parseStringList(json['work_order_numbers']),
      items: _parseItems(json['items']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) => item.toString()).toList();
  }

  static List<SalesOrderItem> _parseItems(dynamic value) {
    if (value is! List) return const [];
    final items = <SalesOrderItem>[];
    for (final item in value) {
      if (item is Map) {
        items.add(SalesOrderItem.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return items;
  }
}

class SalesOrderItem {
  const SalesOrderItem({
    required this.id,
    this.productId,
    this.productName,
    this.productCode,
    this.quantity,
    this.deliveredQuantity,
    this.unit,
    this.unitPrice,
    this.taxRate,
    this.discountAmount,
    this.subtotal,
    this.notes,
  });

  final int id;
  final int? productId;
  final String? productName;
  final String? productCode;
  final int? quantity;
  final double? deliveredQuantity;
  final String? unit;
  final double? unitPrice;
  final double? taxRate;
  final double? discountAmount;
  final double? subtotal;
  final String? notes;

  factory SalesOrderItem.fromJson(Map<String, dynamic> json) {
    return SalesOrderItem(
      id: toInt(json['id']) ?? 0,
      productId: toInt(json['product']),
      productName: toStringOrNull(json['product_name']),
      productCode: toStringOrNull(json['product_code']),
      quantity: toInt(json['quantity']),
      deliveredQuantity: SalesOrderDetail._toDouble(json['delivered_quantity']),
      unit: toStringOrNull(json['unit']),
      unitPrice: SalesOrderDetail._toDouble(json['unit_price']),
      taxRate: SalesOrderDetail._toDouble(json['tax_rate']),
      discountAmount: SalesOrderDetail._toDouble(json['discount_amount']),
      subtotal: SalesOrderDetail._toDouble(json['subtotal']),
      notes: toStringOrNull(json['notes']),
    );
  }
}
