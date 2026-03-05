import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';

abstract class ArtworkRepository {
  Future<PageData<Artwork>> getArtworks({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<void> createArtwork(Artwork artwork);

  Future<void> updateArtwork(Artwork artwork);

  Future<void> deleteArtwork(int id);

  Future<void> confirmArtwork(int id);

  Future<void> createVersion(int id);
}
