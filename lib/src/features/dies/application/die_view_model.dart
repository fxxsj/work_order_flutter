import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/dies/domain/die_repository.dart';

class DieViewModel extends PaginatedViewModel<Die> {
  DieViewModel(this._repository);

  final DieRepository _repository;

  List<Die> get dies => items;

  Future<void> initialize() async {
    await loadDies(resetPage: true);
  }

  Future<void> loadDies({bool resetPage = false}) => loadItems(resetPage: resetPage);

  @override
  Future<PageData<Die>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getDies(page: page, pageSize: pageSize, search: search);
  }

  Future<void> createDie(Die die) async {
    await _repository.createDie(die);
    await loadItems(resetPage: true);
  }

  Future<void> updateDie(Die die) async {
    await _repository.updateDie(die);
    await loadItems();
  }

  Future<void> deleteDie(int id) async {
    await deleteAndReload(() => _repository.deleteDie(id));
  }

  Future<void> confirmDie(int id) async {
    await _repository.confirmDie(id);
    await loadItems();
  }
}
