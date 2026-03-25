import 'package:work_order_app/src/core/data/generic_repository.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/viewmodels/paginated_view_model.dart';

class GenericListViewModel extends PaginatedViewModel<GenericRecord> {
  GenericListViewModel(this._repository);

  final GenericRepository _repository;
  Map<String, dynamic> _extraParams = const {};

  List<GenericRecord> get records => items;
  Map<String, dynamic> get extraParams => _extraParams;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> reload({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  Future<void> applyRoutePrefill({
    String? search,
    Map<String, dynamic>? extraParams,
  }) async {
    setSearchText(search?.trim() ?? '');
    _extraParams = Map<String, dynamic>.from(extraParams ?? const {});
    await reload(resetPage: true);
  }

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
      extraParams: _extraParams.isEmpty ? null : _extraParams,
    );
  }
}
