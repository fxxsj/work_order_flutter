import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';

void main() {
  group('MaterialDto', () {
    test('toPayload includes is_active when set', () {
      final dto = MaterialDto(
        id: 1,
        code: 'MAT001',
        name: 'Test Material',
        isActive: false,
      );
      final payload = dto.toPayload();
      expect(payload['is_active'], equals(false));
    });

    test('toPayload omits is_active when null', () {
      final dto = MaterialDto(
        id: 1,
        code: 'MAT001',
        name: 'Test Material',
        isActive: null,
      );
      final payload = dto.toPayload();
      expect(payload.containsKey('is_active'), isFalse);
    });

    test('toPayload includes all provided fields', () {
      final dto = MaterialDto(
        id: 1,
        code: 'MAT001',
        name: 'Test Material',
        specification: 'Spec',
        unit: 'pcs',
        unitPrice: 10.5,
        stockQuantity: 100.0,
        minStockQuantity: 10.0,
        defaultSupplier: 2,
        leadTimeDays: 5,
        needCutting: true,
        isActive: true,
        notes: 'Note',
      );
      final payload = dto.toPayload();
      expect(payload['code'], equals('MAT001'));
      expect(payload['name'], equals('Test Material'));
      expect(payload['specification'], equals('Spec'));
      expect(payload['unit'], equals('pcs'));
      expect(payload['unit_price'], equals(10.5));
      expect(payload['stock_quantity'], equals(100.0));
      expect(payload['min_stock_quantity'], equals(10.0));
      expect(payload['default_supplier'], equals(2));
      expect(payload['lead_time_days'], equals(5));
      expect(payload['need_cutting'], equals(true));
      expect(payload['is_active'], equals(true));
      expect(payload['notes'], equals('Note'));
    });

    test('fromJson parses is_active correctly', () {
      final json = {
        'id': 1,
        'code': 'MAT001',
        'name': 'Test Material',
        'is_active': false,
        'need_cutting': true,
      };
      final dto = MaterialDto.fromJson(json);
      expect(dto.isActive, isFalse);
      expect(dto.needCutting, isTrue);
    });

    test('fromJson handles missing is_active', () {
      final json = {
        'id': 1,
        'code': 'MAT001',
        'name': 'Test Material',
      };
      final dto = MaterialDto.fromJson(json);
      expect(dto.isActive, isNull);
    });

    test('toEntity preserves is_active', () {
      final dto = MaterialDto(
        id: 1,
        code: 'MAT001',
        name: 'Test Material',
        isActive: false,
      );
      final entity = dto.toEntity();
      expect(entity.isActive, isFalse);
    });
  });
}
