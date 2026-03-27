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
}) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: allowedExtensions,
    withData: true,
  );
  if (result == null || result.files.isEmpty) {
    return null;
  }

  final picked = result.files.single;
  final fileName =
      picked.name.trim().isEmpty ? fallbackFilename : picked.name.trim();
  final bytes = picked.bytes;

  if (bytes != null && bytes.isNotEmpty) {
    return MultipartFile.fromBytes(bytes, filename: fileName);
  }

  final path = picked.path?.trim() ?? '';
  if (path.isNotEmpty) {
    return MultipartFile.fromFile(path, filename: fileName);
  }

  throw const FileUploadPickException('无法读取所选文件');
}
