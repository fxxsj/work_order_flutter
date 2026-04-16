import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_api_service.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_dto.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate_repository.dart';

class FoilingPlateRepositoryImpl implements FoilingPlateRepository {
  FoilingPlateRepositoryImpl(this._api);

  final FoilingPlateApiService _api;

  @override
  Future<PageData<FoilingPlate>> getFoilingPlates({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final response = await _api.fetchFoilingPlates(
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return PageData(
      items: response.items.map((item) => item.toEntity()).toList(),
      total: response.total,
      page: response.page,
      pageSize: response.pageSize,
    );
  }

  @override
  Future<FoilingPlate> createFoilingPlate(FoilingPlate plate) async {
    final dto = await _api.createFoilingPlate(FoilingPlateDto.fromEntity(plate));
    return dto.toEntity();
  }

  @override
  Future<FoilingPlate> updateFoilingPlate(FoilingPlate plate) async {
    final dto = await _api.updateFoilingPlate(FoilingPlateDto.fromEntity(plate));
    return dto.toEntity();
  }

  @override
  Future<void> deleteFoilingPlate(int id) async {
    await _api.deleteFoilingPlate(id);
  }

  @override
  Future<void> confirmFoilingPlate(int id) async {
    await _api.confirmFoilingPlate(id);
  }

  @override
  Future<FoilingPlateImage> uploadFoilingPlateImage(int plateId, MultipartFile imageFile, {int sortOrder = 0, String? description}) async {
    return await _api.uploadImage(plateId, imageFile, sortOrder: sortOrder, description: description);
  }

  @override
  Future<void> deleteFoilingPlateImage(int plateId, int imageId) async {
    await _api.deleteImage(plateId, imageId);
  }
}
