import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';

abstract class FoilingPlateRepository {
  Future<PageData<FoilingPlate>> getFoilingPlates({
    required int page,
    required int pageSize,
    String? search,
    bool? confirmed,
    String? foilingType,
    String? ordering,
  });

  Future<FoilingPlate> getFoilingPlate(int id);

  Future<FoilingPlate> createFoilingPlate(FoilingPlate plate);

  Future<FoilingPlate> updateFoilingPlate(FoilingPlate plate);

  Future<void> deleteFoilingPlate(int id);

  Future<void> confirmFoilingPlate(int id);

  Future<FoilingPlateImage> uploadFoilingPlateImage(
    int plateId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  });

  Future<void> deleteFoilingPlateImage(int plateId, int imageId);
}
