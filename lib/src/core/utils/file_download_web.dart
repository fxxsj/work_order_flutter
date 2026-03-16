// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

Future<String?> saveBytesImpl(
  Uint8List bytes,
  String filename, {
  String? mimeType,
}) async {
  final blob = html.Blob(
    [bytes],
    mimeType ?? 'application/octet-stream',
  );
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..download = filename
    ..style.display = 'none';
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
  return null;
}

