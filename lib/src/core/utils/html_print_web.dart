import 'dart:js_interop';

import 'package:web/web.dart' as web;

Future<void> printHtmlDocumentImpl({
  required String title,
  required String html,
}) async {
  final document = '''
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>${_escapeHtml(title)}</title>
</head>
<body>$html<script>
window.addEventListener('load', function () {
  setTimeout(function () { window.print(); }, 250);
});
</script></body>
</html>
''';
  final blob = web.Blob(
    <JSString>[document.toJS].toJS,
    web.BlobPropertyBag(type: 'text/html;charset=utf-8'),
  );
  final url = web.URL.createObjectURL(blob);
  final opened = web.window.open(url, '_blank');
  if (opened == null) {
    web.URL.revokeObjectURL(url);
    throw StateError('浏览器阻止了打印窗口，请允许弹窗后重试');
  }
}

String _escapeHtml(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}
