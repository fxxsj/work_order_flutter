import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate_repository.dart';

class FoilingPlateViewModel extends PaginatedViewModel<FoilingPlate> {
  FoilingPlateViewModel(this._repository);

  final FoilingPlateRepository _repository;

  bool? _confirmed;
  String? _foilingType;
  String? _ordering;

  List<FoilingPlate> get foilingPlates => items;

  bool? get confirmed => _confirmed;

  String? get foilingType => _foilingType;

  String? get ordering => _ordering;

  Future<void> initialize() async {
    await loadFoilingPlates(resetPage: true);
  }

  Future<void> loadFoilingPlates({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  void setConfirmed(bool? value) {
    _confirmed = value;
    loadItems(resetPage: true);
  }

  void setFoilingType(String? value) {
    _foilingType = value;
    loadItems(resetPage: true);
  }

  void setOrdering(String? value) {
    _ordering = value;
    loadItems(resetPage: true);
  }

  @override
  Future<PageData<FoilingPlate>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getFoilingPlates(
      page: page,
      pageSize: pageSize,
      search: search,
      confirmed: _confirmed,
      foilingType: _foilingType,
      ordering: _ordering,
    );
  }

  Future<FoilingPlate> createFoilingPlate(FoilingPlate plate) async {
    final saved = await _repository.createFoilingPlate(plate);
    await loadItems(resetPage: true);
    return saved;
  }

  Future<FoilingPlate> updateFoilingPlate(FoilingPlate plate) async {
    final saved = await _repository.updateFoilingPlate(plate);
    await loadItems();
    return saved;
  }

  Future<void> deleteFoilingPlate(int id) async {
    await deleteAndReload(() => _repository.deleteFoilingPlate(id));
  }

  Future<void> confirmFoilingPlate(int id) async {
    await _repository.confirmFoilingPlate(id);
    await loadItems();
  }

  Future<FoilingPlateImage> uploadFoilingPlateImage(
    int plateId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  }) async {
    return await _repository.uploadFoilingPlateImage(
      plateId,
      imageFile,
      sortOrder: sortOrder,
      description: description,
    );
  }

  Future<void> deleteFoilingPlateImage(int plateId, int imageId) async {
    await _repository.deleteFoilingPlateImage(plateId, imageId);
    await loadItems();
  }
}
