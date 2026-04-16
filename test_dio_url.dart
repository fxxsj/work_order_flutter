import 'package:dio/dio.dart';
void main() {
  final dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/v1/'));
  final requestOptions = RequestOptions(
    path: '/artworks/2/upload_image/',
    method: 'POST',
    baseUrl: dio.options.baseUrl,
  );
  print('baseUrl: ${dio.options.baseUrl}');
  print('path: ${requestOptions.path}');
  print('uri: ${requestOptions.uri}');
  
  final requestOptions2 = RequestOptions(
    path: 'artworks/2/upload_image/',
    method: 'POST',
    baseUrl: dio.options.baseUrl,
  );
  print('uri (no leading slash): ${requestOptions2.uri}');
}
