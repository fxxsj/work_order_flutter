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
  Future<void> createDie(Die die) async {
    await _api.createDie(DieDto.fromEntity(die));
  }

  @override
  Future<void> updateDie(Die die) async {
    await _api.updateDie(DieDto.fromEntity(die));
  }

  @override
  Future<void> deleteDie(int id) async {
    await _api.deleteDie(id);
  }

  @override
  Future<void> confirmDie(int id) async {
    await _api.confirmDie(id);
  }
}
