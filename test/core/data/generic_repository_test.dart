import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/data/generic_repository.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';

/// Mock GenericApiService for testing GenericRepositoryImpl
class MockGenericApiService implements GenericRepository {
  List<Map<String, dynamic>> mockData = [];
  int mockTotal = 0;
  bool shouldFail = false;
  Map<String, dynamic>? lastParams;

  @override
  Future<PageData<GenericRecord>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
    Map<String, dynamic>? extraParams,
  }) async {
    if (shouldFail) throw Exception('Fetch failed');
    lastParams = {'page': page, 'pageSize': pageSize, 'search': search, 'extraParams': extraParams};
    final start = (page - 1) * pageSize;
    final items = mockData
        .skip(start)
        .take(pageSize)
        .map((e) => GenericRecord(id: e['id'] as int, data: e))
        .toList();
    return PageData(
      items: items,
      total: mockTotal,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Map<String, dynamic>> fetchSummary({Map<String, dynamic>? extraParams}) async {
    if (shouldFail) throw Exception('Summary failed');
    lastParams = {'extraParams': extraParams};
    return {'total': mockTotal, 'count': mockData.length};
  }

  @override
  Future<GenericRecord> createRecord(Map<String, dynamic> payload) async {
    if (shouldFail) throw Exception('Create failed');
    final id = mockData.length + 1;
    final record = {'id': id, ...payload};
    mockData.add(record);
    return GenericRecord(id: id, data: record);
  }

  @override
  Future<GenericRecord> updateRecord(int id, Map<String, dynamic> payload) async {
    if (shouldFail) throw Exception('Update failed');
    final index = mockData.indexWhere((e) => e['id'] == id);
    if (index == -1) throw Exception('Not found');
    mockData[index] = {...mockData[index], ...payload};
    return GenericRecord(id: id, data: mockData[index]);
  }

  @override
  Future<void> deleteRecord(int id) async {
    if (shouldFail) throw Exception('Delete failed');
    mockData.removeWhere((e) => e['id'] == id);
  }
}

void main() {
  group('GenericRepository', () {
    late MockGenericApiService repository;

    setUp(() {
      repository = MockGenericApiService();
      repository.mockData = [
        {'id': 1, 'name': 'Item 1'},
        {'id': 2, 'name': 'Item 2'},
        {'id': 3, 'name': 'Item 3'},
      ];
      repository.mockTotal = 3;
    });

    group('fetchPage', () {
      test('returns paginated data', () async {
        final result = await repository.fetchPage(page: 1, pageSize: 2);
        expect(result.items.length, equals(2));
        expect(result.total, equals(3));
        expect(result.page, equals(1));
        expect(result.pageSize, equals(2));
      });

      test('returns empty items for out of range page', () async {
        final result = await repository.fetchPage(page: 10, pageSize: 10);
        expect(result.items.length, equals(0));
      });

      test('hasNext is true when more pages exist', () async {
        final result = await repository.fetchPage(page: 1, pageSize: 2);
        expect(result.hasNext, isTrue);
      });

      test('hasNext is false on last page', () async {
        final result = await repository.fetchPage(page: 2, pageSize: 2);
        expect(result.hasNext, isFalse);
      });

      test('throws exception when shouldFail is true', () async {
        repository.shouldFail = true;
        expect(
          () => repository.fetchPage(page: 1, pageSize: 10),
          throwsException,
        );
      });
    });

    group('fetchSummary', () {
      test('returns summary data', () async {
        final result = await repository.fetchSummary();
        expect(result['total'], equals(3));
        expect(result['count'], equals(3));
      });

      test('throws exception when shouldFail is true', () async {
        repository.shouldFail = true;
        expect(
          () => repository.fetchSummary(),
          throwsException,
        );
      });
    });

    group('createRecord', () {
      test('creates and returns new record', () async {
        final result = await repository.createRecord({'name': 'New Item'});
        expect(result.data['id'], equals(4));
        expect(result.data['name'], equals('New Item'));
        expect(repository.mockData.length, equals(4));
      });

      test('throws exception when shouldFail is true', () async {
        repository.shouldFail = true;
        expect(
          () => repository.createRecord({'name': 'Test'}),
          throwsException,
        );
      });
    });

    group('updateRecord', () {
      test('updates and returns record', () async {
        final result = await repository.updateRecord(1, {'name': 'Updated'});
        expect(result.data['name'], equals('Updated'));
      });

      test('throws exception when record not found', () async {
        expect(
          () => repository.updateRecord(999, {'name': 'Test'}),
          throwsException,
        );
      });

      test('throws exception when shouldFail is true', () async {
        repository.shouldFail = true;
        expect(
          () => repository.updateRecord(1, {'name': 'Test'}),
          throwsException,
        );
      });
    });

    group('deleteRecord', () {
      test('removes record', () async {
        await repository.deleteRecord(1);
        expect(repository.mockData.length, equals(2));
        expect(repository.mockData.any((e) => e['id'] == 1), isFalse);
      });

      test('throws exception when shouldFail is true', () async {
        repository.shouldFail = true;
        expect(
          () => repository.deleteRecord(1),
          throwsException,
        );
      });
    });
  });

  group('GenericRecord', () {
    test('constructor creates record', () {
      final record = GenericRecord(id: 1, data: {'name': 'Test'});
      expect(record.id, equals(1));
      expect(record.data['name'], equals('Test'));
    });

    test('getNumber returns num value', () {
      final record = GenericRecord(id: 1, data: {'id': 42});
      expect(record.getNumber('id'), equals(42));
    });

    test('getNumber returns null for missing key', () {
      final record = GenericRecord(id: 1, data: {});
      expect(record.getNumber('id'), isNull);
    });

    test('getNumber returns null for non-num value', () {
      final record = GenericRecord(id: 1, data: {'id': 'not a number'});
      expect(record.getNumber('id'), isNull);
    });

    test('getString returns string value', () {
      final record = GenericRecord(id: 1, data: {'name': 'Hello'});
      expect(record.getString('name'), equals('Hello'));
    });

    test('getString returns null for missing key', () {
      final record = GenericRecord(id: 1, data: {});
      expect(record.getString('name'), isNull);
    });

    test('getBool returns bool value', () {
      final record = GenericRecord(id: 1, data: {'active': true});
      expect(record.getBool('active'), isTrue);
    });

    test('getBool returns null for missing key', () {
      final record = GenericRecord(id: 1, data: {});
      expect(record.getBool('active'), isNull);
    });

    test('getDateTime returns DateTime', () {
      final record = GenericRecord(id: 1, data: {'date': '2026-05-15T10:00:00Z'});
      expect(record.getDateTime('date'), isA<DateTime>());
    });

    test('getDateTime returns null for missing key', () {
      final record = GenericRecord(id: 1, data: {});
      expect(record.getDateTime('date'), isNull);
    });

    test('data returns original map', () {
      final data = {'id': 1, 'name': 'Test'};
      final record = GenericRecord(id: 1, data: data);
      expect(record.data, equals(data));
    });
  });
}