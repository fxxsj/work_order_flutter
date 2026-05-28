import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/utils/image_upload_config.dart';
import 'package:work_order_app/src/core/utils/image_upload_picker.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';

typedef PickImageFile =
    Future<MultipartFile?> Function({required String fallbackFilename});

Future<void> pickAndUploadImageForResource<Resource, Image>({
  required int imageCount,
  required String fallbackFilename,
  required bool Function() isMounted,
  required void Function(bool uploading) setUploading,
  required Future<Resource> Function() persistResource,
  required int Function(Resource resource) resourceIdOf,
  required Future<Image> Function(
    int resourceId,
    MultipartFile imageFile,
    int sortOrder,
  )
  uploadImage,
  required void Function(Image image) addImage,
  bool Function()? isModificationBlocked,
  String? blockedMessage,
  PickImageFile pickImageFile = pickImageMultipartFile,
  void Function(String message) showError = ToastUtil.showError,
  void Function(String message) showSuccess = ToastUtil.showSuccess,
}) async {
  if (isModificationBlocked?.call() == true) {
    showError(blockedMessage ?? '当前状态不允许修改图片');
    return;
  }
  if (imageCount >= ImageUploadConfig.maxCount) {
    showError(ImageUploadConfig.maxCountErrorText());
    return;
  }

  setUploading(true);
  try {
    final multipartFile = await pickImageFile(
      fallbackFilename: fallbackFilename,
    );
    if (multipartFile == null) return;

    final savedResource = await persistResource();
    final image = await uploadImage(
      resourceIdOf(savedResource),
      multipartFile,
      imageCount,
    );
    if (isMounted()) {
      addImage(image);
      showSuccess('图片上传成功');
    }
  } catch (err) {
    if (isMounted()) showError('上传失败: $err');
  } finally {
    if (isMounted()) setUploading(false);
  }
}

Future<void> removeImageFromResource<Resource, Image>({
  required Resource? resource,
  required Image image,
  required bool Function() isMounted,
  required int Function(Resource resource) resourceIdOf,
  required int Function(Image image) imageIdOf,
  required Future<void> Function(int resourceId, int imageId) deleteImage,
  required void Function(Image image) removeImage,
  bool Function(Resource resource)? isModificationBlocked,
  String? blockedMessage,
  void Function(String message) showError = ToastUtil.showError,
  void Function(String message) showSuccess = ToastUtil.showSuccess,
}) async {
  final currentResource = resource;
  if (currentResource == null) return;

  if (isModificationBlocked?.call(currentResource) == true) {
    showError(blockedMessage ?? '当前状态不允许修改图片');
    return;
  }

  try {
    await deleteImage(resourceIdOf(currentResource), imageIdOf(image));
    if (isMounted()) {
      removeImage(image);
      showSuccess('图片已删除');
    }
  } catch (err) {
    if (isMounted()) showError('删除失败: $err');
  }
}
