import 'dart:io';
import 'dart:typed_data';

Future<String?> saveBytesImpl(
  Uint8List bytes,
  String filename, {
  String? mimeType,
}) async {
  final safeName = filename.replaceAll(RegExp(r'[\\\\/:*?"<>|]'), '_');
  final directory = Directory.systemTemp;
  final file = File('${directory.path}/$safeName');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

