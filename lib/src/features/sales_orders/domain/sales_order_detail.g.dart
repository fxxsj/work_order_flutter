// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesOrderDetailImpl _$$SalesOrderDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$SalesOrderDetailImpl(
      id: _intFromJson(json['id']),
      orderNumber: _stringFromJson(json['order_number']),
      customerId: _intOrNullFromJson(json['customer']),
      customerName: _stringOrNullFromJson(json['customer_name']),
      customerContact: _stringOrNullFromJson(json['customer_contact']),
      customerPhone: _stringOrNullFromJson(json['customer_phone']),
      customerAddress: _stringOrNullFromJson(json['customer_address']),
      contractNumber: _stringOrNullFromJson(json['contract_number']),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      approvalComment: _stringOrNullFromJson(json['approval_comment']),
      rejectionReason: _stringOrNullFromJson(json['rejection_reason']),
      paymentStatus: _stringOrNullFromJson(json['payment_status']),
      paymentStatusDisplay:
          _stringOrNullFromJson(json['payment_status_display']),
      orderDate: _dateTimeOrNullFromJson(json['order_date']),
      deliveryDate: _dateTimeOrNullFromJson(json['delivery_date']),
      actualDeliveryDate: _dateTimeOrNullFromJson(json['actual_delivery_date']),
      subtotal: _doubleOrNullFromJson(json['subtotal']),
      taxRate: _doubleOrNullFromJson(json['tax_rate']),
      taxAmount: _doubleOrNullFromJson(json['tax_amount']),
      discountAmount: _doubleOrNullFromJson(json['discount_amount']),
      totalAmount: _doubleOrNullFromJson(json['total_amount']),
      depositAmount: _doubleOrNullFromJson(json['deposit_amount']),
      paidAmount: _doubleOrNullFromJson(json['paid_amount']),
      paymentDate: _dateTimeOrNullFromJson(json['payment_date']),
      contactPerson: _stringOrNullFromJson(json['contact_person']),
      contactPhone: _stringOrNullFromJson(json['contact_phone']),
      shippingAddress: _stringOrNullFromJson(json['shipping_address']),
      notes: _stringOrNullFromJson(json['notes']),
      paymentCount: _intOrNullFromJson(json['payment_count']),
      pendingPaymentPlanCount:
          _intOrNullFromJson(json['pending_payment_plan_count']),
      pendingPaymentPlanAmount:
          _doubleOrNullFromJson(json['pending_payment_plan_amount']),
      unpaidAmount: _doubleOrNullFromJson(json['unpaid_amount']),
      workOrderNumbers: json['work_order_numbers'] == null
          ? const <String>[]
          : _stringListFromJson(json['work_order_numbers']),
      deliveryOrderNumbers: json['delivery_order_numbers'] == null
          ? const <String>[]
          : _stringListFromJson(json['delivery_order_numbers']),
      invoiceNumbers: json['invoice_numbers'] == null
          ? const <String>[]
          : _stringListFromJson(json['invoice_numbers']),
      workOrderSummaries:
          _readWorkOrderSummaries(json, 'work_order_summaries') == null
              ? const <TraceabilitySummaryItem>[]
              : _traceabilitySummaryListFromJson(
                  _readWorkOrderSummaries(json, 'work_order_summaries')),
      deliveryOrderSummaries: _readDeliveryOrderSummaries(
                  json, 'delivery_order_summaries') ==
              null
          ? const <TraceabilitySummaryItem>[]
          : _traceabilitySummaryListFromJson(
              _readDeliveryOrderSummaries(json, 'delivery_order_summaries')),
      invoiceSummaries: _readInvoiceSummaries(json, 'invoice_summaries') == null
          ? const <TraceabilitySummaryItem>[]
          : _traceabilitySummaryListFromJson(
              _readInvoiceSummaries(json, 'invoice_summaries')),
      items: json['items'] == null
          ? const <SalesOrderItem>[]
          : _salesOrderItemListFromJson(json['items']),
    );

Map<String, dynamic> _$$SalesOrderDetailImplToJson(
        _$SalesOrderDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'customer': instance.customerId,
      'customer_name': instance.customerName,
      'customer_contact': instance.customerContact,
      'customer_phone': instance.customerPhone,
      'customer_address': instance.customerAddress,
      'contract_number': instance.contractNumber,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'approval_comment': instance.approvalComment,
      'rejection_reason': instance.rejectionReason,
      'payment_status': instance.paymentStatus,
      'payment_status_display': instance.paymentStatusDisplay,
      'order_date': instance.orderDate?.toIso8601String(),
      'delivery_date': instance.deliveryDate?.toIso8601String(),
      'actual_delivery_date': instance.actualDeliveryDate?.toIso8601String(),
      'subtotal': instance.subtotal,
      'tax_rate': instance.taxRate,
      'tax_amount': instance.taxAmount,
      'discount_amount': instance.discountAmount,
      'total_amount': instance.totalAmount,
      'deposit_amount': instance.depositAmount,
      'paid_amount': instance.paidAmount,
      'payment_date': instance.paymentDate?.toIso8601String(),
      'contact_person': instance.contactPerson,
      'contact_phone': instance.contactPhone,
      'shipping_address': instance.shippingAddress,
      'notes': instance.notes,
      'payment_count': instance.paymentCount,
      'pending_payment_plan_count': instance.pendingPaymentPlanCount,
      'pending_payment_plan_amount': instance.pendingPaymentPlanAmount,
      'unpaid_amount': instance.unpaidAmount,
      'work_order_numbers': instance.workOrderNumbers,
      'delivery_order_numbers': instance.deliveryOrderNumbers,
      'invoice_numbers': instance.invoiceNumbers,
      'work_order_summaries':
          _traceabilitySummaryListToJson(instance.workOrderSummaries),
      'delivery_order_summaries':
          _traceabilitySummaryListToJson(instance.deliveryOrderSummaries),
      'invoice_summaries':
          _traceabilitySummaryListToJson(instance.invoiceSummaries),
      'items': instance.items,
    };

_$SalesOrderItemImpl _$$SalesOrderItemImplFromJson(Map<String, dynamic> json) =>
    _$SalesOrderItemImpl(
      id: _intFromJson(json['id']),
      productId: _intOrNullFromJson(json['product']),
      productName: _stringOrNullFromJson(json['product_name']),
      productCode: _stringOrNullFromJson(json['product_code']),
      quantity: _intOrNullFromJson(json['quantity']),
      deliveredQuantity: _doubleOrNullFromJson(json['delivered_quantity']),
      unit: _stringOrNullFromJson(json['unit']),
      unitPrice: _doubleOrNullFromJson(json['unit_price']),
      taxRate: _doubleOrNullFromJson(json['tax_rate']),
      discountAmount: _doubleOrNullFromJson(json['discount_amount']),
      subtotal: _doubleOrNullFromJson(json['subtotal']),
      notes: _stringOrNullFromJson(json['notes']),
    );

Map<String, dynamic> _$$SalesOrderItemImplToJson(
        _$SalesOrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.productId,
      'product_name': instance.productName,
      'product_code': instance.productCode,
      'quantity': instance.quantity,
      'delivered_quantity': instance.deliveredQuantity,
      'unit': instance.unit,
      'unit_price': instance.unitPrice,
      'tax_rate': instance.taxRate,
      'discount_amount': instance.discountAmount,
      'subtotal': instance.subtotal,
      'notes': instance.notes,
    };
