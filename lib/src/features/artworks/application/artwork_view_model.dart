import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork_repository.dart';

class ArtworkViewModel extends PaginatedViewModel<Artwork> {
  ArtworkViewModel(this._repository);

  final ArtworkRepository _repository;
  bool? _confirmed;
  String? _ordering;

  List<Artwork> get artworks => items;
  bool? get confirmed => _confirmed;
  String? get ordering => _ordering;

  Future<void> initialize() async {
    await loadArtworks(resetPage: true);
  }

  Future<void> loadArtworks({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  void setConfirmed(bool? value) {
    _confirmed = value;
    loadItems(resetPage: true);
  }

  void setOrdering(String? value) {
    _ordering = value;
    loadItems(resetPage: true);
  }

  @override
  Future<PageData<Artwork>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getArtworks(
      page: page,
      pageSize: pageSize,
      search: search,
      confirmed: _confirmed,
      ordering: _ordering,
    );
  }

  Future<Artwork> createArtwork(Artwork artwork) async {
    final saved = await _repository.createArtwork(artwork);
    await loadItems(resetPage: true);
    return saved;
  }

  Future<Artwork> updateArtwork(Artwork artwork) async {
    final saved = await _repository.updateArtwork(artwork);
    await loadItems();
    return saved;
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

  Future<ArtworkImage> uploadArtworkImage(
    int artworkId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  }) async {
    return await _repository.uploadArtworkImage(
      artworkId,
      imageFile,
      sortOrder: sortOrder,
      description: description,
    );
  }

  Future<void> deleteArtworkImage(int artworkId, int imageId) async {
    await _repository.deleteArtworkImage(artworkId, imageId);
    await loadItems();
  }
}
