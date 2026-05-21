import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/finance_payments/presentation/widgets/payment_list_dialogs.dart';
import 'package:work_order_app/src/features/finance_statements/presentation/widgets/statement_list_dialogs.dart';
import 'package:work_order_app/src/features/inventory_delivery/presentation/widgets/delivery_order_action_dialogs.dart';
import 'package:work_order_app/src/features/inventory_delivery/presentation/widgets/delivery_order_form_dialog.dart';
import 'package:work_order_app/src/features/inventory_stocks/presentation/widgets/product_stock_dialogs.dart';
import 'package:work_order_app/src/features/inventory_shared/presentation/widgets/inventory_document_form_dialog.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/widgets/purchase_order_action_dialogs.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/widgets/purchase_order_form_dialog.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/widgets/purchase_order_inspection_dialogs.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/widgets/purchase_order_receive_dialog.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/widgets/sales_order_list_dialogs.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_dto.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_action_dialogs.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_sync_preview_dialog.dart';

void main() {
  testWidgets('product stock adjust dialog validates required fields',
      (tester) async {
    ProductStockAdjustResult? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showProductStockAdjustDialog(
          context,
          title: '库存调整',
          submitText: '确认调整',
          cancelText: '取消',
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('确认调整'));
    await tester.pump();

    expect(find.text('请输入有效数量'), findsOneWidget);
    expect(find.text('请输入调整原因'), findsOneWidget);
    expect(result, isNull);
  });

  testWidgets('product stock adjust dialog returns submitted payload',
      (tester) async {
    ProductStockAdjustResult? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showProductStockAdjustDialog(
          context,
          title: '库存调整',
          submitText: '确认调整',
          cancelText: '取消',
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '12.5');
    await tester.enterText(fields.at(1), '盘点校准');
    await tester.tap(find.text('确认调整'));
    await tester.pumpAndSettle();

    expect(result?.adjustType, 'add');
    expect(result?.quantity, 12.5);
    expect(result?.reason, '盘点校准');
  });

  testWidgets('product stock adjust dialog fits mobile width', (tester) async {
    ProductStockAdjustResult? result;

    _setTestViewSize(tester, const Size(360, 720));

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showProductStockAdjustDialog(
          context,
          title: '库存调整',
          submitText: '确认调整',
          cancelText: '取消',
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('库存调整'), findsOneWidget);
    expect(find.text('确认调整'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '5');
    await tester.enterText(fields.at(1), '移动端盘点校准');
    await tester.tap(find.text('确认调整'));
    await tester.pumpAndSettle();

    expect(result?.quantity, 5);
    expect(result?.reason, '移动端盘点校准');
    expect(tester.takeException(), isNull);
  });

  testWidgets('task quantity dialog submits progress payload', (tester) async {
    Map<String, dynamic>? payload;

    await _pumpButton(
      tester,
      onPressed: (context) {
        showTaskQuantityDialog(
          context,
          task: _task,
          onSubmit: (value) async => payload = value,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '3');
    await tester.enterText(fields.at(1), '1');
    await tester.enterText(fields.at(2), '加急完成');
    await tester.tap(find.text('确认更新'));
    await tester.pumpAndSettle();

    expect(payload, {
      'quantity_increment': 3,
      'quantity_defective': 1,
      'notes': '加急完成',
    });
  });

  testWidgets('task quantity dialog blocks invalid increment', (tester) async {
    Map<String, dynamic>? payload;

    await _pumpButton(
      tester,
      onPressed: (context) {
        showTaskQuantityDialog(
          context,
          task: _task,
          onSubmit: (value) async => payload = value,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '0');
    await tester.tap(find.text('确认更新'));
    await tester.pump();

    expect(find.text('请输入大于 0 的数量'), findsOneWidget);
    expect(payload, isNull);
  });

  testWidgets('task complete dialog submits completion payload',
      (tester) async {
    Map<String, dynamic>? payload;

    await _pumpButton(
      tester,
      onPressed: (context) {
        showTaskCompleteDialog(
          context,
          task: _task,
          onSubmit: (value) async => payload = value,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '2');
    await tester.enterText(fields.at(1), '生产完成');
    await tester.enterText(fields.at(2), '已自检');
    await tester.tap(find.text('确认完成'));
    await tester.pumpAndSettle();

    expect(payload, {
      'quantity_defective': 2,
      'completion_reason': '生产完成',
      'notes': '已自检',
    });
  });

  testWidgets('task assign dialog loads operators and submits selection',
      (tester) async {
    int? operatorId;
    String? notes;
    var loadedDepartmentId = 0;

    await _pumpButton(
      tester,
      onPressed: (context) {
        showTaskAssignDialog(
          context,
          task: _task,
          departments: const [
            TaskDepartmentOption(id: 7, name: '印刷部', processIds: [3]),
          ],
          loadOperators: (departmentId) async {
            loadedDepartmentId = departmentId;
            return [
              {'id': 11, 'first_name': '张', 'last_name': '三'},
            ];
          },
          onSubmit: (id, value) async {
            operatorId = id;
            notes = value;
          },
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(loadedDepartmentId, 7);
    expect(find.text('印刷部'), findsOneWidget);
    expect(find.text('张三'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '优先安排');
    await tester.tap(find.text('确认分派'));
    await tester.pumpAndSettle();

    expect(operatorId, 11);
    expect(notes, '优先安排');
  });

  testWidgets('sales order payment dialog returns submitted values',
      (tester) async {
    SalesOrderPaymentUpdateResult? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showSalesOrderPaymentDialog(
          context,
          initialAmountText: '10',
          initialDateText: '2026-05-01',
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), ' 25.5 ');
    await tester.enterText(fields.at(1), ' 2026-05-21 ');
    await tester.tap(find.text('更新'));
    await tester.pumpAndSettle();

    expect(result?.amountText, '25.5');
    expect(result?.dateText, '2026-05-21');
  });

  testWidgets('sales order complete dialog validates required reason',
      (tester) async {
    SalesOrderCompleteResult? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showSalesOrderCompleteDialog(
          context,
          requireReason: true,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('完成'));
    await tester.pump();

    expect(find.text('请填写人工完结原因'), findsOneWidget);
    expect(result, isNull);
  });

  testWidgets('sales order complete dialog returns trimmed reason',
      (tester) async {
    SalesOrderCompleteResult? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showSalesOrderCompleteDialog(
          context,
          requireReason: true,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), ' 客户确认尾差结案 ');
    await tester.tap(find.text('完成'));
    await tester.pumpAndSettle();

    expect(result?.completionReason, '客户确认尾差结案');
  });

  testWidgets('sales order batch create dialog returns defaults and notes',
      (tester) async {
    SalesOrderBatchCreateWorkOrderResult? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showSalesOrderBatchCreateWorkOrdersDialog(
          context,
          selectedCount: 3,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(find.text('将为已选择的 3 张客户订单批量生成施工单草稿。'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), ' 2026-06-01 ');
    await tester.enterText(fields.at(1), ' 统一备注 ');
    await tester.tap(find.text('开始生成'));
    await tester.pumpAndSettle();

    expect(result?.priority, 'normal');
    expect(result?.deliveryDateText, '2026-06-01');
    expect(result?.notes, '统一备注');
  });

  testWidgets('delivery ship dialog submits trimmed logistics data',
      (tester) async {
    String? logisticsCompany;
    String? trackingNumber;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        await showDeliveryShipDialog(
          context,
          cancelText: '取消',
          submitText: '确认发货',
          title: '填写发货信息',
          initialLogisticsCompany: '顺丰',
          initialTrackingNumber: 'SF001',
          onSubmit: (company, tracking) async {
            logisticsCompany = company;
            trackingNumber = tracking;
          },
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), ' 德邦 ');
    await tester.enterText(fields.at(1), ' DB123 ');
    await tester.tap(find.text('确认发货'));
    await tester.pumpAndSettle();

    expect(logisticsCompany, '德邦');
    expect(trackingNumber, 'DB123');
  });

  testWidgets('delivery receive dialog submits trimmed notes', (tester) async {
    String? notes;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        await showDeliveryReceiveDialog(
          context,
          cancelText: '取消',
          submitText: '确认签收',
          title: '签收发货单',
          onSubmit: (value) async => notes = value,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), ' 已签收 ');
    await tester.tap(find.text('确认签收'));
    await tester.pumpAndSettle();

    expect(notes, '已签收');
  });

  testWidgets('delivery reject dialog validates and submits reason',
      (tester) async {
    String? reason;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        await showDeliveryRejectDialog(
          context,
          cancelText: '取消',
          submitText: '确认拒收',
          title: '拒收发货单',
          onSubmit: (value) async => reason = value,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('确认拒收'));
    await tester.pump();

    expect(find.text('请输入拒收原因'), findsOneWidget);
    expect(reason, isNull);

    await tester.enterText(find.byType(TextFormField), ' 包装破损 ');
    await tester.tap(find.text('确认拒收'));
    await tester.pumpAndSettle();

    expect(reason, '包装破损');
  });

  testWidgets('delivery reject dialog fits mobile width and validates reason',
      (tester) async {
    String? reason;

    _setTestViewSize(tester, const Size(320, 640));

    await _pumpButton(
      tester,
      onPressed: (context) async {
        await showDeliveryRejectDialog(
          context,
          cancelText: '取消',
          submitText: '确认拒收',
          title: '拒收发货单',
          onSubmit: (value) async => reason = value,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('拒收发货单'), findsOneWidget);

    await tester.tap(find.text('确认拒收'));
    await tester.pump();

    expect(find.text('请输入拒收原因'), findsOneWidget);
    expect(reason, isNull);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.byType(TextFormField), ' 移动端拒收原因 ');
    await tester.tap(find.text('确认拒收'));
    await tester.pumpAndSettle();

    expect(reason, '移动端拒收原因');
    expect(tester.takeException(), isNull);
  });

  testWidgets('delivery order form fits desktop width and submits',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    final receiverNameController = TextEditingController();
    final receiverPhoneController = TextEditingController();
    final addressController = TextEditingController();
    final logisticsController = TextEditingController();
    final trackingController = TextEditingController();
    final freightController = TextEditingController();
    final packageCountController = TextEditingController();
    final packageWeightController = TextEditingController();
    final notesController = TextEditingController();
    final items = <DeliveryItemDraft>[];
    int? salesOrderId;
    DateTime? deliveryDate;
    var salesOrderLoaded = false;
    var submitted = false;

    _setTestViewSize(tester, const Size(1280, 900));

    addTearDown(() {
      receiverNameController.dispose();
      receiverPhoneController.dispose();
      addressController.dispose();
      logisticsController.dispose();
      trackingController.dispose();
      freightController.dispose();
      packageCountController.dispose();
      packageWeightController.dispose();
      notesController.dispose();
      for (final item in items) {
        item.dispose();
      }
    });

    await _pumpButton(
      tester,
      onPressed: (context) async {
        await showDeliveryOrderFormDialog(
          context,
          isEdit: false,
          title: '新建发货单',
          cancelText: '取消',
          submitText: '保存',
          productsLoading: false,
          formKey: formKey,
          salesOrders: const [SalesOrderDto(id: 7, orderNumber: 'SO-007')],
          products: const [
            ProductOption(id: 8, code: 'P-001', name: '产品A', unit: '件'),
          ],
          selectedSalesOrderId: salesOrderId,
          deliveryDate: deliveryDate,
          receiverNameController: receiverNameController,
          receiverPhoneController: receiverPhoneController,
          addressController: addressController,
          logisticsController: logisticsController,
          trackingController: trackingController,
          freightController: freightController,
          packageCountController: packageCountController,
          packageWeightController: packageWeightController,
          notesController: notesController,
          items: items,
          onSalesOrderChanged: (id, {refresh}) async {
            salesOrderLoaded = true;
            salesOrderId = id;
            receiverNameController.text = '张三';
            receiverPhoneController.text = '13800000000';
            addressController.text = '上海市';
            deliveryDate = DateTime(2026, 5, 21);
            refresh?.call();
          },
          onDatePicked: (picked) => deliveryDate = picked,
          onSubmit: (refresh) async {
            submitted = true;
            expect(formKey.currentState?.validate(), isTrue);
            expect(salesOrderId, 7);
            expect(items.single.productId, 8);
            expect(items.single.quantity, 2);
          },
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('新建发货单'), findsOneWidget);
    expect(find.text('关联单据'), findsOneWidget);
    expect(find.text('收货信息'), findsOneWidget);

    await tester.tap(find.text('客户订单'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SO-007').last);
    await tester.pumpAndSettle();

    expect(salesOrderLoaded, isTrue);
    expect(find.text('张三'), findsOneWidget);
    expect(find.text('13800000000'), findsOneWidget);
    expect(find.text('上海市'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('添加明细'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('添加明细'));
    await tester.pumpAndSettle();

    expect(items, hasLength(1));

    await tester.scrollUntilVisible(
      find.text('产品'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('产品'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('产品A (P-001)').last);
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(fields.evaluate().length - 4), '2');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(submitted, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('purchase reason dialog trims text and returns null for empty',
      (tester) async {
    String? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showPurchaseReasonDialog(
          context,
          title: '驳回采购单',
          confirmText: '确认驳回',
          fieldLabel: '驳回原因',
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), ' 价格异常 ');
    await tester.tap(find.text('确认驳回'));
    await tester.pumpAndSettle();

    expect(result, '价格异常');

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showPurchaseReasonDialog(
          context,
          title: '驳回采购单',
          confirmText: '确认驳回',
          fieldLabel: '驳回原因',
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('确认驳回'));
    await tester.pumpAndSettle();

    expect(result, isNull);
  });

  testWidgets('purchase receive dialog blocks empty receive quantities',
      (tester) async {
    PurchaseReceiveSubmission? submission;
    bool? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showPurchaseReceiveDialog(
          context,
          detail: _purchaseDetail,
          onSubmit: (value) async => submission = value,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('确认收货'));
    await tester.pump();

    expect(submission, isNull);
    expect(result, isNull);
    expect(find.text('请输入收货数量'), findsOneWidget);
    expect(find.text('采购收货'), findsWidgets);
  });

  testWidgets('purchase receive dialog submits selected item quantities',
      (tester) async {
    PurchaseReceiveSubmission? submission;
    bool? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showPurchaseReceiveDialog(
          context,
          detail: _purchaseDetail,
          onSubmit: (value) async => submission = value,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), ' DN-001 ');
    await tester.enterText(fields.at(1), '3.5');
    await tester.enterText(fields.at(2), ' 本批先收 ');
    await tester.tap(find.text('确认收货'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(submission?.deliveryNoteNumber, 'DN-001');
    expect(submission?.items, hasLength(1));
    expect(submission?.items.single.itemId, 101);
    expect(submission?.items.single.receivedQuantity, 3.5);
    expect(submission?.items.single.notes, '本批先收');
  });

  testWidgets('purchase inspection dialog confirms inspection payload',
      (tester) async {
    Map<String, dynamic>? payload;
    var recordId = 0;
    var loadCount = 0;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        await showPurchaseInspectionDialog(
          context,
          loadRecords: () async {
            loadCount += 1;
            return [_pendingInspectionRecord];
          },
          confirmInspection: (id, value) async {
            recordId = id;
            payload = value;
          },
          stockIn: (_) async {},
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(loadCount, 1);
    expect(find.text('收货记录质检'), findsOneWidget);
    expect(find.text('M-001 纸张'), findsOneWidget);

    await tester.tap(find.text('质检'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '7.5');
    await tester.enterText(fields.at(1), '2.5');
    await tester.enterText(fields.at(2), '边角破损');
    await tester.tap(find.text('确认'));
    await tester.pumpAndSettle();

    expect(recordId, 201);
    expect(payload, {
      'qualified_quantity': 7.5,
      'unqualified_quantity': 2.5,
      'unqualified_reason': '边角破损',
    });
    expect(loadCount, 2);
  });

  testWidgets('purchase inspection dialog stocks in qualified record',
      (tester) async {
    var stockedRecordId = 0;
    var loadCount = 0;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        await showPurchaseInspectionDialog(
          context,
          loadRecords: () async {
            loadCount += 1;
            return [_qualifiedInspectionRecord];
          },
          confirmInspection: (_, __) async {},
          stockIn: (id) async => stockedRecordId = id,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(find.text('M-002 油墨'), findsOneWidget);
    await tester.tap(find.text('入库'));
    await tester.pumpAndSettle();

    expect(find.text('确定将 4.0 件物料入库吗？'), findsOneWidget);
    await tester.tap(find.text('确认'));
    await tester.pumpAndSettle();

    expect(stockedRecordId, 202);
    expect(loadCount, 2);
  });

  testWidgets('purchase order form adds material row and submits',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    final notesController = TextEditingController();
    final items = <PurchaseItemDraft>[];
    int? supplierId;
    int? workOrderId;
    var submitted = false;

    addTearDown(notesController.dispose);
    addTearDown(() {
      for (final item in items) {
        item.dispose();
      }
    });

    await _pumpButton(
      tester,
      onPressed: (context) async {
        await showPurchaseOrderFormDialog(
          context,
          isEdit: false,
          title: '新建采购单',
          cancelText: '取消',
          submitText: '保存',
          materialsLoading: false,
          formKey: formKey,
          suppliers: [SupplierDto(id: 3, name: '默认供应商')],
          workOrders: const [WorkOrderDto(id: 4, orderNumber: 'WO-001')],
          selectedSupplierId: supplierId,
          selectedWorkOrderId: workOrderId,
          fallbackWorkOrderNumber: null,
          notesController: notesController,
          materials: const [
            MaterialDto(
              id: 5,
              code: 'M-001',
              name: '纸张',
              unit: '张',
              unitPrice: 2.5,
            ),
          ],
          items: items,
          onCreateSupplier: () async => null,
          onCreateMaterial: () async => null,
          onSupplierChanged: (value) => supplierId = value,
          onWorkOrderChanged: (value) =>
              workOrderId = value == 0 ? null : value,
          onSubmit: (refresh) async {
            submitted = true;
            expect(formKey.currentState?.validate(), isTrue);
            expect(supplierId, 3);
            expect(workOrderId, 4);
            expect(items.single.materialId, 5);
            expect(items.single.quantity, 3);
            expect(items.single.unitPrice, 2.5);
          },
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('请选择').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('默认供应商').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('关联施工单'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('WO-001').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('添加明细'));
    await tester.pumpAndSettle();

    expect(items, hasLength(1));

    await tester.scrollUntilVisible(
      find.text('物料'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('物料'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('M-001 纸张').last);
    await tester.pumpAndSettle();

    expect(find.text('张'), findsOneWidget);
    expect(find.text('2.50'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(fields.evaluate().length - 3), '3');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(submitted, isTrue);
  });

  testWidgets('payment create dialog validates customer and returns payload',
      (tester) async {
    PaymentCreateResult? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showPaymentCreateDialog(
          context,
          customers: const [Customer(id: 7, name: '华东客户')],
          salesOrders: const [SalesOrder(id: 8, orderNumber: 'SO-001')],
          invoices: const [Invoice(id: 9, invoiceNumber: 'INV-001')],
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('创建'));
    await tester.pump();

    expect(find.text('请选择客户'), findsAtLeastNWidgets(1));
    expect(result, isNull);

    await tester.tap(find.text('请选择客户').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('华东客户').last);
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), ' 128.5 ');
    await tester.enterText(fields.at(1), ' 2026-05-21 ');
    await tester.enterText(fields.at(2), ' 工行 ');
    await tester.enterText(fields.at(3), ' TX123 ');
    await tester.enterText(fields.at(4), ' 首付款 ');
    await tester.tap(find.text('创建'));
    await tester.pumpAndSettle();

    expect(result?.payload, {
      'customer': 7,
      'amount': 128.5,
      'payment_method': 'transfer',
      'payment_date': '2026-05-21',
      'bank_account': '工行',
      'transaction_number': 'TX123',
      'notes': '首付款',
    });
  });

  testWidgets('inventory document form refreshes custom fields and submits',
      (tester) async {
    final dateController = TextEditingController(text: '2026-05-21');
    final notesController = TextEditingController(text: '初始备注');
    var counter = 0;
    var submitted = false;

    addTearDown(dateController.dispose);
    addTearDown(notesController.dispose);

    await _pumpButton(
      tester,
      onPressed: (context) async {
        await showInventoryDocumentFormDialog(
          context,
          title: '新建入库单',
          dateLabel: '入库日期',
          dateController: dateController,
          notesController: notesController,
          fieldsBuilder: (context, refresh, submitting) => [
            Text('自定义字段 $counter'),
            TextButton(
              onPressed: submitting
                  ? null
                  : () {
                      counter += 1;
                      refresh();
                    },
              child: const Text('刷新字段'),
            ),
          ],
          onSubmit: () async => submitted = true,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(find.text('自定义字段 0'), findsOneWidget);

    await tester.tap(find.text('刷新字段'));
    await tester.pump();

    expect(find.text('自定义字段 1'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).last, ' 更新备注 ');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(submitted, isTrue);
    expect(notesController.text, ' 更新备注 ');
  });

  testWidgets('statement create dialog validates required fields',
      (tester) async {
    StatementCreateResult? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showStatementCreateDialog(
          context,
          customers: const [Customer(id: 7, name: '华东客户')],
          suppliers: const [],
          onCreateCustomer: () async => null,
          onCreateSupplier: () async => null,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('创建'));
    await tester.pump();

    expect(find.text('请选择客户'), findsAtLeastNWidgets(1));
    expect(find.text('请输入对账周期'), findsOneWidget);
    expect(find.text('请选择对账日期范围'), findsOneWidget);
    expect(result, isNull);
  });

  testWidgets('statement generate dialog creates customer and returns params',
      (tester) async {
    StatementGenerateResult? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showStatementGenerateDialog(
          context,
          customers: const [],
          suppliers: const [],
          onCreateCustomer: () async => const Customer(id: 9, name: '华东客户'),
          onCreateSupplier: () async => const Supplier(id: 8, name: '华南供应商'),
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.widgetWithText(TextButton, '新增客户'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.widgetWithText(TextButton, '新增客户'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), ' 2026-05 ');
    await tester.tap(find.text('生成'));
    await tester.pumpAndSettle();

    expect(result?.params, {
      'period': '2026-05',
      'customer': 9,
    });
  });

  testWidgets('statement generate dialog validates required period',
      (tester) async {
    StatementGenerateResult? result;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showStatementGenerateDialog(
          context,
          customers: const [Customer(id: 9, name: '华东客户')],
          suppliers: const [],
          onCreateCustomer: () async => null,
          onCreateSupplier: () async => null,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('请选择'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('华东客户').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('生成'));
    await tester.pump();

    expect(find.text('请输入对账周期'), findsOneWidget);
    expect(result, isNull);
  });

  testWidgets('statement generate dialog fits mobile width and submits',
      (tester) async {
    StatementGenerateResult? result;

    _setTestViewSize(tester, const Size(320, 640));

    await _pumpButton(
      tester,
      onPressed: (context) async {
        result = await showStatementGenerateDialog(
          context,
          customers: const [Customer(id: 9, name: '华东客户')],
          suppliers: const [],
          onCreateCustomer: () async => null,
          onCreateSupplier: () async => null,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('生成对账数据'), findsOneWidget);
    expect(find.text('生成结果会用于后续确认、异议处理和收付款跟进'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('请选择'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('华东客户').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), ' 2026-05 ');
    await tester.tap(find.text('生成'));
    await tester.pumpAndSettle();

    expect(result?.params, {
      'period': '2026-05',
      'customer': 9,
    });
    expect(tester.takeException(), isNull);
  });

  testWidgets('work order sync preview loads preview and executes selection',
      (tester) async {
    List<int>? previewIds;
    List<int>? executedIds;

    await _pumpButton(
      tester,
      onPressed: (context) async {
        await showWorkOrderSyncPreviewDialog(
          context,
          canSync: true,
          processes: _workOrderProcesses,
          emptyText: '-',
          loadPreview: (ids) async {
            previewIds = ids;
            return const WorkOrderSyncPreviewResult(
              preview: {
                'removed_process_ids': [2],
                'added_process_ids': [1],
                'tasks_to_remove': 1,
                'tasks_to_add': 2,
                'affected': true,
              },
            );
          },
          executeSync: (ids) async => executedIds = ids,
          formatProcessNames: (ids, processMap) => ids
              .map((id) => processMap[id]?.processName ?? id.toString())
              .join('、'),
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('模切'));
    await tester.pump();
    await tester.tap(find.text('预览变更'));
    await tester.pumpAndSettle();

    expect(previewIds, [1]);
    expect(find.text('预览结果'), findsOneWidget);
    expect(find.text('将删除草稿任务'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.text('执行同步'), findsOneWidget);

    await tester.tap(find.text('执行同步'));
    await tester.pumpAndSettle();

    expect(executedIds, [1]);
    expect(find.text('同步工序任务'), findsNothing);
  });
}

const _task = Task(
  id: 1,
  workContent: '印刷任务',
  processId: 3,
  processName: '印刷',
  productionQuantity: 10,
  quantityCompleted: 4,
);

const _purchaseDetail = PurchaseOrderDetail(
  id: 1,
  orderNumber: 'PO-001',
  supplierName: '默认供应商',
  status: 'approved',
  statusDisplay: '已批准',
  items: [
    PurchaseOrderItemDetail(
      id: 101,
      materialName: '纸张',
      materialCode: 'M-001',
      quantity: 10,
      receivedQuantity: 2,
      remainingQuantity: 8,
    ),
  ],
);

final _pendingInspectionRecord = <String, dynamic>{
  'id': 201,
  'material_code': 'M-001',
  'material_name': '纸张',
  'received_quantity': 10,
  'inspection_status': 'pending',
  'inspection_status_display': '待质检',
  'received_date': '2026-05-21',
  'is_stocked': false,
};

final _qualifiedInspectionRecord = <String, dynamic>{
  'id': 202,
  'material_code': 'M-002',
  'material_name': '油墨',
  'received_quantity': 4,
  'qualified_quantity': 4,
  'inspection_status': 'qualified',
  'inspection_status_display': '合格',
  'received_date': '2026-05-21',
  'is_stocked': false,
};

const _workOrderProcesses = [
  WorkOrderProcessItem(
    id: 1,
    processName: '印刷',
    processCode: 'PRINT',
  ),
  WorkOrderProcessItem(
    id: 2,
    processName: '模切',
    processCode: 'DIE',
  ),
];

Future<void> _pumpButton(
  WidgetTester tester, {
  required void Function(BuildContext context) onPressed,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: _theme(),
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => onPressed(context),
                child: const Text('打开'),
              ),
            ),
          );
        },
      ),
    ),
  );
}

void _setTestViewSize(WidgetTester tester, Size size) {
  addTearDown(() => tester.view.resetPhysicalSize());
  addTearDown(() => tester.view.resetDevicePixelRatio());

  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
}

ThemeData _theme() {
  return ThemeData(
    useMaterial3: true,
    extensions: const [
      AppColors(
        background: Colors.white,
        surface: Colors.white,
        sidebar: Colors.white,
        subtleText: Colors.black54,
        sidebarText: Colors.black87,
        borderColor: Colors.black12,
      ),
      AppSemanticColors(
        success: Colors.green,
        warning: Colors.orange,
        danger: Colors.red,
        info: Colors.blue,
        surfaceAlt: Color(0xfff5f5f5),
        shadowStrong: Colors.black26,
        unreadBackground: Color(0xffeef6ff),
      ),
    ],
  );
}
