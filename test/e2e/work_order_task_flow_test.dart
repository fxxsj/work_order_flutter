import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/features/tasks/application/task_view_model.dart';
import 'package:work_order_app/src/features/tasks/data/task_dto.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/domain/task_list_filter_options.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_detail_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';

/// 端到端测试：施工单提交审核 → 生成任务 → 任务查询
///
/// 验证 WorkOrderViewModel 与 TaskViewModel 在真实业务流中的协同。

class _MockWorkOrderRepository implements WorkOrderRepository {
  int _nextId = 100;
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
    final existing = _details[id];
    if (existing == null) throw Exception('WorkOrder not found');
    final updated = _copyWithStatus(existing, status: status);
    _details[id] = updated;
    return WorkOrderDetailDto(entity: updated);
  }

  @override
  Future<WorkOrderDetailDto> submitApproval(
    int id, {
    String? comment,
    Map<String, dynamic>? payload,
  }) async {
    _log('submitApproval:$id');
    final existing = _details[id];
    if (existing == null) throw Exception('WorkOrder not found');
    final updated = _copyWithStatus(
      existing,
      approvalStatus: 'pending_review',
      status: 'pending_review',
    );
    _details[id] = updated;
    return WorkOrderDetailDto(
      entity: updated,
      taskGeneration: {'generated': false, 'count': 0},
    );
  }

  @override
  Future<WorkOrderDetailDto> approveWorkOrder(int id, {String? comment}) async {
    _log('approveWorkOrder:$id');
    final existing = _details[id];
    if (existing == null) throw Exception('WorkOrder not found');
    final updated = _copyWithStatus(
      existing,
      approvalStatus: 'approved',
      status: 'approved',
    );
    _details[id] = updated;
    return WorkOrderDetailDto(
      entity: updated,
      taskGeneration: {'generated': true, 'count': 3},
    );
  }

  @override
  Future<WorkOrderDetailDto> rejectWorkOrder(int id, {required String reason}) async {
    _log('rejectWorkOrder:$id');
    final existing = _details[id];
    if (existing == null) throw Exception('WorkOrder not found');
    final updated = _copyWithStatus(
      existing,
      approvalStatus: 'rejected',
      status: 'rejected',
    );
    _details[id] = updated;
    return WorkOrderDetailDto(entity: updated);
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

  static WorkOrderDetail _copyWithStatus(
    WorkOrderDetail source, {
    String? status,
    String? approvalStatus,
  }) {
    return WorkOrderDetail(
      id: source.id,
      orderNumber: source.orderNumber,
      customerName: source.customerName,
      status: status ?? source.status,
      approvalStatus: approvalStatus ?? source.approvalStatus,
      totalAmount: source.totalAmount,
      orderDate: source.orderDate,
    );
  }
}

