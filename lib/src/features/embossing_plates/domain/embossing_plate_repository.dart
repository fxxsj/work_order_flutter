import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';

abstract class EmbossingPlateRepository {
  Future<PageData<EmbossingPlate>> getEmbossingPlates({
    required int page,
    required int pageSize,
    String? search,
    bool? confirmed,
    String? ordering,
  });

  Future<EmbossingPlate> createEmbossingPlate(EmbossingPlate plate);

  Future<EmbossingPlate> updateEmbossingPlate(EmbossingPlate plate);

  Future<void> deleteEmbossingPlate(int id);

  Future<void> confirmEmbossingPlate(int id);

  Future<EmbossingPlateImage> uploadEmbossingPlateImage(
    int plateId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  });

  Future<void> deleteEmbossingPlateImage(int plateId, int imageId);
}
