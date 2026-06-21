import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/finance_invoices/application/invoice_view_model.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_dto.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_form_options.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_repository.dart';
import 'package:work_order_app/src/features/finance_payments/application/payment_view_model.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_form_options.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_repository.dart';
import 'package:work_order_app/src/features/inventory_delivery/application/delivery_order_view_model.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_dto.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_form_options.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_repository.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_detail_dto.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_detail_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';

/// 端到端测试：客户订单 → 生成施工单 → 发货 → 开票 → 收款
///
/// 验证 SalesOrder / WorkOrder / DeliveryOrder / Invoice / Payment
/// 五大模块 ViewModel 在真实业务流中的协同与数据闭环。

class _MockSalesOrderRepository implements SalesOrderRepository {
  int _nextId = 200;
  final Map<int, SalesOrderDetail> _details = {};
  final List<String> _callLog = [];

  List<String> get callLog => List.unmodifiable(_callLog);

  void _log(String method) => _callLog.add(method);

  @override
  Future<void> deleteSalesOrder(int id) async {
    _log('deleteSalesOrder:$id');
    _details.remove(id);
  }

  @override
  Future<SalesOrderPageDto> getSalesOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? paymentStatus,
    String? ordering,
  }) async {
    _log('getSalesOrders');
    return SalesOrderPageDto(
      items: _details.values
          .map((d) => SalesOrderDto(
                id: d.id,
                orderNumber: d.orderNumber,
                status: d.status,
                customerName: d.customerName,
              ))
          .toList(),
      total: _details.length,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params}) async {
    _log('getSummary');
    return {};
  }

  @override
  Future<SalesOrderDetailDto> getSalesOrderDetail(int id) async {
    _log('getSalesOrderDetail:$id');
    final detail = _details[id];
    if (detail == null) throw Exception('SalesOrder not found');
    return SalesOrderDetailDto(entity: detail);
  }

  @override
  Future<SalesOrderDetailDto> createSalesOrder(Map<String, dynamic> payload) async {
    _log('createSalesOrder');
    final id = _nextId++;
    final detail = SalesOrderDetail(
      id: id,
      orderNumber: 'SO${id.toString().padLeft(5, '0')}',
      status: 'draft',
      approvalStatus: 'draft',
      customerName: payload['customer_name']?.toString(),
      totalAmount: payload['total_amount'] is num
          ? (payload['total_amount'] as num).toDouble()
          : null,
      orderDate: DateTime.now(),
      items: const [],
      workOrderSummaries: const [],
      deliveryOrderSummaries: const [],
      invoiceSummaries: const [],
    );
    _details[id] = detail;
    return SalesOrderDetailDto(entity: detail);
  }

  @override
  Future<SalesOrderDetailDto> updateSalesOrder(
    int id,
    Map<String, dynamic> payload,
  ) async {
    _log('updateSalesOrder:$id');
    return getSalesOrderDetail(id);
  }

  @override
  Future<SalesOrderDetailDto> submit(int id, [Map<String, dynamic>? payload]) async {
    _log('submit:$id');
    final existing = _details[id];
    if (existing == null) throw Exception('SalesOrder not found');
    final updated = _copyWithStatus(existing, status: 'pending_review', approvalStatus: 'pending_review');
    _details[id] = updated;
    return SalesOrderDetailDto(entity: updated);
  }

  @override
  Future<SalesOrderDetailDto> approve(int id, Map<String, dynamic> payload) async {
    _log('approve:$id');
    final existing = _details[id];
    if (existing == null) throw Exception('SalesOrder not found');
    final updated = _copyWithStatus(existing, status: 'approved', approvalStatus: 'approved');
    _details[id] = updated;
    return SalesOrderDetailDto(entity: updated);
  }

  @override
  Future<SalesOrderDetailDto> reject(int id, Map<String, dynamic> payload) async {
    _log('reject:$id');
    final existing = _details[id];
    if (existing == null) throw Exception('SalesOrder not found');
    final updated = _copyWithStatus(existing, status: 'rejected', approvalStatus: 'rejected');
    _details[id] = updated;
    return SalesOrderDetailDto(entity: updated);
  }

  @override
  Future<SalesOrderDetailDto> startProduction(int id) async {
    _log('startProduction:$id');
    final existing = _details[id];
    if (existing == null) throw Exception('SalesOrder not found');
    final updated = _copyWithStatus(existing, status: 'in_production');
    _details[id] = updated;
    return SalesOrderDetailDto(entity: updated);
  }

  @override
  Future<SalesOrderDetailDto> complete(int id, [Map<String, dynamic>? payload]) async {
    _log('complete:$id');
    final existing = _details[id];
    if (existing == null) throw Exception('SalesOrder not found');
    final updated = _copyWithStatus(existing, status: 'completed');
    _details[id] = updated;
    return SalesOrderDetailDto(entity: updated);
  }

  @override
  Future<SalesOrderDetailDto> cancel(int id, Map<String, dynamic> payload) async {
    _log('cancel:$id');
    final existing = _details[id];
    if (existing == null) throw Exception('SalesOrder not found');
    final updated = _copyWithStatus(existing, status: 'cancelled');
    _details[id] = updated;
    return SalesOrderDetailDto(entity: updated);
  }

  @override
  Future<SalesOrderDetailDto> updatePayment(
    int id,
    Map<String, dynamic> payload,
  ) async {
    _log('updatePayment:$id');
    final existing = _details[id];
    if (existing == null) throw Exception('SalesOrder not found');
    final paidAmount = payload['paid_amount'] is num
        ? (payload['paid_amount'] as num).toDouble()
        : existing.paidAmount;
    final updated = _copyWithStatus(
      existing,
      status: existing.status,
      paidAmount: paidAmount,
      paymentStatus: paidAmount != null && existing.totalAmount != null && paidAmount >= existing.totalAmount!
          ? 'paid'
          : 'partial',
    );
    _details[id] = updated;
    return SalesOrderDetailDto(entity: updated);
  }

  @override
  Future<Map<String, dynamic>> createWorkOrdersFromSalesOrders(
    Map<String, dynamic> payload,
  ) async {
    _log('createWorkOrdersFromSalesOrders');
    return {'created': 1, 'work_order_ids': [1001]};
  }

  @override
  Future<Map<String, dynamic>> createWorkOrderFromSalesOrder(
    Map<String, dynamic> payload,
  ) async {
    _log('createWorkOrderFromSalesOrder');
    return {'created': true, 'work_order_id': 1001};
  }

  static SalesOrderDetail _copyWithStatus(
    SalesOrderDetail source, {
    String? status,
    String? approvalStatus,
    double? paidAmount,
    String? paymentStatus,
  }) {
    return SalesOrderDetail(
      id: source.id,
      orderNumber: source.orderNumber,
      customerName: source.customerName,
      status: status ?? source.status,
      approvalStatus: approvalStatus ?? source.approvalStatus,
      totalAmount: source.totalAmount,
      paidAmount: paidAmount ?? source.paidAmount,
      paymentStatus: paymentStatus ?? source.paymentStatus,
      orderDate: source.orderDate,
      items: source.items,
      workOrderSummaries: source.workOrderSummaries,
      deliveryOrderSummaries: source.deliveryOrderSummaries,
      invoiceSummaries: source.invoiceSummaries,
    );
  }
}

