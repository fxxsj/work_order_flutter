import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';

abstract class FoilingPlateRepository {
  Future<PageData<FoilingPlate>> getFoilingPlates({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<void> createFoilingPlate(FoilingPlate plate);

  Future<void> updateFoilingPlate(FoilingPlate plate);

  Future<void> deleteFoilingPlate(int id);

  Future<void> confirmFoilingPlate(int id);
}
