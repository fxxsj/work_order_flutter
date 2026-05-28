import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/utils/image_upload_config.dart';
import 'package:work_order_app/src/core/utils/image_upload_flow.dart';

void main() {
  group('pickAndUploadImageForResource', () {
    test('does not pick file when modification is blocked', () async {
      var picked = false;
      var uploading = false;

      await pickAndUploadImageForResource<_Resource, _Image>(
        imageCount: 0,
        fallbackFilename: 'image.jpg',
        isMounted: () => true,
        setUploading: (value) => uploading = value,
        persistResource: () async => const _Resource(1),
        resourceIdOf: (resource) => resource.id,
        uploadImage: (_, __, ___) async => const _Image(1),
        addImage: (_) {},
        isModificationBlocked: () => true,
        showError: (_) {},
        showSuccess: (_) {},
        pickImageFile: ({required fallbackFilename}) async {
          picked = true;
          return null;
        },
      );

      expect(picked, isFalse);
      expect(uploading, isFalse);
    });

    test('does not pick file when max count is reached', () async {
      var picked = false;

      await pickAndUploadImageForResource<_Resource, _Image>(
        imageCount: ImageUploadConfig.maxCount,
        fallbackFilename: 'image.jpg',
        isMounted: () => true,
        setUploading: (_) {},
        persistResource: () async => const _Resource(1),
        resourceIdOf: (resource) => resource.id,
        uploadImage: (_, __, ___) async => const _Image(1),
        addImage: (_) {},
        showError: (_) {},
        showSuccess: (_) {},
        pickImageFile: ({required fallbackFilename}) async {
          picked = true;
          return null;
        },
      );

      expect(picked, isFalse);
    });

    test('resets uploading when picking is cancelled', () async {
      final states = <bool>[];

      await pickAndUploadImageForResource<_Resource, _Image>(
        imageCount: 0,
        fallbackFilename: 'image.jpg',
        isMounted: () => true,
        setUploading: states.add,
        persistResource: () async => const _Resource(1),
        resourceIdOf: (resource) => resource.id,
        uploadImage: (_, __, ___) async => const _Image(1),
        addImage: (_) {},
        showError: (_) {},
        showSuccess: (_) {},
        pickImageFile: ({required fallbackFilename}) async => null,
      );

      expect(states, [true, false]);
    });

    test('persists resource then uploads image with sort order', () async {
      final file = MultipartFile.fromBytes([1], filename: 'image.jpg');
      final added = <_Image>[];
      var uploadedResourceId = 0;
      var uploadedSortOrder = -1;

      await pickAndUploadImageForResource<_Resource, _Image>(
        imageCount: 3,
        fallbackFilename: 'image.jpg',
        isMounted: () => true,
        setUploading: (_) {},
        persistResource: () async => const _Resource(9),
        resourceIdOf: (resource) => resource.id,
        uploadImage: (resourceId, imageFile, sortOrder) async {
          uploadedResourceId = resourceId;
          uploadedSortOrder = sortOrder;
          expect(imageFile, same(file));
          return const _Image(7);
        },
        addImage: added.add,
        showError: (_) {},
        showSuccess: (_) {},
        pickImageFile: ({required fallbackFilename}) async => file,
      );

      expect(uploadedResourceId, 9);
      expect(uploadedSortOrder, 3);
      expect(added, const [_Image(7)]);
    });
  });

  group('removeImageFromResource', () {
    test('does nothing without resource', () async {
      var deleted = false;

      await removeImageFromResource<_Resource, _Image>(
        resource: null,
        image: const _Image(1),
        isMounted: () => true,
        resourceIdOf: (resource) => resource.id,
        imageIdOf: (image) => image.id,
        deleteImage: (_, __) async => deleted = true,
        removeImage: (_) {},
      );

      expect(deleted, isFalse);
    });

    test('does not delete when modification is blocked', () async {
      var deleted = false;

      await removeImageFromResource<_Resource, _Image>(
        resource: const _Resource(1),
        image: const _Image(2),
        isMounted: () => true,
        resourceIdOf: (resource) => resource.id,
        imageIdOf: (image) => image.id,
        deleteImage: (_, __) async => deleted = true,
        removeImage: (_) {},
        showError: (_) {},
        showSuccess: (_) {},
        isModificationBlocked: (_) => true,
      );

      expect(deleted, isFalse);
    });

    test('deletes image and removes local item', () async {
      final removed = <_Image>[];
      var deletedResourceId = 0;
      var deletedImageId = 0;

      await removeImageFromResource<_Resource, _Image>(
        resource: const _Resource(5),
        image: const _Image(6),
        isMounted: () => true,
        resourceIdOf: (resource) => resource.id,
        imageIdOf: (image) => image.id,
        deleteImage: (resourceId, imageId) async {
          deletedResourceId = resourceId;
          deletedImageId = imageId;
        },
        removeImage: removed.add,
        showError: (_) {},
        showSuccess: (_) {},
      );

      expect(deletedResourceId, 5);
      expect(deletedImageId, 6);
      expect(removed, const [_Image(6)]);
    });
  });
}

class _Resource {
  const _Resource(this.id);

  final int id;
}

class _Image {
  const _Image(this.id);

  final int id;

  @override
  bool operator ==(Object other) => other is _Image && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
