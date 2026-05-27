import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/dies/domain/die_repository.dart';

class DieViewModel extends PaginatedViewModel<Die> {
  DieViewModel(this._repository);

  final DieRepository _repository;

  bool? _confirmed;
  String? _dieType;
  String? _ordering;

  List<Die> get dies => items;

  bool? get confirmed => _confirmed;

  String? get dieType => _dieType;

  String? get ordering => _ordering;

  Future<void> initialize() async {
    await loadDies(resetPage: true);
  }

  Future<void> loadDies({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  void setConfirmed(bool? value) {
    _confirmed = value;
    loadItems(resetPage: true);
  }

  void setDieType(String? value) {
    _dieType = value;
    loadItems(resetPage: true);
  }

  void setOrdering(String? value) {
    _ordering = value;
    loadItems(resetPage: true);
  }

  @override
  Future<PageData<Die>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getDies(
      page: page,
      pageSize: pageSize,
      search: search,
      confirmed: _confirmed,
      dieType: _dieType,
      ordering: _ordering,
    );
  }

  Future<Die> createDie(Die die) async {
    final saved = await _repository.createDie(die);
    await loadItems(resetPage: true);
    return saved;
  }

  Future<Die> updateDie(Die die) async {
    final saved = await _repository.updateDie(die);
    await loadItems();
    return saved;
  }

  Future<void> deleteDie(int id) async {
    await deleteAndReload(() => _repository.deleteDie(id));
  }

  Future<void> confirmDie(int id) async {
    await _repository.confirmDie(id);
    await loadItems();
  }

  Future<DieImage> uploadDieImage(
    int dieId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  }) async {
    return await _repository.uploadDieImage(
      dieId,
      imageFile,
      sortOrder: sortOrder,
      description: description,
    );
  }

  Future<void> deleteDieImage(int dieId, int imageId) async {
    await _repository.deleteDieImage(dieId, imageId);
    await loadItems();
  }
}
