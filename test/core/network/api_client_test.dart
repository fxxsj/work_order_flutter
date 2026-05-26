import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/models/api_response.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('ApiResponse', () {
    test('fromJson parses success response', () {
      final json = {
        'success': true,
        'data': {'id': 1, 'name': 'test'},
        'message': 'OK',
      };
      final response = ApiResponse.fromJson(json);
      expect(response.success, isTrue);
      expect(response.data, equals({'id': 1, 'name': 'test'}));
      expect(response.message, equals('OK'));
    });

    test('fromJson parses error response', () {
      final json = {
        'success': false,
        'code': '100001',
        'message': 'Unauthorized',
      };
      final response = ApiResponse.fromJson(json);
      expect(response.success, isFalse);
      expect(response.code, equals(100001));
      expect(response.message, equals('Unauthorized'));
    });

    test('fromJson handles missing fields', () {
      final json = <String, dynamic>{};
      final response = ApiResponse.fromJson(json);
      expect(response.success, isFalse);
      expect(response.data, isNull);
    });

    test('fromJson handles null payload as success', () {
      final response = ApiResponse.fromJson(null);
      expect(response.success, isTrue);
      expect(response.data, isNull);
    });

    test('fromJson handles non-map payload as success with data', () {
      final response = ApiResponse.fromJson('string data');
      expect(response.success, isTrue);
      expect(response.data, equals('string data'));
    });

    test('fromJson passes through ApiResponse instance', () {
      final original = ApiResponse(
        success: true,
        data: {'id': 1},
        message: 'test',
      );
      final result = ApiResponse.fromJson(original);
      expect(result.success, equals(original.success));
      expect(result.data, equals(original.data));
    });

    test('copyWith creates new instance with updated values', () {
      final original = ApiResponse(
        success: true,
        data: {'id': 1},
        message: 'test',
      );
      final updated = original.copyWith(success: false, message: 'updated');
      expect(updated.success, isFalse);
      expect(updated.message, equals('updated'));
      expect(updated.data, equals({'id': 1}));
    });

    test('code is parsed as int', () {
      final response = ApiResponse.fromJson({
        'success': false,
        'code': 100001,
        'message': 'Error',
      });
      expect(response.code, equals(100001));
    });

    test('message is converted to string', () {
      final response = ApiResponse.fromJson({
        'success': false,
        'message': 123,
      });
      expect(response.message, equals('123'));
    });

    test('data field is preserved', () {
      final response = ApiResponse.fromJson({
        'success': true,
        'data': {
          'items': [1, 2, 3]
        },
      });
      expect(
          response.data,
          equals({
            'items': [1, 2, 3]
          }));
    });

    test('errors field is preserved', () {
      final response = ApiResponse.fromJson({
        'success': false,
        'errors': {
          'field': ['error1', 'error2']
        },
      });
      expect(
          response.errors,
          equals({
            'field': ['error1', 'error2']
          }));
    });
  });
}
