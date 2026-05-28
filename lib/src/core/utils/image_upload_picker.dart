import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/utils/file_upload_picker.dart';
import 'package:work_order_app/src/core/utils/image_upload_config.dart';

Future<MultipartFile?> pickImageMultipartFile({
  required String fallbackFilename,
}) {
  return pickMultipartFile(
    allowedExtensions: ImageUploadConfig.allowedExtensions,
    fallbackFilename: fallbackFilename,
    maxBytes: ImageUploadConfig.maxBytes,
  );
}
