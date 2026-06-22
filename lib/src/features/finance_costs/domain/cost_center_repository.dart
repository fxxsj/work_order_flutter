import 'package:work_order_app/src/core/models/generic_record.dart';

abstract class CostCenterRepository {
  Future<GenericRecord> createRecord(Map<String, dynamic> payload);

  Future<GenericRecord> updateRecord(int id, Map<String, dynamic> payload);

  Future<void> deleteRecord(int id);
}
