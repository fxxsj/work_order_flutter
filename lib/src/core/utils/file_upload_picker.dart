import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileUploadPickException implements Exception {
  const FileUploadPickException(this.message);

  final String message;

  @override
  String toString() => message;
}

Future<MultipartFile> multipartFileFromPathOrBytes({
  required String? path,
  required Uint8List? bytes,
  required String filename,
}) async {
  final trimmedPath = path?.trim() ?? '';
  if (trimmedPath.isNotEmpty) {
    return MultipartFile.fromFile(trimmedPath, filename: filename);
  }
  if (bytes != null && bytes.isNotEmpty) {
    return MultipartFile.fromBytes(bytes, filename: filename);
  }
  throw const FileUploadPickException('无法读取所选文件');
}

Future<MultipartFile?> pickMultipartFile({
  required List<String> allowedExtensions,
  required String fallbackFilename,
  int? maxBytes,
}) async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: allowedExtensions,
    withData: kIsWeb,
  );
  if (result == null || result.files.isEmpty) {
    return null;
  }

  final picked = result.files.single;
  final fileName = picked.name.trim().isEmpty
      ? fallbackFilename
      : picked.name.trim();
  final fileSize = picked.size;

  if (maxBytes != null && maxBytes > 0 && fileSize > maxBytes) {
    final maxMb = (maxBytes / (1024 * 1024)).toStringAsFixed(0);
    throw FileUploadPickException('所选文件过大，不能超过 ${maxMb}MB');
  }

  return multipartFileFromPathOrBytes(
    path: picked.path,
    bytes: picked.bytes,
    filename: fileName,
  );
}
