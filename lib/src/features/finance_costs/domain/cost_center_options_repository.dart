import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/features/finance_costs/domain/cost_center_form_options.dart';

abstract class CostCenterOptionsRepository {
  Future<CostCenterFormOptions> loadOptions({GenericRecord? currentRecord});
}