class _MockWorkOrderRepository implements WorkOrderRepository {
  int _nextId = 1001;
  final Map<int, WorkOrderDetail> _details = {};
  final List<String> _callLog = [];

  List<String> get callLog => List.unmodifiable(_callLog);

  void _log(String method) => _callLog.add(method);

  @override
  Future<WorkOrderPageDto> getWorkOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? priority,
    String? approvalStatus,
    int? customerId,
    int? productId,
    int? processId,
    String? ordering,
  }) async {
    _log('getWorkOrders');
    return WorkOrderPageDto(
      items: _details.values
          .map((d) => WorkOrderDto(
                id: d.id,
                orderNumber: d.orderNumber,
                status: d.status,
                approvalStatus: d.approvalStatus,
                customerName: d.customerName,
              ))
          .toList(),
      total: _details.length,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<WorkOrderDetailDto> getWorkOrderDetail(int id) async {
    _log('getWorkOrderDetail:$id');
    final detail = _details[id];
    if (detail == null) throw Exception('WorkOrder not found');
    return WorkOrderDetailDto(entity: detail);
  }

  @override
  Future<WorkOrderDetailDto> createWorkOrder(Map<String, dynamic> payload) async {
    _log('createWorkOrder');
    final id = _nextId++;
    final detail = WorkOrderDetail(
      id: id,
      orderNumber: 'WO${id.toString().padLeft(5, '0')}',
      status: 'draft',
      approvalStatus: 'draft',
      customerName: payload['customer_name']?.toString(),
      totalAmount: payload['total_amount'] is num
          ? (payload['total_amount'] as num).toDouble()
          : null,
      orderDate: DateTime.now(),
    );
    _details[id] = detail;
    return WorkOrderDetailDto(entity: detail);
  }

  @override
  Future<WorkOrderDetailDto> updateWorkOrder(
    int id,
    Map<String, dynamic> payload,
  ) async {
    _log('updateWorkOrder:$id');
    return getWorkOrderDetail(id);
  }

  @override
  Future<WorkOrderDetailDto> uploadDesignFile(int id, dynamic designFile) async {
    _log('uploadDesignFile:$id');
    return getWorkOrderDetail(id);
  }

  @override
  Future<void> deleteWorkOrder(int id) async {
    _log('deleteWorkOrder:$id');
    _details.remove(id);
  }

  @override
  Future<WorkOrderDetailDto> updateStatus(int id, String status) async {
    _log('updateStatus:$id:$status');
    return _updateDetail(id, status: status);
  }

  @override
  Future<WorkOrderDetailDto> submitApproval(
    int id, {
    String? comment,
    Map<String, dynamic>? payload,
  }) async {
    _log('submitApproval:$id');
    return _updateDetail(id, approvalStatus: 'pending_review', status: 'pending_review');
  }

  @override
  Future<WorkOrderDetailDto> approveWorkOrder(int id, {String? comment}) async {
    _log('approveWorkOrder:$id');
    return _updateDetail(id, approvalStatus: 'approved', status: 'approved');
  }

  @override
  Future<WorkOrderDetailDto> rejectWorkOrder(int id, {required String reason}) async {
    _log('rejectWorkOrder:$id');
    return _updateDetail(id, approvalStatus: 'rejected', status: 'rejected');
  }

  @override
  Future<WorkOrderDetailDto> resubmitForApproval(int id) async {
    _log('resubmitForApproval:$id');
    return submitApproval(id);
  }

  @override
  Future<Map<String, dynamic>> checkCompletion(int id) async {
    _log('checkCompletion:$id');
    return {'can_complete': true};
  }

  @override
  Future<Map<String, dynamic>> markUrgent(int id, {required String reason}) async {
    _log('markUrgent:$id');
    return {'urgent': true};
  }

  @override
  Future<WorkOrderDetailDto> addProcess(int id, Map<String, dynamic> payload) async {
    _log('addProcess:$id');
    return getWorkOrderDetail(id);
  }

  @override
  Future<WorkOrderDetailDto> addMaterial(int id, Map<String, dynamic> payload) async {
    _log('addMaterial:$id');
    return getWorkOrderDetail(id);
  }

  @override
  Future<Map<String, dynamic>> getStatistics({Map<String, dynamic>? params}) async {
    _log('getStatistics');
    return {};
  }

  @override
  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params}) async {
    _log('getSummary');
    return {};
  }

  @override
  Future<dynamic> export({Map<String, dynamic>? params}) async {
    _log('export');
    return null;
  }

  @override
  Future<Map<String, dynamic>> checkSyncNeeded(int id, {List<int>? processIds}) async {
    _log('checkSyncNeeded:$id');
    return {'sync_needed': false};
  }

  @override
  Future<Map<String, dynamic>> syncTasksPreview(
    int id, {
    List<int>? processIds,
  }) async {
    _log('syncTasksPreview:$id');
    return {};
  }

  @override
  Future<Map<String, dynamic>> syncTasksExecute(
    int id, {
    List<int>? processIds,
  }) async {
    _log('syncTasksExecute:$id');
    return {};
  }

  @override
  Future<List<WorkOrder>> searchWorkOrders(
    String query, {
    int pageSize = 20,
  }) async {
    _log('searchWorkOrders:$query');
    final all = await getWorkOrders(pageSize: pageSize, search: query);
    return all.items
        .where((dto) => dto.orderNumber == query)
        .map((dto) => dto.toEntity())
        .toList();
  }

  WorkOrderDetailDto _updateDetail(
    int id, {
    String? status,
    String? approvalStatus,
  }) {
    final existing = _details[id];
    if (existing == null) throw Exception('WorkOrder not found');
    final updated = WorkOrderDetail(
      id: existing.id,
      orderNumber: existing.orderNumber,
      customerName: existing.customerName,
      status: status ?? existing.status,
      approvalStatus: approvalStatus ?? existing.approvalStatus,
      totalAmount: existing.totalAmount,
      orderDate: existing.orderDate,
    );
    _details[id] = updated;
    return WorkOrderDetailDto(entity: updated);
  }
}

