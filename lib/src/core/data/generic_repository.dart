import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';

abstract class GenericRepository {
  Future<PageData<GenericRecord>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
    Map<String, dynamic>? extraParams,
  });

  Future<GenericRecord> createRecord(Map<String, dynamic> payload);

  Future<GenericRecord> updateRecord(int id, Map<String, dynamic> payload);

  Future<void> deleteRecord(int id);
}
