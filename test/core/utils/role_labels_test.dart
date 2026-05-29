import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/utils/role_labels.dart';

void main() {
  group('RoleLabels', () {
    group('label', () {
      test('返回已知角色代码的正确标签', () {
        expect(RoleLabels.label('sales'), equals('业务员'));
        expect(RoleLabels.label('supervisor'), equals('主管'));
        expect(RoleLabels.label('manager'), equals('经理'));
        expect(RoleLabels.label('operator'), equals('操作员'));
        expect(RoleLabels.label('finance'), equals('财务'));
        expect(RoleLabels.label('procurement'), equals('采购'));
        expect(RoleLabels.label('design'), equals('设计/制版'));
        expect(RoleLabels.label('inventory'), equals('仓储'));
        expect(RoleLabels.label('quality'), equals('质检'));
        expect(RoleLabels.label('admin'), equals('系统管理员'));
      });

      test('对于未知角色代码，返回原始代码', () {
        expect(RoleLabels.label('unknown'), equals('unknown'));
        expect(RoleLabels.label('admin2'), equals('admin2'));
        expect(RoleLabels.label(''), equals(''));
      });
    });

    group('labels Map', () {
      test('包含所有预期的角色', () {
        expect(
          RoleLabels.labels.keys,
          containsAll([
            'sales',
            'supervisor',
            'manager',
            'operator',
            'finance',
            'procurement',
            'design',
            'inventory',
            'quality',
            'admin',
          ]),
        );
      });

      test('每个角色都有非空标签', () {
        for (final entry in RoleLabels.labels.entries) {
          expect(
            entry.value.isNotEmpty,
            isTrue,
            reason: '角色 ${entry.key} 的标签为空',
          );
        }
      });
    });

    group('salesPermissions', () {
      test('包含预期的权限', () {
        expect(
          RoleLabels.salesPermissions,
          contains('workorder.view_salesorder'),
        );
        expect(
          RoleLabels.salesPermissions,
          contains('workorder.add_salesorder'),
        );
        expect(
          RoleLabels.salesPermissions,
          contains('workorder.change_salesorder'),
        );
        expect(
          RoleLabels.salesPermissions,
          contains('workorder.view_customer'),
        );
      });

      test('不包含生产相关权限', () {
        expect(
          RoleLabels.salesPermissions,
          isNot(contains('workorder.view_workorder')),
        );
      });
    });

    group('productionPermissions', () {
      test('包含工单相关权限', () {
        expect(
          RoleLabels.productionPermissions,
          contains('workorder.view_workorder'),
        );
        expect(
          RoleLabels.productionPermissions,
          contains('workorder.add_workorder'),
        );
        expect(
          RoleLabels.productionPermissions,
          contains('workorder.change_workorder'),
        );
      });

      test('不包含销售相关权限', () {
        expect(
          RoleLabels.productionPermissions,
          isNot(contains('workorder.view_salesorder')),
        );
      });
    });

    group('financePermissions', () {
      test('包含财务相关权限', () {
        expect(
          RoleLabels.financePermissions,
          contains('workorder.view_invoice'),
        );
        expect(
          RoleLabels.financePermissions,
          contains('workorder.add_invoice'),
        );
        expect(
          RoleLabels.financePermissions,
          contains('workorder.view_payment'),
        );
      });
    });

    group('procurementPermissions', () {
      test('包含采购相关权限', () {
        expect(
          RoleLabels.procurementPermissions,
          contains('workorder.view_purchaseorder'),
        );
        expect(
          RoleLabels.procurementPermissions,
          contains('workorder.add_purchaseorder'),
        );
        expect(
          RoleLabels.procurementPermissions,
          contains('workorder.change_purchaseorder'),
        );
        expect(
          RoleLabels.procurementPermissions,
          contains('workorder.view_supplier'),
        );
      });
    });

    group('designPermissions', () {
      test('包含设计/制版相关权限', () {
        expect(
          RoleLabels.designPermissions,
          contains('workorder.view_artwork'),
        );
        expect(RoleLabels.designPermissions, contains('workorder.add_artwork'));
        expect(RoleLabels.designPermissions, contains('workorder.change_die'));
        expect(
          RoleLabels.designPermissions,
          contains('workorder.change_workordertask'),
        );
      });
    });

    group('inventoryPermissions', () {
      test('包含仓储相关权限', () {
        expect(
          RoleLabels.inventoryPermissions,
          contains('workorder.view_productstock'),
        );
        expect(
          RoleLabels.inventoryPermissions,
          contains('workorder.change_productstock'),
        );
        expect(
          RoleLabels.inventoryPermissions,
          contains('workorder.view_stockin'),
        );
      });
    });

    group('qualityPermissions', () {
      test('包含质检相关权限', () {
        expect(
          RoleLabels.qualityPermissions,
          contains('workorder.view_qualityinspection'),
        );
        expect(
          RoleLabels.qualityPermissions,
          contains('workorder.add_qualityinspection'),
        );
        expect(
          RoleLabels.qualityPermissions,
          contains('workorder.change_qualityinspection'),
        );
      });
    });

    group('systemPermissions', () {
      test('包含系统设置相关权限', () {
        expect(
          RoleLabels.systemPermissions,
          contains('workorder.view_department'),
        );
        expect(
          RoleLabels.systemPermissions,
          contains('workorder.change_department'),
        );
        expect(
          RoleLabels.systemPermissions,
          contains('workorder.view_auditlog'),
        );
      });
    });
  });
}
