import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate_repository.dart';

class FoilingPlateViewModel extends PaginatedViewModel<FoilingPlate> {
  FoilingPlateViewModel(this._repository);

  final FoilingPlateRepository _repository;

  List<FoilingPlate> get foilingPlates => items;

  Future<void> initialize() async {
    await loadFoilingPlates(resetPage: true);
  }

  Future<void> loadFoilingPlates({bool resetPage = false}) => loadItems(resetPage: resetPage);

  @override
  Future<PageData<FoilingPlate>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getFoilingPlates(page: page, pageSize: pageSize, search: search);
  }

  Future<void> createFoilingPlate(FoilingPlate plate) async {
    await _repository.createFoilingPlate(plate);
    await loadItems(resetPage: true);
  }

  Future<void> updateFoilingPlate(FoilingPlate plate) async {
    await _repository.updateFoilingPlate(plate);
    await loadItems();
  }

  Future<void> deleteFoilingPlate(int id) async {
    await deleteAndReload(() => _repository.deleteFoilingPlate(id));
  }

  Future<void> confirmFoilingPlate(int id) async {
    await _repository.confirmFoilingPlate(id);
    await loadItems();
  }
}
