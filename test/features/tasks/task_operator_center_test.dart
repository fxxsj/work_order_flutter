import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/domain/task_operator_center_result.dart';

void main() {
  group('OperatorSummary', () {
    test('fromJson parses all fields', () {
      final json = {
        'my_total': 10,
        'my_pending': 3,
        'my_in_progress': 5,
        'my_completed': 2,
        'claimable_count': 7,
      };
      final summary = OperatorSummary.fromJson(json);
      expect(summary.myTotal, 10);
      expect(summary.myPending, 3);
      expect(summary.myInProgress, 5);
      expect(summary.myCompleted, 2);
      expect(summary.claimableCount, 7);
    });

    test('fromJson handles null', () {
      final summary = OperatorSummary.fromJson(null);
      expect(summary.myTotal, 0);
      expect(summary.claimableCount, 0);
    });

    test('fromJson handles missing fields', () {
      final summary = OperatorSummary.fromJson({});
      expect(summary.myTotal, 0);
      expect(summary.myPending, 0);
      expect(summary.claimableCount, 0);
    });
  });

  group('PaginationMeta', () {
    test('fromJson parses all fields', () {
      final json = {
        'my_total': 20,
        'my_count': 10,
        'my_has_more': true,
        'claimable_total': 15,
        'claimable_count': 15,
        'claimable_has_more': false,
      };
      final meta = PaginationMeta.fromJson(json);
      expect(meta.myTotal, 20);
      expect(meta.myCount, 10);
      expect(meta.myHasMore, true);
      expect(meta.claimableTotal, 15);
      expect(meta.claimableCount, 15);
      expect(meta.claimableHasMore, false);
    });

    test('fromJson handles null', () {
      final meta = PaginationMeta.fromJson(null);
      expect(meta.myTotal, 0);
      expect(meta.myHasMore, false);
    });

    test('fromJson handles has_more=false', () {
      final meta = PaginationMeta.fromJson({'my_has_more': false});
      expect(meta.myHasMore, false);
    });
  });

  group('Task.fromJson operator_center task', () {
    test('parses task with all context fields', () {
      final json = {
        'id': 1,
        'work_content': '印刷任务',
        'status': 'pending',
        'status_display': '待开始',
        'task_type': 'production',
        'task_type_display': '生产',
        'production_quantity': 100.0,
        'quantity_completed': 50.0,
        'quantity_defective': 2.0,
        'product_name': '纸盒A',
        'product_code': 'P001',
        'artwork_name': '设计稿A',
        'artwork_code': 'A001',
        'die_name': '刀模1号',
        'die_code': 'D001',
        'material_name': '铜版纸',
        'material_code': 'M001',
        'version': 3,
        'work_order_process_info': {
          'work_order': {
            'id': 10,
            'order_number': 'WO2024001',
            'customer_name': '客户A',
          },
          'process': {'id': 5, 'name': '印刷'},
        },
      };
      final task = Task.fromJson(json);
      expect(task.id, 1);
      expect(task.workContent, '印刷任务');
      expect(task.status, 'pending');
      expect(task.productionQuantity, 100.0);
      expect(task.quantityCompleted, 50.0);
      expect(task.productName, '纸盒A');
      expect(task.artworkName, '设计稿A');
      expect(task.dieName, '刀模1号');
      expect(task.materialName, '铜版纸');
      expect(task.version, 3);
    });

    test('parses task with version for optimistic locking', () {
      final json = {'id': 5, 'status': 'in_progress', 'version': 7};
      final task = Task.fromJson(json);
      expect(task.id, 5);
      expect(task.version, 7);
    });
  });
}
