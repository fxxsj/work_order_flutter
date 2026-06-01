import 'html_print_stub.dart'
    if (dart.library.html) 'html_print_web.dart'
    if (dart.library.io) 'html_print_stub.dart';

Future<void> printHtmlDocument({required String title, required String html}) {
  return printHtmlDocumentImpl(title: title, html: html);
}
