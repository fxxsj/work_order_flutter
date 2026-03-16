import 'dart:typed_data';

import 'file_download_stub.dart'
    if (dart.library.html) 'file_download_web.dart'
    if (dart.library.io) 'file_download_io.dart';

Future<String?> saveBytes(
  Uint8List bytes,
  String filename, {
  String? mimeType,
}) {
  return saveBytesImpl(bytes, filename, mimeType: mimeType);
}

