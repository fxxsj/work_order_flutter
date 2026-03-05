import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate_repository.dart';

class EmbossingPlateViewModel extends PaginatedViewModel<EmbossingPlate> {
  EmbossingPlateViewModel(this._repository);

  final EmbossingPlateRepository _repository;

  List<EmbossingPlate> get embossingPlates => items;

  Future<void> initialize() async {
    await loadEmbossingPlates(resetPage: true);
  }

  Future<void> loadEmbossingPlates({bool resetPage = false}) => loadItems(resetPage: resetPage);

  @override
  Future<PageData<EmbossingPlate>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getEmbossingPlates(page: page, pageSize: pageSize, search: search);
  }

  Future<void> createEmbossingPlate(EmbossingPlate plate) async {
    await _repository.createEmbossingPlate(plate);
    await loadItems(resetPage: true);
  }

  Future<void> updateEmbossingPlate(EmbossingPlate plate) async {
    await _repository.updateEmbossingPlate(plate);
    await loadItems();
  }

  Future<void> deleteEmbossingPlate(int id) async {
    await deleteAndReload(() => _repository.deleteEmbossingPlate(id));
  }

  Future<void> confirmEmbossingPlate(int id) async {
    await _repository.confirmEmbossingPlate(id);
    await loadItems();
  }
}
