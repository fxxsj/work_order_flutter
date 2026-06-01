import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadPickException implements Exception {
  const FileUploadPickException(this.message);

  final String message;

  @override
  String toString() => message;
}

Future<MultipartFile?> pickMultipartFile({
  required List<String> allowedExtensions,
  required String fallbackFilename,
  int? maxBytes,
}) async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: allowedExtensions,
    withData: true,
  );
  if (result == null || result.files.isEmpty) {
    return null;
  }

  final picked = result.files.single;
  final fileName = picked.name.trim().isEmpty
      ? fallbackFilename
      : picked.name.trim();
  final bytes = picked.bytes;
  final fileSize = picked.size;

  if (maxBytes != null && maxBytes > 0 && fileSize > maxBytes) {
    final maxMb = (maxBytes / (1024 * 1024)).toStringAsFixed(0);
    throw FileUploadPickException('所选文件过大，不能超过 ${maxMb}MB');
  }

  if (bytes != null && bytes.isNotEmpty) {
    return MultipartFile.fromBytes(bytes, filename: fileName);
  }

  final path = picked.path?.trim() ?? '';
  if (path.isNotEmpty) {
    return MultipartFile.fromFile(path, filename: fileName);
  }

  throw const FileUploadPickException('无法读取所选文件');
}
