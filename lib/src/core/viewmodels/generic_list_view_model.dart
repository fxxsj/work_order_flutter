import 'package:work_order_app/src/core/data/generic_repository.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/viewmodels/paginated_view_model.dart';

class GenericListViewModel extends PaginatedViewModel<GenericRecord> {
  GenericListViewModel(this._repository, {this.enableSummary = false});

  final GenericRepository _repository;
  final bool enableSummary;
  Map<String, dynamic> _extraParams = const {};
  Map<String, dynamic> _summary = const {};

  List<GenericRecord> get records => items;
  Map<String, dynamic> get extraParams => _extraParams;
  Map<String, dynamic> get summary => _summary;

  Future<void> initialize() => reload(resetPage: true);

  Future<void> reload({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    await _loadSummary();
  }

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

  Future<void> _loadSummary() async {
    if (!enableSummary) return;
    try {
      _summary = await _repository.fetchSummary(
        extraParams: _extraParams.isEmpty ? null : _extraParams,
      );
      safeNotify();
    } catch (_) {
      // Summary is supplemental; ignore failures to keep the list available.
    }
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
