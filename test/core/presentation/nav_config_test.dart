import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';

void main() {
  group('nav_config permission access', () {
    test('allows procurement users into purchase order list', () {
      final user = {
        'permissions': ['workorder.view_purchaseorder'],
      };

      expect(canAccessPath('/purchase-orders', currentUser: user), isTrue);
      expect(
        requiredPermissionsForPath('/purchase-orders'),
        contains('workorder.view_purchaseorder'),
      );
    });

    test('blocks purchase order list without view permission', () {
      final user = {
        'permissions': ['workorder.view_supplier'],
      };

      expect(canAccessPath('/purchase-orders', currentUser: user), isFalse);
    });

    test('blocks protected paths without user permissions', () {
      expect(canAccessPath('/purchase-orders'), isFalse);
      expect(canAccessPath('/workorders/create'), isFalse);
    });

    test('allows design users into plate asset pages', () {
      final user = {
        'permissions': [
          'workorder.view_artwork',
          'workorder.view_die',
          'workorder.view_foilingplate',
          'workorder.view_embossingplate',
        ],
      };

      expect(canAccessPath('/artworks', currentUser: user), isTrue);
      expect(canAccessPath('/dies', currentUser: user), isTrue);
      expect(canAccessPath('/foiling-plates', currentUser: user), isTrue);
      expect(canAccessPath('/embossing-plates', currentUser: user), isTrue);
    });

    test('allows quality users into quality inspection page', () {
      final user = {
        'permissions': ['workorder.view_qualityinspection'],
      };

      expect(canAccessPath('/inventory/quality', currentUser: user), isTrue);
    });

    test('requires add permission for create routes', () {
      expect(
        requiredPermissionsForPath('/purchase-orders'),
        isNot(contains('workorder.add_purchaseorder')),
      );
      expect(
        requiredPermissionsForPath('/workorders/create'),
        equals(['workorder.add_workorder']),
      );
      expect(
        requiredPermissionsForPath('/sales-orders/create'),
        equals(['workorder.add_salesorder']),
      );
      expect(
        requiredPermissionsForPath('/artworks/create'),
        equals(['workorder.add_artwork']),
      );
    });

    test('requires change permission for edit routes', () {
      expect(
        requiredPermissionsForPath('/workorders/42/edit'),
        equals(['workorder.change_workorder']),
      );
      expect(
        requiredPermissionsForPath('/sales-orders/42/edit'),
        equals(['workorder.change_salesorder']),
      );
      expect(
        requiredPermissionsForPath('/dies/42/edit'),
        equals(['workorder.change_die']),
      );
    });
  });
}