class _MockTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];
  String? _lastSearchFilter;
  String? _lastStatusFilter;

  List<Task> get tasks => List.unmodifiable(_tasks);
  String? get lastSearchFilter => _lastSearchFilter;
  String? get lastStatusFilter => _lastStatusFilter;

  void seedTasksForWorkOrder(String workOrderNumber, List<Task> tasks) {
    _tasks.addAll(
      tasks.map((t) => t.copyWith(workOrderNumber: workOrderNumber)),
    );
  }

  @override
  Future<TaskPageDto> getTasks({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? priority,
    String? taskType,
    int? departmentId,
    int? assignedOperatorId,
    int? processId,
    String? workOrderNumber,
    String? workContent,
    String? departmentName,
    String? operatorName,
    bool? isDraft,
    String? ordering,
    String? todo,
  }) async {
    _lastSearchFilter = search;
    _lastStatusFilter = status;
    final filtered = _tasks.where((t) {
      var matches = true;
      if (search != null && search.isNotEmpty) {
        matches = matches && (t.workOrderNumber == search || t.workContent?.contains(search) == true);
      }
      if (status != null && status.isNotEmpty) {
        matches = matches && t.status == status;
      }
      return matches;
    }).toList();

    return TaskPageDto(
      items: filtered
          .map((t) => TaskDto(
                id: t.id,
                workContent: t.workContent,
                status: t.status,
                workOrderNumber: t.workOrderNumber,
                workOrderId: t.workOrderId,
              ))
          .toList(),
      total: filtered.length,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Map<String, dynamic>> getSummary({
    String? search,
    String? status,
    String? priority,
    int? departmentId,
    int? processId,
    String? todo,
  }) async {
    return {};
  }

  @override
  Future<TaskListFilterOptions> loadFilterOptions() async {
    return const TaskListFilterOptions(departments: [], processes: []);
  }

  @override
  Future<TaskExportResult> export(Map<String, dynamic> params) async {
    return TaskExportResult(
      bytes: Uint8List(0),
      filename: 'tasks.xlsx',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> loadOperators(int departmentId) async {
    return [];
  }

  @override
  Future<List<TaskDepartmentOption>> loadProcessDepartments(int processId) async {
    return [];
  }

  @override
  Future<void> updateQuantity(int taskId, Map<String, dynamic> payload) async {}

  @override
  Future<void> completeTask(int taskId, Map<String, dynamic> payload) async {}

  @override
  Future<void> assignTask(
    int taskId, {
    required int operatorId,
    required String notes,
  }) async {}
}

void main() {
  group('E2E: WorkOrder → Task Flow', () {
    late _MockWorkOrderRepository workOrderRepo;
    late _MockTaskRepository taskRepo;
    late WorkOrderViewModel workOrderVm;
    late TaskViewModel taskVm;

    setUp(() {
      workOrderRepo = _MockWorkOrderRepository();
      taskRepo = _MockTaskRepository();
      workOrderVm = WorkOrderViewModel(workOrderRepo);
      taskVm = TaskViewModel(taskRepo);
    });

    tearDown(() {
      workOrderVm.dispose();
      taskVm.dispose();
    });

    test('完整流程：创建 → 提交审核 → 审批通过 → 生成任务 → 查询任务', () async {
      // Step 1: 创建施工单
      final created = await workOrderVm.createWorkOrder({
        'customer_name': '测试客户',
        'total_amount': 5000.0,
      });
      expect(created.orderNumber, startsWith('WO'));
      expect(created.approvalStatus, equals('draft'));
      expect(workOrderRepo.callLog, contains('createWorkOrder'));

      final workOrderId = created.id;

      // Step 2: 提交审核
      final submitted = await workOrderVm.submitApproval(workOrderId);
      expect(submitted.approvalStatus, equals('pending_review'));
      expect(workOrderVm.lastTaskGeneration, isNotNull);
      expect(workOrderVm.lastTaskGeneration?['generated'], isFalse);

      // Step 3: 审批通过（触发任务生成）
      final approved = await workOrderVm.approveWorkOrder(workOrderId);
      expect(approved.approvalStatus, equals('approved'));
      expect(workOrderVm.lastTaskGeneration, isNotNull);
      expect(workOrderVm.lastTaskGeneration?['generated'], isTrue);
      expect(workOrderVm.lastTaskGeneration?['count'], equals(3));

      // Step 4: 模拟后端生成任务后，TaskRepository 能查询到
      taskRepo.seedTasksForWorkOrder(approved.orderNumber, [
        Task(
          id: 1,
          workContent: '印刷工序',
          status: 'pending',
          workOrderId: workOrderId,
          workOrderNumber: approved.orderNumber,
        ),
        Task(
          id: 2,
          workContent: '覆膜工序',
          status: 'pending',
          workOrderId: workOrderId,
          workOrderNumber: approved.orderNumber,
        ),
        Task(
          id: 3,
          workContent: '模切工序',
          status: 'pending',
          workOrderId: workOrderId,
          workOrderNumber: approved.orderNumber,
        ),
      ]);

      // Step 5: TaskViewModel 按施工单号查询任务
      await taskVm.applyRoutePrefill(search: approved.orderNumber);
      await taskVm.loadTasks(resetPage: true);

      expect(taskRepo.lastSearchFilter, equals(approved.orderNumber));
      expect(taskVm.tasks.length, equals(3));
      expect(taskVm.tasks.map((t) => t.workContent).toList(),
          containsAll(['印刷工序', '覆膜工序', '模切工序']));

      // Step 6: 验证调用顺序
      final expectedCalls = [
        'createWorkOrder',
        'getWorkOrders',
        'submitApproval:$workOrderId',
        'approveWorkOrder:$workOrderId',
      ];
      for (final call in expectedCalls) {
        expect(workOrderRepo.callLog, contains(call));
      }
    });

    test('审批通过后列表刷新包含最新状态', () async {
      final created = await workOrderVm.createWorkOrder({
        'customer_name': '刷新测试客户',
      });
      final id = created.id;

      await workOrderVm.approveWorkOrder(id);
      await workOrderVm.loadWorkOrders(resetPage: true);

      final approvedOrder = workOrderVm.workOrders.firstWhere((o) => o.id == id);
      expect(approvedOrder.approvalStatus, equals('approved'));
    });

    test('任务筛选：按状态查询审批后的施工单任务', () async {
      final created = await workOrderVm.createWorkOrder({
        'customer_name': '筛选测试客户',
      });
      final id = created.id;
      await workOrderVm.approveWorkOrder(id);

      taskRepo.seedTasksForWorkOrder(created.orderNumber, [
        Task(
          id: 10,
          workContent: '待认领任务',
          status: 'pending',
          workOrderId: id,
          workOrderNumber: created.orderNumber,
        ),
        Task(
          id: 11,
          workContent: '进行中任务',
          status: 'in_progress',
          workOrderId: id,
          workOrderNumber: created.orderNumber,
        ),
      ]);

      await taskVm.applyRoutePrefill(
        search: created.orderNumber,
        status: 'pending',
      );
      await taskVm.loadTasks(resetPage: true);

      expect(taskVm.tasks.length, equals(1));
      expect(taskVm.tasks.first.status, equals('pending'));
      expect(taskVm.tasks.first.workContent, equals('待认领任务'));
    });
  });
}