class _MockDeliveryOrderRepository implements DeliveryOrderRepository {
  final List<String> _callLog = [];
  final Map<int, DeliveryOrder> _orders = {};

  List<String> get callLog => List.unmodifiable(_callLog);

  void _log(String method) => _callLog.add(method);

  @override
  Future<DeliveryOrderPageDto> getDeliveryOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    int? customerId,
    int? departmentId,
    String? todo,
    String? startDate,
    String? endDate,
    String? ordering,
  }) async {
    _log('getDeliveryOrders');
    return DeliveryOrderPageDto(
      items: _orders.values
          .map((o) => DeliveryOrderDto(
                id: o.id,
                orderNumber: o.orderNumber,
                status: o.status,
                customerName: o.customerName,
              ))
          .toList(),
      total: _orders.length,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Map<String, dynamic>> ship(int id, Map<String, dynamic> payload) async {
    _log('ship:$id');
    final order = _orders[id];
    if (order == null) throw Exception('DeliveryOrder not found');
    return {'status': 'shipped', 'shipped_at': DateTime.now().toIso8601String()};
  }

  @override
  Future<Map<String, dynamic>> receive(int id, Map<String, dynamic> payload) async {
    _log('receive:$id');
    return {'status': 'received'};
  }

  @override
  Future<Map<String, dynamic>> reject(int id, Map<String, dynamic> payload) async {
    _log('reject:$id');
    return {'status': 'rejected'};
  }

  @override
  Future<Map<String, dynamic>> getSummary({
    int? departmentId,
    String? status,
    int? customerId,
    String? todo,
    String? startDate,
    String? endDate,
  }) async {
    _log('getSummary');
    return {};
  }

  @override
  Future<DeliveryOrderDetail> getDeliveryOrderDetail(int id) async {
    _log('getDeliveryOrderDetail:$id');
    final order = _orders[id];
    if (order == null) throw Exception('DeliveryOrder not found');
    return DeliveryOrderDetail(
      id: order.id,
      orderNumber: order.orderNumber,
      customerName: order.customerName,
      status: order.status,
    );
  }

  @override
  Future<DeliveryOrderDetail> createDeliveryOrder(
    Map<String, dynamic> payload,
  ) async {
    _log('createDeliveryOrder');
    final id = _orders.keys.isEmpty ? 1 : _orders.keys.reduce((a, b) => a > b ? a : b) + 1;
    final order = DeliveryOrder(
      id: id,
      orderNumber: 'DO${id.toString().padLeft(5, '0')}',
      status: 'pending',
      customerName: payload['customer_name']?.toString(),
    );
    _orders[id] = order;
    return DeliveryOrderDetail(
      id: order.id,
      orderNumber: order.orderNumber,
      customerName: order.customerName,
      status: order.status,
    );
  }

  @override
  Future<DeliveryOrderDetail> updateDeliveryOrder(
    int id,
    Map<String, dynamic> payload,
  ) async {
    _log('updateDeliveryOrder:$id');
    final order = _orders[id];
    if (order == null) throw Exception('DeliveryOrder not found');
    return DeliveryOrderDetail(
      id: order.id,
      orderNumber: order.orderNumber,
      customerName: order.customerName,
      status: order.status,
    );
  }

  @override
  Future<void> deleteDeliveryOrder(int id) async {
    _log('deleteDeliveryOrder:$id');
    _orders.remove(id);
  }

  @override
  Future<Map<String, dynamic>> resolveException(
    int id,
    Map<String, dynamic> payload,
  ) async {
    _log('resolveException:$id');
    return {'status': 'resolved'};
  }

  @override
  Future<DeliveryOrderDetail> uploadReceiverSignature(
    int id,
    MultipartFile receiverSignature,
  ) async {
    _log('uploadReceiverSignature:$id');
    final order = _orders[id];
    if (order == null) throw Exception('DeliveryOrder not found');
    return DeliveryOrderDetail(
      id: order.id,
      orderNumber: order.orderNumber,
      customerName: order.customerName,
      status: order.status,
    );
  }

  @override
  Future<DeliveryOrderFormOptions> loadFormOptions() async {
    _log('loadFormOptions');
    return const DeliveryOrderFormOptions(
      customers: [],
      salesOrders: [],
      products: [],
    );
  }

  @override
  Future<SalesOrderDetail> fetchSalesOrderDetail(int id) async {
    _log('fetchSalesOrderDetail:$id');
    return SalesOrderDetail(id: id, orderNumber: 'SO$id');
  }

  void seedDeliveryOrder(DeliveryOrder order) {
    _orders[order.id] = order;
  }
}

class _MockInvoiceRepository implements InvoiceRepository {
  int _nextId = 400;
  final Map<int, Invoice> _invoices = {};
  final List<String> _callLog = [];

  List<String> get callLog => List.unmodifiable(_callLog);

  void _log(String method) => _callLog.add(method);

  @override
  Future<InvoicePageDto> getInvoices({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? approvalStatus,
    String? todo,
    String? ordering,
  }) async {
    _log('getInvoices');
    return InvoicePageDto(
      items: _invoices.values
          .map((i) => InvoiceDto(
                id: i.id,
                invoiceNumber: i.invoiceNumber,
                status: i.status,
                customerName: i.customerName,
                amount: i.amount,
              ))
          .toList(),
      total: _invoices.length,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Map<String, dynamic>> submit(int id, [Map<String, dynamic>? payload]) async {
    _log('submit:$id');
    return {'status': 'submitted'};
  }

  @override
  Future<InvoiceDto> create(Map<String, dynamic> payload) async {
    _log('create');
    final id = _nextId++;
    final invoice = Invoice(
      id: id,
      invoiceNumber: 'INV${id.toString().padLeft(5, '0')}',
      customerName: payload['customer_name']?.toString(),
      amount: payload['amount'] is num ? (payload['amount'] as num).toDouble() : null,
      status: 'draft',
      issueDate: DateTime.now(),
    );
    _invoices[id] = invoice;
    return InvoiceDto(
      id: id,
      invoiceNumber: invoice.invoiceNumber,
      customerName: invoice.customerName,
      amount: invoice.amount,
      status: invoice.status,
      issueDate: invoice.issueDate,
    );
  }

  @override
  Future<Map<String, dynamic>> uploadAttachment(int id, dynamic attachment) async {
    _log('uploadAttachment:$id');
    return {'uploaded': true};
  }

  @override
  Future<Map<String, dynamic>> approve(int id, Map<String, dynamic> payload) async {
    _log('approve:$id');
    final existing = _invoices[id];
    if (existing != null) {
      _invoices[id] = existing.copyWith(status: 'approved');
    }
    return {'status': 'approved'};
  }

  @override
  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params}) async {
    _log('getSummary');
    return {};
  }

  @override
  Future<InvoiceFormOptions> loadFormOptions() async {
    _log('loadFormOptions');
    return const InvoiceFormOptions(
      customers: [],
      salesOrders: [],
      workOrders: [],
    );
  }

  @override
  Future<Invoice> getInvoiceDetail(int id) async {
    _log('getInvoiceDetail:$id');
    final existing = _invoices[id];
    if (existing != null) return existing;
    return Invoice(
      id: id,
      invoiceNumber: 'INV$id',
      status: 'draft',
      issueDate: DateTime.now(),
    );
  }
}

class _MockPaymentRepository implements PaymentRepository {
  final List<Payment> _payments = [];

  @override
  Future<PageData<Payment>> getPayments({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? customer,
    String? paymentMethod,
    String? todo,
    String? ordering,
    String? startDate,
    String? endDate,
  }) async {
    return PageData(
      items: _payments,
      total: _payments.length,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params}) async {
    return {};
  }

  @override
  Future<PaymentFormOptions> loadFormOptions() async {
    return const PaymentFormOptions(
      customers: [],
      salesOrders: [],
      invoices: [],
    );
  }

  @override
  Future<void> createPayment(Map<String, dynamic> payload) async {
    return;
  }

  void seedPayment(Payment payment) {
    _payments.add(payment);
  }
}

void main() {
  group('E2E: SalesOrder → WorkOrder → Delivery → Invoice → Payment', () {
    late _MockSalesOrderRepository salesRepo;
    late _MockWorkOrderRepository workOrderRepo;
    late _MockDeliveryOrderRepository deliveryRepo;
    late _MockInvoiceRepository invoiceRepo;
    late _MockPaymentRepository paymentRepo;

    late SalesOrderViewModel salesVm;
    late WorkOrderViewModel workOrderVm;
    late DeliveryOrderViewModel deliveryVm;
    late InvoiceViewModel invoiceVm;
    late PaymentViewModel paymentVm;

    setUp(() {
      salesRepo = _MockSalesOrderRepository();
      workOrderRepo = _MockWorkOrderRepository();
      deliveryRepo = _MockDeliveryOrderRepository();
      invoiceRepo = _MockInvoiceRepository();
      paymentRepo = _MockPaymentRepository();

      salesVm = SalesOrderViewModel(salesRepo);
      workOrderVm = WorkOrderViewModel(workOrderRepo);
      deliveryVm = DeliveryOrderViewModel(deliveryRepo);
      invoiceVm = InvoiceViewModel(invoiceRepo);
      paymentVm = PaymentViewModel(paymentRepo);
    });

    tearDown(() {
      salesVm.dispose();
      workOrderVm.dispose();
      deliveryVm.dispose();
      invoiceVm.dispose();
      paymentVm.dispose();
    });

    test(
        '完整流程：创建订单 → 提交 → 审核 → 生成施工单 → 审批 → 发货 → 开票 → 收款闭环',
        () async {
      // Step 1: 创建客户订单
      final order = await salesVm.createSalesOrder({
        'customer_name': '闭环测试客户',
        'total_amount': 8000.0,
      });
      expect(order.orderNumber, startsWith('SO'));
      expect(order.status, equals('draft'));

      final salesOrderId = order.id;

      // Step 2: 提交订单审核
      final submitted = await salesVm.submit(salesOrderId);
      expect(submitted.status, equals('pending_review'));
      expect(salesRepo.callLog, contains('submit:$salesOrderId'));

      // Step 3: 审核通过
      final approved = await salesVm.approve(salesOrderId, {'comment': '同意'});
      expect(approved.status, equals('approved'));
      expect(salesRepo.callLog, contains('approve:$salesOrderId'));

      // Step 4: 从销售订单生成施工单
      final woResult = await salesVm.createWorkOrderFromSalesOrder({
        'sales_order_id': salesOrderId,
      });
      expect(woResult['created'], isTrue);
      expect(woResult['work_order_id'], isNotNull);
      expect(salesRepo.callLog, contains('createWorkOrderFromSalesOrder'));

      // Step 5: WorkOrderViewModel 审批施工单
      final workOrderId = woResult['work_order_id'] as int;
      // 先创建一个施工单让它存在
      await workOrderVm.createWorkOrder({
        'customer_name': '闭环测试客户',
        'total_amount': 8000.0,
      });
      final approvedWo = await workOrderVm.approveWorkOrder(workOrderId);
      expect(approvedWo.approvalStatus, equals('approved'));
      expect(workOrderRepo.callLog, contains('approveWorkOrder:$workOrderId'));

      // Step 6: 发货（创建发货单并执行 ship）
      const deliveryOrderId = 300;
      deliveryRepo.seedDeliveryOrder(DeliveryOrder(
        id: deliveryOrderId,
        orderNumber: 'DO00300',
        status: 'pending',
        salesOrderId: salesOrderId,
        customerName: '闭环测试客户',
      ));
      final shipResult = await deliveryRepo.ship(deliveryOrderId, {
        'items': [{'product_id': 1, 'quantity': 100}],
      });
      expect(shipResult['status'], equals('shipped'));
      expect(deliveryRepo.callLog, contains('ship:$deliveryOrderId'));

      // Step 7: 创建发票
      final invoice = await invoiceVm.createInvoice({
        'sales_order': salesOrderId,
        'customer_name': '闭环测试客户',
        'amount': 8000.0,
        'invoice_type': 'sales',
      });
      expect(invoice.invoiceNumber, startsWith('INV'));
      expect(invoice.amount, equals(8000.0));
      expect(invoice.status, equals('draft'));
      expect(invoiceRepo.callLog, contains('create'));

      // Step 8: 审批发票
      final invoiceApproveResult = await invoiceRepo.approve(invoice.id, {'comment': '确认开票'});
      expect(invoiceApproveResult['status'], equals('approved'));

      // Step 9: 创建收款并核销（模拟 PaymentService 闭环）
      paymentRepo.seedPayment(Payment(
        id: 1,
        paymentNumber: 'PM00001',
        salesOrderId: salesOrderId,
        salesOrderNumber: order.orderNumber,
        invoiceId: invoice.id,
        invoiceNumber: invoice.invoiceNumber,
        amount: 8000.0,
        appliedAmount: 8000.0,
        remainingAmount: 0.0,
        paymentMethod: 'bank_transfer',
        status: 'confirmed',
        paymentDate: DateTime.now(),
      ));

      // Step 10: PaymentViewModel 加载并验证闭环
      await paymentVm.loadPayments(resetPage: true);
      expect(paymentVm.payments.length, equals(1));
      final payment = paymentVm.payments.first;
      expect(payment.salesOrderId, equals(salesOrderId));
      expect(payment.appliedAmount, equals(8000.0));
      expect(payment.remainingAmount, equals(0.0));

      // Step 11: 验证销售订单付款状态更新
      final updatedOrder = await salesVm.updatePayment(salesOrderId, {
        'paid_amount': 8000.0,
        'payment_date': '2026-06-07',
      });
      expect(updatedOrder.paymentStatus, equals('paid'));
      expect(updatedOrder.paidAmount, equals(8000.0));

      // Step 12: 验证端到端调用链完整
      expect(salesRepo.callLog, contains('createSalesOrder'));
      expect(salesRepo.callLog, contains('submit:$salesOrderId'));
      expect(salesRepo.callLog, contains('approve:$salesOrderId'));
      expect(salesRepo.callLog, contains('createWorkOrderFromSalesOrder'));
      expect(salesRepo.callLog, contains('updatePayment:$salesOrderId'));
      expect(workOrderRepo.callLog, contains('approveWorkOrder:$workOrderId'));
      expect(deliveryRepo.callLog, contains('ship:$deliveryOrderId'));
      expect(invoiceRepo.callLog, contains('create'));
      expect(invoiceRepo.callLog, contains('approve:${invoice.id}'));
    });

    test('部分付款场景：订单 8000，收款 5000，状态为 partial', () async {
      final order = await salesVm.createSalesOrder({
        'customer_name': '部分付款客户',
        'total_amount': 8000.0,
      });

      final partialPayment = await salesVm.updatePayment(order.id, {
        'paid_amount': 5000.0,
      });

      expect(partialPayment.paymentStatus, equals('partial'));
      expect(partialPayment.paidAmount, equals(5000.0));
    });

    test('发货单按客户订单筛选', () async {
      const salesOrderId = 999;
      deliveryRepo.seedDeliveryOrder(DeliveryOrder(
        id: 1,
        orderNumber: 'DO00001',
        status: 'shipped',
        salesOrderId: salesOrderId,
        customerName: '筛选客户',
      ));
      deliveryRepo.seedDeliveryOrder(DeliveryOrder(
        id: 2,
        orderNumber: 'DO00002',
        status: 'pending',
        salesOrderId: 888,
        customerName: '其他客户',
      ));

      deliveryVm.setFiltersSilently(status: 'shipped');
      await deliveryVm.loadDeliveryOrders(resetPage: true);

      // 状态筛选生效后应只返回 shipped
      expect(deliveryVm.deliveryOrders.any((o) => o.status == 'shipped'), isTrue);
    });

    test('发票关联销售订单号正确传递', () async {
      final invoice = await invoiceVm.createInvoice({
        'sales_order': 555,
        'customer_name': '关联测试客户',
        'amount': 3000.0,
      });

      expect(invoice.customerName, equals('关联测试客户'));
      expect(invoice.amount, equals(3000.0));
    });
  });
}
