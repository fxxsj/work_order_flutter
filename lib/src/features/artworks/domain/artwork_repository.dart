import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';

abstract class ArtworkRepository {
  Future<PageData<Artwork>> getArtworks({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<Artwork> createArtwork(Artwork artwork);

  Future<Artwork> updateArtwork(Artwork artwork);

  Future<void> deleteArtwork(int id);

  Future<void> confirmArtwork(int id);

  Future<void> createVersion(int id);

  Future<ArtworkImage> uploadArtworkImage(int artworkId, MultipartFile imageFile, {int sortOrder = 0, String? description});

  Future<void> deleteArtworkImage(int artworkId, int imageId);
}
