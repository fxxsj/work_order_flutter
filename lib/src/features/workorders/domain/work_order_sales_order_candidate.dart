class WorkOrderSalesOrderCandidate {
  const WorkOrderSalesOrderCandidate({
    required this.id,
    required this.orderNumber,
    this.customerId,
    this.customerName,
    this.status,
    this.statusDisplay,
    this.orderDate,
    this.deliveryDate,
    this.availableProducts = const [],
  });

  final int id;
  final String orderNumber;
  final int? customerId;
  final String? customerName;
  final String? status;
  final String? statusDisplay;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final List<WorkOrderSalesOrderCandidateProduct> availableProducts;

  Set<int> get availableProductIds => availableProducts
      .map((item) => item.productId)
      .where((item) => item > 0)
      .toSet();

  factory WorkOrderSalesOrderCandidate.fromJson(Map<String, dynamic> json) {
    final products = json['available_products'];
    return WorkOrderSalesOrderCandidate(
      id: _toInt(json['id']),
      orderNumber: json['order_number']?.toString() ?? '',
      customerId: _toNullableInt(json['customer']),
      customerName: _toNullableString(json['customer_name']),
      status: _toNullableString(json['status']),
      statusDisplay: _toNullableString(json['status_display']),
      orderDate: _toNullableDateTime(json['order_date']),
      deliveryDate: _toNullableDateTime(json['delivery_date']),
      availableProducts: products is List
          ? products
                .whereType<Map>()
                .map(
                  (item) => WorkOrderSalesOrderCandidateProduct.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false)
          : const [],
    );
  }
}

class WorkOrderSalesOrderCandidateProduct {
  const WorkOrderSalesOrderCandidateProduct({
    required this.productId,
    this.salesOrderItemId,
    this.productName,
    this.productCode,
    this.quantity,
    this.allocatedQuantity,
    this.remainingQuantity,
    this.unit,
  });

  final int productId;
  final int? salesOrderItemId;
  final String? productName;
  final String? productCode;
  final int? quantity;
  final int? allocatedQuantity;
  final int? remainingQuantity;
  final String? unit;

  factory WorkOrderSalesOrderCandidateProduct.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkOrderSalesOrderCandidateProduct(
      productId: _toInt(json['product_id']),
      salesOrderItemId: _toNullableInt(json['sales_order_item_id']),
      productName: _toNullableString(json['product_name']),
      productCode: _toNullableString(json['product_code']),
      quantity: _toNullableInt(json['quantity']),
      allocatedQuantity: _toNullableInt(json['allocated_quantity']),
      remainingQuantity: _toNullableInt(json['remaining_quantity']),
      unit: _toNullableString(json['unit']),
    );
  }
}

int _toInt(dynamic value) => _toNullableInt(value) ?? 0;

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

String? _toNullableString(dynamic value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

DateTime? _toNullableDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
