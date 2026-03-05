import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';

abstract class EmbossingPlateRepository {
  Future<PageData<EmbossingPlate>> getEmbossingPlates({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<void> createEmbossingPlate(EmbossingPlate plate);

  Future<void> updateEmbossingPlate(EmbossingPlate plate);

  Future<void> deleteEmbossingPlate(int id);

  Future<void> confirmEmbossingPlate(int id);
}
