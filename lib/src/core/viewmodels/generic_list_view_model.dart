import 'package:work_order_app/src/core/data/generic_repository.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/viewmodels/paginated_view_model.dart';

class GenericListViewModel extends PaginatedViewModel<GenericRecord> {
  GenericListViewModel(this._repository);

  final GenericRepository _repository;

  List<GenericRecord> get records => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> reload({bool resetPage = false}) => loadItems(resetPage: resetPage);

  Future<void> deleteRecord(int id) async {
    await deleteAndReload(() => _repository.deleteRecord(id));
  }

  @override
  Future<PageData<GenericRecord>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.fetchPage(
      page: page,
      pageSize: pageSize,
      search: search,
    );
  }
}
