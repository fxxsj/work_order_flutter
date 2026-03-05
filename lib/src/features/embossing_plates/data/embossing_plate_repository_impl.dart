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
  }) async {
    final response = await _api.fetchEmbossingPlates(
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
  Future<void> createEmbossingPlate(EmbossingPlate plate) async {
    await _api.createEmbossingPlate(EmbossingPlateDto.fromEntity(plate));
  }

  @override
  Future<void> updateEmbossingPlate(EmbossingPlate plate) async {
    await _api.updateEmbossingPlate(EmbossingPlateDto.fromEntity(plate));
  }

  @override
  Future<void> deleteEmbossingPlate(int id) async {
    await _api.deleteEmbossingPlate(id);
  }

  @override
  Future<void> confirmEmbossingPlate(int id) async {
    await _api.confirmEmbossingPlate(id);
  }
}
