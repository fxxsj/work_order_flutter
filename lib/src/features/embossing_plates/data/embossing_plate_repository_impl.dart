import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_api_service.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_dto.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate_repository.dart';

class EmbossingPlateRepositoryImpl implements EmbossingPlateRepository {
  EmbossingPlateRepositoryImpl(this._api);

  final EmbossingPlateApiService _api;

  @override
  Future<PageData<EmbossingPlate>> getEmbossingPlates({
    required int page,
    required int pageSize,
    String? search,
    bool? confirmed,
    String? ordering,
  }) async {
    final response = await _api.fetchEmbossingPlates(
      page: page,
      pageSize: pageSize,
      search: search,
      confirmed: confirmed,
      ordering: ordering,
    );
    return PageData(
      items: response.items.map((item) => item.toEntity()).toList(),
      total: response.total,
      page: response.page,
      pageSize: response.pageSize,
    );
  }

  @override
  Future<EmbossingPlate> getEmbossingPlate(int id) async {
    final dto = await _api.fetchEmbossingPlate(id);
    return dto.toEntity();
  }

  @override
  Future<EmbossingPlate> createEmbossingPlate(EmbossingPlate plate) async {
    final dto = await _api.createEmbossingPlate(
      EmbossingPlateDto.fromEntity(plate),
    );
    return dto.toEntity();
  }

  @override
  Future<EmbossingPlate> updateEmbossingPlate(EmbossingPlate plate) async {
    final dto = await _api.updateEmbossingPlate(
      EmbossingPlateDto.fromEntity(plate),
    );
    return dto.toEntity();
  }

  @override
  Future<void> deleteEmbossingPlate(int id) async {
    await _api.deleteEmbossingPlate(id);
  }

  @override
  Future<void> confirmEmbossingPlate(int id) async {
    await _api.confirmEmbossingPlate(id);
  }

  @override
  Future<EmbossingPlateImage> uploadEmbossingPlateImage(
    int plateId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  }) async {
    return await _api.uploadImage(
      plateId,
      imageFile,
      sortOrder: sortOrder,
      description: description,
    );
  }

  @override
  Future<void> deleteEmbossingPlateImage(int plateId, int imageId) async {
    await _api.deleteImage(plateId, imageId);
  }
}
