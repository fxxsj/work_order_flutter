import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork_repository.dart';

class ArtworkViewModel extends PaginatedViewModel<Artwork> {
  ArtworkViewModel(this._repository);

  final ArtworkRepository _repository;

  List<Artwork> get artworks => items;

  Future<void> initialize() async {
    await loadArtworks(resetPage: true);
  }

  Future<void> loadArtworks({bool resetPage = false}) => loadItems(resetPage: resetPage);

  @override
  Future<PageData<Artwork>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getArtworks(page: page, pageSize: pageSize, search: search);
  }

  Future<void> createArtwork(Artwork artwork) async {
    await _repository.createArtwork(artwork);
    await loadItems(resetPage: true);
  }

  Future<void> updateArtwork(Artwork artwork) async {
    await _repository.updateArtwork(artwork);
    await loadItems();
  }

  Future<void> deleteArtwork(int id) async {
    await deleteAndReload(() => _repository.deleteArtwork(id));
  }

  Future<void> confirmArtwork(int id) async {
    await _repository.confirmArtwork(id);
    await loadItems();
  }

  Future<void> createVersion(int id) async {
    await _repository.createVersion(id);
    await loadItems();
  }
}
