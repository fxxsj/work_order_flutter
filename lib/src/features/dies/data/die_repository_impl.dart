import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/dies/data/die_api_service.dart';
import 'package:work_order_app/src/features/dies/data/die_dto.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/dies/domain/die_repository.dart';

class DieRepositoryImpl implements DieRepository {
  DieRepositoryImpl(this._api);

  final DieApiService _api;

  @override
  Future<PageData<Die>> getDies({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final response = await _api.fetchDies(
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
  Future<Die> createDie(Die die) async {
    final dto = await _api.createDie(DieDto.fromEntity(die));
    return dto.toEntity();
  }

  @override
  Future<Die> updateDie(Die die) async {
    final dto = await _api.updateDie(DieDto.fromEntity(die));
    return dto.toEntity();
  }

  @override
  Future<void> deleteDie(int id) async {
    await _api.deleteDie(id);
  }

  @override
  Future<void> confirmDie(int id) async {
    await _api.confirmDie(id);
  }

  @override
  Future<DieImage> uploadDieImage(int dieId, MultipartFile imageFile, {int sortOrder = 0, String? description}) async {
    return await _api.uploadImage(dieId, imageFile, sortOrder: sortOrder, description: description);
  }

  @override
  Future<void> deleteDieImage(int dieId, int imageId) async {
    await _api.deleteImage(dieId, imageId);
  }
}
