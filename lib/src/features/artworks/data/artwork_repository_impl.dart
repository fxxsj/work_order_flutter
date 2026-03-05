import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_api_service.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_dto.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork_repository.dart';

class ArtworkRepositoryImpl implements ArtworkRepository {
  ArtworkRepositoryImpl(this._api);

  final ArtworkApiService _api;

  @override
  Future<PageData<Artwork>> getArtworks({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final response = await _api.fetchArtworks(
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return PageData(
      items: response.items.map((item) => item.toEntity()).toList(),
      total: response.total,
      page: response.page,
      pageSize: response.pageSize,
    );
  }

  @override
  Future<void> createArtwork(Artwork artwork) async {
    await _api.createArtwork(ArtworkDto.fromEntity(artwork));
  }

  @override
  Future<void> updateArtwork(Artwork artwork) async {
    await _api.updateArtwork(ArtworkDto.fromEntity(artwork));
  }

  @override
  Future<void> deleteArtwork(int id) async {
    await _api.deleteArtwork(id);
  }

  @override
  Future<void> confirmArtwork(int id) async {
    await _api.confirmArtwork(id);
  }

  @override
  Future<void> createVersion(int id) async {
    await _api.createVersion(id);
  }
}
